import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/add_item/add_item_view.form.dart';

import 'add_item_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'productName'),
  FormTextField(name: 'price'),
  FormTextField(name: 'initialStockLevel'),
  FormTextField(name: 'productUnitId'),
  FormTextField(name: 'serviceUnitId'),
])
class AddItemView extends StackedView<AddItemViewModel> with $AddItemView {
  const AddItemView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddItemViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        busy: viewModel.isBusy,
        onBackPressed: viewModel.navigateBack,
        onMainButtonTapped: () {
          if (viewModel.formKey.currentState!.validate()) {
            viewModel.isProduct
                ? viewModel.saveProductData(context)
                : viewModel.saveServiceData(context);
          }
        },
        title: 'Add item',
        subtitle: 'Create an item',
        mainButtonTitle: 'Add',
        form: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        viewModel.isProduct = true;
                        viewModel.rebuildUi();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: kcBorderColor,
                          gradient: viewModel.isProduct
                              ? const LinearGradient(
                                  colors: [kcPrimaryColor, Color(0xFF6275E9)],
                                )
                              : null, // fallback to null to use default color
                        ),
                        child: Text(
                          'Product',
                          style: viewModel.isProduct
                              ? ktsSubtitleTileText2
                              : ktsSubtitleTileText3,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        viewModel.isProduct = false;
                        viewModel.rebuildUi();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: kcBorderColor,
                          gradient: !viewModel.isProduct
                              ? const LinearGradient(
                                  colors: [Color(0xFF6275E9), kcPrimaryColor],
                                )
                              : null, // fallback to null to use default color
                        ),
                        child: Text(
                          'Service',
                          style: !viewModel.isProduct
                              ? ktsSubtitleTileText2
                              : ktsSubtitleTileText3,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Text('Name', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  cursorColor: kcPrimaryColor,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Enter name',
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
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Enter price',
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
                if (viewModel.isProduct) ...[
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
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // hintStyle: ktsFormHintText,
                      // hintText: 'Select',
                      enabledBorder: defaultFormBorder,
                      focusedBorder: defaultFocusedFormBorder,
                      focusedErrorBorder: defaultErrorFormBorder,
                      errorStyle: ktsErrorText,
                      errorBorder: defaultErrorFormBorder,
                      // labelStyle: ktsFormText,
                      // border: defaultFormBorder
                    ),
                    items: viewModel.productUnitdropdownItems,
                    // itemHeight: 12,
                    value: productUnitIdController.text.isEmpty
                        ? null
                        : productUnitIdController.text,
                    onChanged: (value) {
                      productUnitIdController.text = value.toString();
                    },
                    // Customize the dropdown item style
                  ),
                  verticalSpaceSmall,
                  Text('Initial stock level', style: ktsFormTitleText),
                  verticalSpaceTiny,
                  TextFormField(
                    cursorColor: kcPrimaryColor,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        hintText: '0',
                        hintStyle: ktsFormHintText,
                        // border: defaultFormBorder,
                        enabledBorder: defaultFormBorder,
                        focusedBorder: defaultFocusedFormBorder,
                        focusedErrorBorder: defaultErrorFormBorder,
                        errorStyle: ktsErrorText,
                        errorBorder: defaultErrorFormBorder),
                    // textCapitalization: TextCapitalization.words,
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
                ] else ...[
                  Text('Service unit', style: ktsFormTitleText),
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
                    items: viewModel.serviceUnitdropdownItems,
                    value: serviceUnitIdController.text.isEmpty
                        ? null
                        : serviceUnitIdController.text,
                    onChanged: (value) {
                      serviceUnitIdController.text = value.toString();
                    },
                  ),
                ]
              ],
            )),
      ),
    );
  }

  @override
  void onDispose(AddItemViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(AddItemViewModel viewModel) async {
    await viewModel.getProductUnits();
    await viewModel.getServiceUnits();

    syncFormWithViewModel(viewModel);
  }

  @override
  AddItemViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddItemViewModel();
}
