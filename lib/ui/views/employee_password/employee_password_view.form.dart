// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String OldPasswordValueKey = 'oldPassword';
const String NewPasswordValueKey = 'newPassword';

final Map<String, TextEditingController>
    _EmployeePasswordViewTextEditingControllers = {};

final Map<String, FocusNode> _EmployeePasswordViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _EmployeePasswordViewTextValidations = {
  OldPasswordValueKey: null,
  NewPasswordValueKey: null,
};

mixin $EmployeePasswordView {
  TextEditingController get oldPasswordController =>
      _getFormTextEditingController(OldPasswordValueKey);
  TextEditingController get newPasswordController =>
      _getFormTextEditingController(NewPasswordValueKey);

  FocusNode get oldPasswordFocusNode => _getFormFocusNode(OldPasswordValueKey);
  FocusNode get newPasswordFocusNode => _getFormFocusNode(NewPasswordValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_EmployeePasswordViewTextEditingControllers.containsKey(key)) {
      return _EmployeePasswordViewTextEditingControllers[key]!;
    }

    _EmployeePasswordViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _EmployeePasswordViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_EmployeePasswordViewFocusNodes.containsKey(key)) {
      return _EmployeePasswordViewFocusNodes[key]!;
    }
    _EmployeePasswordViewFocusNodes[key] = FocusNode();
    return _EmployeePasswordViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    oldPasswordController.addListener(() => _updateFormData(model));
    newPasswordController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    oldPasswordController.addListener(() => _updateFormData(model));
    newPasswordController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          OldPasswordValueKey: oldPasswordController.text,
          NewPasswordValueKey: newPasswordController.text,
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

    for (var controller in _EmployeePasswordViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _EmployeePasswordViewFocusNodes.values) {
      focusNode.dispose();
    }

    _EmployeePasswordViewTextEditingControllers.clear();
    _EmployeePasswordViewFocusNodes.clear();
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

  String? get oldPasswordValue =>
      this.formValueMap[OldPasswordValueKey] as String?;
  String? get newPasswordValue =>
      this.formValueMap[NewPasswordValueKey] as String?;

  set oldPasswordValue(String? value) {
    this.setData(
      this.formValueMap..addAll({OldPasswordValueKey: value}),
    );

    if (_EmployeePasswordViewTextEditingControllers.containsKey(
        OldPasswordValueKey)) {
      _EmployeePasswordViewTextEditingControllers[OldPasswordValueKey]?.text =
          value ?? '';
    }
  }

  set newPasswordValue(String? value) {
    this.setData(
      this.formValueMap..addAll({NewPasswordValueKey: value}),
    );

    if (_EmployeePasswordViewTextEditingControllers.containsKey(
        NewPasswordValueKey)) {
      _EmployeePasswordViewTextEditingControllers[NewPasswordValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasOldPassword =>
      this.formValueMap.containsKey(OldPasswordValueKey) &&
      (oldPasswordValue?.isNotEmpty ?? false);
  bool get hasNewPassword =>
      this.formValueMap.containsKey(NewPasswordValueKey) &&
      (newPasswordValue?.isNotEmpty ?? false);

  bool get hasOldPasswordValidationMessage =>
      this.fieldsValidationMessages[OldPasswordValueKey]?.isNotEmpty ?? false;
  bool get hasNewPasswordValidationMessage =>
      this.fieldsValidationMessages[NewPasswordValueKey]?.isNotEmpty ?? false;

  String? get oldPasswordValidationMessage =>
      this.fieldsValidationMessages[OldPasswordValueKey];
  String? get newPasswordValidationMessage =>
      this.fieldsValidationMessages[NewPasswordValueKey];
}

extension Methods on FormStateHelper {
  setOldPasswordValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[OldPasswordValueKey] = validationMessage;
  setNewPasswordValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[NewPasswordValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    oldPasswordValue = '';
    newPasswordValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      OldPasswordValueKey: getValidationMessage(OldPasswordValueKey),
      NewPasswordValueKey: getValidationMessage(NewPasswordValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _EmployeePasswordViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _EmployeePasswordViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      OldPasswordValueKey: getValidationMessage(OldPasswordValueKey),
      NewPasswordValueKey: getValidationMessage(NewPasswordValueKey),
    });