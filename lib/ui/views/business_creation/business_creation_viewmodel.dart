import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/business_creation_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/business_creation/business_creation_view.form.dart';

class BusinessCreationViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();
  final _businessCreationService = locator<BusinessCreationService>();
  final authService = locator<AuthenticationService>();
  List<DropdownMenuItem<String>> businessCategorydropdownItems = [];
  List<DropdownMenuItem<String>> countrydropdownItems = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<List<BusinessCategory>> getBusinessCategories() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final businessCategories =
        await _businessCreationService.getBusinessCategories();
    businessCategorydropdownItems = businessCategories.map((businessCategory) {
      return DropdownMenuItem<String>(
        value: businessCategory.id.toString(),
        child: Text(businessCategory.categoryName),
      );
    }).toList();
    return businessCategories;
  }

  Future<List<Country>> getCountries() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final countries = await _businessCreationService.getCountries();
    countrydropdownItems = countries.map((country) {
      return DropdownMenuItem<String>(
        value: country.id.toString(),
        child: Text(country.countryName),
      );
    }).toList();
    return countries;
  }

  Future<BusinessCreationResult> runBusinessCreation() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    return _businessCreationService.createBusinessProfile(
        businessName: businessNameValue ?? '',
        businessEmail: businessEmailValue ?? '',
        businessMobile: businessMobileValue ?? '',
        businessCategoryId: businessCategoryIdValue ?? '',
        countryId: countryIdValue ?? '');
  }

  Future saveBusinessData(BuildContext context) async {
    final result = await runBusyFuture(runBusinessCreation());

    if (result.business != null) {
      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Business Profile',
          description: 'Business profile has been sucessfully created',
          barrierDismissible: true,
          mainButtonTitle: 'Ok');
      // navigate to success route
      navigationService.replaceWith(Routes.loginView);
    } else if (result.error != null) {
      setValidationMessage(result.error?.message);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            validationMessage ?? 'An error occurred, Try again.',
            textAlign: TextAlign.start,
            style: ktsSubtitleTileText2,
          ),
          elevation: 2,
          duration: const Duration(seconds: 3), // Adjust as needed
          backgroundColor: kcErrorColor,
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.fixed,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4))),
          padding: const EdgeInsets.all(12),
          // margin: EdgeInsets.only(
          //     bottom: MediaQuery.of(context).size.height * 0.85),
        ),
      );
    } else {
      // handle other errors
    }
  }

  void navigateBack() => navigationService.back();
}
