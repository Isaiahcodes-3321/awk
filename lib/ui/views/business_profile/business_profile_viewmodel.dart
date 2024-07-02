import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/business_creation_service.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';

class BusinessProfileViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final dashboardService = locator<DashboardService>();
  final businessCreationService = locator<BusinessCreationService>();
  final DialogService dialogService = locator<DialogService>();
  final authService = locator<AuthenticationService>();
  List<DropdownMenuItem<String>> businessCategorydropdownItems = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<List<BusinessCategory>> getBusinessCategories() async {
    final businessCategories =
        await businessCreationService.getBusinessCategories();
    businessCategorydropdownItems = businessCategories.map((businessCategory) {
      return DropdownMenuItem<String>(
        value: businessCategory.id.toString(),
        child: Text(businessCategory.categoryName),
      );
    }).toList();
    return businessCategories;
  }

  late List<Business> businesses;
  // late Business businesses1;

  Future<void> getUserAndBusinessData() async {
    final resultToken = await authService.refreshToken();
    if (resultToken.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final result = await dashboardService.getUserAndBusinessData();
    businesses = result.businesses;

    rebuildUi();
  }

  void setSelectedBusiness() {
    updateBusinessNameController.text = businesses.first.businessName;
    updateBusinessCategoryIdController.text =
        businesses.first.businessCategoryId;
    updateBusinessMobileController.text = businesses.first.businessMobile;
    updateBusinessEmailController.text = businesses.first.businessEmail;
    rebuildUi();
  }

  TextEditingController updateBusinessNameController = TextEditingController();
  TextEditingController updateBusinessCategoryIdController =
      TextEditingController();
  TextEditingController updateBusinessEmailController = TextEditingController();
  TextEditingController updateBusinessMobileController =
      TextEditingController();

  Future<BusinessUpdateResult> runBusinessUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final businessId = prefs.getString('businessId');
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    return businessCreationService.updateBusiness(
        businessId: businessId!,
        businessName: updateBusinessNameController.text,
        businessEmail: updateBusinessEmailController.text,
        businessMobile: updateBusinessMobileController.text,
        businessCategoryId: updateBusinessCategoryIdController.text);
  }

  Future updateBusinessData(BuildContext context) async {
    final result = await runBusyFuture(runBusinessUpdate());

    if (result.business != null) {
      // navigate to success route

      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Sucessful!',
          description: 'Business information successfully updated',
          barrierDismissible: true,
          mainButtonTitle: 'Ok');
      await getUserAndBusinessData();
      await navigationService.replaceWith(Routes.settingsView);
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
          // margin:
          //     EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.9),
        ),
      );
    } else {
      // handle other errors
    }
  }

  void navigateBack() => navigationService.back();
}
