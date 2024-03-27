import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/views/verification/verification_view.form.dart';

import 'verification_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'otp1'),
  FormTextField(name: 'otp2'),
  FormTextField(name: 'otp3'),
  FormTextField(name: 'otp4'),
])
class VerificationView extends StackedView<VerificationViewModel>
    with $VerificationView {
  const VerificationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    VerificationViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: kcButtonTextColor,
          body: AuthenticationLayout(
            busy: viewModel.isBusy,
            onMainButtonTapped: () {
              if (viewModel.formKey.currentState!.validate()) {
                viewModel.getVerificationResponse(context);
              }
            },
            onResendVerificationCodeTapped: viewModel.resendVerification,
            // validationMessage: viewModel.validationMessage,
            title: 'Enter OTP',
            subtitle: 'Please enter the OTP sent to your email inbox',
            form: Form(
              key: viewModel.formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 44,
                    width: 44,
                    child: TextFormField(
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder,
                          fillColor: kcOTPColor,
                          filled: true),
                      controller: otp1Controller,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      onSaved: (pin1) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    width: 44,
                    child: TextFormField(
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder,
                          fillColor: kcOTPColor,
                          filled: true),
                      controller: otp2Controller,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      onSaved: (pin2) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    width: 44,
                    child: TextFormField(
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder,
                          fillColor: kcOTPColor,
                          filled: true),
                      controller: otp3Controller,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      onSaved: (pin3) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    width: 44,
                    child: TextFormField(
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder,
                          fillColor: kcOTPColor,
                          filled: true),
                      controller: otp4Controller,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      onSaved: (pin4) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        final parsedValue = int.tryParse(value);
                        if (parsedValue == null || parsedValue < 0) {
                          return '';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            mainButtonTitle: 'Verify',
            // showTermsText: false,
          )),
    );
  }

  @override
  void onDispose(VerificationViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(VerificationViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  VerificationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      VerificationViewModel();
}
