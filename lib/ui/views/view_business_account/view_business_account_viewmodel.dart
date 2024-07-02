import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/business_creation_service.dart';

class ViewBusinessAccountViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final authService = locator<AuthenticationService>();
  final businessService = locator<BusinessCreationService>();

  BusinessAccount? businessAccount;

  Future<BusinessAccount?>? checkbusinessAcccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result1 = await authService.refreshToken();
    if (result1.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final result =
        await businessService.viewBusinessAccount(businessId: businessIdValue);
    if (result == null) {
      await navigationService.navigateTo(Routes.businessBvnView);
    } else {
      businessAccount = result;
      setSelectedBusiness();
    }
    rebuildUi();
    return businessAccount;
  }

  void setSelectedBusiness() {
    accountNameController.text = businessAccount!.accountName;
    addressController.text =
        '${businessAccount!.accountbillingAddressLine1}, ${businessAccount!.accountbillingAddressCity}, ${businessAccount!.accountbillingAddressState}';
    accountNumberController.text = businessAccount!.accountNumber;
    accountTypeController.text = businessAccount!.accountType;
    bvnController.text = businessAccount!.bvn;
    accountBalanceController.text = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
    ).format(businessAccount!.accountBalance);
    rebuildUi();
  }

  TextEditingController accountNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController accountBalanceController = TextEditingController();
  TextEditingController bvnController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void navigateBack() => navigationService.back();
}
