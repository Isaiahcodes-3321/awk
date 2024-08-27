// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String CurrentPinValueKey = 'currentPin';
const String NewPinValueKey = 'newPin';

final Map<String, TextEditingController> _PinChangeViewTextEditingControllers =
    {};

final Map<String, FocusNode> _PinChangeViewFocusNodes = {};

final Map<String, String? Function(String?)?> _PinChangeViewTextValidations = {
  CurrentPinValueKey: null,
  NewPinValueKey: null,
};

mixin $PinChangeView {
  TextEditingController get currentPinController =>
      _getFormTextEditingController(CurrentPinValueKey);
  TextEditingController get newPinController =>
      _getFormTextEditingController(NewPinValueKey);

  FocusNode get currentPinFocusNode => _getFormFocusNode(CurrentPinValueKey);
  FocusNode get newPinFocusNode => _getFormFocusNode(NewPinValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_PinChangeViewTextEditingControllers.containsKey(key)) {
      return _PinChangeViewTextEditingControllers[key]!;
    }

    _PinChangeViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _PinChangeViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_PinChangeViewFocusNodes.containsKey(key)) {
      return _PinChangeViewFocusNodes[key]!;
    }
    _PinChangeViewFocusNodes[key] = FocusNode();
    return _PinChangeViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    currentPinController.addListener(() => _updateFormData(model));
    newPinController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    currentPinController.addListener(() => _updateFormData(model));
    newPinController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          CurrentPinValueKey: currentPinController.text,
          NewPinValueKey: newPinController.text,
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

    for (var controller in _PinChangeViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _PinChangeViewFocusNodes.values) {
      focusNode.dispose();
    }

    _PinChangeViewTextEditingControllers.clear();
    _PinChangeViewFocusNodes.clear();
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

  String? get currentPinValue =>
      this.formValueMap[CurrentPinValueKey] as String?;
  String? get newPinValue => this.formValueMap[NewPinValueKey] as String?;

  set currentPinValue(String? value) {
    this.setData(
      this.formValueMap..addAll({CurrentPinValueKey: value}),
    );

    if (_PinChangeViewTextEditingControllers.containsKey(CurrentPinValueKey)) {
      _PinChangeViewTextEditingControllers[CurrentPinValueKey]?.text =
          value ?? '';
    }
  }

  set newPinValue(String? value) {
    this.setData(
      this.formValueMap..addAll({NewPinValueKey: value}),
    );

    if (_PinChangeViewTextEditingControllers.containsKey(NewPinValueKey)) {
      _PinChangeViewTextEditingControllers[NewPinValueKey]?.text = value ?? '';
    }
  }

  bool get hasCurrentPin =>
      this.formValueMap.containsKey(CurrentPinValueKey) &&
      (currentPinValue?.isNotEmpty ?? false);
  bool get hasNewPin =>
      this.formValueMap.containsKey(NewPinValueKey) &&
      (newPinValue?.isNotEmpty ?? false);

  bool get hasCurrentPinValidationMessage =>
      this.fieldsValidationMessages[CurrentPinValueKey]?.isNotEmpty ?? false;
  bool get hasNewPinValidationMessage =>
      this.fieldsValidationMessages[NewPinValueKey]?.isNotEmpty ?? false;

  String? get currentPinValidationMessage =>
      this.fieldsValidationMessages[CurrentPinValueKey];
  String? get newPinValidationMessage =>
      this.fieldsValidationMessages[NewPinValueKey];
}

extension Methods on FormStateHelper {
  setCurrentPinValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CurrentPinValueKey] = validationMessage;
  setNewPinValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[NewPinValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    currentPinValue = '';
    newPinValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      CurrentPinValueKey: getValidationMessage(CurrentPinValueKey),
      NewPinValueKey: getValidationMessage(NewPinValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _PinChangeViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _PinChangeViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      CurrentPinValueKey: getValidationMessage(CurrentPinValueKey),
      NewPinValueKey: getValidationMessage(NewPinValueKey),
    });
