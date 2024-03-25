import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/merchant_invoice_to_purchase/merchant_invoice_to_purchase_view.form.dart';

import 'merchant_invoice_to_purchase_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'date'),
])
class MerchantInvoiceToPurchaseView
    extends StackedView<MerchantInvoiceToPurchaseViewModel>
    with $MerchantInvoiceToPurchaseView {
  final Purchases selectedPurchase;
  const MerchantInvoiceToPurchaseView(
      {Key? key, required this.selectedPurchase})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MerchantInvoiceToPurchaseViewModel viewModel,
    Widget? child,
  ) {
    return AuthenticationLayout(
        busy: viewModel.isBusy,
        validationMessage: viewModel.validationMessage,
        title: 'Merchant invoice',
        subtitle: 'Upload merchant invoice',
        mainButtonTitle: 'Save',
        onMainButtonTapped: () async {
          if (viewModel.formKey.currentState!.validate()) {
            await viewModel.upload(context);
          }
        },
        form: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  onTap: () async {
                    await viewModel.showDatePickerDialog(context);
                    if (viewModel.pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd')
                          .format(viewModel.pickedDate!);
                      dateController.text = formattedDate;
                    }
                  },
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
                  controller: dateController,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                verticalSpaceSmall,
                Text('Amount', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  readOnly: true,
                  initialValue: NumberFormat.currency(
                    locale: 'en_NGN',
                    symbol: '₦',
                  ).format(viewModel.purchase.total),
                  cursorColor: kcPrimaryColor,

                  decoration: InputDecoration(
                      filled: true,
                      fillColor: kcOTPColor,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      errorBorder: defaultErrorFormBorder),
                  // textCapitalization: TextCapitalization.words,
                  style: ktsBodyText.copyWith(fontFamily: 'Roboto'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            )));
  }

  @override
  MerchantInvoiceToPurchaseViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MerchantInvoiceToPurchaseViewModel(purchase: selectedPurchase);

  @override
  void onDispose(MerchantInvoiceToPurchaseViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(MerchantInvoiceToPurchaseViewModel viewModel) async {
    syncFormWithViewModel(viewModel);
  }
}
