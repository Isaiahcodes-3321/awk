import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/create_account/create_account_view.form.dart';

import 'create_account_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'fullName'),
  FormTextField(name: 'email'),
  FormTextField(name: 'password'),
])
class CreateAccountView extends StackedView<CreateAccountViewModel>
    with $CreateAccountView {
  const CreateAccountView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CreateAccountViewModel viewModel,
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
                viewModel.saveData(context);
              }
            },
            onLoginTapped: viewModel.navigateToLogin,
            // validationMessage: viewModel.validationMessage,
            title: 'Sign up on Verzo',
            subtitle: "Let's set up your account",
            mainButtonTitle: 'Create account',
            form: Form(
              key: viewModel.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Full name', style: ktsFormTitleText),
                  verticalSpaceTiny,
                  TextFormField(
                    cursorColor: kcPrimaryColor,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        hintText: 'Enter full name',
                        hintStyle: ktsFormHintText,
                        // border: defaultFormBorder,
                        enabledBorder: defaultFormBorder,
                        focusedBorder: defaultFocusedFormBorder,
                        focusedErrorBorder: defaultErrorFormBorder,
                        errorStyle: ktsErrorText,
                        errorBorder: defaultErrorFormBorder),
                    textCapitalization: TextCapitalization.words,
                    style: ktsBodyText,
                    controller: fullNameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.length < 2) {
                        return 'Name must be at least 2 characters long';
                      }
                      if (value.length > 50) {
                        return 'Name must not exceed 50 characters';
                      }

                      // // Optional: Check for alphabetic characters and spaces only
                      // // This regex allows for both uppercase and lowercase letters and space characters, but disallows numbers and special characters
                      // bool isValidName =
                      //     RegExp(r"^[a-zA-Z\s]+$").hasMatch(value);
                      // if (!isValidName) {
                      //   return 'Name must contain only letters and spaces';
                      // }

                      return null;
                    },
                  ),
                  verticalSpaceSmall,
                  Text('Email address', style: ktsFormTitleText),
                  verticalSpaceTiny,
                  TextFormField(
                    cursorColor: kcPrimaryColor,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        hintText: 'Enter email address',
                        hintStyle: ktsFormHintText,
                        // border: defaultFormBorder,
                        enabledBorder: defaultFormBorder,
                        focusedBorder: defaultFocusedFormBorder,
                        focusedErrorBorder: defaultErrorFormBorder,
                        errorStyle: ktsErrorText,
                        errorBorder: defaultErrorFormBorder),
                    // textCapitalization: TextCapitalization.words,
                    style: ktsBodyText,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      // Email regex pattern
                      const emailPattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      if (!RegExp(emailPattern).hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  verticalSpaceSmall,
                  Text('Password', style: ktsFormTitleText),
                  verticalSpaceTiny,
                  TextFormField(
                    cursorColor: kcPrimaryColor,
                    obscureText: !viewModel.isPasswordVisible,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        suffixIcon: GestureDetector(
                          onTap: viewModel.togglePasswordVisibility,
                          child: Icon(
                            viewModel.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 18,
                            color: kcFormBorderColor,
                          ),
                        ),
                        hintText: 'Enter password',
                        hintStyle: ktsFormHintText,
                        // border: defaultFormBorder,
                        enabledBorder: defaultFormBorder,
                        focusedBorder: defaultFocusedFormBorder,
                        focusedErrorBorder: defaultErrorFormBorder,
                        errorMaxLines: 3,
                        errorStyle: ktsErrorText,
                        errorBorder: defaultErrorFormBorder),
                    style: ktsBodyText,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+]).{8,}$')
                          .hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            showTermsText: true,
          )),
    );
  }

  @override
  void onDispose(CreateAccountViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(CreateAccountViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  CreateAccountViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CreateAccountViewModel();
}
