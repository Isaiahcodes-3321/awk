import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/expense/expense_viewmodel.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({
    Key? key,
  }) : super(key: key);

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  int selectedPageIndex = 2;
  void onHomeTapped() {
    setState(() {
      selectedPageIndex = 0;
    });
    navigationService.replaceWith(Routes.homeView);
  }

  void onInvoicingTapped() {
    setState(() {
      selectedPageIndex = 1;
    });
    navigationService.replaceWith(Routes.salesView);
  }

  void onPurchaseTapped() {
    setState(() {
      selectedPageIndex = 3;
    });
    navigationService.replaceWith(Routes.purchaseView);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExpenseViewModel>.reactive(
        viewModelBuilder: () => ExpenseViewModel(),
        onViewModelReady: (viewModel) async {},
        builder: (context, viewModel, child) {
          return PopScope(
            canPop: false,
            child: Scaffold(
                backgroundColor: kcTextTitleColor,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniEndFloat,
                floatingActionButton: FloatingActionButton(
                  elevation: 4,
                  highlightElevation: 8.0, // Elevation when button is pressed
                  focusElevation: 4.0, // Elevation when button is focused
                  hoverElevation: 4.0,
                  foregroundColor: kcButtonTextColor,
                  backgroundColor: kcPrimaryColor,
                  shape: const CircleBorder(
                    eccentricity: 1,
                    side: BorderSide.none,
                  ),
                  onPressed: () {
                    viewModel.navigationService
                        .navigateTo(Routes.addExpenseView);
                  },
                  child: const Icon(
                    Icons.add,
                    size: 24,
                  ),
                ),
                bottomNavigationBar: SizedBox(
                  height: 60,
                  child: BottomNavigationBar(
                      backgroundColor: kcButtonTextColor,
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: kcIconColor,
                      unselectedItemColor:
                          kcTextColorLight, // Set unselected item color
                      selectedLabelStyle:
                          ktsFormHintText, // Set selected label color
                      unselectedLabelStyle: ktsFormHintText,
                      iconSize: 24,
                      currentIndex: selectedPageIndex,
                      onTap: (index) {
                        if (index == 0) {
                          onHomeTapped();
                        } else if (index == 1) {
                          onInvoicingTapped();
                        } else if (index == 3) {
                          onPurchaseTapped();
                        }
                      },
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            'assets/images/home-02.svg',
                            width: 24,
                            height: 24,
                          ),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                            icon: SvgPicture.asset(
                              'assets/images/receipt-lines.svg',
                              width: 24,
                              height: 24,
                            ),
                            label: 'Invoice'),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            'assets/images/card-minus-2.svg',
                            width: 24,
                            height: 24,
                          ),
                          label: 'Expense',
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            'assets/images/cart.svg',
                            width: 24,
                            height: 24,
                          ),
                          label: 'Purchase',
                        )
                      ]),
                ),
                body: SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 14.h,
                        color: kcTextTitleColor,
                        padding:
                            const EdgeInsets.only(left: 28, right: 28, top: 4),
                        child: Column(
                          children: [
                            verticalSpaceRegular,
                            if (!viewModel.isSearchActive)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expense',
                                        style: ktsHeaderText1,
                                      ),
                                      verticalSpaceTinyt,
                                      Text(
                                        'Create and manage expenses',
                                        style: ktsSubtitleTextAuthentication1,
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      viewModel.toggleSearch();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/Group_search.svg',
                                      width: 28,
                                      height: 28,
                                    ),
                                  ),
                                ],
                              ),
                            if (viewModel.isSearchActive)
                              TextField(
                                controller: viewModel
                                    .searchController, // Use the search controller
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    viewModel.reloadExpense();
                                  } // Call the search function as you type
                                  else {
                                    viewModel.searchExpense();
                                  }
                                },
                                style: ktsBodyTextWhite,
                                cursorColor: kcPrimaryColor,
                                decoration: InputDecoration(
                                  focusColor: kcButtonTextColor,
                                  hoverColor: kcPrimaryColor,
                                  fillColor: kcPrimaryColor,
                                  contentPadding:
                                      const EdgeInsets.only(top: 10),
                                  prefixIconColor: kcTextSubTitleColor,
                                  hintText: 'Search expense...',
                                  hintStyle: const TextStyle(
                                      color: kcTextSubTitleColor,
                                      fontSize: 16,
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: -0.3),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 20,
                                  ),
                                  suffixIconColor: kcTextSubTitleColor,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      viewModel
                                          .toggleSearch(); // Call toggleSearch to hide the search bar
                                    },
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: kcBorderColor)),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: kcPrimaryColor)),
                                  // border: const UnderlineInputBorder(
                                  //     borderSide: BorderSide(
                                  //         width: 1, color: kcPrimaryColor)),
                                ),
                              ),
                            if (viewModel.isSearchActive) verticalSpaceTinyt,
                          ],
                        ),
                      ),
                      verticalSpaceSmall,
                      Container(
                        padding:
                            const EdgeInsets.only(left: 28, right: 28, top: 6),
                        height: 76.h,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32)),
                            color: kcButtonTextColor),
                        child: Column(
                          children: [
                            if (!viewModel.isSearchActive)
                              Container(
                                clipBehavior: Clip.antiAlias,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 6),
                                decoration: BoxDecoration(
                                  color: kcArchiveColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 32,
                                child: TabBar(
                                  indicatorPadding: EdgeInsets.zero,
                                  indicatorSize: TabBarIndicatorSize
                                      .tab, // Adjust the indicatorSize
                                  indicator: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: kcButtonTextColor),
                                    color:
                                        kcButtonTextColor, // Use your desired color
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  dividerColor: kcArchiveColor,
                                  indicatorColor: kcTextSubTitleColor,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  labelColor: kcTextTitleColor,
                                  labelStyle: const TextStyle(
                                    fontSize: 11.44,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                    letterSpacing: -0.25,
                                  ),
                                  // Use your desired label color
                                  unselectedLabelColor: kcTextSubTitleColor,
                                  unselectedLabelStyle: const TextStyle(
                                    fontSize: 11.44,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.25,
                                  ), // Use your desired unselected label color
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        'All (${viewModel.expenses.length})', // Use your label text
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        ''
                                        'Archived (${viewModel.archivedExpenses.length})', // Use your label text
                                      ),
                                    ),
                                  ],
                                  controller: tabController,
                                ),
                              ),
                            verticalSpaceSmall,
                            Expanded(
                              child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    Builder(builder: (context) {
                                      if (viewModel.isBusy) {
                                        return const SizedBox(
                                            height: 500,
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  color: kcPrimaryColor,
                                                ),
                                              ],
                                            )));
                                      }
                                      if (viewModel.isSearchActive &&
                                          viewModel.expenses.isEmpty) {
                                        return SizedBox(
                                            height: 400,
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/Group 1000007841.svg',
                                                  width: 200,
                                                  height: 150,
                                                ),
                                                verticalSpaceSmall,
                                                Text(
                                                  'No expense available',
                                                  style:
                                                      ktsSubtitleTextAuthentication,
                                                ),
                                              ],
                                            )));
                                      }
                                      if (viewModel.isSearchActive &&
                                          viewModel.expenses.isNotEmpty) {
                                        return ListView.separated(
                                          padding: const EdgeInsets.all(2),
                                          scrollDirection: Axis.vertical,
                                          // physics: const NeverScrollableScrollPhysics(),
                                          primary: true,
                                          shrinkWrap: true,
                                          itemCount: viewModel.expenses.length,
                                          itemBuilder: (context, index) {
                                            var expense =
                                                viewModel.expenses[index];
                                            return Container(
                                              clipBehavior: Clip.antiAlias,
                                              padding: EdgeInsets.zero,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                // color: kcButtonTextColor,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    width: 1.3,
                                                    color: kcBorderColor),
                                              ),
                                              child: ExpenseCard(
                                                expenses: expense,
                                                expenseId: expense.id,
                                              ),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return verticalSpaceTiny1;
                                          },
                                        );
                                      }
                                      if (viewModel.expenses.isEmpty) {
                                        return SizedBox(
                                            height: 400,
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/Group 1000007942.svg',
                                                  width: 200,
                                                  height: 150,
                                                ),
                                                verticalSpaceSmall,
                                                Text(
                                                  'No expense available',
                                                  style:
                                                      ktsSubtitleTextAuthentication,
                                                ),
                                              ],
                                            )));
                                      }
                                      return ListView.separated(
                                        padding: const EdgeInsets.all(2),
                                        scrollDirection: Axis.vertical,
                                        // physics: const NeverScrollableScrollPhysics(),
                                        primary: true,
                                        shrinkWrap: true,
                                        itemCount: viewModel.expenses.length,
                                        itemBuilder: (context, index) {
                                          var expense =
                                              viewModel.expenses[index];
                                          return Container(
                                            clipBehavior: Clip.antiAlias,
                                            padding: EdgeInsets.zero,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              // color: kcButtonTextColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  width: 1.3,
                                                  color: kcBorderColor),
                                            ),
                                            child: ExpenseCard(
                                              expenses: expense,
                                              expenseId: expense.id,
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return verticalSpaceTiny1;
                                        },
                                      );
                                    }),
                                    Builder(builder: (context) {
                                      if (viewModel.isBusy) {
                                        return const SizedBox(
                                            height: 500,
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  color: kcPrimaryColor,
                                                ),
                                              ],
                                            )));
                                      }

                                      if (viewModel.archivedExpenses.isEmpty) {
                                        return SizedBox(
                                            height: 400,
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/Group 1000007942.svg',
                                                  width: 200,
                                                  height: 150,
                                                ),
                                                verticalSpaceSmall,
                                                Text(
                                                  'No expense available',
                                                  style:
                                                      ktsSubtitleTextAuthentication,
                                                ),
                                              ],
                                            )));
                                      }
                                      return ListView.separated(
                                        padding: const EdgeInsets.all(2),
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        primary: true,
                                        shrinkWrap: true,
                                        itemCount:
                                            viewModel.archivedExpenses.length,
                                        itemBuilder: (context, index) {
                                          var expense =
                                              viewModel.archivedExpenses[index];
                                          return Container(
                                            clipBehavior: Clip.antiAlias,
                                            padding: EdgeInsets.zero,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              // color: kcButtonTextColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  width: 1.3,
                                                  color: kcBorderColor),
                                            ),
                                            child: ArchivedExpenseCard(
                                              expenses: expense,
                                              expenseId: expense.id,
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return verticalSpaceTiny1;
                                        },
                                      );
                                    }),
                                  ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}

class ExpenseCard extends ViewModelWidget<ExpenseViewModel> {
  const ExpenseCard({
    Key? key,
    required this.expenses,
    required this.expenseId,
  }) : super(key: key);

  final Expenses expenses;

  final String expenseId;

  @override
  Widget build(BuildContext context, ExpenseViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      title: Text(
        '#${expenses.reference}',
        style: ktsBorderText,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: NumberFormat.currency(locale: 'en_NGN', symbol: '₦')
                  .currencySymbol, // The remaining digits without the symbol
              style: ktsSubtitleTileText.copyWith(fontFamily: 'Roboto'),
            ),
            TextSpan(
              text: NumberFormat.currency(locale: 'en_NGN', symbol: '').format(
                  expenses.amount), // The remaining digits without the symbol
              style: ktsSubtitleTileText,
            ),
          ],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              'assets/images/eye.svg',
              width: 20,
              height: 20,
            ),
            onPressed: (() {
              viewModel.navigationService
                  .navigateTo(Routes.viewExpenseView, arguments: expenseId);
            }),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              viewModel.archiveExpense(expenseId);
            },
            icon: SvgPicture.asset(
              'assets/images/archive.svg',
              // width: 20,
              // height: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class ArchivedExpenseCard extends ViewModelWidget<ExpenseViewModel> {
  const ArchivedExpenseCard({
    Key? key,
    required this.expenses,
    required this.expenseId,
  }) : super(key: key);

  final Expenses expenses;

  final String expenseId;

  @override
  Widget build(BuildContext context, ExpenseViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      title: Text(
        '#${expenses.reference}',
        style: ktsBorderText,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: NumberFormat.currency(locale: 'en_NGN', symbol: '₦')
                  .currencySymbol, // The remaining digits without the symbol
              style: ktsSubtitleTileText.copyWith(fontFamily: 'Roboto'),
            ),
            TextSpan(
              text: NumberFormat.currency(locale: 'en_NGN', symbol: '').format(
                  expenses.amount), // The remaining digits without the symbol
              style: ktsSubtitleTileText,
            ),
          ],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: const EdgeInsets.only(top: 2),
            onPressed: () async {
              viewModel.unArchiveExpense(expenseId);
            },
            icon: SvgPicture.asset(
              'assets/images/unarchive2.svg',
              // width: 20,
              // height: 20,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              'assets/images/trash-04.svg',
              width: 18,
              height: 18,
            ),
            onPressed: (() {
              viewModel.deleteExpense(expenseId);
            }),
          ),
        ],
      ),
    );
  }
}
