// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String UserIdValueKey = 'userId';
const String AmountValueKey = 'amount';

final Map<String, TextEditingController> _AddCardViewTextEditingControllers =
    {};

final Map<String, FocusNode> _AddCardViewFocusNodes = {};

final Map<String, String? Function(String?)?> _AddCardViewTextValidations = {
  UserIdValueKey: null,
  AmountValueKey: null,
};

mixin $AddCardView {
  TextEditingController get userIdController =>
      _getFormTextEditingController(UserIdValueKey);
  TextEditingController get amountController =>
      _getFormTextEditingController(AmountValueKey);

  FocusNode get userIdFocusNode => _getFormFocusNode(UserIdValueKey);
  FocusNode get amountFocusNode => _getFormFocusNode(AmountValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_AddCardViewTextEditingControllers.containsKey(key)) {
      return _AddCardViewTextEditingControllers[key]!;
    }

    _AddCardViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _AddCardViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_AddCardViewFocusNodes.containsKey(key)) {
      return _AddCardViewFocusNodes[key]!;
    }
    _AddCardViewFocusNodes[key] = FocusNode();
    return _AddCardViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    userIdController.addListener(() => _updateFormData(model));
    amountController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    userIdController.addListener(() => _updateFormData(model));
    amountController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          UserIdValueKey: userIdController.text,
          AmountValueKey: amountController.text,
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

    for (var controller in _AddCardViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _AddCardViewFocusNodes.values) {
      focusNode.dispose();
    }

    _AddCardViewTextEditingControllers.clear();
    _AddCardViewFocusNodes.clear();
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

  String? get userIdValue => this.formValueMap[UserIdValueKey] as String?;
  String? get amountValue => this.formValueMap[AmountValueKey] as String?;

  set userIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({UserIdValueKey: value}),
    );

    if (_AddCardViewTextEditingControllers.containsKey(UserIdValueKey)) {
      _AddCardViewTextEditingControllers[UserIdValueKey]?.text = value ?? '';
    }
  }

  set amountValue(String? value) {
    this.setData(
      this.formValueMap..addAll({AmountValueKey: value}),
    );

    if (_AddCardViewTextEditingControllers.containsKey(AmountValueKey)) {
      _AddCardViewTextEditingControllers[AmountValueKey]?.text = value ?? '';
    }
  }

  bool get hasUserId =>
      this.formValueMap.containsKey(UserIdValueKey) &&
      (userIdValue?.isNotEmpty ?? false);
  bool get hasAmount =>
      this.formValueMap.containsKey(AmountValueKey) &&
      (amountValue?.isNotEmpty ?? false);

  bool get hasUserIdValidationMessage =>
      this.fieldsValidationMessages[UserIdValueKey]?.isNotEmpty ?? false;
  bool get hasAmountValidationMessage =>
      this.fieldsValidationMessages[AmountValueKey]?.isNotEmpty ?? false;

  String? get userIdValidationMessage =>
      this.fieldsValidationMessages[UserIdValueKey];
  String? get amountValidationMessage =>
      this.fieldsValidationMessages[AmountValueKey];
}

extension Methods on FormStateHelper {
  setUserIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[UserIdValueKey] = validationMessage;
  setAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[AmountValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    userIdValue = '';
    amountValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      UserIdValueKey: getValidationMessage(UserIdValueKey),
      AmountValueKey: getValidationMessage(AmountValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _AddCardViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _AddCardViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      UserIdValueKey: getValidationMessage(UserIdValueKey),
      AmountValueKey: getValidationMessage(AmountValueKey),
    });
