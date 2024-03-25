import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/create_merchant/create_merchant_view.form.dart';

import 'create_merchant_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'name'),
  FormTextField(name: 'email'),
])
class CreateMerchantView extends StackedView<CreateMerchantViewModel>
    with $CreateMerchantView {
  const CreateMerchantView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CreateMerchantViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        busy: viewModel.isBusy,
        // validationMessage: viewModel.validationMessage,
        onBackPressed: viewModel.navigateBack,
        title: 'Create a merchant',
        subtitle: 'This can be your supplier or manufacturer',
        mainButtonTitle: 'Save merchant',
        onMainButtonTapped: () {
          if (viewModel.formKey.currentState!.validate()) {
            viewModel.saveMerchantData(context);
          }
        },

        form: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                cursorColor: kcPrimaryColor,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'Enter merchant name',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                textCapitalization: TextCapitalization.words,
                style: ktsBodyText,
                controller: nameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
              // verticalSpaceSmall
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onDispose(CreateMerchantViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(CreateMerchantViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  CreateMerchantViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CreateMerchantViewModel();
}
