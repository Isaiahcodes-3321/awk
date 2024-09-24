import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:verzo/app/app.router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:verzo/ui/views/expense/expense_viewmodel.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({
    Key? key,
  }) : super(key: key);

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExpenseViewModel>.reactive(
        viewModelBuilder: () => ExpenseViewModel(),
        onViewModelReady: (viewModel) async {},
        builder: (context, viewModel, child) {
          return PopScope(
            canPop: false,
            child: Scaffold(
                backgroundColor: Color(0XFF2A5DC8),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniEndFloat,
                floatingActionButton: FloatingActionButton(
                  elevation: 4,
                  highlightElevation: 8.0, // Elevation when button is pressed
                  focusElevation: 4.0, // Elevation when button is focused
                  hoverElevation: 4.0,
                  foregroundColor: kcButtonTextColor,
                  backgroundColor: Color(0XFF2A5DC8).withOpacity(0.7),
                  shape: const CircleBorder(
                    eccentricity: 1,
                    side: BorderSide.none,
                  ),
                  onPressed: () async {
                    final result = await viewModel.navigationService
                        .navigateTo(Routes.addExpenseView);

                    if (result == true) {
                      viewModel.reloadExpenseData();
                    }
                  },
                  child: const Icon(
                    Icons.add,
                    size: 24,
                  ),
                ),
                body: SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          color: const Color(0XFF2A5DC8),
                          padding: const EdgeInsets.only(
                              left: 28, right: 28, top: 4),
                          child: Column(
                            children: [
                              verticalSpaceRegular,
                              if (!viewModel.isSearchActive)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Padding(
                                      padding:  EdgeInsets.only(top: 1.h),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              onTap: () async {
                                                final result = await viewModel
                                                    .navigationService
                                                    .navigateTo(Routes
                                                        .archivedExpenseView);
                                                if (result == true) {
                                                  viewModel.reloadExpenseData();
                                                }
                                              },
                                              child: const Icon(
                                                Icons.inventory_2_outlined,
                                                color: kcButtonTextColor,
                                                size: 20,
                                              )),
                                          horizontalSpaceRegular,
                                          // GestureDetector(
                                          //     onTap: () {
                                          //       viewModel.toggleSearch();
                                          //     },
                                          //     child: const Icon(
                                          //       Icons.search,
                                          //       color: kcButtonTextColor,
                                          //     )),
                                        ],
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
                                  cursorColor: kcButtonTextColor,
                                  decoration: InputDecoration(
                                    focusColor: kcButtonTextColor,
                                    hoverColor: kcPrimaryColor,
                                    fillColor: kcButtonTextColor,
                                    contentPadding:
                                        const EdgeInsets.only(top: 10),
                                    prefixIconColor: kcButtonTextColor,
                                    hintText: 'Search expense...',
                                    hintStyle: TextStyle(
                                        color:
                                            kcButtonTextColor.withOpacity(0.4),
                                        fontSize: 16,
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: -0.3),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      size: 20,
                                    ),
                                    suffixIconColor: kcButtonTextColor,
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
                      ),
                      // verticalSpaceSmall,
                      Flexible(
                        flex: 8,
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 0, right: 0, top: 6),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24)),
                              color: kcButtonTextColor),
                          child: Column(
                            children: [
                              verticalSpaceSmall,
                              Expanded(
                                child: Builder(builder: (context) {
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
                                      viewModel.data!.isEmpty) {
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
                                      viewModel.data!.isNotEmpty) {
                                    return ListView.separated(
                                      padding: const EdgeInsets.all(2),
                                      scrollDirection: Axis.vertical,
                                      // physics: const NeverScrollableScrollPhysics(),
                                      primary: true,
                                      shrinkWrap: true,
                                      itemCount: viewModel.data!.length,
                                      itemBuilder: (context, index) {
                                        var expense = viewModel.data![index];
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
                                  }
                                  if (
                                      // viewModel.data == null ||

                                      viewModel.data!.isEmpty) {
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
                                  return Material(
                                    color: Colors.transparent,
                                    child: ListView.separated(
                                      padding: const EdgeInsets.all(2),
                                      scrollDirection: Axis.vertical,
                                      // physics: const NeverScrollableScrollPhysics(),
                                      primary: true,
                                      shrinkWrap: true,
                                      itemCount: viewModel.data!.length,
                                      itemBuilder: (context, index) {
                                        var expense = viewModel.data![index];
                                        return ExpenseCard(
                                          expenses: expense,
                                          expenseId: expense.id,
                                          // ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const Divider(
                                          thickness: 0.2,
                                        );
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}

// class ExpenseCard extends ViewModelWidget<ExpenseViewModel> {
//   const ExpenseCard({
//     Key? key,
//     required this.expenses,
//     required this.expenseId,
//   }) : super(key: key);

//   final Expenses expenses;

//   final String expenseId;

//   @override
//   Widget build(BuildContext context, ExpenseViewModel viewModel) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         splashColor: kcFormBorderColor.withOpacity(0.3),
//         onTap: (() async {
//           final result = await viewModel.navigationService
//               .navigateTo(Routes.viewExpenseView, arguments: expenseId);

//           if (result == true) {
//             viewModel.reloadExpenseData();
//           }
//         }),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     expenses.description.length <= 15
//                         ? '${expenses.description[0].toUpperCase()}${expenses.description.substring(1)}'
//                         : '${expenses.description[0].toUpperCase()}${expenses.description.substring(1, 15)}...',
//                     style: TextStyle(
//                       fontFamily: 'Satoshi',
//                       color: kcTextTitleColor.withOpacity(0.9),
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: NumberFormat.currency(
//                                   locale: 'en_NGN', symbol: '₦')
//                               .currencySymbol, // The remaining digits without the symbol
//                           style: GoogleFonts.openSans(
//                             color: kcTextTitleColor.withOpacity(0.8),
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ).copyWith(fontFamily: 'Roboto'),
//                         ),
//                         TextSpan(
//                           text: NumberFormat.currency(
//                                   locale: 'en_NGN', symbol: '')
//                               .format(expenses
//                                   .amount), // The remaining digits without the symbol
//                           style: TextStyle(
//                               fontFamily: 'Satoshi',
//                               color: kcTextTitleColor.withOpacity(0.9),
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 0.5),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               // verticalSpaceTinyt1,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     expenses.expenseDate,
//                     style: const TextStyle(
//                       fontFamily: 'Satoshi',
//                       color: kcTextSubTitleColor,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                   Text(
//                     expenses.merchantName,
//                     style: const TextStyle(
//                       fontFamily: 'Satoshi',
//                       color: kcTextSubTitleColor,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: kcFormBorderColor.withOpacity(0.3),
        onTap: (() async {
          final result = await viewModel.navigationService
              .navigateTo(Routes.viewExpenseView, arguments: expenseId);

          if (result == true) {
            viewModel.reloadExpenseData();
          }
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    expenses.description.length <= 15
                        ? '${expenses.description[0].toUpperCase()}${expenses.description.substring(1)}'
                        : '${expenses.description[0].toUpperCase()}${expenses.description.substring(1, 15)}...',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: kcTextTitleColor.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: NumberFormat.currency(
                                  locale: 'en_NGN', symbol: '₦')
                              .currencySymbol, // The remaining digits without the symbol
                          style: GoogleFonts.openSans(
                            color: kcTextTitleColor.withOpacity(0.8),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ).copyWith(fontFamily: 'Roboto'),
                        ),
                        TextSpan(
                          text: NumberFormat.currency(
                                  locale: 'en_NGN', symbol: '')
                              .format(expenses
                                  .amount), // The remaining digits without the symbol
                          style: TextStyle(
                              fontFamily: 'Satoshi',
                              color: kcTextTitleColor.withOpacity(0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // verticalSpaceTinyt1,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    expenses.expenseDate,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      color: kcTextSubTitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    expenses.merchantName,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      color: kcTextSubTitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
