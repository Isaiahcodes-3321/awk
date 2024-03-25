// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String DescriptionValueKey = 'description';
const String ReferenceValueKey = 'reference';
const String TransactionDateValueKey = 'transactionDate';
const String MerchantIdValueKey = 'merchantId';

final Map<String, TextEditingController>
    _AddPurchaseViewTextEditingControllers = {};

final Map<String, FocusNode> _AddPurchaseViewFocusNodes = {};

final Map<String, String? Function(String?)?> _AddPurchaseViewTextValidations =
    {
  DescriptionValueKey: null,
  ReferenceValueKey: null,
  TransactionDateValueKey: null,
  MerchantIdValueKey: null,
};

mixin $AddPurchaseView {
  TextEditingController get descriptionController =>
      _getFormTextEditingController(DescriptionValueKey);
  TextEditingController get referenceController =>
      _getFormTextEditingController(ReferenceValueKey);
  TextEditingController get transactionDateController =>
      _getFormTextEditingController(TransactionDateValueKey);
  TextEditingController get merchantIdController =>
      _getFormTextEditingController(MerchantIdValueKey);

  FocusNode get descriptionFocusNode => _getFormFocusNode(DescriptionValueKey);
  FocusNode get referenceFocusNode => _getFormFocusNode(ReferenceValueKey);
  FocusNode get transactionDateFocusNode =>
      _getFormFocusNode(TransactionDateValueKey);
  FocusNode get merchantIdFocusNode => _getFormFocusNode(MerchantIdValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_AddPurchaseViewTextEditingControllers.containsKey(key)) {
      return _AddPurchaseViewTextEditingControllers[key]!;
    }

    _AddPurchaseViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _AddPurchaseViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_AddPurchaseViewFocusNodes.containsKey(key)) {
      return _AddPurchaseViewFocusNodes[key]!;
    }
    _AddPurchaseViewFocusNodes[key] = FocusNode();
    return _AddPurchaseViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    descriptionController.addListener(() => _updateFormData(model));
    referenceController.addListener(() => _updateFormData(model));
    transactionDateController.addListener(() => _updateFormData(model));
    merchantIdController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    descriptionController.addListener(() => _updateFormData(model));
    referenceController.addListener(() => _updateFormData(model));
    transactionDateController.addListener(() => _updateFormData(model));
    merchantIdController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          DescriptionValueKey: descriptionController.text,
          ReferenceValueKey: referenceController.text,
          TransactionDateValueKey: transactionDateController.text,
          MerchantIdValueKey: merchantIdController.text,
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

    for (var controller in _AddPurchaseViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _AddPurchaseViewFocusNodes.values) {
      focusNode.dispose();
    }

    _AddPurchaseViewTextEditingControllers.clear();
    _AddPurchaseViewFocusNodes.clear();
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

  String? get descriptionValue =>
      this.formValueMap[DescriptionValueKey] as String?;
  String? get referenceValue => this.formValueMap[ReferenceValueKey] as String?;
  String? get transactionDateValue =>
      this.formValueMap[TransactionDateValueKey] as String?;
  String? get merchantIdValue =>
      this.formValueMap[MerchantIdValueKey] as String?;

  set descriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({DescriptionValueKey: value}),
    );

    if (_AddPurchaseViewTextEditingControllers.containsKey(
        DescriptionValueKey)) {
      _AddPurchaseViewTextEditingControllers[DescriptionValueKey]?.text =
          value ?? '';
    }
  }

  set referenceValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ReferenceValueKey: value}),
    );

    if (_AddPurchaseViewTextEditingControllers.containsKey(ReferenceValueKey)) {
      _AddPurchaseViewTextEditingControllers[ReferenceValueKey]?.text =
          value ?? '';
    }
  }

  set transactionDateValue(String? value) {
    this.setData(
      this.formValueMap..addAll({TransactionDateValueKey: value}),
    );

    if (_AddPurchaseViewTextEditingControllers.containsKey(
        TransactionDateValueKey)) {
      _AddPurchaseViewTextEditingControllers[TransactionDateValueKey]?.text =
          value ?? '';
    }
  }

  set merchantIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({MerchantIdValueKey: value}),
    );

    if (_AddPurchaseViewTextEditingControllers.containsKey(
        MerchantIdValueKey)) {
      _AddPurchaseViewTextEditingControllers[MerchantIdValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasDescription =>
      this.formValueMap.containsKey(DescriptionValueKey) &&
      (descriptionValue?.isNotEmpty ?? false);
  bool get hasReference =>
      this.formValueMap.containsKey(ReferenceValueKey) &&
      (referenceValue?.isNotEmpty ?? false);
  bool get hasTransactionDate =>
      this.formValueMap.containsKey(TransactionDateValueKey) &&
      (transactionDateValue?.isNotEmpty ?? false);
  bool get hasMerchantId =>
      this.formValueMap.containsKey(MerchantIdValueKey) &&
      (merchantIdValue?.isNotEmpty ?? false);

  bool get hasDescriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey]?.isNotEmpty ?? false;
  bool get hasReferenceValidationMessage =>
      this.fieldsValidationMessages[ReferenceValueKey]?.isNotEmpty ?? false;
  bool get hasTransactionDateValidationMessage =>
      this.fieldsValidationMessages[TransactionDateValueKey]?.isNotEmpty ??
      false;
  bool get hasMerchantIdValidationMessage =>
      this.fieldsValidationMessages[MerchantIdValueKey]?.isNotEmpty ?? false;

  String? get descriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey];
  String? get referenceValidationMessage =>
      this.fieldsValidationMessages[ReferenceValueKey];
  String? get transactionDateValidationMessage =>
      this.fieldsValidationMessages[TransactionDateValueKey];
  String? get merchantIdValidationMessage =>
      this.fieldsValidationMessages[MerchantIdValueKey];
}

extension Methods on FormStateHelper {
  setDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DescriptionValueKey] = validationMessage;
  setReferenceValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ReferenceValueKey] = validationMessage;
  setTransactionDateValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[TransactionDateValueKey] =
          validationMessage;
  setMerchantIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[MerchantIdValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    descriptionValue = '';
    referenceValue = '';
    transactionDateValue = '';
    merchantIdValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      DescriptionValueKey: getValidationMessage(DescriptionValueKey),
      ReferenceValueKey: getValidationMessage(ReferenceValueKey),
      TransactionDateValueKey: getValidationMessage(TransactionDateValueKey),
      MerchantIdValueKey: getValidationMessage(MerchantIdValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _AddPurchaseViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _AddPurchaseViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      DescriptionValueKey: getValidationMessage(DescriptionValueKey),
      ReferenceValueKey: getValidationMessage(ReferenceValueKey),
      TransactionDateValueKey: getValidationMessage(TransactionDateValueKey),
      MerchantIdValueKey: getValidationMessage(MerchantIdValueKey),
    });
