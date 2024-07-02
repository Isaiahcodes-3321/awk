import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/make_expense_payment/make_expense_payment_view.dart';
import 'package:verzo/ui/views/mark_expense_item_as_received/mark_expense_item_as_received_view.dart';
import 'package:verzo/ui/views/merchant_invoice/merchant_invoice_view.dart';

import 'view_expense_viewmodel.dart';

class ViewExpenseView extends StackedView<ViewExpenseViewModel> {
  const ViewExpenseView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(ViewExpenseViewModel viewModel) async {
    // syncFormWithViewModel(viewModel);
    await viewModel.getExpenseById();
  }

  @override
  Widget builder(
    BuildContext context,
    ViewExpenseViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.expense == null) {
      return Scaffold(
        backgroundColor: kcButtonTextColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: ListView(
            children: [
              verticalSpaceSmall,
              GestureDetector(
                onTap: viewModel.navigateBack,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: kcFormBorderColor.withOpacity(0.3),
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.arrow_back_ios_rounded,
                                fill: 0.9,
                                color: kcTextSubTitleColor,
                                size: 16,
                              ),
                              onPressed: viewModel.navigateBack),
                        ),
                        horizontalSpaceTiny,
                        Text(
                          'back',
                          style: ktsSubtitleTextAuthentication,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {},
                          icon: SvgPicture.asset(
                            'assets/images/archive-2.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {},
                          icon: SvgPicture.asset(
                            'assets/images/trash-01.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              verticalSpaceSmallMid,
              const SizedBox(
                  height: 500,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: kcPrimaryColor,
                      ),
                    ],
                  )))
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: kcButtonTextColor,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ListView(children: [
              verticalSpaceSmall,
              GestureDetector(
                onTap: viewModel.navigateBack,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: kcFormBorderColor.withOpacity(0.3),
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.arrow_back_ios_rounded,
                                fill: 0.9,
                                color: kcTextSubTitleColor,
                                size: 16,
                              ),
                              onPressed: viewModel.navigateBack),
                        ),
                        horizontalSpaceTiny,
                        Text(
                          'back',
                          style: ktsSubtitleTextAuthentication,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            viewModel.archiveExpense(context);
                          },
                          icon: SvgPicture.asset(
                            'assets/images/archive-2.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            viewModel.deleteExpense(context);
                          },
                          icon: SvgPicture.asset(
                            'assets/images/trash-01.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              verticalSpaceSmallMid,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${viewModel.expense!.reference}',
                    style: ktsTextAuthentication2,
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.expense!.expenseStatusId == 1
                          ? viewModel.navigationService.navigateTo(
                              Routes.updateExpenseView,
                              arguments: viewModel.expenseId)
                          : null;

                      viewModel.rebuildUi();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/images/edit-contained.svg',
                          width: 18,
                          height: 18,
                        ),
                        horizontalSpaceminute,
                        Text(
                          'Edit',
                          style: ktsAddNewText,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              verticalSpaceIntermitent,
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.expense!.merchantName,
                        style: ktsTextAuthentication2,
                      ),
                      verticalSpaceTinyt1,
                      Text(
                        viewModel.expense!.merchantEmail!,
                        style: ktsFormHintText,
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kcSuccessColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(viewModel.expense!.expenseCategoryName,
                        style: ktsSubtitleTileText2 // Set your text style
                        ),
                  )
                ],
              ),
              verticalSpaceTiny,
              Divider(
                color: kcBorderColor,
              ),
              verticalSpaceTiny,
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: ktsFormHintText,
                        ),
                        verticalSpaceTinyt,
                        Text(
                          viewModel.expense!.description,
                          style: ktsTextAuthentication3,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Transaction Date',
                        style: ktsFormHintText,
                      ),
                      verticalSpaceTinyt,
                      Text(
                        viewModel.expense!.expenseDate,
                        style: ktsTextAuthentication3,
                      ),
                    ],
                  )
                ],
              ),

              // Container(
              //   clipBehavior: Clip.antiAlias,
              //   padding: EdgeInsets.zero,
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     // color: kcButtonTextColor,
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(width: 1, color: kcBorderColor),
              //   ),
              //   child: Column(mainAxisSize: MainAxisSize.min, children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 14, vertical: 20),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               SvgPicture.asset(
              //                 'assets/images/calendar-03.svg',
              //                 width: 20,
              //                 height: 20,
              //               ),
              //               horizontalSpaceTiny,
              //               Text(
              //                 'Issue date',
              //                 style: ktsFormTitleText,
              //               ),
              //             ],
              //           ),
              //           Text(
              //             viewModel.expense!.expenseDate,
              //             style: ktsFormHintText,
              //           ),
              //         ],
              //       ),
              //     ),
              //     const Divider(
              //       color: kcBorderColor,
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 14, vertical: 14),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               SvgPicture.asset(
              //                 'assets/images/plus-01.svg',
              //                 width: 20,
              //                 height: 20,
              //               ),
              //               horizontalSpaceTiny,
              //               Text(
              //                 'Category',
              //                 style: ktsFormTitleText,
              //               ),
              //             ],
              //           ),
              //           Container(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 12, vertical: 6),
              //             decoration: BoxDecoration(
              //               color: kcSuccessColor,
              //               borderRadius: BorderRadius.circular(20),
              //             ),
              //             child: Text(viewModel.expense!.expenseCategoryName,
              //                 style: ktsSubtitleTileText2 // Set your text style
              //                 ),
              //           )
              //         ],
              //       ),
              //     ),
              //     const Divider(
              //       color: kcBorderColor,
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 14, vertical: 20),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               SvgPicture.asset(
              //                 'assets/images/user-profile-02.svg',
              //                 width: 20,
              //                 height: 20,
              //               ),
              //               horizontalSpaceTiny,
              //               Text(
              //                 'Merchant',
              //                 style: ktsFormTitleText,
              //               ),
              //             ],
              //           ),
              //           Text(
              //             viewModel.expense!.merchantName,
              //             style: ktsFormHintText,
              //           ),
              //         ],
              //       ),
              //     ),
              //     const Divider(
              //       color: kcBorderColor,
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 14, vertical: 20),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               SvgPicture.asset(
              //                 'assets/images/email.svg',
              //                 width: 20,
              //                 height: 20,
              //               ),
              //               horizontalSpaceTiny,
              //               Text(
              //                 'Email',
              //                 style: ktsFormTitleText,
              //               ),
              //             ],
              //           ),
              //           Text(
              //             viewModel.expense!.merchantEmail!,
              //             style: ktsFormHintText,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ]),
              // ),
              verticalSpaceIntermitent,
              Text(
                'Expense details',
                style: ktsTextAuthentication,
              ),
              if (viewModel.expense!.expenseItems.isNotEmpty) verticalSpaceTiny,
              if (viewModel.expense!.expenseItems.isNotEmpty)
                ...viewModel.expense!.expenseItems.map(
                  (expenseItem) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    minVerticalPadding: 0,
                    leading: Text(
                      '${expenseItem.quantity}x',
                      style: ktsFormTitleText,
                    ),
                    title: Text(expenseItem.description),
                    titleTextStyle: ktsFormTitleText3,
                    trailing: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: NumberFormat.currency(
                                    locale: 'en_NGN', symbol: '₦')
                                .currencySymbol, // The remaining digits without the symbol
                            style:
                                ktsBorderText2.copyWith(fontFamily: 'Roboto'),
                          ),
                          TextSpan(
                            text: NumberFormat.currency(
                                    locale: 'en_NGN', symbol: '')
                                .format(expenseItem
                                    .unitPrice), // The remaining digits without the symbol
                            style: ktsBorderText2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const Divider(
                color: kcBorderColor,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount due',
                    style: ktsBorderText,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: NumberFormat.currency(
                                  locale: 'en_NGN', symbol: '₦')
                              .currencySymbol, // The remaining digits without the symbol
                          style: ktsBorderText2.copyWith(fontFamily: 'Roboto'),
                        ),
                        TextSpan(
                          text: NumberFormat.currency(
                                  locale: 'en_NGN', symbol: '')
                              .format(viewModel.expense!
                                  .amount), // The remaining digits without the symbol
                          style: ktsBorderText2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // const Divider(
              //   color: kcBorderColor,
              // ),
              verticalSpaceIntermitent,
              Text(
                'More actions',
                style: ktsTextAuthentication,
              ),
              Text(
                'Tap to add extra info',
                style: ktsFormHintText,
              ),
              verticalSpaceSmallMid,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tileColor: kcOTPColor,
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: kcFormBorderColor // Stroke color
                                ),
                        color: kcSuccessColor, // Fill color
                      ),
                    ),
                    title: Text(
                      'Review expense',
                      style: ktsFormTitleText,
                    ),
                  ),
                  verticalSpaceSmallMid,
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tileColor: kcOTPColor,
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: kcFormBorderColor // Stroke color
                                ),
                        color: viewModel.expense!.expenseStatusId == 1
                            ? kcButtonTextColor
                            : kcSuccessColor, // Fill color
                      ),
                    ),
                    onTap: viewModel.expense!.expenseStatusId == 1
                        ? () {
                            showModalBottomSheet(
                              backgroundColor: kcButtonTextColor,
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.84,
                                    child: MarkExpenseItemAsReceivedView(
                                      selectedExpense: viewModel.expense!,
                                    ),
                                  ),
                                );
                              },
                            ).whenComplete(() async {
                              viewModel.rebuildUi();
                              viewModel.reloadView();
                              // Navigator.of(context).pop();
                            });
                          }
                        : null,
                    title: const Text(
                      'Confirm items',
                    ),
                    titleTextStyle: ktsFormTitleText,
                  ),
                  verticalSpaceSmallMid,
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tileColor: kcOTPColor,
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: kcFormBorderColor // Stroke color
                                ),
                        color: viewModel.expense!.expenseStatusId <= 2
                            ? kcButtonTextColor
                            : kcSuccessColor, // Fill color
                      ),
                    ),
                    onTap: viewModel.expense!.expenseStatusId == 2
                        ? () {
                            showModalBottomSheet(
                              backgroundColor: kcButtonTextColor,
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.54,
                                    child: MerchantInvoiceView(
                                      selectedExpense: viewModel.expense!,
                                    ),
                                  ),
                                );
                              },
                            ).whenComplete(() async {
                              viewModel.rebuildUi();
                              // Navigator.pop(context);
                            });

                            // if (result != null) {
                            //   // Do something with the result if needed
                            //   // For example, you can update the UI or perform any additional actions
                            // }

                            // Navigator.pop(context);
                          }
                        : null,
                    title: const Text(
                      'Merchant invoice',
                    ),
                    titleTextStyle: ktsFormTitleText,
                  ),
                  verticalSpaceSmallMid,
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tileColor: kcOTPColor,
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: kcFormBorderColor // Stroke color
                                ),
                        color: viewModel.expense!.expenseStatusId <= 3
                            ? kcButtonTextColor
                            : kcSuccessColor, // Fill color
                      ),
                    ),
                    title: Text(
                      'Add payment details',
                      style: ktsFormTitleText,
                    ),
                    onTap: viewModel.expense!.expenseStatusId == 3
                        ? () {
                            // Navigator.of(context).pop();
                            // Handle the action
                            showModalBottomSheet(
                              backgroundColor: kcButtonTextColor,
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child: MakeExpensePaymentView(
                                      selectedExpense: viewModel.expense!,
                                    ),
                                  ),
                                );
                              },
                            ).whenComplete(() async {
                              // Navigator.of(context).pop();
                            });
                          }
                        : null,
                  ),
                  verticalSpaceSmall
                ],
              )
            ])),
      );
    }
  }

  @override
  ViewExpenseViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final String expenseId =
        ModalRoute.of(context)!.settings.arguments as String;
    return ViewExpenseViewModel(expenseId: expenseId);
  }
}
