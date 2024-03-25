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
    _MarkPurchaseItemAsReceivedViewTextEditingControllers = {};

final Map<String, FocusNode> _MarkPurchaseItemAsReceivedViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _MarkPurchaseItemAsReceivedViewTextValidations = {
  TransactionDateValueKey: null,
};

mixin $MarkPurchaseItemAsReceivedView {
  TextEditingController get transactionDateController =>
      _getFormTextEditingController(TransactionDateValueKey);

  FocusNode get transactionDateFocusNode =>
      _getFormFocusNode(TransactionDateValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_MarkPurchaseItemAsReceivedViewTextEditingControllers.containsKey(
        key)) {
      return _MarkPurchaseItemAsReceivedViewTextEditingControllers[key]!;
    }

    _MarkPurchaseItemAsReceivedViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _MarkPurchaseItemAsReceivedViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_MarkPurchaseItemAsReceivedViewFocusNodes.containsKey(key)) {
      return _MarkPurchaseItemAsReceivedViewFocusNodes[key]!;
    }
    _MarkPurchaseItemAsReceivedViewFocusNodes[key] = FocusNode();
    return _MarkPurchaseItemAsReceivedViewFocusNodes[key]!;
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
        in _MarkPurchaseItemAsReceivedViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _MarkPurchaseItemAsReceivedViewFocusNodes.values) {
      focusNode.dispose();
    }

    _MarkPurchaseItemAsReceivedViewTextEditingControllers.clear();
    _MarkPurchaseItemAsReceivedViewFocusNodes.clear();
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

    if (_MarkPurchaseItemAsReceivedViewTextEditingControllers.containsKey(
        TransactionDateValueKey)) {
      _MarkPurchaseItemAsReceivedViewTextEditingControllers[
              TransactionDateValueKey]
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
  final validatorForKey = _MarkPurchaseItemAsReceivedViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _MarkPurchaseItemAsReceivedViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      TransactionDateValueKey: getValidationMessage(TransactionDateValueKey),
    });
