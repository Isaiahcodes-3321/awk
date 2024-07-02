import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/add_product/add_product_view.form.dart';

import 'add_product_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'productName'),
  FormTextField(name: 'price'),
  FormTextField(name: 'initialStockLevel'),
  FormTextField(name: 'productUnitId'),
])
class AddProductView extends StackedView<AddProductViewModel>
    with $AddProductView {
  const AddProductView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddProductViewModel viewModel,
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
            viewModel.saveProductData(context);
          }
        },
        title: 'New product',
        subtitle: 'Enter product details',
        mainButtonTitle: 'Create product',
        form: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product name', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                cursorColor: kcPrimaryColor,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: 'Enter product name',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                textCapitalization: TextCapitalization.words,
                style: ktsBodyText,
                controller: productNameController,
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
                    hintText: 'Product price',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
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
              Text('Initial stock level', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                cursorColor: kcPrimaryColor,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    hintText: '0',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                style: ktsBodyText,
                controller: initialStockLevelController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid number';
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
                  Text('Product unit details',
                      style: ktsSubtitleTextAuthentication),
                  GestureDetector(
                    onTap: () async {
                      // Navigate to the create customer view
                      await viewModel.navigationService
                          .navigateTo(Routes.createProductUnitView);
                      await viewModel.getProductUnits();
                    },
                    child: Text(
                      '+ Add unit',
                      style: ktsAddNewText,
                    ),
                  )
                ],
              ),
              verticalSpaceSmall,
              Text('Product unit', style: ktsFormTitleText),
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
                    errorBorder: defaultErrorFormBorder,
                    // labelStyle: ktsFormText,
                    border: defaultFormBorder),
                items: viewModel.productUnitdropdownItems,
                // itemHeight: 42,
                value: productUnitIdController.text.isEmpty
                    ? null
                    : productUnitIdController.text,
                onChanged: (value) {
                  productUnitIdController.text = value.toString();
                },
                // Customize the dropdown item style
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onDispose(AddProductViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(AddProductViewModel viewModel) async {
    await viewModel.getProductUnits();
    syncFormWithViewModel(viewModel);
  }

  @override
  AddProductViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddProductViewModel();
}
