// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String ServiceIdValueKey = 'serviceId';
const String ServiceExpenseAmountValueKey = 'serviceExpenseAmount';
const String ServiceExpenseBaseAmountValueKey = 'serviceExpenseBaseAmount';
const String ServiceExpenseDescriptionValueKey = 'serviceExpenseDescription';
const String SaleExpenseItemDescriptionValueKey = 'saleExpenseItemDescription';
const String SaleExpenseItemAmountValueKey = 'saleExpenseItemAmount';
const String SaleExpenseItemBaseAmountValueKey = 'saleExpenseItemBaseAmount';

final Map<String, TextEditingController>
    _UpdateSalesViewTextEditingControllers = {};

final Map<String, FocusNode> _UpdateSalesViewFocusNodes = {};

final Map<String, String? Function(String?)?> _UpdateSalesViewTextValidations =
    {
  ServiceIdValueKey: null,
  ServiceExpenseAmountValueKey: null,
  ServiceExpenseBaseAmountValueKey: null,
  ServiceExpenseDescriptionValueKey: null,
  SaleExpenseItemDescriptionValueKey: null,
  SaleExpenseItemAmountValueKey: null,
  SaleExpenseItemBaseAmountValueKey: null,
};

mixin $UpdateSalesView {
  TextEditingController get serviceIdController =>
      _getFormTextEditingController(ServiceIdValueKey);
  TextEditingController get serviceExpenseAmountController =>
      _getFormTextEditingController(ServiceExpenseAmountValueKey);
  TextEditingController get serviceExpenseBaseAmountController =>
      _getFormTextEditingController(ServiceExpenseBaseAmountValueKey);
  TextEditingController get serviceExpenseDescriptionController =>
      _getFormTextEditingController(ServiceExpenseDescriptionValueKey);
  TextEditingController get saleExpenseItemDescriptionController =>
      _getFormTextEditingController(SaleExpenseItemDescriptionValueKey);
  TextEditingController get saleExpenseItemAmountController =>
      _getFormTextEditingController(SaleExpenseItemAmountValueKey);
  TextEditingController get saleExpenseItemBaseAmountController =>
      _getFormTextEditingController(SaleExpenseItemBaseAmountValueKey);

  FocusNode get serviceIdFocusNode => _getFormFocusNode(ServiceIdValueKey);
  FocusNode get serviceExpenseAmountFocusNode =>
      _getFormFocusNode(ServiceExpenseAmountValueKey);
  FocusNode get serviceExpenseBaseAmountFocusNode =>
      _getFormFocusNode(ServiceExpenseBaseAmountValueKey);
  FocusNode get serviceExpenseDescriptionFocusNode =>
      _getFormFocusNode(ServiceExpenseDescriptionValueKey);
  FocusNode get saleExpenseItemDescriptionFocusNode =>
      _getFormFocusNode(SaleExpenseItemDescriptionValueKey);
  FocusNode get saleExpenseItemAmountFocusNode =>
      _getFormFocusNode(SaleExpenseItemAmountValueKey);
  FocusNode get saleExpenseItemBaseAmountFocusNode =>
      _getFormFocusNode(SaleExpenseItemBaseAmountValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_UpdateSalesViewTextEditingControllers.containsKey(key)) {
      return _UpdateSalesViewTextEditingControllers[key]!;
    }

    _UpdateSalesViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _UpdateSalesViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_UpdateSalesViewFocusNodes.containsKey(key)) {
      return _UpdateSalesViewFocusNodes[key]!;
    }
    _UpdateSalesViewFocusNodes[key] = FocusNode();
    return _UpdateSalesViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    serviceIdController.addListener(() => _updateFormData(model));
    serviceExpenseAmountController.addListener(() => _updateFormData(model));
    serviceExpenseBaseAmountController
        .addListener(() => _updateFormData(model));
    serviceExpenseDescriptionController
        .addListener(() => _updateFormData(model));
    saleExpenseItemDescriptionController
        .addListener(() => _updateFormData(model));
    saleExpenseItemAmountController.addListener(() => _updateFormData(model));
    saleExpenseItemBaseAmountController
        .addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    serviceIdController.addListener(() => _updateFormData(model));
    serviceExpenseAmountController.addListener(() => _updateFormData(model));
    serviceExpenseBaseAmountController
        .addListener(() => _updateFormData(model));
    serviceExpenseDescriptionController
        .addListener(() => _updateFormData(model));
    saleExpenseItemDescriptionController
        .addListener(() => _updateFormData(model));
    saleExpenseItemAmountController.addListener(() => _updateFormData(model));
    saleExpenseItemBaseAmountController
        .addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          ServiceIdValueKey: serviceIdController.text,
          ServiceExpenseAmountValueKey: serviceExpenseAmountController.text,
          ServiceExpenseBaseAmountValueKey:
              serviceExpenseBaseAmountController.text,
          ServiceExpenseDescriptionValueKey:
              serviceExpenseDescriptionController.text,
          SaleExpenseItemDescriptionValueKey:
              saleExpenseItemDescriptionController.text,
          SaleExpenseItemAmountValueKey: saleExpenseItemAmountController.text,
          SaleExpenseItemBaseAmountValueKey:
              saleExpenseItemBaseAmountController.text,
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

    for (var controller in _UpdateSalesViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _UpdateSalesViewFocusNodes.values) {
      focusNode.dispose();
    }

    _UpdateSalesViewTextEditingControllers.clear();
    _UpdateSalesViewFocusNodes.clear();
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

  String? get serviceIdValue => this.formValueMap[ServiceIdValueKey] as String?;
  String? get serviceExpenseAmountValue =>
      this.formValueMap[ServiceExpenseAmountValueKey] as String?;
  String? get serviceExpenseBaseAmountValue =>
      this.formValueMap[ServiceExpenseBaseAmountValueKey] as String?;
  String? get serviceExpenseDescriptionValue =>
      this.formValueMap[ServiceExpenseDescriptionValueKey] as String?;
  String? get saleExpenseItemDescriptionValue =>
      this.formValueMap[SaleExpenseItemDescriptionValueKey] as String?;
  String? get saleExpenseItemAmountValue =>
      this.formValueMap[SaleExpenseItemAmountValueKey] as String?;
  String? get saleExpenseItemBaseAmountValue =>
      this.formValueMap[SaleExpenseItemBaseAmountValueKey] as String?;

  set serviceIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ServiceIdValueKey: value}),
    );

    if (_UpdateSalesViewTextEditingControllers.containsKey(ServiceIdValueKey)) {
      _UpdateSalesViewTextEditingControllers[ServiceIdValueKey]?.text =
          value ?? '';
    }
  }

  set serviceExpenseAmountValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ServiceExpenseAmountValueKey: value}),
    );

    if (_UpdateSalesViewTextEditingControllers.containsKey(
        ServiceExpenseAmountValueKey)) {
      _UpdateSalesViewTextEditingControllers[ServiceExpenseAmountValueKey]
          ?.text = value ?? '';
    }
  }

  set serviceExpenseBaseAmountValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ServiceExpenseBaseAmountValueKey: value}),
    );

    if (_UpdateSalesViewTextEditingControllers.containsKey(
        ServiceExpenseBaseAmountValueKey)) {
      _UpdateSalesViewTextEditingControllers[ServiceExpenseBaseAmountValueKey]
          ?.text = value ?? '';
    }
  }

  set serviceExpenseDescriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ServiceExpenseDescriptionValueKey: value}),
    );

    if (_UpdateSalesViewTextEditingControllers.containsKey(
        ServiceExpenseDescriptionValueKey)) {
      _UpdateSalesViewTextEditingControllers[ServiceExpenseDescriptionValueKey]
          ?.text = value ?? '';
    }
  }

  set saleExpenseItemDescriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({SaleExpenseItemDescriptionValueKey: value}),
    );

    if (_UpdateSalesViewTextEditingControllers.containsKey(
        SaleExpenseItemDescriptionValueKey)) {
      _UpdateSalesViewTextEditingControllers[SaleExpenseItemDescriptionValueKey]
          ?.text = value ?? '';
    }
  }

  set saleExpenseItemAmountValue(String? value) {
    this.setData(
      this.formValueMap..addAll({SaleExpenseItemAmountValueKey: value}),
    );

    if (_UpdateSalesViewTextEditingControllers.containsKey(
        SaleExpenseItemAmountValueKey)) {
      _UpdateSalesViewTextEditingControllers[SaleExpenseItemAmountValueKey]
          ?.text = value ?? '';
    }
  }

  set saleExpenseItemBaseAmountValue(String? value) {
    this.setData(
      this.formValueMap..addAll({SaleExpenseItemBaseAmountValueKey: value}),
    );

    if (_UpdateSalesViewTextEditingControllers.containsKey(
        SaleExpenseItemBaseAmountValueKey)) {
      _UpdateSalesViewTextEditingControllers[SaleExpenseItemBaseAmountValueKey]
          ?.text = value ?? '';
    }
  }

  bool get hasServiceId =>
      this.formValueMap.containsKey(ServiceIdValueKey) &&
      (serviceIdValue?.isNotEmpty ?? false);
  bool get hasServiceExpenseAmount =>
      this.formValueMap.containsKey(ServiceExpenseAmountValueKey) &&
      (serviceExpenseAmountValue?.isNotEmpty ?? false);
  bool get hasServiceExpenseBaseAmount =>
      this.formValueMap.containsKey(ServiceExpenseBaseAmountValueKey) &&
      (serviceExpenseBaseAmountValue?.isNotEmpty ?? false);
  bool get hasServiceExpenseDescription =>
      this.formValueMap.containsKey(ServiceExpenseDescriptionValueKey) &&
      (serviceExpenseDescriptionValue?.isNotEmpty ?? false);
  bool get hasSaleExpenseItemDescription =>
      this.formValueMap.containsKey(SaleExpenseItemDescriptionValueKey) &&
      (saleExpenseItemDescriptionValue?.isNotEmpty ?? false);
  bool get hasSaleExpenseItemAmount =>
      this.formValueMap.containsKey(SaleExpenseItemAmountValueKey) &&
      (saleExpenseItemAmountValue?.isNotEmpty ?? false);
  bool get hasSaleExpenseItemBaseAmount =>
      this.formValueMap.containsKey(SaleExpenseItemBaseAmountValueKey) &&
      (saleExpenseItemBaseAmountValue?.isNotEmpty ?? false);

  bool get hasServiceIdValidationMessage =>
      this.fieldsValidationMessages[ServiceIdValueKey]?.isNotEmpty ?? false;
  bool get hasServiceExpenseAmountValidationMessage =>
      this.fieldsValidationMessages[ServiceExpenseAmountValueKey]?.isNotEmpty ??
      false;
  bool get hasServiceExpenseBaseAmountValidationMessage =>
      this
          .fieldsValidationMessages[ServiceExpenseBaseAmountValueKey]
          ?.isNotEmpty ??
      false;
  bool get hasServiceExpenseDescriptionValidationMessage =>
      this
          .fieldsValidationMessages[ServiceExpenseDescriptionValueKey]
          ?.isNotEmpty ??
      false;
  bool get hasSaleExpenseItemDescriptionValidationMessage =>
      this
          .fieldsValidationMessages[SaleExpenseItemDescriptionValueKey]
          ?.isNotEmpty ??
      false;
  bool get hasSaleExpenseItemAmountValidationMessage =>
      this
          .fieldsValidationMessages[SaleExpenseItemAmountValueKey]
          ?.isNotEmpty ??
      false;
  bool get hasSaleExpenseItemBaseAmountValidationMessage =>
      this
          .fieldsValidationMessages[SaleExpenseItemBaseAmountValueKey]
          ?.isNotEmpty ??
      false;

  String? get serviceIdValidationMessage =>
      this.fieldsValidationMessages[ServiceIdValueKey];
  String? get serviceExpenseAmountValidationMessage =>
      this.fieldsValidationMessages[ServiceExpenseAmountValueKey];
  String? get serviceExpenseBaseAmountValidationMessage =>
      this.fieldsValidationMessages[ServiceExpenseBaseAmountValueKey];
  String? get serviceExpenseDescriptionValidationMessage =>
      this.fieldsValidationMessages[ServiceExpenseDescriptionValueKey];
  String? get saleExpenseItemDescriptionValidationMessage =>
      this.fieldsValidationMessages[SaleExpenseItemDescriptionValueKey];
  String? get saleExpenseItemAmountValidationMessage =>
      this.fieldsValidationMessages[SaleExpenseItemAmountValueKey];
  String? get saleExpenseItemBaseAmountValidationMessage =>
      this.fieldsValidationMessages[SaleExpenseItemBaseAmountValueKey];
}

extension Methods on FormStateHelper {
  setServiceIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ServiceIdValueKey] = validationMessage;
  setServiceExpenseAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ServiceExpenseAmountValueKey] =
          validationMessage;
  setServiceExpenseBaseAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ServiceExpenseBaseAmountValueKey] =
          validationMessage;
  setServiceExpenseDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ServiceExpenseDescriptionValueKey] =
          validationMessage;
  setSaleExpenseItemDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[SaleExpenseItemDescriptionValueKey] =
          validationMessage;
  setSaleExpenseItemAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[SaleExpenseItemAmountValueKey] =
          validationMessage;
  setSaleExpenseItemBaseAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[SaleExpenseItemBaseAmountValueKey] =
          validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    serviceIdValue = '';
    serviceExpenseAmountValue = '';
    serviceExpenseBaseAmountValue = '';
    serviceExpenseDescriptionValue = '';
    saleExpenseItemDescriptionValue = '';
    saleExpenseItemAmountValue = '';
    saleExpenseItemBaseAmountValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      ServiceIdValueKey: getValidationMessage(ServiceIdValueKey),
      ServiceExpenseAmountValueKey:
          getValidationMessage(ServiceExpenseAmountValueKey),
      ServiceExpenseBaseAmountValueKey:
          getValidationMessage(ServiceExpenseBaseAmountValueKey),
      ServiceExpenseDescriptionValueKey:
          getValidationMessage(ServiceExpenseDescriptionValueKey),
      SaleExpenseItemDescriptionValueKey:
          getValidationMessage(SaleExpenseItemDescriptionValueKey),
      SaleExpenseItemAmountValueKey:
          getValidationMessage(SaleExpenseItemAmountValueKey),
      SaleExpenseItemBaseAmountValueKey:
          getValidationMessage(SaleExpenseItemBaseAmountValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _UpdateSalesViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _UpdateSalesViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      ServiceIdValueKey: getValidationMessage(ServiceIdValueKey),
      ServiceExpenseAmountValueKey:
          getValidationMessage(ServiceExpenseAmountValueKey),
      ServiceExpenseBaseAmountValueKey:
          getValidationMessage(ServiceExpenseBaseAmountValueKey),
      ServiceExpenseDescriptionValueKey:
          getValidationMessage(ServiceExpenseDescriptionValueKey),
      SaleExpenseItemDescriptionValueKey:
          getValidationMessage(SaleExpenseItemDescriptionValueKey),
      SaleExpenseItemAmountValueKey:
          getValidationMessage(SaleExpenseItemAmountValueKey),
      SaleExpenseItemBaseAmountValueKey:
          getValidationMessage(SaleExpenseItemBaseAmountValueKey),
    });
