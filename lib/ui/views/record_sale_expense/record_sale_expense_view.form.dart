// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String TransactionDateValueKey = 'transactionDate';

final Map<String, TextEditingController>
    _RecordSaleExpenseViewTextEditingControllers = {};

final Map<String, FocusNode> _RecordSaleExpenseViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _RecordSaleExpenseViewTextValidations = {
  TransactionDateValueKey: null,
};

mixin $RecordSaleExpenseView {
  TextEditingController get transactionDateController =>
      _getFormTextEditingController(TransactionDateValueKey);

  FocusNode get transactionDateFocusNode =>
      _getFormFocusNode(TransactionDateValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_RecordSaleExpenseViewTextEditingControllers.containsKey(key)) {
      return _RecordSaleExpenseViewTextEditingControllers[key]!;
    }

    _RecordSaleExpenseViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _RecordSaleExpenseViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_RecordSaleExpenseViewFocusNodes.containsKey(key)) {
      return _RecordSaleExpenseViewFocusNodes[key]!;
    }
    _RecordSaleExpenseViewFocusNodes[key] = FocusNode();
    return _RecordSaleExpenseViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    transactionDateController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    transactionDateController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          TransactionDateValueKey: transactionDateController.text,
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
        in _RecordSaleExpenseViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _RecordSaleExpenseViewFocusNodes.values) {
      focusNode.dispose();
    }

    _RecordSaleExpenseViewTextEditingControllers.clear();
    _RecordSaleExpenseViewFocusNodes.clear();
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

  String? get transactionDateValue =>
      this.formValueMap[TransactionDateValueKey] as String?;

  set transactionDateValue(String? value) {
    this.setData(
      this.formValueMap..addAll({TransactionDateValueKey: value}),
    );

    if (_RecordSaleExpenseViewTextEditingControllers.containsKey(
        TransactionDateValueKey)) {
      _RecordSaleExpenseViewTextEditingControllers[TransactionDateValueKey]
          ?.text = value ?? '';
    }
  }

  bool get hasTransactionDate =>
      this.formValueMap.containsKey(TransactionDateValueKey) &&
      (transactionDateValue?.isNotEmpty ?? false);

  bool get hasTransactionDateValidationMessage =>
      this.fieldsValidationMessages[TransactionDateValueKey]?.isNotEmpty ??
      false;

  String? get transactionDateValidationMessage =>
      this.fieldsValidationMessages[TransactionDateValueKey];
}

extension Methods on FormStateHelper {
  setTransactionDateValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[TransactionDateValueKey] =
          validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    transactionDateValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      TransactionDateValueKey: getValidationMessage(TransactionDateValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _RecordSaleExpenseViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _RecordSaleExpenseViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      TransactionDateValueKey: getValidationMessage(TransactionDateValueKey),
    });
