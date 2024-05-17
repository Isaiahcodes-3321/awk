import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/make_sales_payment/make_sales_payment_view.dart';
import 'package:verzo/ui/views/record_sale_expense/record_sale_expense_view.dart';

import 'view_sales_viewmodel.dart';

class ViewSalesView extends StackedView<ViewSalesViewModel> {
  const ViewSalesView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(ViewSalesViewModel viewModel) async {
    // syncFormWithViewModel(viewModel);
    await viewModel.getSaleById();
  }

  @override
  Widget builder(
    BuildContext context,
    ViewSalesViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.sale == null) {
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
                            viewModel.archiveSale(context);
                          },
                          icon: SvgPicture.asset(
                            'assets/images/archive-2.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            viewModel.deleteSale(context);
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
                    '#${viewModel.sale!.reference}',
                    style: ktsTextAuthentication2,
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.sale!.saleStatusId == 1
                          ? viewModel.navigationService.navigateTo(
                              Routes.updateSalesView,
                              arguments: viewModel.saleId)
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
                        viewModel.sale!.customerName,
                        style: ktsTextAuthentication2,
                      ),
                      verticalSpaceTinyt1,
                      Text(
                        viewModel.sale!.customerEmail!,
                        style: ktsFormHintText,
                      ),
                    ],
                  ),
                  if (viewModel.sale!.paid == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kcSuccessColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Paid',
                          style: ktsSubtitleTileText2 // Set your text style
                          ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kcArchiveColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Pending',
                          style: ktsSubtitleTileText // Set your text style
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Date',
                        style: ktsFormHintText,
                      ),
                      verticalSpaceTinyt,
                      Text(
                        viewModel.sale!.transactionDate,
                        style: ktsTextAuthentication3,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Due Date',
                        style: ktsFormHintText,
                      ),
                      verticalSpaceTinyt,
                      Text(
                        viewModel.sale!.dueDate,
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
              //                 'Transaction date',
              //                 style: ktsFormTitleText,
              //               ),
              //             ],
              //           ),
              //           Text(
              //             viewModel.sale!.transactionDate,
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
              //                 'assets/images/calendar-03.svg',
              //                 width: 20,
              //                 height: 20,
              //               ),
              //               horizontalSpaceTiny,
              //               Text(
              //                 'Due date',
              //                 style: ktsFormTitleText,
              //               ),
              //             ],
              //           ),
              //           Text(
              //             viewModel.sale!.dueDate,
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
              //                 'assets/images/check-broken.svg',
              //                 width: 20,
              //                 height: 20,
              //               ),
              //               horizontalSpaceTiny,
              //               Text(
              //                 'Status',
              //                 style: ktsFormTitleText,
              //               ),
              //             ],
              //           ),
              //           if (viewModel.sale!.paid == true)
              //             Container(
              //               padding: const EdgeInsets.symmetric(
              //                   horizontal: 12, vertical: 6),
              //               decoration: BoxDecoration(
              //                 color: kcSuccessColor,
              //                 borderRadius: BorderRadius.circular(20),
              //               ),
              //               child: Text('Paid',
              //                   style:
              //                       ktsSubtitleTileText2 // Set your text style
              //                   ),
              //             )
              //           else
              //             Container(
              //               padding: const EdgeInsets.symmetric(
              //                   horizontal: 12, vertical: 6),
              //               decoration: BoxDecoration(
              //                 color: kcArchiveColor,
              //                 borderRadius: BorderRadius.circular(20),
              //               ),
              //               child: Text('Pending',
              //                   style:
              //                       ktsSubtitleTileText // Set your text style
              //                   ),
              //             )
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
              //                 'Customer',
              //                 style: ktsFormTitleText,
              //               ),
              //             ],
              //           ),
              //           Text(
              //             viewModel.sale!.customerName,
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
              //             viewModel.sale!.customerEmail!,
              //             style: ktsFormHintText,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ]),
              // ),
              verticalSpaceIntermitent,
              Text(
                'Invoice details',
                style: ktsTextAuthentication,
              ),
              if (viewModel.sale!.invoiceDetails.isNotEmpty) verticalSpaceTiny,
              if (viewModel.sale!.invoiceDetails.isNotEmpty)
                ...viewModel.sale!.invoiceDetails.map(
                  (item) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    minVerticalPadding: 0,
                    leading: Text(
                      '${item.quantity}x',
                      style: ktsFormTitleText,
                    ),
                    title: Text(item.name),
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
                                .format(item
                                    .price), // The remaining digits without the symbol
                            style: ktsBorderText2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // const Divider(
              //   color: kcBorderColor,
              // ),
              verticalSpaceSmall,
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sub total',
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
                              .format(viewModel.sale!
                                  .subtotal), // The remaining digits without the symbol
                          style: ktsBorderText2,
                        ),
                      ],
                    ),
                  ),
                ],
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
                              .format(viewModel.sale!
                                  .totalAmount), // The remaining digits without the symbol
                          style: ktsBorderText2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              verticalSpaceIntermitent,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'More actions',
                        style: ktsTextAuthentication,
                      ),
                      Text(
                        'Tap to add extra info',
                        style: ktsFormHintText,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.sendInvoice();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Send invoice',
                          style: ktsAddNewText,
                        ),
                        horizontalSpaceminute,
                        SvgPicture.asset(
                          'assets/images/share.svg',
                          width: 18,
                          height: 18,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // verticalSpaceTinyt,

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
                      'Review invoice',
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
                        color: viewModel.sale!.saleStatusId == 1
                            ? kcButtonTextColor
                            : kcSuccessColor, // Fill color
                      ),
                    ),
                    onTap: viewModel.sale!.saleStatusId == 1
                        ? () {
                            showModalBottomSheet(
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
                                        0.9,
                                    child: RecordSaleExpenseView(
                                      selectedSale: viewModel.sale!,
                                    ),
                                  ),
                                );
                              },
                            ).whenComplete(() async {
                              viewModel.rebuildUi();
                              viewModel.reloadView();
                            });
                            // viewModel.reloadView();
                          }
                        : null,
                    title: const Text(
                      'Record sale expense',
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
                        color: viewModel.sale!.saleStatusId <= 2
                            ? kcButtonTextColor
                            : kcSuccessColor, // Fill color
                      ),
                    ),
                    title: Text(
                      'Add payment details',
                      style: ktsFormTitleText,
                    ),
                    onTap: viewModel.sale!.saleStatusId == 2
                        ? () {
                            // Navigator.of(context).pop();
                            // Handle the action
                            showModalBottomSheet(
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
                                    child: MakeSalesPaymentView(
                                      selectedSales: viewModel.sale!,
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
  ViewSalesViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final String saleId = ModalRoute.of(context)!.settings.arguments as String;
    return ViewSalesViewModel(saleId: saleId);
  }
}
