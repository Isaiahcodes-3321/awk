import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'view_business_account_viewmodel.dart';

class ViewBusinessAccountView
    extends StackedView<ViewBusinessAccountViewModel> {
  const ViewBusinessAccountView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ViewBusinessAccountViewModel viewModel,
    Widget? child,
  ) {
    if
        //  (viewModel.businessAccount == null)
        (viewModel.isBusy) {
      return Scaffold(
        backgroundColor: kcButtonTextColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: ListView(children: [
            verticalSpaceSmall,
            GestureDetector(
              onTap: viewModel.navigateBack,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: kcFormBorderColor.withOpacity(0.3),
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          fill: 0.9,
                          color: kcTextSubTitleColor,
                          size: 16,
                        ),
                        onPressed: viewModel.navigateBack),
                  ),
                  horizontalSpaceTiny,
                  Text(
                    'back',
                    style: ktsSubtitleTextAuthentication,
                  ),
                ],
              ),
            ),
            verticalSpaceSmallMid,
            const SizedBox(
              height: 500,
              child: Center(
                  child: CircularProgressIndicator(
                color: kcPrimaryColor,
              )),
            ),
          ]),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: kcButtonTextColor,
        body: AuthenticationLayout(
          onBackPressed: viewModel.navigateBack,
          busy: viewModel.isBusy,
          onMainButtonTapped: () {
            viewModel.navigateBack();
          },
          title: 'Verzo account',
          subtitle: 'View your account info',
          mainButtonTitle: 'Done',
          form: Form(
            // key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account name', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  readOnly: true,

                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // hintText: 'Enter full name',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,

                  controller: viewModel.accountNameController,
                  keyboardType: TextInputType.name,
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return 'Please enter your  name';
                  //   }
                  //   if (value.length < 2) {
                  //     return 'Name must be at least 2 characters long';
                  //   }
                  //   if (value.length > 50) {
                  //     return 'Name must not exceed 50 characters';
                  //   }

                  //   // // Optional: Check for alphabetic characters and spaces only
                  //   // // This regex allows for both uppercase and lowercase letters and space characters, but disallows numbers and special characters
                  //   // bool isValidName =
                  //   //     RegExp(r"^[a-zA-Z\s]+$").hasMatch(value);
                  //   // if (!isValidName) {
                  //   //   return 'Name must contain only letters and spaces';
                  //   // }

                  //   return null;
                  // },
                ),
                verticalSpaceSmall,
                Text('Account number', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  readOnly: true,

                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // hintText: 'Enter full name',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  // textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: viewModel.accountNumberController,
                  keyboardType: TextInputType.number,
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return 'Please enter your  name';
                  //   }
                  //   if (value.length < 2) {
                  //     return 'Name must be at least 2 characters long';
                  //   }
                  //   if (value.length > 50) {
                  //     return 'Name must not exceed 50 characters';
                  //   }

                  //   // // Optional: Check for alphabetic characters and spaces only
                  //   // // This regex allows for both uppercase and lowercase letters and space characters, but disallows numbers and special characters
                  //   // bool isValidName =
                  //   //     RegExp(r"^[a-zA-Z\s]+$").hasMatch(value);
                  //   // if (!isValidName) {
                  //   //   return 'Name must contain only letters and spaces';
                  //   // }

                  //   return null;
                  // },
                ),
                verticalSpaceSmall,
                Text('BVN', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  readOnly: true,

                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // hintText: 'Enter full name',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  // textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: viewModel.bvnController,
                  keyboardType: TextInputType.number,
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return 'Please enter your  name';
                  //   }
                  //   if (value.length < 2) {
                  //     return 'Name must be at least 2 characters long';
                  //   }
                  //   if (value.length > 50) {
                  //     return 'Name must not exceed 50 characters';
                  //   }

                  //   // // Optional: Check for alphabetic characters and spaces only
                  //   // // This regex allows for both uppercase and lowercase letters and space characters, but disallows numbers and special characters
                  //   // bool isValidName =
                  //   //     RegExp(r"^[a-zA-Z\s]+$").hasMatch(value);
                  //   // if (!isValidName) {
                  //   //   return 'Name must contain only letters and spaces';
                  //   // }

                  //   return null;
                  // },
                ),
                verticalSpaceSmall,
                Text('Account balance', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  readOnly: true,
                  // initialValue: NumberFormat.currency(
                  //   locale: 'en_NGN',
                  //   symbol: '₦',
                  // ).format(viewModel.businessAccount?.accountBalance),

                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // hintText: 'Enter full name',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: viewModel.accountBalanceController,
                  keyboardType: TextInputType.name,
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return 'Please enter your  name';
                  //   }
                  //   if (value.length < 2) {
                  //     return 'Name must be at least 2 characters long';
                  //   }
                  //   if (value.length > 50) {
                  //     return 'Name must not exceed 50 characters';
                  //   }

                  //   // // Optional: Check for alphabetic characters and spaces only
                  //   // // This regex allows for both uppercase and lowercase letters and space characters, but disallows numbers and special characters
                  //   // bool isValidName =
                  //   //     RegExp(r"^[a-zA-Z\s]+$").hasMatch(value);
                  //   // if (!isValidName) {
                  //   //   return 'Name must contain only letters and spaces';
                  //   // }

                  //   return null;
                  // },
                ),
                verticalSpaceSmall,
                Text('Account type', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  readOnly: true,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // hintText: 'Enter full name',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: viewModel.accountTypeController,
                  keyboardType: TextInputType.name,
                ),
                verticalSpaceSmall,
                Text('Address', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  maxLines: 3,
                  cursorColor: kcPrimaryColor,
                  readOnly: true,
                  decoration: InputDecoration(
                      // contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      // hintText: 'Enter full name',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: viewModel.addressController,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  void onViewModelReady(ViewBusinessAccountViewModel viewModel) async {
    await viewModel.checkbusinessAcccount();
  }

  @override
  ViewBusinessAccountViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ViewBusinessAccountViewModel();
}
