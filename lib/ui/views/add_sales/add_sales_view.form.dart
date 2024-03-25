// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String DescriptionValueKey = 'description';
const String CustomerIdValueKey = 'customerId';
const String DueDateValueKey = 'dueDate';
const String DateOfIssueValueKey = 'dateOfIssue';
const String ServiceIdValueKey = 'serviceId';
const String ServiceExpenseAmountValueKey = 'serviceExpenseAmount';
const String ServiceExpenseDescriptionValueKey = 'serviceExpenseDescription';
const String SaleExpenseItemDescriptionValueKey = 'saleExpenseItemDescription';
const String SaleExpenseItemAmountValueKey = 'saleExpenseItemAmount';

final Map<String, TextEditingController> _AddSalesViewTextEditingControllers =
    {};

final Map<String, FocusNode> _AddSalesViewFocusNodes = {};

final Map<String, String? Function(String?)?> _AddSalesViewTextValidations = {
  DescriptionValueKey: null,
  CustomerIdValueKey: null,
  DueDateValueKey: null,
  DateOfIssueValueKey: null,
  ServiceIdValueKey: null,
  ServiceExpenseAmountValueKey: null,
  ServiceExpenseDescriptionValueKey: null,
  SaleExpenseItemDescriptionValueKey: null,
  SaleExpenseItemAmountValueKey: null,
};

mixin $AddSalesView {
  TextEditingController get descriptionController =>
      _getFormTextEditingController(DescriptionValueKey);
  TextEditingController get customerIdController =>
      _getFormTextEditingController(CustomerIdValueKey);
  TextEditingController get dueDateController =>
      _getFormTextEditingController(DueDateValueKey);
  TextEditingController get dateOfIssueController =>
      _getFormTextEditingController(DateOfIssueValueKey);
  TextEditingController get serviceIdController =>
      _getFormTextEditingController(ServiceIdValueKey);
  TextEditingController get serviceExpenseAmountController =>
      _getFormTextEditingController(ServiceExpenseAmountValueKey);
  TextEditingController get serviceExpenseDescriptionController =>
      _getFormTextEditingController(ServiceExpenseDescriptionValueKey);
  TextEditingController get saleExpenseItemDescriptionController =>
      _getFormTextEditingController(SaleExpenseItemDescriptionValueKey);
  TextEditingController get saleExpenseItemAmountController =>
      _getFormTextEditingController(SaleExpenseItemAmountValueKey);

  FocusNode get descriptionFocusNode => _getFormFocusNode(DescriptionValueKey);
  FocusNode get customerIdFocusNode => _getFormFocusNode(CustomerIdValueKey);
  FocusNode get dueDateFocusNode => _getFormFocusNode(DueDateValueKey);
  FocusNode get dateOfIssueFocusNode => _getFormFocusNode(DateOfIssueValueKey);
  FocusNode get serviceIdFocusNode => _getFormFocusNode(ServiceIdValueKey);
  FocusNode get serviceExpenseAmountFocusNode =>
      _getFormFocusNode(ServiceExpenseAmountValueKey);
  FocusNode get serviceExpenseDescriptionFocusNode =>
      _getFormFocusNode(ServiceExpenseDescriptionValueKey);
  FocusNode get saleExpenseItemDescriptionFocusNode =>
      _getFormFocusNode(SaleExpenseItemDescriptionValueKey);
  FocusNode get saleExpenseItemAmountFocusNode =>
      _getFormFocusNode(SaleExpenseItemAmountValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_AddSalesViewTextEditingControllers.containsKey(key)) {
      return _AddSalesViewTextEditingControllers[key]!;
    }

    _AddSalesViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _AddSalesViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_AddSalesViewFocusNodes.containsKey(key)) {
      return _AddSalesViewFocusNodes[key]!;
    }
    _AddSalesViewFocusNodes[key] = FocusNode();
    return _AddSalesViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    descriptionController.addListener(() => _updateFormData(model));
    customerIdController.addListener(() => _updateFormData(model));
    dueDateController.addListener(() => _updateFormData(model));
    dateOfIssueController.addListener(() => _updateFormData(model));
    serviceIdController.addListener(() => _updateFormData(model));
    serviceExpenseAmountController.addListener(() => _updateFormData(model));
    serviceExpenseDescriptionController
        .addListener(() => _updateFormData(model));
    saleExpenseItemDescriptionController
        .addListener(() => _updateFormData(model));
    saleExpenseItemAmountController.addListener(() => _updateFormData(model));

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
    customerIdController.addListener(() => _updateFormData(model));
    dueDateController.addListener(() => _updateFormData(model));
    dateOfIssueController.addListener(() => _updateFormData(model));
    serviceIdController.addListener(() => _updateFormData(model));
    serviceExpenseAmountController.addListener(() => _updateFormData(model));
    serviceExpenseDescriptionController
        .addListener(() => _updateFormData(model));
    saleExpenseItemDescriptionController
        .addListener(() => _updateFormData(model));
    saleExpenseItemAmountController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          DescriptionValueKey: descriptionController.text,
          CustomerIdValueKey: customerIdController.text,
          DueDateValueKey: dueDateController.text,
          DateOfIssueValueKey: dateOfIssueController.text,
          ServiceIdValueKey: serviceIdController.text,
          ServiceExpenseAmountValueKey: serviceExpenseAmountController.text,
          ServiceExpenseDescriptionValueKey:
              serviceExpenseDescriptionController.text,
          SaleExpenseItemDescriptionValueKey:
              saleExpenseItemDescriptionController.text,
          SaleExpenseItemAmountValueKey: saleExpenseItemAmountController.text,
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

    for (var controller in _AddSalesViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _AddSalesViewFocusNodes.values) {
      focusNode.dispose();
    }

    _AddSalesViewTextEditingControllers.clear();
    _AddSalesViewFocusNodes.clear();
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
  String? get customerIdValue =>
      this.formValueMap[CustomerIdValueKey] as String?;
  String? get dueDateValue => this.formValueMap[DueDateValueKey] as String?;
  String? get dateOfIssueValue =>
      this.formValueMap[DateOfIssueValueKey] as String?;
  String? get serviceIdValue => this.formValueMap[ServiceIdValueKey] as String?;
  String? get serviceExpenseAmountValue =>
      this.formValueMap[ServiceExpenseAmountValueKey] as String?;
  String? get serviceExpenseDescriptionValue =>
      this.formValueMap[ServiceExpenseDescriptionValueKey] as String?;
  String? get saleExpenseItemDescriptionValue =>
      this.formValueMap[SaleExpenseItemDescriptionValueKey] as String?;
  String? get saleExpenseItemAmountValue =>
      this.formValueMap[SaleExpenseItemAmountValueKey] as String?;

  set descriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({DescriptionValueKey: value}),
    );

    if (_AddSalesViewTextEditingControllers.containsKey(DescriptionValueKey)) {
      _AddSalesViewTextEditingControllers[DescriptionValueKey]?.text =
          value ?? '';
    }
  }

  set customerIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({CustomerIdValueKey: value}),
    );

    if (_AddSalesViewTextEditingControllers.containsKey(CustomerIdValueKey)) {
      _AddSalesViewTextEditingControllers[CustomerIdValueKey]?.text =
          value ?? '';
    }
  }

  set dueDateValue(String? value) {
    this.setData(
      this.formValueMap..addAll({DueDateValueKey: value}),
    );

    if (_AddSalesViewTextEditingControllers.containsKey(DueDateValueKey)) {
      _AddSalesViewTextEditingControllers[DueDateValueKey]?.text = value ?? '';
    }
  }

  set dateOfIssueValue(String? value) {
    this.setData(
      this.formValueMap..addAll({DateOfIssueValueKey: value}),
    );

    if (_AddSalesViewTextEditingControllers.containsKey(DateOfIssueValueKey)) {
      _AddSalesViewTextEditingControllers[DateOfIssueValueKey]?.text =
          value ?? '';
    }
  }

  set serviceIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ServiceIdValueKey: value}),
    );

    if (_AddSalesViewTextEditingControllers.containsKey(ServiceIdValueKey)) {
      _AddSalesViewTextEditingControllers[ServiceIdValueKey]?.text =
          value ?? '';
    }
  }

  set serviceExpenseAmountValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ServiceExpenseAmountValueKey: value}),
    );

    if (_AddSalesViewTextEditingControllers.containsKey(
        ServiceExpenseAmountValueKey)) {
      _AddSalesViewTextEditingControllers[ServiceExpenseAmountValueKey]?.text =
          value ?? '';
    }
  }

  set serviceExpenseDescriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ServiceExpenseDescriptionValueKey: value}),
    );

    if (_AddSalesViewTextEditingControllers.containsKey(
        ServiceExpenseDescriptionValueKey)) {
      _AddSalesViewTextEditingControllers[ServiceExpenseDescriptionValueKey]
          ?.text = value ?? '';
    }
  }

  set saleExpenseItemDescriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({SaleExpenseItemDescriptionValueKey: value}),
    );

    if (_AddSalesViewTextEditingControllers.containsKey(
        SaleExpenseItemDescriptionValueKey)) {
      _AddSalesViewTextEditingControllers[SaleExpenseItemDescriptionValueKey]
          ?.text = value ?? '';
    }
  }

  set saleExpenseItemAmountValue(String? value) {
    this.setData(
      this.formValueMap..addAll({SaleExpenseItemAmountValueKey: value}),
    );

    if (_AddSalesViewTextEditingControllers.containsKey(
        SaleExpenseItemAmountValueKey)) {
      _AddSalesViewTextEditingControllers[SaleExpenseItemAmountValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasDescription =>
      this.formValueMap.containsKey(DescriptionValueKey) &&
      (descriptionValue?.isNotEmpty ?? false);
  bool get hasCustomerId =>
      this.formValueMap.containsKey(CustomerIdValueKey) &&
      (customerIdValue?.isNotEmpty ?? false);
  bool get hasDueDate =>
      this.formValueMap.containsKey(DueDateValueKey) &&
      (dueDateValue?.isNotEmpty ?? false);
  bool get hasDateOfIssue =>
      this.formValueMap.containsKey(DateOfIssueValueKey) &&
      (dateOfIssueValue?.isNotEmpty ?? false);
  bool get hasServiceId =>
      this.formValueMap.containsKey(ServiceIdValueKey) &&
      (serviceIdValue?.isNotEmpty ?? false);
  bool get hasServiceExpenseAmount =>
      this.formValueMap.containsKey(ServiceExpenseAmountValueKey) &&
      (serviceExpenseAmountValue?.isNotEmpty ?? false);
  bool get hasServiceExpenseDescription =>
      this.formValueMap.containsKey(ServiceExpenseDescriptionValueKey) &&
      (serviceExpenseDescriptionValue?.isNotEmpty ?? false);
  bool get hasSaleExpenseItemDescription =>
      this.formValueMap.containsKey(SaleExpenseItemDescriptionValueKey) &&
      (saleExpenseItemDescriptionValue?.isNotEmpty ?? false);
  bool get hasSaleExpenseItemAmount =>
      this.formValueMap.containsKey(SaleExpenseItemAmountValueKey) &&
      (saleExpenseItemAmountValue?.isNotEmpty ?? false);

  bool get hasDescriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey]?.isNotEmpty ?? false;
  bool get hasCustomerIdValidationMessage =>
      this.fieldsValidationMessages[CustomerIdValueKey]?.isNotEmpty ?? false;
  bool get hasDueDateValidationMessage =>
      this.fieldsValidationMessages[DueDateValueKey]?.isNotEmpty ?? false;
  bool get hasDateOfIssueValidationMessage =>
      this.fieldsValidationMessages[DateOfIssueValueKey]?.isNotEmpty ?? false;
  bool get hasServiceIdValidationMessage =>
      this.fieldsValidationMessages[ServiceIdValueKey]?.isNotEmpty ?? false;
  bool get hasServiceExpenseAmountValidationMessage =>
      this.fieldsValidationMessages[ServiceExpenseAmountValueKey]?.isNotEmpty ??
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

  String? get descriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey];
  String? get customerIdValidationMessage =>
      this.fieldsValidationMessages[CustomerIdValueKey];
  String? get dueDateValidationMessage =>
      this.fieldsValidationMessages[DueDateValueKey];
  String? get dateOfIssueValidationMessage =>
      this.fieldsValidationMessages[DateOfIssueValueKey];
  String? get serviceIdValidationMessage =>
      this.fieldsValidationMessages[ServiceIdValueKey];
  String? get serviceExpenseAmountValidationMessage =>
      this.fieldsValidationMessages[ServiceExpenseAmountValueKey];
  String? get serviceExpenseDescriptionValidationMessage =>
      this.fieldsValidationMessages[ServiceExpenseDescriptionValueKey];
  String? get saleExpenseItemDescriptionValidationMessage =>
      this.fieldsValidationMessages[SaleExpenseItemDescriptionValueKey];
  String? get saleExpenseItemAmountValidationMessage =>
      this.fieldsValidationMessages[SaleExpenseItemAmountValueKey];
}

extension Methods on FormStateHelper {
  setDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DescriptionValueKey] = validationMessage;
  setCustomerIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CustomerIdValueKey] = validationMessage;
  setDueDateValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DueDateValueKey] = validationMessage;
  setDateOfIssueValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DateOfIssueValueKey] = validationMessage;
  setServiceIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ServiceIdValueKey] = validationMessage;
  setServiceExpenseAmountValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ServiceExpenseAmountValueKey] =
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

  /// Clears text input fields on the Form
  void clearForm() {
    descriptionValue = '';
    customerIdValue = '';
    dueDateValue = '';
    dateOfIssueValue = '';
    serviceIdValue = '';
    serviceExpenseAmountValue = '';
    serviceExpenseDescriptionValue = '';
    saleExpenseItemDescriptionValue = '';
    saleExpenseItemAmountValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      DescriptionValueKey: getValidationMessage(DescriptionValueKey),
      CustomerIdValueKey: getValidationMessage(CustomerIdValueKey),
      DueDateValueKey: getValidationMessage(DueDateValueKey),
      DateOfIssueValueKey: getValidationMessage(DateOfIssueValueKey),
      ServiceIdValueKey: getValidationMessage(ServiceIdValueKey),
      ServiceExpenseAmountValueKey:
          getValidationMessage(ServiceExpenseAmountValueKey),
      ServiceExpenseDescriptionValueKey:
          getValidationMessage(ServiceExpenseDescriptionValueKey),
      SaleExpenseItemDescriptionValueKey:
          getValidationMessage(SaleExpenseItemDescriptionValueKey),
      SaleExpenseItemAmountValueKey:
          getValidationMessage(SaleExpenseItemAmountValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _AddSalesViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _AddSalesViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      DescriptionValueKey: getValidationMessage(DescriptionValueKey),
      CustomerIdValueKey: getValidationMessage(CustomerIdValueKey),
      DueDateValueKey: getValidationMessage(DueDateValueKey),
      DateOfIssueValueKey: getValidationMessage(DateOfIssueValueKey),
      ServiceIdValueKey: getValidationMessage(ServiceIdValueKey),
      ServiceExpenseAmountValueKey:
          getValidationMessage(ServiceExpenseAmountValueKey),
      ServiceExpenseDescriptionValueKey:
          getValidationMessage(ServiceExpenseDescriptionValueKey),
      SaleExpenseItemDescriptionValueKey:
          getValidationMessage(SaleExpenseItemDescriptionValueKey),
      SaleExpenseItemAmountValueKey:
          getValidationMessage(SaleExpenseItemAmountValueKey),
    });
