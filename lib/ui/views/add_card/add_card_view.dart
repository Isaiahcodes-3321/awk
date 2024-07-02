import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/add_card/add_card_view.form.dart';

import 'add_card_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'userId'),
  FormTextField(name: 'amount'),
])
class AddCardView extends StackedView<AddCardViewModel> with $AddCardView {
  const AddCardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddCardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: AuthenticationLayout(
          onBackPressed: viewModel.navigateBack,
          busy: viewModel.isBusy,
          onMainButtonTapped: () {
            if (viewModel.formKey.currentState!.validate()) {
              // SudoCardSpendingInterval selectedInterval =
              //     viewModel.selectedInterval!;
              // Set the spending limit in the ViewModel
              num amount = num.parse(amountController.text);
              viewModel.setSpendingLimit(amount, viewModel.selectedInterval!);
              viewModel.createSudoCard(context);
            }
          },
          title: 'Add card',
          subtitle: 'Create a verzo card',
          mainButtonTitle: 'Add card',
          form: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Assigned User', style: ktsFormTitleText),
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
                      return 'Please select an assigned user';
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
                  items: viewModel.userdropdownItems,
                  value: userIdController.text.isEmpty
                      ? null
                      : userIdController.text,
                  onChanged: (value) {
                    userIdController.text = value.toString();
                  },
                ),
                verticalSpaceIntermitent,
                Text('Spending limit', style: ktsSubtitleTextAuthentication),
                verticalSpaceSmallMid,
                Text('Amount', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Enter amount',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  // textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid amount';
                    }

                    // Check if the value is not a whole number (non-integer) or is negative
                    final parsedValue = int.tryParse(value);
                    if (parsedValue == null || parsedValue < 0) {
                      return 'Please enter a valid non-negative whole number (integer)';
                    }

                    return null;
                  },
                ),
                verticalSpaceSmall,
                Text('Interval', style: ktsFormTitleText),
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
                    if (value == null
                        // ||

                        // value.isEmpty
                        ) {
                      return 'Please select an interval';
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
                  items: SudoCardSpendingInterval.values.map((interval) {
                    return DropdownMenuItem(
                      value: interval,
                      child: Text(interval
                          .toString()
                          .split('.')
                          .last), // Display enum value as string
                    );
                  }).toList(),
                  value: viewModel
                      .selectedInterval, // Define selectedInterval in your widget's state
                  onChanged: (value) {
                    viewModel.setSelectedInterval(value!);
                  },
                ),
              ],
            ),
          )),
    );
  }

  @override
  void onDispose(AddCardViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(AddCardViewModel viewModel) async {
    await viewModel.getUsersByBusiness();
    syncFormWithViewModel(viewModel);
  }

  @override
  AddCardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddCardViewModel();
}
