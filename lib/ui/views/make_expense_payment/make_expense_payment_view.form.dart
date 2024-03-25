// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String PaymentDescriptionValueKey = 'paymentDescription';
const String PaymentTransactionDateValueKey = 'paymentTransactionDate';

final Map<String, TextEditingController>
    _MakeExpensePaymentViewTextEditingControllers = {};

final Map<String, FocusNode> _MakeExpensePaymentViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _MakeExpensePaymentViewTextValidations = {
  PaymentDescriptionValueKey: null,
  PaymentTransactionDateValueKey: null,
};

mixin $MakeExpensePaymentView {
  TextEditingController get paymentDescriptionController =>
      _getFormTextEditingController(PaymentDescriptionValueKey);
  TextEditingController get paymentTransactionDateController =>
      _getFormTextEditingController(PaymentTransactionDateValueKey);

  FocusNode get paymentDescriptionFocusNode =>
      _getFormFocusNode(PaymentDescriptionValueKey);
  FocusNode get paymentTransactionDateFocusNode =>
      _getFormFocusNode(PaymentTransactionDateValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_MakeExpensePaymentViewTextEditingControllers.containsKey(key)) {
      return _MakeExpensePaymentViewTextEditingControllers[key]!;
    }

    _MakeExpensePaymentViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _MakeExpensePaymentViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_MakeExpensePaymentViewFocusNodes.containsKey(key)) {
      return _MakeExpensePaymentViewFocusNodes[key]!;
    }
    _MakeExpensePaymentViewFocusNodes[key] = FocusNode();
    return _MakeExpensePaymentViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    paymentDescriptionController.addListener(() => _updateFormData(model));
    paymentTransactionDateController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    paymentDescriptionController.addListener(() => _updateFormData(model));
    paymentTransactionDateController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          PaymentDescriptionValueKey: paymentDescriptionController.text,
          PaymentTransactionDateValueKey: paymentTransactionDateController.text,
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
        in _MakeExpensePaymentViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _MakeExpensePaymentViewFocusNodes.values) {
      focusNode.dispose();
    }

    _MakeExpensePaymentViewTextEditingControllers.clear();
    _MakeExpensePaymentViewFocusNodes.clear();
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

  String? get paymentDescriptionValue =>
      this.formValueMap[PaymentDescriptionValueKey] as String?;
  String? get paymentTransactionDateValue =>
      this.formValueMap[PaymentTransactionDateValueKey] as String?;

  set paymentDescriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({PaymentDescriptionValueKey: value}),
    );

    if (_MakeExpensePaymentViewTextEditingControllers.containsKey(
        PaymentDescriptionValueKey)) {
      _MakeExpensePaymentViewTextEditingControllers[PaymentDescriptionValueKey]
          ?.text = value ?? '';
    }
  }

  set paymentTransactionDateValue(String? value) {
    this.setData(
      this.formValueMap..addAll({PaymentTransactionDateValueKey: value}),
    );

    if (_MakeExpensePaymentViewTextEditingControllers.containsKey(
        PaymentTransactionDateValueKey)) {
      _MakeExpensePaymentViewTextEditingControllers[
              PaymentTransactionDateValueKey]
          ?.text = value ?? '';
    }
  }

  bool get hasPaymentDescription =>
      this.formValueMap.containsKey(PaymentDescriptionValueKey) &&
      (paymentDescriptionValue?.isNotEmpty ?? false);
  bool get hasPaymentTransactionDate =>
      this.formValueMap.containsKey(PaymentTransactionDateValueKey) &&
      (paymentTransactionDateValue?.isNotEmpty ?? false);

  bool get hasPaymentDescriptionValidationMessage =>
      this.fieldsValidationMessages[PaymentDescriptionValueKey]?.isNotEmpty ??
      false;
  bool get hasPaymentTransactionDateValidationMessage =>
      this
          .fieldsValidationMessages[PaymentTransactionDateValueKey]
          ?.isNotEmpty ??
      false;

  String? get paymentDescriptionValidationMessage =>
      this.fieldsValidationMessages[PaymentDescriptionValueKey];
  String? get paymentTransactionDateValidationMessage =>
      this.fieldsValidationMessages[PaymentTransactionDateValueKey];
}

extension Methods on FormStateHelper {
  setPaymentDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PaymentDescriptionValueKey] =
          validationMessage;
  setPaymentTransactionDateValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PaymentTransactionDateValueKey] =
          validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    paymentDescriptionValue = '';
    paymentTransactionDateValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      PaymentDescriptionValueKey:
          getValidationMessage(PaymentDescriptionValueKey),
      PaymentTransactionDateValueKey:
          getValidationMessage(PaymentTransactionDateValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _MakeExpensePaymentViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _MakeExpensePaymentViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      PaymentDescriptionValueKey:
          getValidationMessage(PaymentDescriptionValueKey),
      PaymentTransactionDateValueKey:
          getValidationMessage(PaymentTransactionDateValueKey),
    });
