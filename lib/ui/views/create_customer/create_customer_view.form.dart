// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String CustomerNameValueKey = 'customerName';
const String MobileValueKey = 'mobile';
const String EmailValueKey = 'email';
const String AddressValueKey = 'address';

final Map<String, TextEditingController>
    _CreateCustomerViewTextEditingControllers = {};

final Map<String, FocusNode> _CreateCustomerViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _CreateCustomerViewTextValidations = {
  CustomerNameValueKey: null,
  MobileValueKey: null,
  EmailValueKey: null,
  AddressValueKey: null,
};

mixin $CreateCustomerView {
  TextEditingController get customerNameController =>
      _getFormTextEditingController(CustomerNameValueKey);
  TextEditingController get mobileController =>
      _getFormTextEditingController(MobileValueKey);
  TextEditingController get emailController =>
      _getFormTextEditingController(EmailValueKey);
  TextEditingController get addressController =>
      _getFormTextEditingController(AddressValueKey);

  FocusNode get customerNameFocusNode =>
      _getFormFocusNode(CustomerNameValueKey);
  FocusNode get mobileFocusNode => _getFormFocusNode(MobileValueKey);
  FocusNode get emailFocusNode => _getFormFocusNode(EmailValueKey);
  FocusNode get addressFocusNode => _getFormFocusNode(AddressValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_CreateCustomerViewTextEditingControllers.containsKey(key)) {
      return _CreateCustomerViewTextEditingControllers[key]!;
    }

    _CreateCustomerViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _CreateCustomerViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_CreateCustomerViewFocusNodes.containsKey(key)) {
      return _CreateCustomerViewFocusNodes[key]!;
    }
    _CreateCustomerViewFocusNodes[key] = FocusNode();
    return _CreateCustomerViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    customerNameController.addListener(() => _updateFormData(model));
    mobileController.addListener(() => _updateFormData(model));
    emailController.addListener(() => _updateFormData(model));
    addressController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    customerNameController.addListener(() => _updateFormData(model));
    mobileController.addListener(() => _updateFormData(model));
    emailController.addListener(() => _updateFormData(model));
    addressController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          CustomerNameValueKey: customerNameController.text,
          MobileValueKey: mobileController.text,
          EmailValueKey: emailController.text,
          AddressValueKey: addressController.text,
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

    for (var controller in _CreateCustomerViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _CreateCustomerViewFocusNodes.values) {
      focusNode.dispose();
    }

    _CreateCustomerViewTextEditingControllers.clear();
    _CreateCustomerViewFocusNodes.clear();
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

  String? get customerNameValue =>
      this.formValueMap[CustomerNameValueKey] as String?;
  String? get mobileValue => this.formValueMap[MobileValueKey] as String?;
  String? get emailValue => this.formValueMap[EmailValueKey] as String?;
  String? get addressValue => this.formValueMap[AddressValueKey] as String?;

  set customerNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({CustomerNameValueKey: value}),
    );

    if (_CreateCustomerViewTextEditingControllers.containsKey(
        CustomerNameValueKey)) {
      _CreateCustomerViewTextEditingControllers[CustomerNameValueKey]?.text =
          value ?? '';
    }
  }

  set mobileValue(String? value) {
    this.setData(
      this.formValueMap..addAll({MobileValueKey: value}),
    );

    if (_CreateCustomerViewTextEditingControllers.containsKey(MobileValueKey)) {
      _CreateCustomerViewTextEditingControllers[MobileValueKey]?.text =
          value ?? '';
    }
  }

  set emailValue(String? value) {
    this.setData(
      this.formValueMap..addAll({EmailValueKey: value}),
    );

    if (_CreateCustomerViewTextEditingControllers.containsKey(EmailValueKey)) {
      _CreateCustomerViewTextEditingControllers[EmailValueKey]?.text =
          value ?? '';
    }
  }

  set addressValue(String? value) {
    this.setData(
      this.formValueMap..addAll({AddressValueKey: value}),
    );

    if (_CreateCustomerViewTextEditingControllers.containsKey(
        AddressValueKey)) {
      _CreateCustomerViewTextEditingControllers[AddressValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasCustomerName =>
      this.formValueMap.containsKey(CustomerNameValueKey) &&
      (customerNameValue?.isNotEmpty ?? false);
  bool get hasMobile =>
      this.formValueMap.containsKey(MobileValueKey) &&
      (mobileValue?.isNotEmpty ?? false);
  bool get hasEmail =>
      this.formValueMap.containsKey(EmailValueKey) &&
      (emailValue?.isNotEmpty ?? false);
  bool get hasAddress =>
      this.formValueMap.containsKey(AddressValueKey) &&
      (addressValue?.isNotEmpty ?? false);

  bool get hasCustomerNameValidationMessage =>
      this.fieldsValidationMessages[CustomerNameValueKey]?.isNotEmpty ?? false;
  bool get hasMobileValidationMessage =>
      this.fieldsValidationMessages[MobileValueKey]?.isNotEmpty ?? false;
  bool get hasEmailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey]?.isNotEmpty ?? false;
  bool get hasAddressValidationMessage =>
      this.fieldsValidationMessages[AddressValueKey]?.isNotEmpty ?? false;

  String? get customerNameValidationMessage =>
      this.fieldsValidationMessages[CustomerNameValueKey];
  String? get mobileValidationMessage =>
      this.fieldsValidationMessages[MobileValueKey];
  String? get emailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey];
  String? get addressValidationMessage =>
      this.fieldsValidationMessages[AddressValueKey];
}

extension Methods on FormStateHelper {
  setCustomerNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CustomerNameValueKey] = validationMessage;
  setMobileValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[MobileValueKey] = validationMessage;
  setEmailValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[EmailValueKey] = validationMessage;
  setAddressValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[AddressValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    customerNameValue = '';
    mobileValue = '';
    emailValue = '';
    addressValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      CustomerNameValueKey: getValidationMessage(CustomerNameValueKey),
      MobileValueKey: getValidationMessage(MobileValueKey),
      EmailValueKey: getValidationMessage(EmailValueKey),
      AddressValueKey: getValidationMessage(AddressValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _CreateCustomerViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _CreateCustomerViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      CustomerNameValueKey: getValidationMessage(CustomerNameValueKey),
      MobileValueKey: getValidationMessage(MobileValueKey),
      EmailValueKey: getValidationMessage(EmailValueKey),
      AddressValueKey: getValidationMessage(AddressValueKey),
    });
