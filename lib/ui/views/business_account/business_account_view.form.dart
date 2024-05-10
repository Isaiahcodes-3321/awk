// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String BvnValueKey = 'bvn';
const String OtpValueKey = 'otp';
const String AddressValueKey = 'address';
const String CityValueKey = 'city';
const String StateValueKey = 'state';
const String PostalCodeValueKey = 'postalCode';
const String DateOfBirthValueKey = 'dateOfBirth';

final Map<String, TextEditingController>
    _BusinessAccountViewTextEditingControllers = {};

final Map<String, FocusNode> _BusinessAccountViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _BusinessAccountViewTextValidations = {
  BvnValueKey: null,
  OtpValueKey: null,
  AddressValueKey: null,
  CityValueKey: null,
  StateValueKey: null,
  PostalCodeValueKey: null,
  DateOfBirthValueKey: null,
};

mixin $BusinessAccountView {
  TextEditingController get bvnController =>
      _getFormTextEditingController(BvnValueKey);
  TextEditingController get otpController =>
      _getFormTextEditingController(OtpValueKey);
  TextEditingController get addressController =>
      _getFormTextEditingController(AddressValueKey);
  TextEditingController get cityController =>
      _getFormTextEditingController(CityValueKey);
  TextEditingController get stateController =>
      _getFormTextEditingController(StateValueKey);
  TextEditingController get postalCodeController =>
      _getFormTextEditingController(PostalCodeValueKey);
  TextEditingController get dateOfBirthController =>
      _getFormTextEditingController(DateOfBirthValueKey);

  FocusNode get bvnFocusNode => _getFormFocusNode(BvnValueKey);
  FocusNode get otpFocusNode => _getFormFocusNode(OtpValueKey);
  FocusNode get addressFocusNode => _getFormFocusNode(AddressValueKey);
  FocusNode get cityFocusNode => _getFormFocusNode(CityValueKey);
  FocusNode get stateFocusNode => _getFormFocusNode(StateValueKey);
  FocusNode get postalCodeFocusNode => _getFormFocusNode(PostalCodeValueKey);
  FocusNode get dateOfBirthFocusNode => _getFormFocusNode(DateOfBirthValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_BusinessAccountViewTextEditingControllers.containsKey(key)) {
      return _BusinessAccountViewTextEditingControllers[key]!;
    }

    _BusinessAccountViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _BusinessAccountViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_BusinessAccountViewFocusNodes.containsKey(key)) {
      return _BusinessAccountViewFocusNodes[key]!;
    }
    _BusinessAccountViewFocusNodes[key] = FocusNode();
    return _BusinessAccountViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    bvnController.addListener(() => _updateFormData(model));
    otpController.addListener(() => _updateFormData(model));
    addressController.addListener(() => _updateFormData(model));
    cityController.addListener(() => _updateFormData(model));
    stateController.addListener(() => _updateFormData(model));
    postalCodeController.addListener(() => _updateFormData(model));
    dateOfBirthController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    bvnController.addListener(() => _updateFormData(model));
    otpController.addListener(() => _updateFormData(model));
    addressController.addListener(() => _updateFormData(model));
    cityController.addListener(() => _updateFormData(model));
    stateController.addListener(() => _updateFormData(model));
    postalCodeController.addListener(() => _updateFormData(model));
    dateOfBirthController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          BvnValueKey: bvnController.text,
          OtpValueKey: otpController.text,
          AddressValueKey: addressController.text,
          CityValueKey: cityController.text,
          StateValueKey: stateController.text,
          PostalCodeValueKey: postalCodeController.text,
          DateOfBirthValueKey: dateOfBirthController.text,
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

    for (var controller in _BusinessAccountViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _BusinessAccountViewFocusNodes.values) {
      focusNode.dispose();
    }

    _BusinessAccountViewTextEditingControllers.clear();
    _BusinessAccountViewFocusNodes.clear();
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

  String? get bvnValue => this.formValueMap[BvnValueKey] as String?;
  String? get otpValue => this.formValueMap[OtpValueKey] as String?;
  String? get addressValue => this.formValueMap[AddressValueKey] as String?;
  String? get cityValue => this.formValueMap[CityValueKey] as String?;
  String? get stateValue => this.formValueMap[StateValueKey] as String?;
  String? get postalCodeValue =>
      this.formValueMap[PostalCodeValueKey] as String?;
  String? get dateOfBirthValue =>
      this.formValueMap[DateOfBirthValueKey] as String?;

  set bvnValue(String? value) {
    this.setData(
      this.formValueMap..addAll({BvnValueKey: value}),
    );

    if (_BusinessAccountViewTextEditingControllers.containsKey(BvnValueKey)) {
      _BusinessAccountViewTextEditingControllers[BvnValueKey]?.text =
          value ?? '';
    }
  }

  set otpValue(String? value) {
    this.setData(
      this.formValueMap..addAll({OtpValueKey: value}),
    );

    if (_BusinessAccountViewTextEditingControllers.containsKey(OtpValueKey)) {
      _BusinessAccountViewTextEditingControllers[OtpValueKey]?.text =
          value ?? '';
    }
  }

  set addressValue(String? value) {
    this.setData(
      this.formValueMap..addAll({AddressValueKey: value}),
    );

    if (_BusinessAccountViewTextEditingControllers.containsKey(
        AddressValueKey)) {
      _BusinessAccountViewTextEditingControllers[AddressValueKey]?.text =
          value ?? '';
    }
  }

  set cityValue(String? value) {
    this.setData(
      this.formValueMap..addAll({CityValueKey: value}),
    );

    if (_BusinessAccountViewTextEditingControllers.containsKey(CityValueKey)) {
      _BusinessAccountViewTextEditingControllers[CityValueKey]?.text =
          value ?? '';
    }
  }

  set stateValue(String? value) {
    this.setData(
      this.formValueMap..addAll({StateValueKey: value}),
    );

    if (_BusinessAccountViewTextEditingControllers.containsKey(StateValueKey)) {
      _BusinessAccountViewTextEditingControllers[StateValueKey]?.text =
          value ?? '';
    }
  }

  set postalCodeValue(String? value) {
    this.setData(
      this.formValueMap..addAll({PostalCodeValueKey: value}),
    );

    if (_BusinessAccountViewTextEditingControllers.containsKey(
        PostalCodeValueKey)) {
      _BusinessAccountViewTextEditingControllers[PostalCodeValueKey]?.text =
          value ?? '';
    }
  }

  set dateOfBirthValue(String? value) {
    this.setData(
      this.formValueMap..addAll({DateOfBirthValueKey: value}),
    );

    if (_BusinessAccountViewTextEditingControllers.containsKey(
        DateOfBirthValueKey)) {
      _BusinessAccountViewTextEditingControllers[DateOfBirthValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasBvn =>
      this.formValueMap.containsKey(BvnValueKey) &&
      (bvnValue?.isNotEmpty ?? false);
  bool get hasOtp =>
      this.formValueMap.containsKey(OtpValueKey) &&
      (otpValue?.isNotEmpty ?? false);
  bool get hasAddress =>
      this.formValueMap.containsKey(AddressValueKey) &&
      (addressValue?.isNotEmpty ?? false);
  bool get hasCity =>
      this.formValueMap.containsKey(CityValueKey) &&
      (cityValue?.isNotEmpty ?? false);
  bool get hasState =>
      this.formValueMap.containsKey(StateValueKey) &&
      (stateValue?.isNotEmpty ?? false);
  bool get hasPostalCode =>
      this.formValueMap.containsKey(PostalCodeValueKey) &&
      (postalCodeValue?.isNotEmpty ?? false);
  bool get hasDateOfBirth =>
      this.formValueMap.containsKey(DateOfBirthValueKey) &&
      (dateOfBirthValue?.isNotEmpty ?? false);

  bool get hasBvnValidationMessage =>
      this.fieldsValidationMessages[BvnValueKey]?.isNotEmpty ?? false;
  bool get hasOtpValidationMessage =>
      this.fieldsValidationMessages[OtpValueKey]?.isNotEmpty ?? false;
  bool get hasAddressValidationMessage =>
      this.fieldsValidationMessages[AddressValueKey]?.isNotEmpty ?? false;
  bool get hasCityValidationMessage =>
      this.fieldsValidationMessages[CityValueKey]?.isNotEmpty ?? false;
  bool get hasStateValidationMessage =>
      this.fieldsValidationMessages[StateValueKey]?.isNotEmpty ?? false;
  bool get hasPostalCodeValidationMessage =>
      this.fieldsValidationMessages[PostalCodeValueKey]?.isNotEmpty ?? false;
  bool get hasDateOfBirthValidationMessage =>
      this.fieldsValidationMessages[DateOfBirthValueKey]?.isNotEmpty ?? false;

  String? get bvnValidationMessage =>
      this.fieldsValidationMessages[BvnValueKey];
  String? get otpValidationMessage =>
      this.fieldsValidationMessages[OtpValueKey];
  String? get addressValidationMessage =>
      this.fieldsValidationMessages[AddressValueKey];
  String? get cityValidationMessage =>
      this.fieldsValidationMessages[CityValueKey];
  String? get stateValidationMessage =>
      this.fieldsValidationMessages[StateValueKey];
  String? get postalCodeValidationMessage =>
      this.fieldsValidationMessages[PostalCodeValueKey];
  String? get dateOfBirthValidationMessage =>
      this.fieldsValidationMessages[DateOfBirthValueKey];
}

extension Methods on FormStateHelper {
  setBvnValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[BvnValueKey] = validationMessage;
  setOtpValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[OtpValueKey] = validationMessage;
  setAddressValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[AddressValueKey] = validationMessage;
  setCityValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CityValueKey] = validationMessage;
  setStateValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[StateValueKey] = validationMessage;
  setPostalCodeValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PostalCodeValueKey] = validationMessage;
  setDateOfBirthValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DateOfBirthValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    bvnValue = '';
    otpValue = '';
    addressValue = '';
    cityValue = '';
    stateValue = '';
    postalCodeValue = '';
    dateOfBirthValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      BvnValueKey: getValidationMessage(BvnValueKey),
      OtpValueKey: getValidationMessage(OtpValueKey),
      AddressValueKey: getValidationMessage(AddressValueKey),
      CityValueKey: getValidationMessage(CityValueKey),
      StateValueKey: getValidationMessage(StateValueKey),
      PostalCodeValueKey: getValidationMessage(PostalCodeValueKey),
      DateOfBirthValueKey: getValidationMessage(DateOfBirthValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _BusinessAccountViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _BusinessAccountViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      BvnValueKey: getValidationMessage(BvnValueKey),
      OtpValueKey: getValidationMessage(OtpValueKey),
      AddressValueKey: getValidationMessage(AddressValueKey),
      CityValueKey: getValidationMessage(CityValueKey),
      StateValueKey: getValidationMessage(StateValueKey),
      PostalCodeValueKey: getValidationMessage(PostalCodeValueKey),
      DateOfBirthValueKey: getValidationMessage(DateOfBirthValueKey),
    });
