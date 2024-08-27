import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/pin_change/pin_change_view.form.dart';

import 'pin_change_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'currentPin'),
  FormTextField(name: 'newPin'),
])
class PinChangeView extends StackedView<PinChangeViewModel>
    with $PinChangeView {
  final String cardId;
  const PinChangeView({Key? key, required this.cardId}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PinChangeViewModel viewModel,
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
            viewModel.changePinData(context);
          }
        },
        title: 'Card pin',
        subtitle: 'Change your card pin',
        mainButtonTitle: 'Submit',
        form: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current pin', style: ktsFormTitleText),
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
                    hintText: 'Enter current pin',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorMaxLines: 3,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                style: ktsBodyText,
                controller: currentPinController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current pin';
                  }
                  if (value.length != 4) {
                    return 'Pin must be exactly 4 digits';
                  }
                  if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                    return 'Pin must contain only numbers';
                  }
                  return null;
                },
              ),
              verticalSpaceSmall,
              Text('New pin', style: ktsFormTitleText),
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
                    hintText: 'Enter new pin',
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
                controller: newPinController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new pin';
                  }
                  if (value.length != 4) {
                    return 'Pin must be exactly 4 digits';
                  }
                  if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                    return 'Pin must contain only numbers';
                  }
                  // Check if the new password is the same as the old password
                  if (value == currentPinController.text) {
                    return 'New pin must be different from the current pin';
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
  PinChangeViewModel viewModelBuilder(BuildContext context) =>
      PinChangeViewModel(cardId: cardId);

  @override
  void onDispose(PinChangeViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(PinChangeViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }
}
