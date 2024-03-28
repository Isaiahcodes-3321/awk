import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'update_service_viewmodel.dart';

class UpdateServiceView extends StackedView<UpdateServiceViewModel> {
  const UpdateServiceView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(UpdateServiceViewModel viewModel) async {
    // syncFormWithViewModel(viewModel);
    await viewModel.getServicesById1();
    // await viewModel.getServiceUnits();
    viewModel.setSelectedService();
  }

  @override
  UpdateServiceViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final String serviceId =
        ModalRoute.of(context)!.settings.arguments as String;
    return UpdateServiceViewModel(serviceId: serviceId);
  }

  @override
  Widget builder(
    BuildContext context,
    UpdateServiceViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isBusy) {
      return const Scaffold(
        backgroundColor: kcButtonTextColor,
        body: Center(
            child: CircularProgressIndicator(
          color: kcPrimaryColor,
        )),
      );
    }
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        onBackPressed: viewModel.navigateBack,
        busy: viewModel.isBusy,
        onMainButtonTapped: () {
          if (viewModel.formKey.currentState!.validate()) {
            viewModel.updateServiceData(context);
          }
        },
        onArchiveButtonTapped: viewModel.archiveService,
        onDeleteButtonTapped: viewModel.deleteService,
        archiveButtonTitle: 'Archive service',
        title: 'Edit Service',
        subtitle: 'Edit the service details.',
        mainButtonTitle: 'Edit service',
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                controller: viewModel.updateserviceNameController,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'Service price',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                style: ktsBodyText,
                controller: viewModel.updatepriceController,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                items: viewModel.serviceUnitdropdownItems,
                value: viewModel.updateServiceUnitIdController.text.isEmpty
                    ? null
                    : viewModel.updateServiceUnitIdController.text,
                onChanged: (value) {
                  viewModel.updateServiceUnitIdController.text =
                      value.toString();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
