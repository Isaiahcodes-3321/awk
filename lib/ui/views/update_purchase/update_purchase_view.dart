import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/merchant_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'update_purchase_viewmodel.dart';

class UpdatePurchaseView extends StackedView<UpdatePurchaseViewModel> {
  const UpdatePurchaseView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(UpdatePurchaseViewModel viewModel) async {
    await viewModel.getPurchaseById1();
    // await viewModel.getMerchantsByBusiness();
    viewModel.setSelectedPurchase();

    // syncFormWithViewModel(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    UpdatePurchaseViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const Scaffold(
        backgroundColor: kcButtonTextColor,
        body: Center(
            child: CircularProgressIndicator(
          color: kcPrimaryColor,
        )),
      );
    }
    return Scaffold(
        backgroundColor: kcButtonTextColor,
        body: AuthenticationLayout(
          busy: viewModel.isBusy,
          onBackPressed: viewModel.navigateBack,
          // validationMessage: viewModel.validationMessage,
          onMainButtonTapped: () {
            if (viewModel.formKey.currentState!.validate()) {
              viewModel.updatePurchaseData(context);
            }
          },
          title: 'Update Purchase',
          subtitle: 'Fill out the information below to edit this purchase',
          mainButtonTitle: 'Save',
          form: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Merchant details',
                        style: ktsSubtitleTextAuthentication),
                    GestureDetector(
                      onTap: () async {
                        // Navigate to the create customer view
                        await viewModel.navigationService
                            .navigateTo(Routes.createMerchantView);
                        await viewModel.getMerchantsByBusiness();
                      },
                      child: Text(
                        '+ Add merchant',
                        style: ktsAddNewText,
                      ),
                    )
                  ],
                ),
                verticalSpaceSmallMid,
                Text('Merchant', style: ktsFormTitleText),
                verticalSpaceTiny,
                DropdownButtonFormField(
                  hint: Text(
                    'Select',
                    style: ktsFormHintText,
                  ),
                  menuMaxHeight: 320,
                  elevation: 4,
                  // padding: EdgeInsets.symmetric(horizontal: 12),
                  dropdownColor: kcButtonTextColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a merchant';
                    }
                    return null;
                  },
                  icon: const Icon(Icons.expand_more),
                  iconSize: 20,
                  isExpanded: true,
                  focusColor: kcPrimaryColor,
                  style: ktsBodyText,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // hintStyle: ktsFormHintText,
                      // hintText: 'Select',
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder,
                      // labelStyle: ktsFormText,
                      border: defaultFormBorder),
                  items: viewModel.merchantdropdownItems,
                  value: viewModel.updateMerchantIdController.text.isEmpty
                      ? null
                      : viewModel.updateMerchantIdController.text,
                  onChanged: (value) {
                    viewModel.updateMerchantIdController.text =
                        value.toString();
                    // Find the selected customer
                    Merchants selectedMerchant =
                        viewModel.merchantList.firstWhere(
                      (merchant) => merchant.id.toString() == value.toString(),
                    );
                    viewModel.updateMerchantEmailController.text =
                        selectedMerchant.email;

                    // Update the selected customer name
                    viewModel.selectedMerchantName = selectedMerchant.email;
                  },
                ),
                verticalSpaceSmall,
                Text('Email address', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  readOnly: true,

                  controller: viewModel.updateMerchantEmailController,
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // hintText: 'Enter email address',
                      // hintStyle: ktsFormHintText,
                      border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      errorBorder: defaultErrorFormBorder),
                  // textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  keyboardType: TextInputType.emailAddress,
                  // validator: ((value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter a valid email';
                  //   }
                  //   return null;
                  // }),
                ),
                verticalSpaceSmall,
                Text('Transaction date', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  onTap: () async {
                    await viewModel.showDatePickerDialog(context);
                    if (viewModel.pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd')
                          .format(viewModel.pickedDate!);
                      viewModel.updateTransactionDateController.text =
                          formattedDate;
                    }
                  },
                  readOnly: true,
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/images/calendar-03.svg',
                          color: kcFormBorderColor,
                        ),
                      ),
                      suffixIconColor: kcFormBorderColor,
                      hintText: 'Pick a date',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  style: ktsBodyText,
                  controller: viewModel.updateTransactionDateController,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                verticalSpaceIntermitent,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Items', style: ktsSubtitleTextAuthentication),
                    horizontalSpaceTiny,
                    GestureDetector(
                      onTap: () async {
                        viewModel.newlySelectedPurchaseItems = await viewModel
                            .navigationService
                            .navigateTo(Routes.choosePurchaseItemView);
                        // Receive the selected items from ChooseItemView
                        viewModel.addselectedItems(
                            viewModel.convertProductsToPurchaseItemDetails(
                                viewModel.newlySelectedPurchaseItems));
                      },
                      child: Text(
                        '+ Add item',
                        style: ktsAddNewText,
                      ),
                    )
                  ],
                ),
                if (viewModel.selectedPurchaseItems.isNotEmpty)
                  verticalSpaceTiny,
                if (viewModel.selectedPurchaseItems.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.selectedPurchaseItems.length,
                    itemBuilder: (context, index) {
                      final purcahseItem =
                          viewModel.selectedPurchaseItems[index];
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 2),
                        minVerticalPadding: 0,
                        leading: Text(
                          '${purcahseItem.quantity}x',
                          style: ktsQuantityText,
                        ),
                        title: Text(purcahseItem.itemDescription),
                        // ... display other purchase item details ...
                        titleTextStyle: ktsBorderText,
                        subtitle: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: NumberFormat.currency(
                                        locale: 'en_NGN', symbol: '₦')
                                    .currencySymbol, // The remaining digits without the symbol
                                style: ktsFormHintText.copyWith(
                                    fontFamily: 'Roboto'),
                              ),
                              TextSpan(
                                text: NumberFormat.currency(
                                        locale: 'en_NGN', symbol: '')
                                    .format(purcahseItem
                                        .unitPrice), // The remaining digits without the symbol
                                style: ktsFormHintText,
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/edit-03.svg',
                                width: 20,
                                height: 20,
                              ),
                              onPressed: () {
                                viewModel.openEditBottomSheet(purcahseItem);
                              },
                            ),
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/trash-01.svg',
                                width: 20,
                                height: 20,
                              ),
                              onPressed: () {
                                viewModel.removeSelectedItem(purcahseItem);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                // if (viewModel.selectedItems.isNotEmpty) verticalSpaceTinyt,
                if (viewModel.selectedPurchaseItems.isNotEmpty) const Divider(),
                if (viewModel.selectedPurchaseItems.isNotEmpty)
                  verticalSpaceTinyt,
                if (viewModel.selectedPurchaseItems.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount due', style: ktsBorderText),
                      RichText(
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
                                  .format(viewModel
                                      .total), // The remaining digits without the symbol
                              style: ktsBorderText2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (viewModel.selectedPurchaseItems.isNotEmpty)
                  verticalSpaceTiny,
                if (viewModel.selectedPurchaseItems.isNotEmpty) const Divider(),
                verticalSpaceIntermitent,
                Text('Description', style: ktsSubtitleTextAuthentication),
                verticalSpaceTiny,
                TextFormField(
                  maxLines: 3,
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      hintText: 'Say more to your customer',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  textCapitalization: TextCapitalization.sentences,
                  style: ktsBodyText,
                  controller: viewModel.updateDescriptionController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }

                    return null;
                  },
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      // Ensure the first letter of the input is capitalized
                      if (newValue.text.isNotEmpty) {
                        return TextEditingValue(
                          text: newValue.text[0].toUpperCase() +
                              newValue.text.substring(1),
                          selection: newValue.selection,
                        );
                      }
                      return newValue;
                    }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  UpdatePurchaseViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final String purchaseId =
        ModalRoute.of(context)!.settings.arguments as String;
    return UpdatePurchaseViewModel(purchaseId: purchaseId);
  }
}
