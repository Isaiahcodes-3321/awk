import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/make_purchase_payment/make_purchase_payment_view.dart';
import 'package:verzo/ui/views/mark_purchase_item_as_received/mark_purchase_item_as_received_view.dart';
import 'package:verzo/ui/views/merchant_invoice_to_purchase/merchant_invoice_to_purchase_view.dart';

import 'view_purchase_viewmodel.dart';

class ViewPurchaseView extends StackedView<ViewPurchaseViewModel> {
  const ViewPurchaseView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(ViewPurchaseViewModel viewModel) async {
    // syncFormWithViewModel(viewModel);
    await viewModel.getPurchaseById();
  }

  @override
  Widget builder(
    BuildContext context,
    ViewPurchaseViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.purchase == null) {
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
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            viewModel.archivePurchase(context);
                          },
                          icon: SvgPicture.asset(
                            'assets/images/archive-2.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            viewModel.deletePurchase(context);
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
                    '#${viewModel.purchase!.reference}',
                    style: ktsTextAuthentication2,
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.purchase!.purchaseStatusId == 1
                          ? viewModel.navigationService.navigateTo(
                              Routes.updatePurchaseView,
                              arguments: viewModel.purchaseId)
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
                        viewModel.purchase!.merchantName,
                        style: ktsTextAuthentication2,
                      ),
                      verticalSpaceTinyt1,
                      Text(
                        viewModel.purchase!.merchantEmail,
                        style: ktsFormHintText,
                      ),
                    ],
                  ),
                  if (viewModel.purchase!.paid == true)
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
                        'Description',
                        style: ktsFormHintText,
                      ),
                      verticalSpaceTinyt,
                      Text(
                        viewModel.purchase!.description,
                        style: ktsTextAuthentication3,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
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
                        viewModel.purchase!.transactionDate,
                        style: ktsTextAuthentication3,
                      ),
                    ],
                  )
                ],
              ),
              verticalSpaceIntermitent,
              Text(
                'Purchase details',
                style: ktsTextAuthentication,
              ),
              if (viewModel.purchase!.purchaseItems.isNotEmpty)
                verticalSpaceTiny,
              if (viewModel.purchase!.purchaseItems.isNotEmpty)
                ...viewModel.purchase!.purchaseItems.map(
                  (purchaseItem) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    minVerticalPadding: 0,
                    leading: Text(
                      '${purchaseItem.quantity}x',
                      style: ktsFormTitleText,
                    ),
                    title: Text(purchaseItem.itemDescription),
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
                                .format(purchaseItem
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
                              .format(viewModel.purchase!
                                  .total), // The remaining digits without the symbol
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
                      viewModel.sendPurchase();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Send purchase',
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
                      'Review purchase',
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
                        color: viewModel.purchase!.purchaseStatusId == 1
                            ? kcButtonTextColor
                            : kcSuccessColor, // Fill color
                      ),
                    ),
                    onTap: viewModel.purchase!.purchaseStatusId == 1
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
                                    child: MarkPurchaseItemAsReceivedView(
                                      selectedPurchase: viewModel.purchase!,
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
                        color: viewModel.purchase!.purchaseStatusId <= 2
                            ? kcButtonTextColor
                            : kcSuccessColor, // Fill color
                      ),
                    ),
                    onTap: viewModel.purchase!.purchaseStatusId == 2
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
                                        0.54,
                                    child: MerchantInvoiceToPurchaseView(
                                      selectedPurchase: viewModel.purchase!,
                                    ),
                                  ),
                                );
                              },
                            ).whenComplete(() async {
                              viewModel.rebuildUi();
                              // Navigator.of(context).pop();
                            });
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
                        color: viewModel.purchase!.purchaseStatusId <= 3
                            ? kcButtonTextColor
                            : kcSuccessColor, // Fill color
                      ),
                    ),
                    title: Text(
                      'Add payment details',
                      style: ktsFormTitleText,
                    ),
                    onTap: viewModel.purchase!.purchaseStatusId == 3
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
                                    child: MakePurchasePaymentView(
                                      selectedPurchase: viewModel.purchase!,
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
  ViewPurchaseViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final String purchaseId =
        ModalRoute.of(context)!.settings.arguments as String;
    return ViewPurchaseViewModel(purchaseId: purchaseId);
  }
}
