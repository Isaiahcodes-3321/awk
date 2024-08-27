import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/pin_change/pin_change_view.form.dart';

class PinChangeViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final dashboardService = locator<DashboardService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();
  bool isPasswordVisible1 = false;
  bool isPasswordVisible2 = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String cardId;

  PinChangeViewModel({required this.cardId});

  Future<PinChangeResult> runPinChange() async {
    final prefs = await SharedPreferences.getInstance();
    final businessId = prefs.getString('businessId');
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final result1 = await dashboardService.changeCardPin(
        businessId: businessId ?? '',
        cardId: cardId,
        oldPin: currentPinValue ?? '',
        newPin: newPinValue ?? '');
    return result1;
  }

  Future changePinData(BuildContext context) async {
    final result = await runBusyFuture(runPinChange());

    if (result.success != null) {
      // navigate to success route
      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Sucessful!',
          description: 'Card pin successfully changed',
          barrierDismissible: true,
          mainButtonTitle: 'Ok');

      await navigationService.back(result: true);
      rebuildUi();
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
      rebuildUi();
      // await dialogService.showCustomDialog(
      //     variant: DialogType.info,
      //     title: 'Unsucessful!',
      //     description: 'Ensure current pin is correct',
      //     barrierDismissible: true,
      //     mainButtonTitle: 'Ok');
    }
  }

  void togglePasswordVisibility1() {
    isPasswordVisible1 = !isPasswordVisible1;

    rebuildUi();
  }

  void togglePasswordVisibility2() {
    isPasswordVisible2 = !isPasswordVisible2;

    rebuildUi();
  }

  void navigateBack() => navigationService.back();
}
