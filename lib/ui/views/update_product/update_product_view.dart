import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'update_product_viewmodel.dart';

class UpdateProductView extends StackedView<UpdateProductViewModel> {
  const UpdateProductView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(UpdateProductViewModel viewModel) async {
    // syncFormWithViewModel(viewModel);
    await viewModel.getProductsById();
    await viewModel.getProductUnits();
    viewModel.setSelectedProduct();
  }

  @override
  UpdateProductViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;
    return UpdateProductViewModel(productId: productId);
  }

  @override
  Widget builder(
    BuildContext context,
    UpdateProductViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        onBackPressed: viewModel.navigateBack,
        busy: viewModel.isBusy,
        onMainButtonTapped: () {
          if (viewModel.formKey.currentState!.validate()) {
            viewModel.updateProductData(context);
          }
        },
        onArchiveButtonTapped: viewModel.archiveProduct,
        onDeleteButtonTapped: viewModel.deleteProduct,
        title: 'Edit Product',
        subtitle: 'Edit the product details.',
        mainButtonTitle: 'Edit product',
        archiveButtonTitle: 'Archive product',
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
                controller: viewModel.updateproductNameController,
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
              Text('Product unit', style: ktsFormTitleText),
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
                items: viewModel.productUnitdropdownItems,
                value: viewModel.updateProductUnitIdController.text.isEmpty
                    ? null
                    : viewModel.updateProductUnitIdController.text,
                onChanged: (value) {
                  viewModel.updateProductUnitIdController.text =
                      value.toString();
                },
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  Text('Track reorder level', style: ktsFormTitleText),
                  Checkbox(
                    fillColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      // Use different colors for different states if needed
                      if (states.contains(MaterialState.selected)) {
                        return kcFormBorderColor; // Color when checkbox is selected
                      }
                      return null; // Color when checkbox is not selected
                    }),
                    // shape: BorderRadius.circular(12),
                    side: const BorderSide(
                      width: 1,
                      color: kcFormBorderColor,
                    ),
                    checkColor: kcTextTitleColor,
                    value: viewModel.trackReorderLevel,
                    onChanged: (value) {
                      viewModel.setTrackReorderLevel(value ?? false);
                    },
                  ),
                ],
              ),
              if (viewModel.trackReorderLevel)
                Text('Reorder Level', style: ktsFormTitleText),
              if (viewModel.trackReorderLevel) verticalSpaceTiny,
              if (viewModel
                  .trackReorderLevel) // Show TextFormField only if tracking is enabled
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Enter reorder level',
                      hintStyle: ktsFormHintText,
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder),
                  style: ktsBodyText,
                  controller: viewModel.reorderLevelController,
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
            ],
          ),
        ),
      ),
    );
  }
}
