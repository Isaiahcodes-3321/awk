import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/purchase/purchase_viewmodel.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({
    Key? key,
  }) : super(key: key);

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  int selectedPageIndex = 3;
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

  void onExpensesTapped() {
    setState(() {
      selectedPageIndex = 2;
    });
    navigationService.replaceWith(Routes.expenseView);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PurchaseViewModel>.reactive(
      // key: UniqueKey(),
      viewModelBuilder: () => PurchaseViewModel(),
      onViewModelReady: (viewModel) async {},
      builder: (
        BuildContext context,
        PurchaseViewModel viewModel,
        Widget? child,
      ) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: kcButtonTextColor,
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
                viewModel.navigationService.navigateTo(Routes.addPurchaseView);
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
                    } else if (index == 2) {
                      onExpensesTapped();
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
                        'assets/images/card-minus.svg',
                        width: 24,
                        height: 24,
                      ),
                      label: 'Expense',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/images/cart-2.svg',
                        width: 24,
                        height: 24,
                      ),
                      label: 'Purchase',
                    )
                  ]),
            ),
            body: Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 0, left: 28, right: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpaceRegular,
                  if (!viewModel.isSearchActive)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Purchase',
                              style: ktsHeaderText,
                            ),
                            verticalSpaceTinyt,
                            Text(
                              'Create and manage orders',
                              style: ktsSubtitleTextAuthentication,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            viewModel.toggleSearch();
                          },
                          child: SvgPicture.asset(
                            'assets/images/Group_search.svg',
                            width: 36,
                            height: 36,
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
                          viewModel.reloadPurchase();
                        } // Call the search function as you type
                        else {
                          viewModel.searchPurchase();
                        }
                      },
                      style: ktsBodyText,
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                        focusColor: kcPrimaryColor,
                        hoverColor: kcPrimaryColor,
                        fillColor: kcPrimaryColor,
                        contentPadding: const EdgeInsets.only(top: 10),
                        prefixIconColor: kcTextSubTitleColor,
                        hintText: 'Search purchases...',
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
                        suffixIconColor: kcTextTitleColor,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            viewModel
                                .toggleSearch(); // Call toggleSearch to hide the search bar
                          },
                        ),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: kcBorderColor)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: kcPrimaryColor)),
                        // border: const UnderlineInputBorder(
                        //     borderSide: BorderSide(
                        //         width: 1, color: kcPrimaryColor)),
                      ),
                    ),
                  if (viewModel.isSearchActive) verticalSpaceTinyt,
                  verticalSpaceSmallMid,
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.762,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 6),
                      decoration: BoxDecoration(
                        color: kcButtonTextColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                                      'All (${viewModel.purchases.length})', // Use your label text
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      ''
                                      'Archived (${viewModel.archivedPurchases.length})', // Use your label text
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
                                        viewModel.purchases.isEmpty) {
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
                                                'No purchase available',
                                                style:
                                                    ktsSubtitleTextAuthentication,
                                              ),
                                            ],
                                          )));
                                    }
                                    if (viewModel.isSearchActive &&
                                        viewModel.purchases.isNotEmpty) {
                                      ListView.separated(
                                        padding: const EdgeInsets.all(2),
                                        scrollDirection: Axis.vertical,
                                        // physics: const NeverScrollableScrollPhysics(),
                                        primary: true,
                                        shrinkWrap: true,
                                        itemCount: viewModel.purchases.length,
                                        itemBuilder: (context, index) {
                                          var purchase =
                                              viewModel.purchases[index];
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
                                            child: PurchaseOrderCard(
                                              purchase: purchase,
                                              purchaseId: purchase.id,
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return verticalSpaceTiny1;
                                        },
                                      );
                                    }
                                    if (viewModel.purchases.isEmpty) {
                                      return SizedBox(
                                          height: 400,
                                          child: Center(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/Group 1000007944.svg',
                                                width: 200,
                                                height: 150,
                                              ),
                                              verticalSpaceSmall,
                                              Text(
                                                'No purchase available',
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
                                      itemCount: viewModel.purchases.length,
                                      itemBuilder: (context, index) {
                                        var purchase =
                                            viewModel.purchases[index];
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
                                          child: PurchaseOrderCard(
                                            purchase: purchase,
                                            purchaseId: purchase.id,
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

                                    if (viewModel.archivedPurchases.isEmpty) {
                                      return SizedBox(
                                          height: 400,
                                          child: Center(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/Group 1000007944.svg',
                                                width: 200,
                                                height: 150,
                                              ),
                                              verticalSpaceSmall,
                                              Text(
                                                'No purchase available',
                                                style:
                                                    ktsSubtitleTextAuthentication,
                                              ),
                                            ],
                                          )));
                                    }
                                    return ListView.separated(
                                      padding: const EdgeInsets.all(2),
                                      scrollDirection: Axis.vertical,
                                      // physics:
                                      //     const NeverScrollableScrollPhysics(),
                                      primary: true,
                                      shrinkWrap: true,
                                      itemCount:
                                          viewModel.archivedPurchases.length,
                                      itemBuilder: (context, index) {
                                        var purchase =
                                            viewModel.archivedPurchases[index];
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
                                          child: ArchivedPurchaseOrderCard(
                                            purchase: purchase,
                                            purchaseId: purchase.id,
                                          ),
                                        );
                                        // }
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return verticalSpaceTiny1;
                                      },
                                    );
                                  })
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PurchaseOrderCard extends ViewModelWidget<PurchaseViewModel> {
  const PurchaseOrderCard({
    Key? key,
    required this.purchase,
    required this.purchaseId,
  }) : super(key: key);

  final Purchases purchase;

  final String purchaseId;

  @override
  Widget build(BuildContext context, PurchaseViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      title: Text(
        '#${purchase.reference}',
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
                  purchase.total), // The remaining digits without the symbol
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
                  .navigateTo(Routes.viewPurchaseView, arguments: purchaseId);
            }),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              viewModel.archivePurchase(purchaseId);
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

class ArchivedPurchaseOrderCard extends ViewModelWidget<PurchaseViewModel> {
  const ArchivedPurchaseOrderCard({
    Key? key,
    required this.purchase,
    required this.purchaseId,
  }) : super(key: key);

  final Purchases purchase;

  final String purchaseId;

  @override
  Widget build(BuildContext context, PurchaseViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      title: Text(
        '#${purchase.reference}',
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
                  purchase.total), // The remaining digits without the symbol
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
              viewModel.unArchivePurchase(purchaseId);
            },
            icon: SvgPicture.asset(
              'assets/images/unarchive2.svg',
              // width: 22,
              // height: 22,
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
              viewModel.deletePurchase(purchaseId);
            }),
          ),
        ],
      ),
    );
  }
}
