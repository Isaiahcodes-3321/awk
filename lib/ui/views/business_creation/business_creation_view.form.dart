// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String BusinessNameValueKey = 'businessName';
const String BusinessEmailValueKey = 'businessEmail';
const String BusinessMobileValueKey = 'businessMobile';
const String BusinessCategoryIdValueKey = 'businessCategoryId';
const String CountryIdValueKey = 'countryId';

final Map<String, TextEditingController>
    _BusinessCreationViewTextEditingControllers = {};

final Map<String, FocusNode> _BusinessCreationViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _BusinessCreationViewTextValidations = {
  BusinessNameValueKey: null,
  BusinessEmailValueKey: null,
  BusinessMobileValueKey: null,
  BusinessCategoryIdValueKey: null,
  CountryIdValueKey: null,
};

mixin $BusinessCreationView {
  TextEditingController get businessNameController =>
      _getFormTextEditingController(BusinessNameValueKey);
  TextEditingController get businessEmailController =>
      _getFormTextEditingController(BusinessEmailValueKey);
  TextEditingController get businessMobileController =>
      _getFormTextEditingController(BusinessMobileValueKey);
  TextEditingController get businessCategoryIdController =>
      _getFormTextEditingController(BusinessCategoryIdValueKey);
  TextEditingController get countryIdController =>
      _getFormTextEditingController(CountryIdValueKey);

  FocusNode get businessNameFocusNode =>
      _getFormFocusNode(BusinessNameValueKey);
  FocusNode get businessEmailFocusNode =>
      _getFormFocusNode(BusinessEmailValueKey);
  FocusNode get businessMobileFocusNode =>
      _getFormFocusNode(BusinessMobileValueKey);
  FocusNode get businessCategoryIdFocusNode =>
      _getFormFocusNode(BusinessCategoryIdValueKey);
  FocusNode get countryIdFocusNode => _getFormFocusNode(CountryIdValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_BusinessCreationViewTextEditingControllers.containsKey(key)) {
      return _BusinessCreationViewTextEditingControllers[key]!;
    }

    _BusinessCreationViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _BusinessCreationViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_BusinessCreationViewFocusNodes.containsKey(key)) {
      return _BusinessCreationViewFocusNodes[key]!;
    }
    _BusinessCreationViewFocusNodes[key] = FocusNode();
    return _BusinessCreationViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    businessNameController.addListener(() => _updateFormData(model));
    businessEmailController.addListener(() => _updateFormData(model));
    businessMobileController.addListener(() => _updateFormData(model));
    businessCategoryIdController.addListener(() => _updateFormData(model));
    countryIdController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    businessNameController.addListener(() => _updateFormData(model));
    businessEmailController.addListener(() => _updateFormData(model));
    businessMobileController.addListener(() => _updateFormData(model));
    businessCategoryIdController.addListener(() => _updateFormData(model));
    countryIdController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          BusinessNameValueKey: businessNameController.text,
          BusinessEmailValueKey: businessEmailController.text,
          BusinessMobileValueKey: businessMobileController.text,
          BusinessCategoryIdValueKey: businessCategoryIdController.text,
          CountryIdValueKey: countryIdController.text,
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

    for (var controller in _BusinessCreationViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _BusinessCreationViewFocusNodes.values) {
      focusNode.dispose();
    }

    _BusinessCreationViewTextEditingControllers.clear();
    _BusinessCreationViewFocusNodes.clear();
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

  String? get businessNameValue =>
      this.formValueMap[BusinessNameValueKey] as String?;
  String? get businessEmailValue =>
      this.formValueMap[BusinessEmailValueKey] as String?;
  String? get businessMobileValue =>
      this.formValueMap[BusinessMobileValueKey] as String?;
  String? get businessCategoryIdValue =>
      this.formValueMap[BusinessCategoryIdValueKey] as String?;
  String? get countryIdValue => this.formValueMap[CountryIdValueKey] as String?;

  set businessNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({BusinessNameValueKey: value}),
    );

    if (_BusinessCreationViewTextEditingControllers.containsKey(
        BusinessNameValueKey)) {
      _BusinessCreationViewTextEditingControllers[BusinessNameValueKey]?.text =
          value ?? '';
    }
  }

  set businessEmailValue(String? value) {
    this.setData(
      this.formValueMap..addAll({BusinessEmailValueKey: value}),
    );

    if (_BusinessCreationViewTextEditingControllers.containsKey(
        BusinessEmailValueKey)) {
      _BusinessCreationViewTextEditingControllers[BusinessEmailValueKey]?.text =
          value ?? '';
    }
  }

  set businessMobileValue(String? value) {
    this.setData(
      this.formValueMap..addAll({BusinessMobileValueKey: value}),
    );

    if (_BusinessCreationViewTextEditingControllers.containsKey(
        BusinessMobileValueKey)) {
      _BusinessCreationViewTextEditingControllers[BusinessMobileValueKey]
          ?.text = value ?? '';
    }
  }

  set businessCategoryIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({BusinessCategoryIdValueKey: value}),
    );

    if (_BusinessCreationViewTextEditingControllers.containsKey(
        BusinessCategoryIdValueKey)) {
      _BusinessCreationViewTextEditingControllers[BusinessCategoryIdValueKey]
          ?.text = value ?? '';
    }
  }

  set countryIdValue(String? value) {
    this.setData(
      this.formValueMap..addAll({CountryIdValueKey: value}),
    );

    if (_BusinessCreationViewTextEditingControllers.containsKey(
        CountryIdValueKey)) {
      _BusinessCreationViewTextEditingControllers[CountryIdValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasBusinessName =>
      this.formValueMap.containsKey(BusinessNameValueKey) &&
      (businessNameValue?.isNotEmpty ?? false);
  bool get hasBusinessEmail =>
      this.formValueMap.containsKey(BusinessEmailValueKey) &&
      (businessEmailValue?.isNotEmpty ?? false);
  bool get hasBusinessMobile =>
      this.formValueMap.containsKey(BusinessMobileValueKey) &&
      (businessMobileValue?.isNotEmpty ?? false);
  bool get hasBusinessCategoryId =>
      this.formValueMap.containsKey(BusinessCategoryIdValueKey) &&
      (businessCategoryIdValue?.isNotEmpty ?? false);
  bool get hasCountryId =>
      this.formValueMap.containsKey(CountryIdValueKey) &&
      (countryIdValue?.isNotEmpty ?? false);

  bool get hasBusinessNameValidationMessage =>
      this.fieldsValidationMessages[BusinessNameValueKey]?.isNotEmpty ?? false;
  bool get hasBusinessEmailValidationMessage =>
      this.fieldsValidationMessages[BusinessEmailValueKey]?.isNotEmpty ?? false;
  bool get hasBusinessMobileValidationMessage =>
      this.fieldsValidationMessages[BusinessMobileValueKey]?.isNotEmpty ??
      false;
  bool get hasBusinessCategoryIdValidationMessage =>
      this.fieldsValidationMessages[BusinessCategoryIdValueKey]?.isNotEmpty ??
      false;
  bool get hasCountryIdValidationMessage =>
      this.fieldsValidationMessages[CountryIdValueKey]?.isNotEmpty ?? false;

  String? get businessNameValidationMessage =>
      this.fieldsValidationMessages[BusinessNameValueKey];
  String? get businessEmailValidationMessage =>
      this.fieldsValidationMessages[BusinessEmailValueKey];
  String? get businessMobileValidationMessage =>
      this.fieldsValidationMessages[BusinessMobileValueKey];
  String? get businessCategoryIdValidationMessage =>
      this.fieldsValidationMessages[BusinessCategoryIdValueKey];
  String? get countryIdValidationMessage =>
      this.fieldsValidationMessages[CountryIdValueKey];
}

extension Methods on FormStateHelper {
  setBusinessNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[BusinessNameValueKey] = validationMessage;
  setBusinessEmailValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[BusinessEmailValueKey] = validationMessage;
  setBusinessMobileValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[BusinessMobileValueKey] = validationMessage;
  setBusinessCategoryIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[BusinessCategoryIdValueKey] =
          validationMessage;
  setCountryIdValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[CountryIdValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    businessNameValue = '';
    businessEmailValue = '';
    businessMobileValue = '';
    businessCategoryIdValue = '';
    countryIdValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      BusinessNameValueKey: getValidationMessage(BusinessNameValueKey),
      BusinessEmailValueKey: getValidationMessage(BusinessEmailValueKey),
      BusinessMobileValueKey: getValidationMessage(BusinessMobileValueKey),
      BusinessCategoryIdValueKey:
          getValidationMessage(BusinessCategoryIdValueKey),
      CountryIdValueKey: getValidationMessage(CountryIdValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _BusinessCreationViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _BusinessCreationViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      BusinessNameValueKey: getValidationMessage(BusinessNameValueKey),
      BusinessEmailValueKey: getValidationMessage(BusinessEmailValueKey),
      BusinessMobileValueKey: getValidationMessage(BusinessMobileValueKey),
      BusinessCategoryIdValueKey:
          getValidationMessage(BusinessCategoryIdValueKey),
      CountryIdValueKey: getValidationMessage(CountryIdValueKey),
    });
