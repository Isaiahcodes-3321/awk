// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String DateValueKey = 'date';

final Map<String, TextEditingController>
    _MerchantInvoiceViewTextEditingControllers = {};

final Map<String, FocusNode> _MerchantInvoiceViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _MerchantInvoiceViewTextValidations = {
  DateValueKey: null,
};

mixin $MerchantInvoiceView {
  TextEditingController get dateController =>
      _getFormTextEditingController(DateValueKey);

  FocusNode get dateFocusNode => _getFormFocusNode(DateValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_MerchantInvoiceViewTextEditingControllers.containsKey(key)) {
      return _MerchantInvoiceViewTextEditingControllers[key]!;
    }

    _MerchantInvoiceViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _MerchantInvoiceViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_MerchantInvoiceViewFocusNodes.containsKey(key)) {
      return _MerchantInvoiceViewFocusNodes[key]!;
    }
    _MerchantInvoiceViewFocusNodes[key] = FocusNode();
    return _MerchantInvoiceViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    dateController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    dateController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          DateValueKey: dateController.text,
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

    for (var controller in _MerchantInvoiceViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _MerchantInvoiceViewFocusNodes.values) {
      focusNode.dispose();
    }

    _MerchantInvoiceViewTextEditingControllers.clear();
    _MerchantInvoiceViewFocusNodes.clear();
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

  String? get dateValue => this.formValueMap[DateValueKey] as String?;

  set dateValue(String? value) {
    this.setData(
      this.formValueMap..addAll({DateValueKey: value}),
    );

    if (_MerchantInvoiceViewTextEditingControllers.containsKey(DateValueKey)) {
      _MerchantInvoiceViewTextEditingControllers[DateValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasDate =>
      this.formValueMap.containsKey(DateValueKey) &&
      (dateValue?.isNotEmpty ?? false);

  bool get hasDateValidationMessage =>
      this.fieldsValidationMessages[DateValueKey]?.isNotEmpty ?? false;

  String? get dateValidationMessage =>
      this.fieldsValidationMessages[DateValueKey];
}

extension Methods on FormStateHelper {
  setDateValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DateValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    dateValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      DateValueKey: getValidationMessage(DateValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _MerchantInvoiceViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _MerchantInvoiceViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      DateValueKey: getValidationMessage(DateValueKey),
    });
