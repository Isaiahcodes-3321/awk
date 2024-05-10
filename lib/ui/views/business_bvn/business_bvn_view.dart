import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/business_account/business_account_view.form.dart';
import 'package:verzo/ui/views/business_account/business_account_viewmodel.dart';

class BusinessBvnView extends StackedView<BusinessAccountViewModel>
    with $BusinessAccountView {
  const BusinessBvnView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BusinessAccountViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kcButtonTextColor,
        body: AuthenticationLayout(
          busy: viewModel.isBusy,
          // validationMessage: viewModel.validationMessage,
          onBackPressed: viewModel.navigateBack2,
          onMainButtonTapped: () {
            if (viewModel.formKey.currentState!.validate()) {
              viewModel.saveBVNData(context);
            }
          },
          title: 'Tell us about your business',
          subtitle: 'Input your BVN ',
          mainButtonTitle: 'Next',
          form: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceSmallMid,
                Text('Bank Verification Number (BVN)', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'BVN',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  // textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: bvnController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your 11 digit BVN';
                    }
                    if (value.length != 11) {
                      return 'Please enter your 11 digit BVN';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter your 11 digit BVN';
                    }
                    return null;
                  },
                ),
                // verticalSpaceSmall,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(BusinessAccountViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  BusinessAccountViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BusinessAccountViewModel();
}
