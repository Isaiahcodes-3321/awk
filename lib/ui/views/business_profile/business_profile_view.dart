import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'business_profile_viewmodel.dart';

class BusinessProfileView extends StackedView<BusinessProfileViewModel> {
  const BusinessProfileView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BusinessProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        onBackPressed: viewModel.navigateBack,
        busy: viewModel.isBusy,
        onMainButtonTapped: () {
          if (viewModel.formKey.currentState!.validate()) {
            viewModel.updateBusinessData(context);
          }
        },
        title: 'Business profile',
        subtitle: 'Provide accurate info',
        mainButtonTitle: 'Update business',
        form: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Business name', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                cursorColor: kcPrimaryColor,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'Enter business name',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                textCapitalization: TextCapitalization.words,
                style: ktsBodyText,
                controller: viewModel.updateBusinessNameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your business name';
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
                    hintText: 'Enter business email address',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                style: ktsBodyText,
                controller: viewModel.updateBusinessEmailController,
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
              Text('Phone number', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                cursorColor: kcPrimaryColor,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'Enter business phone number',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                style: ktsBodyText,
                controller: viewModel.updateBusinessMobileController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }

                  // Check if the value consists only of whole numbers
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Please enter a valid phone number with digits only';
                  }

                  return null;
                },
              ),
              verticalSpaceSmall,
              Text('Business Category', style: ktsFormTitleText),
              verticalSpaceTiny,
              DropdownButtonFormField(
                hint: Text(
                  'Select',
                  style: ktsFormHintText,
                ),
                menuMaxHeight: 320,
                elevation: 4,
                // padding: EdgeInsets.symmetric(horizontal: 12),
                dropdownColor: kcButtonTextColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
                icon: const Icon(Icons.expand_more),
                iconSize: 20,
                isExpanded: true,
                focusColor: kcPrimaryColor,
                style: ktsBodyText,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    // hintStyle: ktsFormHintText,
                    // hintText: 'Select category',
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder
                    // labelStyle: ktsFormText,
                    // border: defaultFormBorder
                    ),
                items: viewModel.businessCategorydropdownItems,
                value: viewModel.updateBusinessCategoryIdController.text.isEmpty
                    ? null
                    : viewModel.updateBusinessCategoryIdController.text,
                onChanged: (value) {
                  viewModel.updateBusinessCategoryIdController.text =
                      value.toString();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(BusinessProfileViewModel viewModel) async {
    // syncFormWithViewModel(viewModel);
    await viewModel.getUserAndBusinessData();
    await viewModel.getBusinessCategories();
    viewModel.setSelectedBusiness();
  }

  @override
  BusinessProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BusinessProfileViewModel();
}
