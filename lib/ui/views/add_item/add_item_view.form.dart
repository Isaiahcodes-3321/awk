// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String ProductNameValueKey = 'productName';
const String PriceValueKey = 'price';
const String InitialStockLevelValueKey = 'initialStockLevel';
const String ProductUnitIdValueKey = 'productUnitId';
const String ServiceUnitIdValueKey = 'serviceUnitId';

final Map<String, TextEditingController> _AddItemViewTextEditingControllers =
    {};

final Map<String, FocusNode> _AddItemViewFocusNodes = {};

final Map<String, String? Function(String?)?> _AddItemViewTextValidations = {
  ProductNameValueKey: null,
  PriceValueKey: null,
  InitialStockLevelValueKey: null,
  ProductUnitIdValueKey: null,
  ServiceUnitIdValueKey: null,
};

mixin $AddItemView {
  TextEditingController get productNameController =>
      _getFormTextEditingController(ProductNameValueKey);
  TextEditingController get priceController =>
      _getFormTextEditingController(PriceValueKey);
  TextEditingController get initialStockLevelController =>
      _getFormTextEditingController(InitialStockLevelValueKey);
  TextEditingController get productUnitIdController =>
      _getFormTextEditingController(ProductUnitIdValueKey);
  TextEditingController get serviceUnitIdController =>
      _getFormTextEditingController(ServiceUnitIdValueKey);

  FocusNode get productNameFocusNode => _getFormFocusNode(ProductNameValueKey);
  FocusNode get priceFocusNode => _getFormFocusNode(PriceValueKey);
  FocusNode get initialStockLevelFocusNode =>
      _getFormFocusNode(InitialStockLevelValueKey);
  FocusNode get productUnitIdFocusNode =>
      _getFormFocusNode(ProductUnitIdValueKey);
  FocusNode get serviceUnitIdFocusNode =>
      _getFormFocusNode(ServiceUnitIdValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_AddItemViewTextEditingControllers.containsKey(key)) {
      return _AddItemViewTextEditingControllers[key]!;
    }

    _AddItemViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _AddItemViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_AddItemViewFocusNodes.containsKey(key)) {
      return _AddItemViewFocusNodes[key]!;
    }
    _AddItemViewFocusNodes[key] = FocusNode();
    return _AddItemViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    productNameController.addListener(() => _updateFormData(model));
    priceController.addListener(() => _updateFormData(model));
    initialStockLevelController.addListener(() => _updateFormData(model));
    productUnitIdController.addListener(() => _updateFormData(model));
    serviceUnitIdController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    productNameController.addListener(() => _updateFormData(model));
    priceController.addListener(() => _updateFormData(model));
    initialStockLevelController.addListener(() => _updateFormData(model));
    productUnitIdController.addListener(() => _updateFormData(model));
    serviceUnitIdController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          ProductNameValueKey: productNameController.text,
          PriceValueKey: priceController.text,
          InitialStockLevelValueKey: initialStockLevelController.text,
          ProductUnitIdValueKey: productUnitIdController.text,
          ServiceUnitIdValueKey: serviceUnitIdController.text,
        }),
    );

    if (_autoTextFieldValidation || forceValidate) {
      updateValidationData(model);
    }
  }

  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _AddItemViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _AddItemViewFocusNodes.values) {
      focusNode.dispose();
    }

    _AddItemViewTextEditingControllers.clear();
    _AddItemViewFocusNodes.clear();
  }
}

extension ValueProperties on FormStateHelper {
  bool get hasAnyValidationMessage => this
      .fieldsValidationMessages
      .values
      .any((validation) => validation != null);

  bool get isFormValid {
    if (!_autoTextFieldValidation) this.validateForm();

    return !hasAnyValidationMessage;
  }

  String? get productNameValue =>
      this.formValueMap[ProductNameValueKey] as String?;
  String? get priceValue => this.formValueMap[PriceValueKey] as String?;
  String? get initialStockLevelValue =>
      this.formValueMap[InitialStockLevelValueKey] as String?;
  String? get productUnitIdValue =>
      this.formValueMap[ProductUnitIdValueKey] as String?;
  String? get serviceUnitIdValue =>
      this.formValueMap[ServiceUnitIdValueKey] as String?;

  set productNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ProductNameValueKey: value}),
    );

    if (_AddItemViewTextEditingControllers.containsKey(ProductNameValueKey)) {
      _AddItemViewTextEditingControllers[ProductNameValueKey]?.text =
          value ?? '';
    }
  }

  set priceValue(String? value) {
    this.setData(
      this.formValueMap..addAll({PriceValueKey: value}),
    );

    if (_AddItemViewTextEditingControllers.containsKey(PriceValueKey)) {
      _AddItemViewTextEditingControllers[PriceValueKey]?.text = value ?? '';
    }
  }

  set initialStockLevelValue(String? value) {
    this.setData(
      this.formValueMap..addAll({InitialStockLevelValueKey: value}),
    );

    if (_AddItemViewTextEditingControllers.containsKey(
        InitialStockLevelValueKey)) {
      _AddItemViewTextEditingControllers[InitialStockLevelValueKey]?.text =
          value ?? '';
    }
  }

  set productUnitIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ProductUnitIdValueKey: value}),
    );

    if (_AddItemViewTextEditingControllers.containsKey(ProductUnitIdValueKey)) {
      _AddItemViewTextEditingControllers[ProductUnitIdValueKey]?.text =
          value ?? '';
    }
  }

  set serviceUnitIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ServiceUnitIdValueKey: value}),
    );

    if (_AddItemViewTextEditingControllers.containsKey(ServiceUnitIdValueKey)) {
      _AddItemViewTextEditingControllers[ServiceUnitIdValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasProductName =>
      this.formValueMap.containsKey(ProductNameValueKey) &&
      (productNameValue?.isNotEmpty ?? false);
  bool get hasPrice =>
      this.formValueMap.containsKey(PriceValueKey) &&
      (priceValue?.isNotEmpty ?? false);
  bool get hasInitialStockLevel =>
      this.formValueMap.containsKey(InitialStockLevelValueKey) &&
      (initialStockLevelValue?.isNotEmpty ?? false);
  bool get hasProductUnitId =>
      this.formValueMap.containsKey(ProductUnitIdValueKey) &&
      (productUnitIdValue?.isNotEmpty ?? false);
  bool get hasServiceUnitId =>
      this.formValueMap.containsKey(ServiceUnitIdValueKey) &&
      (serviceUnitIdValue?.isNotEmpty ?? false);

  bool get hasProductNameValidationMessage =>
      this.fieldsValidationMessages[ProductNameValueKey]?.isNotEmpty ?? false;
  bool get hasPriceValidationMessage =>
      this.fieldsValidationMessages[PriceValueKey]?.isNotEmpty ?? false;
  bool get hasInitialStockLevelValidationMessage =>
      this.fieldsValidationMessages[InitialStockLevelValueKey]?.isNotEmpty ??
      false;
  bool get hasProductUnitIdValidationMessage =>
      this.fieldsValidationMessages[ProductUnitIdValueKey]?.isNotEmpty ?? false;
  bool get hasServiceUnitIdValidationMessage =>
      this.fieldsValidationMessages[ServiceUnitIdValueKey]?.isNotEmpty ?? false;

  String? get productNameValidationMessage =>
      this.fieldsValidationMessages[ProductNameValueKey];
  String? get priceValidationMessage =>
      this.fieldsValidationMessages[PriceValueKey];
  String? get initialStockLevelValidationMessage =>
      this.fieldsValidationMessages[InitialStockLevelValueKey];
  String? get productUnitIdValidationMessage =>
      this.fieldsValidationMessages[ProductUnitIdValueKey];
  String? get serviceUnitIdValidationMessage =>
      this.fieldsValidationMessages[ServiceUnitIdValueKey];
}

extension Methods on FormStateHelper {
  setProductNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ProductNameValueKey] = validationMessage;
  setPriceValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PriceValueKey] = validationMessage;
  setInitialStockLevelValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[InitialStockLevelValueKey] =
          validationMessage;
  setProductUnitIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ProductUnitIdValueKey] = validationMessage;
  setServiceUnitIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ServiceUnitIdValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    productNameValue = '';
    priceValue = '';
    initialStockLevelValue = '';
    productUnitIdValue = '';
    serviceUnitIdValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      ProductNameValueKey: getValidationMessage(ProductNameValueKey),
      PriceValueKey: getValidationMessage(PriceValueKey),
      InitialStockLevelValueKey:
          getValidationMessage(InitialStockLevelValueKey),
      ProductUnitIdValueKey: getValidationMessage(ProductUnitIdValueKey),
      ServiceUnitIdValueKey: getValidationMessage(ServiceUnitIdValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _AddItemViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _AddItemViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      ProductNameValueKey: getValidationMessage(ProductNameValueKey),
      PriceValueKey: getValidationMessage(PriceValueKey),
      InitialStockLevelValueKey:
          getValidationMessage(InitialStockLevelValueKey),
      ProductUnitIdValueKey: getValidationMessage(ProductUnitIdValueKey),
      ServiceUnitIdValueKey: getValidationMessage(ServiceUnitIdValueKey),
    });
