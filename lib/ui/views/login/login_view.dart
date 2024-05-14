import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/login/login_view.form.dart';
import 'package:verzo/ui/views/login/login_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'email'),
  FormTextField(name: 'password'),
])
class LoginView extends StackedView<LoginViewModel> with $LoginView {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
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
            // onSecondaryButtonTapped: (() {}),
            onCreateAccountTapped: viewModel.navigateToCreateAccount,
            // validationMessage: viewModel.validationMessage,
            title: 'Log in to Verzo ',
            subtitle: 'Get back into your account',
            form: Form(
              key: viewModel.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email address', style: ktsFormTitleText),
                  verticalSpaceTiny,
                  TextFormField(
                    cursorColor: kcPrimaryColor,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        hintText: 'e.g john@mail.com',
                        hintStyle: ktsFormHintText,
                        enabledBorder: defaultFormBorder,
                        focusedBorder: defaultFocusedFormBorder,
                        focusedErrorBorder: defaultErrorFormBorder,
                        errorStyle: ktsErrorText,
                        errorBorder: defaultErrorFormBorder),
                    style: ktsBodyText,
                    controller: viewModel.emailController1,
                    // controller:
                    //     viewModel.email != null && viewModel.email!.isNotEmpty
                    //         ? TextEditingController(text: viewModel.email!)
                    //         : emailController,
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
                        hintText: 'Enter your password',
                        hintStyle: ktsFormHintText,
                        enabledBorder: defaultFormBorder,
                        focusedBorder: defaultFocusedFormBorder,
                        focusedErrorBorder: defaultErrorFormBorder,
                        errorMaxLines: 3,
                        errorStyle: ktsErrorText,
                        errorBorder: defaultErrorFormBorder),
                    style: ktsBodyText,
                    controller: viewModel.passwordController1,
                    // controller: viewModel.password != null &&
                    //         viewModel.password!.isNotEmpty
                    //     ? TextEditingController(text: viewModel.password!)
                    //     : passwordController,
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
            onForgotPassword: () {},
            mainButtonTitle: 'Log in',
            // secondaryButtonTitle: 'Continue with Google',
            // showTermsText: true,
          )),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();

  @override
  void onDispose(LoginViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(LoginViewModel viewModel) async {
    viewModel.setEmailPassword();
    // syncFormWithViewModel(viewModel);
  }
}
