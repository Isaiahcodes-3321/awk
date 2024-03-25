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
const String ExpenseCategoryIdValueKey = 'expenseCategoryId';
const String ExpenseDateValueKey = 'expenseDate';
const String MerchantIdValueKey = 'merchantId';
const String ExpenseItemDescriptionValueKey = 'expenseItemDescription';
const String ExpenseItemQuantityValueKey = 'expenseItemQuantity';
const String ExpenseItemUnitPriceValueKey = 'expenseItemUnitPrice';
const String CreditAccountIdValueKey = 'creditAccountId';

final Map<String, TextEditingController> _AddExpenseViewTextEditingControllers =
    {};

final Map<String, FocusNode> _AddExpenseViewFocusNodes = {};

final Map<String, String? Function(String?)?> _AddExpenseViewTextValidations = {
  DescriptionValueKey: null,
  ReferenceValueKey: null,
  ExpenseCategoryIdValueKey: null,
  ExpenseDateValueKey: null,
  MerchantIdValueKey: null,
  ExpenseItemDescriptionValueKey: null,
  ExpenseItemQuantityValueKey: null,
  ExpenseItemUnitPriceValueKey: null,
  CreditAccountIdValueKey: null,
};

mixin $AddExpenseView {
  TextEditingController get descriptionController =>
      _getFormTextEditingController(DescriptionValueKey);
  TextEditingController get referenceController =>
      _getFormTextEditingController(ReferenceValueKey);
  TextEditingController get expenseCategoryIdController =>
      _getFormTextEditingController(ExpenseCategoryIdValueKey);
  TextEditingController get expenseDateController =>
      _getFormTextEditingController(ExpenseDateValueKey);
  TextEditingController get merchantIdController =>
      _getFormTextEditingController(MerchantIdValueKey);
  TextEditingController get expenseItemDescriptionController =>
      _getFormTextEditingController(ExpenseItemDescriptionValueKey);
  TextEditingController get expenseItemQuantityController =>
      _getFormTextEditingController(ExpenseItemQuantityValueKey);
  TextEditingController get expenseItemUnitPriceController =>
      _getFormTextEditingController(ExpenseItemUnitPriceValueKey);
  TextEditingController get creditAccountIdController =>
      _getFormTextEditingController(CreditAccountIdValueKey);

  FocusNode get descriptionFocusNode => _getFormFocusNode(DescriptionValueKey);
  FocusNode get referenceFocusNode => _getFormFocusNode(ReferenceValueKey);
  FocusNode get expenseCategoryIdFocusNode =>
      _getFormFocusNode(ExpenseCategoryIdValueKey);
  FocusNode get expenseDateFocusNode => _getFormFocusNode(ExpenseDateValueKey);
  FocusNode get merchantIdFocusNode => _getFormFocusNode(MerchantIdValueKey);
  FocusNode get expenseItemDescriptionFocusNode =>
      _getFormFocusNode(ExpenseItemDescriptionValueKey);
  FocusNode get expenseItemQuantityFocusNode =>
      _getFormFocusNode(ExpenseItemQuantityValueKey);
  FocusNode get expenseItemUnitPriceFocusNode =>
      _getFormFocusNode(ExpenseItemUnitPriceValueKey);
  FocusNode get creditAccountIdFocusNode =>
      _getFormFocusNode(CreditAccountIdValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_AddExpenseViewTextEditingControllers.containsKey(key)) {
      return _AddExpenseViewTextEditingControllers[key]!;
    }

    _AddExpenseViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _AddExpenseViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_AddExpenseViewFocusNodes.containsKey(key)) {
      return _AddExpenseViewFocusNodes[key]!;
    }
    _AddExpenseViewFocusNodes[key] = FocusNode();
    return _AddExpenseViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    descriptionController.addListener(() => _updateFormData(model));
    referenceController.addListener(() => _updateFormData(model));
    expenseCategoryIdController.addListener(() => _updateFormData(model));
    expenseDateController.addListener(() => _updateFormData(model));
    merchantIdController.addListener(() => _updateFormData(model));
    expenseItemDescriptionController.addListener(() => _updateFormData(model));
    expenseItemQuantityController.addListener(() => _updateFormData(model));
    expenseItemUnitPriceController.addListener(() => _updateFormData(model));
    creditAccountIdController.addListener(() => _updateFormData(model));

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
    expenseCategoryIdController.addListener(() => _updateFormData(model));
    expenseDateController.addListener(() => _updateFormData(model));
    merchantIdController.addListener(() => _updateFormData(model));
    expenseItemDescriptionController.addListener(() => _updateFormData(model));
    expenseItemQuantityController.addListener(() => _updateFormData(model));
    expenseItemUnitPriceController.addListener(() => _updateFormData(model));
    creditAccountIdController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          DescriptionValueKey: descriptionController.text,
          ReferenceValueKey: referenceController.text,
          ExpenseCategoryIdValueKey: expenseCategoryIdController.text,
          ExpenseDateValueKey: expenseDateController.text,
          MerchantIdValueKey: merchantIdController.text,
          ExpenseItemDescriptionValueKey: expenseItemDescriptionController.text,
          ExpenseItemQuantityValueKey: expenseItemQuantityController.text,
          ExpenseItemUnitPriceValueKey: expenseItemUnitPriceController.text,
          CreditAccountIdValueKey: creditAccountIdController.text,
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

    for (var controller in _AddExpenseViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _AddExpenseViewFocusNodes.values) {
      focusNode.dispose();
    }

    _AddExpenseViewTextEditingControllers.clear();
    _AddExpenseViewFocusNodes.clear();
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
  String? get expenseCategoryIdValue =>
      this.formValueMap[ExpenseCategoryIdValueKey] as String?;
  String? get expenseDateValue =>
      this.formValueMap[ExpenseDateValueKey] as String?;
  String? get merchantIdValue =>
      this.formValueMap[MerchantIdValueKey] as String?;
  String? get expenseItemDescriptionValue =>
      this.formValueMap[ExpenseItemDescriptionValueKey] as String?;
  String? get expenseItemQuantityValue =>
      this.formValueMap[ExpenseItemQuantityValueKey] as String?;
  String? get expenseItemUnitPriceValue =>
      this.formValueMap[ExpenseItemUnitPriceValueKey] as String?;
  String? get creditAccountIdValue =>
      this.formValueMap[CreditAccountIdValueKey] as String?;

  set descriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({DescriptionValueKey: value}),
    );

    if (_AddExpenseViewTextEditingControllers.containsKey(
        DescriptionValueKey)) {
      _AddExpenseViewTextEditingControllers[DescriptionValueKey]?.text =
          value ?? '';
    }
  }

  set referenceValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ReferenceValueKey: value}),
    );

    if (_AddExpenseViewTextEditingControllers.containsKey(ReferenceValueKey)) {
      _AddExpenseViewTextEditingControllers[ReferenceValueKey]?.text =
          value ?? '';
    }
  }

  set expenseCategoryIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ExpenseCategoryIdValueKey: value}),
    );

    if (_AddExpenseViewTextEditingControllers.containsKey(
        ExpenseCategoryIdValueKey)) {
      _AddExpenseViewTextEditingControllers[ExpenseCategoryIdValueKey]?.text =
          value ?? '';
    }
  }

  set expenseDateValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ExpenseDateValueKey: value}),
    );

    if (_AddExpenseViewTextEditingControllers.containsKey(
        ExpenseDateValueKey)) {
      _AddExpenseViewTextEditingControllers[ExpenseDateValueKey]?.text =
          value ?? '';
    }
  }

  set merchantIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({MerchantIdValueKey: value}),
    );

    if (_AddExpenseViewTextEditingControllers.containsKey(MerchantIdValueKey)) {
      _AddExpenseViewTextEditingControllers[MerchantIdValueKey]?.text =
          value ?? '';
    }
  }

  set expenseItemDescriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ExpenseItemDescriptionValueKey: value}),
    );

    if (_AddExpenseViewTextEditingControllers.containsKey(
        ExpenseItemDescriptionValueKey)) {
      _AddExpenseViewTextEditingControllers[ExpenseItemDescriptionValueKey]
          ?.text = value ?? '';
    }
  }

  set expenseItemQuantityValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ExpenseItemQuantityValueKey: value}),
    );

    if (_AddExpenseViewTextEditingControllers.containsKey(
        ExpenseItemQuantityValueKey)) {
      _AddExpenseViewTextEditingControllers[ExpenseItemQuantityValueKey]?.text =
          value ?? '';
    }
  }

  set expenseItemUnitPriceValue(String? value) {
    this.setData(
      this.formValueMap..addAll({ExpenseItemUnitPriceValueKey: value}),
    );

    if (_AddExpenseViewTextEditingControllers.containsKey(
        ExpenseItemUnitPriceValueKey)) {
      _AddExpenseViewTextEditingControllers[ExpenseItemUnitPriceValueKey]
          ?.text = value ?? '';
    }
  }

  set creditAccountIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({CreditAccountIdValueKey: value}),
    );

    if (_AddExpenseViewTextEditingControllers.containsKey(
        CreditAccountIdValueKey)) {
      _AddExpenseViewTextEditingControllers[CreditAccountIdValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasDescription =>
      this.formValueMap.containsKey(DescriptionValueKey) &&
      (descriptionValue?.isNotEmpty ?? false);
  bool get hasReference =>
      this.formValueMap.containsKey(ReferenceValueKey) &&
      (referenceValue?.isNotEmpty ?? false);
  bool get hasExpenseCategoryId =>
      this.formValueMap.containsKey(ExpenseCategoryIdValueKey) &&
      (expenseCategoryIdValue?.isNotEmpty ?? false);
  bool get hasExpenseDate =>
      this.formValueMap.containsKey(ExpenseDateValueKey) &&
      (expenseDateValue?.isNotEmpty ?? false);
  bool get hasMerchantId =>
      this.formValueMap.containsKey(MerchantIdValueKey) &&
      (merchantIdValue?.isNotEmpty ?? false);
  bool get hasExpenseItemDescription =>
      this.formValueMap.containsKey(ExpenseItemDescriptionValueKey) &&
      (expenseItemDescriptionValue?.isNotEmpty ?? false);
  bool get hasExpenseItemQuantity =>
      this.formValueMap.containsKey(ExpenseItemQuantityValueKey) &&
      (expenseItemQuantityValue?.isNotEmpty ?? false);
  bool get hasExpenseItemUnitPrice =>
      this.formValueMap.containsKey(ExpenseItemUnitPriceValueKey) &&
      (expenseItemUnitPriceValue?.isNotEmpty ?? false);
  bool get hasCreditAccountId =>
      this.formValueMap.containsKey(CreditAccountIdValueKey) &&
      (creditAccountIdValue?.isNotEmpty ?? false);

  bool get hasDescriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey]?.isNotEmpty ?? false;
  bool get hasReferenceValidationMessage =>
      this.fieldsValidationMessages[ReferenceValueKey]?.isNotEmpty ?? false;
  bool get hasExpenseCategoryIdValidationMessage =>
      this.fieldsValidationMessages[ExpenseCategoryIdValueKey]?.isNotEmpty ??
      false;
  bool get hasExpenseDateValidationMessage =>
      this.fieldsValidationMessages[ExpenseDateValueKey]?.isNotEmpty ?? false;
  bool get hasMerchantIdValidationMessage =>
      this.fieldsValidationMessages[MerchantIdValueKey]?.isNotEmpty ?? false;
  bool get hasExpenseItemDescriptionValidationMessage =>
      this
          .fieldsValidationMessages[ExpenseItemDescriptionValueKey]
          ?.isNotEmpty ??
      false;
  bool get hasExpenseItemQuantityValidationMessage =>
      this.fieldsValidationMessages[ExpenseItemQuantityValueKey]?.isNotEmpty ??
      false;
  bool get hasExpenseItemUnitPriceValidationMessage =>
      this.fieldsValidationMessages[ExpenseItemUnitPriceValueKey]?.isNotEmpty ??
      false;
  bool get hasCreditAccountIdValidationMessage =>
      this.fieldsValidationMessages[CreditAccountIdValueKey]?.isNotEmpty ??
      false;

  String? get descriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey];
  String? get referenceValidationMessage =>
      this.fieldsValidationMessages[ReferenceValueKey];
  String? get expenseCategoryIdValidationMessage =>
      this.fieldsValidationMessages[ExpenseCategoryIdValueKey];
  String? get expenseDateValidationMessage =>
      this.fieldsValidationMessages[ExpenseDateValueKey];
  String? get merchantIdValidationMessage =>
      this.fieldsValidationMessages[MerchantIdValueKey];
  String? get expenseItemDescriptionValidationMessage =>
      this.fieldsValidationMessages[ExpenseItemDescriptionValueKey];
  String? get expenseItemQuantityValidationMessage =>
      this.fieldsValidationMessages[ExpenseItemQuantityValueKey];
  String? get expenseItemUnitPriceValidationMessage =>
      this.fieldsValidationMessages[ExpenseItemUnitPriceValueKey];
  String? get creditAccountIdValidationMessage =>
      this.fieldsValidationMessages[CreditAccountIdValueKey];
}

extension Methods on FormStateHelper {
  setDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DescriptionValueKey] = validationMessage;
  setReferenceValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ReferenceValueKey] = validationMessage;
  setExpenseCategoryIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ExpenseCategoryIdValueKey] =
          validationMessage;
  setExpenseDateValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ExpenseDateValueKey] = validationMessage;
  setMerchantIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[MerchantIdValueKey] = validationMessage;
  setExpenseItemDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ExpenseItemDescriptionValueKey] =
          validationMessage;
  setExpenseItemQuantityValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ExpenseItemQuantityValueKey] =
          validationMessage;
  setExpenseItemUnitPriceValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[ExpenseItemUnitPriceValueKey] =
          validationMessage;
  setCreditAccountIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CreditAccountIdValueKey] =
          validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    descriptionValue = '';
    referenceValue = '';
    expenseCategoryIdValue = '';
    expenseDateValue = '';
    merchantIdValue = '';
    expenseItemDescriptionValue = '';
    expenseItemQuantityValue = '';
    expenseItemUnitPriceValue = '';
    creditAccountIdValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      DescriptionValueKey: getValidationMessage(DescriptionValueKey),
      ReferenceValueKey: getValidationMessage(ReferenceValueKey),
      ExpenseCategoryIdValueKey:
          getValidationMessage(ExpenseCategoryIdValueKey),
      ExpenseDateValueKey: getValidationMessage(ExpenseDateValueKey),
      MerchantIdValueKey: getValidationMessage(MerchantIdValueKey),
      ExpenseItemDescriptionValueKey:
          getValidationMessage(ExpenseItemDescriptionValueKey),
      ExpenseItemQuantityValueKey:
          getValidationMessage(ExpenseItemQuantityValueKey),
      ExpenseItemUnitPriceValueKey:
          getValidationMessage(ExpenseItemUnitPriceValueKey),
      CreditAccountIdValueKey: getValidationMessage(CreditAccountIdValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _AddExpenseViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _AddExpenseViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      DescriptionValueKey: getValidationMessage(DescriptionValueKey),
      ReferenceValueKey: getValidationMessage(ReferenceValueKey),
      ExpenseCategoryIdValueKey:
          getValidationMessage(ExpenseCategoryIdValueKey),
      ExpenseDateValueKey: getValidationMessage(ExpenseDateValueKey),
      MerchantIdValueKey: getValidationMessage(MerchantIdValueKey),
      ExpenseItemDescriptionValueKey:
          getValidationMessage(ExpenseItemDescriptionValueKey),
      ExpenseItemQuantityValueKey:
          getValidationMessage(ExpenseItemQuantityValueKey),
      ExpenseItemUnitPriceValueKey:
          getValidationMessage(ExpenseItemUnitPriceValueKey),
      CreditAccountIdValueKey: getValidationMessage(CreditAccountIdValueKey),
    });
