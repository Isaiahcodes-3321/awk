import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/business_creation/business_creation_view.form.dart';

import 'business_creation_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'businessName'),
  FormTextField(name: 'businessEmail'),
  FormTextField(name: 'businessMobile'),
  FormTextField(name: 'businessCategoryId'),
  FormTextField(name: 'countryId'),
])
class BusinessCreationView extends StackedView<BusinessCreationViewModel>
    with $BusinessCreationView {
  const BusinessCreationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BusinessCreationViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kcButtonTextColor,
        body: AuthenticationLayout(
          busy: viewModel.isBusy,
          // validationMessage: viewModel.validationMessage,
          // onBackPressed: model.navigateBack,
          onMainButtonTapped: () {
            if (viewModel.formKey.currentState!.validate()) {
              viewModel.saveBusinessData(context);
            }
          },
          title: 'Tell us about your business',
          subtitle: 'This will be visible by your customers and vendors',
          mainButtonTitle: 'Set up business',
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
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
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
                  controller: businessNameController,
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
                  style: ktsBodyText,
                  controller: businessEmailController,
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
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Enter business phone number',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  style: ktsBodyText,
                  controller: businessMobileController,
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
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // hintStyle: ktsFormHintText,
                      // hintText: 'Select',
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder
                      // labelStyle: ktsFormText,
                      // border: defaultFormBorder
                      ),
                  items: viewModel.businessCategorydropdownItems,
                  value: businessCategoryIdController.text.isEmpty
                      ? null
                      : businessCategoryIdController.text,
                  onChanged: (value) {
                    businessCategoryIdController.text = value.toString();
                  },
                ),
                verticalSpaceSmall,
                Text('Country', style: ktsFormTitleText),
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
                      return 'Please select a country';
                    }
                    return null;
                  },
                  icon: const Icon(Icons.expand_more),
                  iconSize: 20,
                  isExpanded: true,
                  focusColor: kcPrimaryColor,
                  style: ktsBodyText,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // hintStyle: ktsFormHintText,
                      // hintText: 'Select',
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder
                      // labelStyle: ktsFormText,
                      // border: defaultFormBorder
                      ),
                  items: viewModel.countrydropdownItems,
                  value: countryIdController.text.isEmpty
                      ? null
                      : countryIdController.text,
                  onChanged: (value) {
                    countryIdController.text = value.toString();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onDispose(BusinessCreationViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(BusinessCreationViewModel viewModel) async {
    await viewModel.getBusinessCategories();
    await viewModel.getCountries();
    syncFormWithViewModel(viewModel);
  }

  @override
  BusinessCreationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BusinessCreationViewModel();
}
