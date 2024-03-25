// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String ServiceNameValueKey = 'serviceName';
const String PriceValueKey = 'price';
const String ServiceUnitIdValueKey = 'serviceUnitId';

final Map<String, TextEditingController> _AddServiceViewTextEditingControllers =
    {};

final Map<String, FocusNode> _AddServiceViewFocusNodes = {};

final Map<String, String? Function(String?)?> _AddServiceViewTextValidations = {
  ServiceNameValueKey: null,
  PriceValueKey: null,
  ServiceUnitIdValueKey: null,
};

mixin $AddServiceView {
  TextEditingController get serviceNameController =>
      _getFormTextEditingController(ServiceNameValueKey);
  TextEditingController get priceController =>
      _getFormTextEditingController(PriceValueKey);
  TextEditingController get serviceUnitIdController =>
      _getFormTextEditingController(ServiceUnitIdValueKey);

  FocusNode get serviceNameFocusNode => _getFormFocusNode(ServiceNameValueKey);
  FocusNode get priceFocusNode => _getFormFocusNode(PriceValueKey);
  FocusNode get serviceUnitIdFocusNode =>
      _getFormFocusNode(ServiceUnitIdValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_AddServiceViewTextEditingControllers.containsKey(key)) {
      return _AddServiceViewTextEditingControllers[key]!;
    }

    _AddServiceViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _AddServiceViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_AddServiceViewFocusNodes.containsKey(key)) {
      return _AddServiceViewFocusNodes[key]!;
    }
    _AddServiceViewFocusNodes[key] = FocusNode();
    return _AddServiceViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    serviceNameController.addListener(() => _updateFormData(model));
    priceController.addListener(() => _updateFormData(model));
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
    serviceNameController.addListener(() => _updateFormData(model));
    priceController.addListener(() => _updateFormData(model));
    serviceUnitIdController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          ServiceNameValueKey: serviceNameController.text,
          PriceValueKey: priceController.text,
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

    for (var controller in _AddServiceViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _AddServiceViewFocusNodes.values) {
      focusNode.dispose();
    }

    _AddServiceViewTextEditingControllers.clear();
    _AddServiceViewFocusNodes.clear();
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

  String? get serviceNameValue =>
      this.formValueMap[ServiceNameValueKey] as String?;
  String? get priceValue => this.formValueMap[PriceValueKey] as String?;
  String? get serviceUnitIdValue =>
      this.formValueMap[ServiceUnitIdValueKey] as String?;

  set serviceNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ServiceNameValueKey: value}),
    );

    if (_AddServiceViewTextEditingControllers.containsKey(
        ServiceNameValueKey)) {
      _AddServiceViewTextEditingControllers[ServiceNameValueKey]?.text =
          value ?? '';
    }
  }

  set priceValue(String? value) {
    this.setData(
      this.formValueMap..addAll({PriceValueKey: value}),
    );

    if (_AddServiceViewTextEditingControllers.containsKey(PriceValueKey)) {
      _AddServiceViewTextEditingControllers[PriceValueKey]?.text = value ?? '';
    }
  }

  set serviceUnitIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ServiceUnitIdValueKey: value}),
    );

    if (_AddServiceViewTextEditingControllers.containsKey(
        ServiceUnitIdValueKey)) {
      _AddServiceViewTextEditingControllers[ServiceUnitIdValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasServiceName =>
      this.formValueMap.containsKey(ServiceNameValueKey) &&
      (serviceNameValue?.isNotEmpty ?? false);
  bool get hasPrice =>
      this.formValueMap.containsKey(PriceValueKey) &&
      (priceValue?.isNotEmpty ?? false);
  bool get hasServiceUnitId =>
      this.formValueMap.containsKey(ServiceUnitIdValueKey) &&
      (serviceUnitIdValue?.isNotEmpty ?? false);

  bool get hasServiceNameValidationMessage =>
      this.fieldsValidationMessages[ServiceNameValueKey]?.isNotEmpty ?? false;
  bool get hasPriceValidationMessage =>
      this.fieldsValidationMessages[PriceValueKey]?.isNotEmpty ?? false;
  bool get hasServiceUnitIdValidationMessage =>
      this.fieldsValidationMessages[ServiceUnitIdValueKey]?.isNotEmpty ?? false;

  String? get serviceNameValidationMessage =>
      this.fieldsValidationMessages[ServiceNameValueKey];
  String? get priceValidationMessage =>
      this.fieldsValidationMessages[PriceValueKey];
  String? get serviceUnitIdValidationMessage =>
      this.fieldsValidationMessages[ServiceUnitIdValueKey];
}

extension Methods on FormStateHelper {
  setServiceNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ServiceNameValueKey] = validationMessage;
  setPriceValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PriceValueKey] = validationMessage;
  setServiceUnitIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ServiceUnitIdValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    serviceNameValue = '';
    priceValue = '';
    serviceUnitIdValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      ServiceNameValueKey: getValidationMessage(ServiceNameValueKey),
      PriceValueKey: getValidationMessage(PriceValueKey),
      ServiceUnitIdValueKey: getValidationMessage(ServiceUnitIdValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _AddServiceViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _AddServiceViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      ServiceNameValueKey: getValidationMessage(ServiceNameValueKey),
      PriceValueKey: getValidationMessage(PriceValueKey),
      ServiceUnitIdValueKey: getValidationMessage(ServiceUnitIdValueKey),
    });
