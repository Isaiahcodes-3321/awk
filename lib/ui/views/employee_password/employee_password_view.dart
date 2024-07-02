import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/employee_password/employee_password_view.form.dart';

import 'employee_password_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'oldPassword'),
  FormTextField(name: 'newPassword'),
])
class EmployeePasswordView extends StackedView<EmployeePasswordViewModel>
    with $EmployeePasswordView {
  const EmployeePasswordView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EmployeePasswordViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        onBackPressed: viewModel.navigateBack,
        // validationMessage: viewModel.validationMessage,
        busy: viewModel.isBusy,
        onMainButtonTapped: () {
          if (viewModel.formKey.currentState!.validate()) {
            viewModel.resetPasswordData();
          }
        },
        title: 'Password',
        subtitle: 'Update your password',
        mainButtonTitle: 'Update password',
        form: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Old password', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                cursorColor: kcPrimaryColor,
                obscureText: !viewModel.isPasswordVisible1,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    suffixIcon: GestureDetector(
                      onTap: viewModel.togglePasswordVisibility1,
                      child: Icon(
                        viewModel.isPasswordVisible1
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 18,
                        color: kcFormBorderColor,
                      ),
                    ),
                    hintText: 'Enter current password',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorMaxLines: 3,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                style: ktsBodyText,
                controller: oldPasswordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
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
              verticalSpaceSmall,
              Text('New password', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                cursorColor: kcPrimaryColor,
                obscureText: !viewModel.isPasswordVisible2,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    suffixIcon: GestureDetector(
                      onTap: viewModel.togglePasswordVisibility2,
                      child: Icon(
                        viewModel.isPasswordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 18,
                        color: kcFormBorderColor,
                      ),
                    ),
                    hintText: '8+ characters',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorMaxLines: 3,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                // textCapitalization: TextCapitalization.words,
                style: ktsBodyText,
                controller: newPasswordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  if (!RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+]).{8,}$')
                      .hasMatch(value)) {
                    return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
                  }
                  // Check if the new password is the same as the old password
                  if (value == oldPasswordController.text) {
                    return 'New password must be different from the old password';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  EmployeePasswordViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EmployeePasswordViewModel();

  @override
  void onDispose(EmployeePasswordViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(EmployeePasswordViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }
}
