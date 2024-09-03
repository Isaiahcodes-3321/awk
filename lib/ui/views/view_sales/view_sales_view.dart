import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
                      bool hasSaleExpense =
                          viewModel.sale!.saleExpenses!.isNotEmpty;

                      if (hasSaleExpense) {
                        if (viewModel.sale!.saleStatusId == 1) {
                          viewModel.navigationService.navigateTo(
                            Routes.updateSalesView,
                            arguments: viewModel.saleId,
                          );
                        }
                      } else {
                        if (viewModel.sale!.saleStatusId == 2) {
                          viewModel.navigationService.navigateTo(
                            Routes.updateSalesView,
                            arguments: viewModel.saleId,
                          );
                        }
                      }

                      viewModel.rebuildUi();
                      // viewModel.sale!.saleStatusId == 1
                      //     ? viewModel.navigationService.navigateTo(
                      //         Routes.updateSalesView,
                      //         arguments: viewModel.saleId)
                      //     : null;

                      // viewModel.rebuildUi();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: (viewModel.sale!.saleExpenses!.isNotEmpty &&
                                      viewModel.sale!.saleStatusId == 1) ||
                                  (viewModel.sale!.saleExpenses!.isEmpty &&
                                      viewModel.sale!.saleStatusId == 2)
                              ? 1.0
                              : 0.6, // Set opacity based on the condition
                          child: SvgPicture.asset(
                            'assets/images/edit-contained.svg',
                            width: 18,
                            height: 18,
                          ),
                        ),
                        horizontalSpaceminute,
                        Text(
                          'Edit',
                          style: ktsAddNewText.copyWith(
                            color: (viewModel.sale!.saleExpenses!.isNotEmpty &&
                                        viewModel.sale!.saleStatusId == 1) ||
                                    (viewModel.sale!.saleExpenses!.isEmpty &&
                                        viewModel.sale!.saleStatusId == 2)
                                ? ktsAddNewText.color
                                : ktsAddNewText.color?.withOpacity(0.6),
                          ),
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

              verticalSpaceTiny,
              Divider(
                color: kcBorderColor,
              ),
              verticalSpaceTiny,
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          viewModel.sale!.description,
                          style: ktsTextAuthentication3,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  horizontalSpaceSmall,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Currency',
                        style: ktsFormHintText,
                      ),
                      verticalSpaceTinyt,
                      Text(
                        ('${viewModel.sale!.currencyName}(${viewModel.sale!.currencySymbol}) '),
                        style: GoogleFonts.openSans(
                          color: kcTextTitleColor.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ).copyWith(fontFamily: 'Roboto'),
                      ),
                    ],
                  )
                ],
              ),
              if (viewModel.sale!.note!.isNotEmpty) verticalSpaceTiny,
              if (viewModel.sale!.note!.isNotEmpty)
                Divider(
                  color: kcBorderColor,
                ),
              if (viewModel.sale!.note!.isNotEmpty) verticalSpaceTiny,
              if (viewModel.sale!.note!.isNotEmpty)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes / Terms',
                      style: ktsFormHintText,
                    ),
                    verticalSpaceTinyt,
                    Text(
                      viewModel.sale!.note!,
                      style: ktsTextAuthentication3,
                    ),
                  ],
                ),
              verticalSpaceIntermitent,
              Text(
                'Invoice details',
                style: ktsFormTitleText3,
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
                                    symbol: viewModel.sale!.currencySymbol)
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
                                  symbol: viewModel.sale!.currencySymbol)
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
              verticalSpaceTiny,
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VAT',
                    style: ktsBorderText,
                  ),
                  Text(
                    '+7.5%',
                    style: ktsBorderText2,
                  ),
                ],
              ),
              if (viewModel.sale!.saleExpenses!.isNotEmpty) verticalSpaceTiny,
              if (viewModel.sale!.saleExpenses!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sale expenses',
                      style: ktsBorderText,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: NumberFormat.currency(
                                    symbol: viewModel.sale!.currencySymbol)
                                .currencySymbol,
                            style:
                                ktsBorderText2.copyWith(fontFamily: 'Roboto'),
                          ),
                          TextSpan(
                            text: NumberFormat.currency(
                              locale: 'en_NGN',
                              symbol: '',
                            ).format(viewModel.totalSaleExpensesAmount),
                            style: ktsBorderText2,
                          ),
                        ],
                      ),
                    )
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
                    style: ktsTextAuthentication,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: NumberFormat.currency(
                                  symbol: viewModel.sale!.currencySymbol)
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
              if (viewModel.sale!.saleExpenses!.isNotEmpty) verticalSpaceSmall,
              if (viewModel.sale!.saleExpenses!.isNotEmpty)
                const Divider(
                  color: kcBorderColor,
                ),
              if (viewModel.sale!.saleExpenses!.isNotEmpty)
                Text(
                  'Sale expenses',
                  style: ktsFormTitleText3,
                ),
              if (viewModel.sale!.saleExpenses!.isNotEmpty)
                ...viewModel.sale!.saleExpenses!.map(
                  (saleExpense) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    minVerticalPadding: 0,
                    title: Text(saleExpense.description),
                    titleTextStyle: ktsBorderText,
                    trailing: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: NumberFormat.currency(
                                    symbol: viewModel.sale!.currencySymbol)
                                .currencySymbol, // The remaining digits without the symbol
                            style:
                                ktsBorderText2.copyWith(fontFamily: 'Roboto'),
                          ),
                          TextSpan(
                            text: NumberFormat.currency(
                                    locale: 'en_NGN', symbol: '')
                                .format(saleExpense
                                    .amount), // The remaining digits without the symbol
                            style: ktsBorderText2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (viewModel.sale!.saleExpenses!.isNotEmpty)
                const Divider(
                  color: kcBorderColor,
                ),
              if (viewModel.sale!.saleExpenses!.isNotEmpty) verticalSpaceSmall,
              if (viewModel.sale!.saleExpenses!.isEmpty)
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
                      viewModel.sendInvoice(context);
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
                                    child: MakeSalesPaymentView(
                                      selectedSales: viewModel.sale!,
                                    ),
                                  ),
                                );
                              },
                            ).whenComplete(() async {
                              viewModel.rebuildUi();
                              // viewModel.reloadView();
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
