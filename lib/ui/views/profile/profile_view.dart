import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        onBackPressed: viewModel.navigateBack,
        busy: viewModel.isBusy,
        onMainButtonTapped: () {
          if (viewModel.formKey.currentState!.validate()) {
            viewModel.updateUserData(context);
          }
        },
        title: 'Personal information',
        subtitle: 'Provide accurate info',
        mainButtonTitle: 'Update profile',
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                controller: viewModel.updateUserNameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your  name';
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
                controller: viewModel.updateUserEmailController,
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(ProfileViewModel viewModel) async {
    // syncFormWithViewModel(viewModel);
    await viewModel.getUserAndBusinessData();
    viewModel.setSelectedUser();
  }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();
}
