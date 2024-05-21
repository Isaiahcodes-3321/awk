import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/create_service_unit/create_service_unit_view.form.dart';

import 'create_service_unit_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'unitName'),
])
class CreateServiceUnitView extends StackedView<CreateServiceUnitViewModel>
    with $CreateServiceUnitView {
  const CreateServiceUnitView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CreateServiceUnitViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        busy: viewModel.isBusy,
        // validationMessage: viewModel.validationMessage,
        onBackPressed: viewModel.navigateBack,
        title: 'New service unit',
        subtitle: 'Enter the unit details',
        mainButtonTitle: 'Save unit',
        onMainButtonTapped: () {
          if (viewModel.formKey.currentState!.validate()) {
            viewModel.saveServiceUnitData(context);
          }
        },

        form: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Unit name', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                cursorColor: kcPrimaryColor,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'Unit name',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                textCapitalization: TextCapitalization.words,
                style: ktsBodyText,
                controller: unitNameController,
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onDispose(CreateServiceUnitViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(CreateServiceUnitViewModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  CreateServiceUnitViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CreateServiceUnitViewModel();
}
