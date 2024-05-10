import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/business_account/business_account_view.form.dart';

import 'business_account_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'bvn'),
  FormTextField(name: 'otp'),
  FormTextField(name: 'address'),
  FormTextField(name: 'city'),
  FormTextField(name: 'state'),
  FormTextField(name: 'postalCode'),
  FormTextField(name: 'dateOfBirth'),
])
class BusinessAccountView extends StackedView<BusinessAccountViewModel>
    with $BusinessAccountView {
  const BusinessAccountView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BusinessAccountViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kcButtonTextColor,
        body: AuthenticationLayout(
          busy: viewModel.isBusy,
          // validationMessage: viewModel.validationMessage,
          onBackPressed: viewModel.navigateBack,
          onMainButtonTapped: () {
            if (viewModel.formKey.currentState!.validate()) {
              viewModel.saveBusinessData(context);
            }
          },
          title: 'Tell us about your business',
          subtitle: 'Create your business account',
          mainButtonTitle: 'Create account',
          form: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text('BVN', style: ktsSubtitleTextAuthentication),
                //     Text(viewModel.bvnNo, style: ktsSubtitleTextAuthentication),
                //   ],
                // ),
                // verticalSpaceTiny1,
                Text('BVN OTP', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Enter 6 digit OTP',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  // textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your 6 digit OTP';
                    }
                    if (value.length != 6) {
                      return 'Please enter your 6 digit OTP';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter your 6 digit OTP';
                    }
                    return null;
                  },
                ),
                verticalSpaceSmallMid,
                Text('Date of birth (DOB)', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  onTap: () async {
                    await viewModel.showDatePickerDialog(context);
                    if (viewModel.pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd')
                          .format(viewModel.pickedDate!);
                      dateOfBirthController.text = formattedDate;
                    }
                  },
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Pick a date',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  style: ktsBodyText,
                  controller: dateOfBirthController,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pick a date';
                    }
                    return null;
                  },
                ),
                verticalSpaceSmall,
                Text("Address", style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  maxLines: 3,
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      // contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      hintText: "Address",
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  }),
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
                verticalSpaceSmall,
                Text('City', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Lekki',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: cityController,
                  keyboardType: TextInputType.text,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  }),
                ),
                verticalSpaceSmall,
                Text('State', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Lagos',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: stateController,
                  keyboardType: TextInputType.text,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a state';
                    }
                    return null;
                  }),
                ),
                verticalSpaceSmall,
                Text('Postal code', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: '100001',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  // textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: postalCodeController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your 6 digit postal code';
                    }
                    if (value.length != 6) {
                      return 'Please enter your 6 digit postal code';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter your 6 digit postal code';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // void onDispose(BusinessAccountViewModel viewModel) {
  //   super.onDispose(viewModel);
  //   disposeForm();
  // }

  @override
  void onViewModelReady(BusinessAccountViewModel viewModel) async {
    // viewModel.setBusinessDetails;
    syncFormWithViewModel(viewModel);
  }

  @override
  BusinessAccountViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BusinessAccountViewModel();
}
