import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/add_service/add_service_view.form.dart';

import 'add_service_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'serviceName'),
  FormTextField(name: 'price'),
  FormTextField(name: 'serviceUnitId'),
])
class AddServiceView extends StackedView<AddServiceViewModel>
    with $AddServiceView {
  const AddServiceView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddServiceViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: kcButtonTextColor,
        body: AuthenticationLayout(
          busy: viewModel.isBusy,
          // validationMessage: viewModel.validationMessage,
          onBackPressed: viewModel.navigateBack,
          onMainButtonTapped: () {
            if (viewModel.formKey.currentState!.validate()) {
              viewModel.saveServiceData(context);
            }
          },
          title: 'New service',
          subtitle: 'Enter the service details',
          mainButtonTitle: 'Create service',
          form: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Service name', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Enter service name',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: serviceNameController,
                  keyboardType: TextInputType.name,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  }),
                ),
                verticalSpaceSmall,
                Text('Price', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Service price',
                      hintStyle: ktsFormHintText,
                      // border: defaultFormBorder,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  // textCapitalization: TextCapitalization.words,
                  style: ktsBodyText,
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid price';
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Service unit details',
                        style: ktsSubtitleTextAuthentication),
                    GestureDetector(
                      onTap: () async {
                        // Navigate to the create customer view
                        await viewModel.navigationService
                            .navigateTo(Routes.createServiceUnitView);
                        await viewModel.getServiceUnits();
                      },
                      child: Text(
                        '+ Add unit',
                        style: ktsAddNewText,
                      ),
                    )
                  ],
                ),
                verticalSpaceSmall,
                Text('Service unit', style: ktsFormTitleText),
                verticalSpaceTiny,
                DropdownButtonFormField(
                  menuMaxHeight: 320,
                  elevation: 4,
                  // padding: EdgeInsets.symmetric(horizontal: 12),
                  dropdownColor: kcButtonTextColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a unit';
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
                      hintStyle: ktsFormHintText,
                      hintText: 'Select',
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder
                      // labelStyle: ktsFormText,
                      // border: defaultFormBorder
                      ),
                  items: viewModel.serviceUnitdropdownItems,
                  value: serviceUnitIdController.text.isEmpty
                      ? null
                      : serviceUnitIdController.text,
                  onChanged: (value) {
                    serviceUnitIdController.text = value.toString();
                  },
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void onDispose(AddServiceViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(AddServiceViewModel viewModel) async {
    await viewModel.getServiceUnits();
    syncFormWithViewModel(viewModel);
  }

  @override
  AddServiceViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddServiceViewModel();
}
