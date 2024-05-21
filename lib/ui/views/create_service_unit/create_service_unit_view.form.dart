// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String UnitNameValueKey = 'unitName';

final Map<String, TextEditingController>
    _CreateServiceUnitViewTextEditingControllers = {};

final Map<String, FocusNode> _CreateServiceUnitViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _CreateServiceUnitViewTextValidations = {
  UnitNameValueKey: null,
};

mixin $CreateServiceUnitView {
  TextEditingController get unitNameController =>
      _getFormTextEditingController(UnitNameValueKey);

  FocusNode get unitNameFocusNode => _getFormFocusNode(UnitNameValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_CreateServiceUnitViewTextEditingControllers.containsKey(key)) {
      return _CreateServiceUnitViewTextEditingControllers[key]!;
    }

    _CreateServiceUnitViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _CreateServiceUnitViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_CreateServiceUnitViewFocusNodes.containsKey(key)) {
      return _CreateServiceUnitViewFocusNodes[key]!;
    }
    _CreateServiceUnitViewFocusNodes[key] = FocusNode();
    return _CreateServiceUnitViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    unitNameController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    unitNameController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          UnitNameValueKey: unitNameController.text,
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

    for (var controller
        in _CreateServiceUnitViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _CreateServiceUnitViewFocusNodes.values) {
      focusNode.dispose();
    }

    _CreateServiceUnitViewTextEditingControllers.clear();
    _CreateServiceUnitViewFocusNodes.clear();
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

  String? get unitNameValue => this.formValueMap[UnitNameValueKey] as String?;

  set unitNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({UnitNameValueKey: value}),
    );

    if (_CreateServiceUnitViewTextEditingControllers.containsKey(
        UnitNameValueKey)) {
      _CreateServiceUnitViewTextEditingControllers[UnitNameValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasUnitName =>
      this.formValueMap.containsKey(UnitNameValueKey) &&
      (unitNameValue?.isNotEmpty ?? false);

  bool get hasUnitNameValidationMessage =>
      this.fieldsValidationMessages[UnitNameValueKey]?.isNotEmpty ?? false;

  String? get unitNameValidationMessage =>
      this.fieldsValidationMessages[UnitNameValueKey];
}

extension Methods on FormStateHelper {
  setUnitNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[UnitNameValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    unitNameValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      UnitNameValueKey: getValidationMessage(UnitNameValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _CreateServiceUnitViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _CreateServiceUnitViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      UnitNameValueKey: getValidationMessage(UnitNameValueKey),
    });
