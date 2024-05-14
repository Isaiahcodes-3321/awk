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
import 'package:verzo/ui/views/make_purchase_payment/make_purchase_payment_view.form.dart';

import 'make_purchase_payment_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'paymentDescription'),
  FormTextField(name: 'paymentTransactionDate'),
])
class MakePurchasePaymentView extends StackedView<MakePurchasePaymentViewModel>
    with $MakePurchasePaymentView {
  final Purchases selectedPurchase;

  const MakePurchasePaymentView({Key? key, required this.selectedPurchase})
      : super(key: key);

  @override
  void onDispose(MakePurchasePaymentViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(MakePurchasePaymentViewModel viewModel) async {
    syncFormWithViewModel(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    MakePurchasePaymentViewModel viewModel,
    Widget? child,
  ) {
    return AuthenticationLayout(
        busy: viewModel.isBusy,
        validationMessage: viewModel.validationMessage,
        title: 'Add payment details',
        subtitle: 'Add payment to this purchase',
        mainButtonTitle: 'Save',
        onMainButtonTapped: () async {
          if (viewModel.formKey.currentState!.validate()) {
            await viewModel.payment(context);
          }
        },
        form: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment date', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  onTap: () async {
                    await viewModel.showDatePickerDialog(context);
                    if (viewModel.pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd')
                          .format(viewModel.pickedDate!);
                      paymentTransactionDateController.text = formattedDate;
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
                  controller: paymentTransactionDateController,
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
                verticalSpaceSmall,
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
                  textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: paymentDescriptionController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }

                    return null;
                  },
                ),
              ],
            )));
  }

  @override
  MakePurchasePaymentViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MakePurchasePaymentViewModel(purchase: selectedPurchase);
}
