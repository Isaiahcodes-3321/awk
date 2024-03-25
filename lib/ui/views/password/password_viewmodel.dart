import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/ui/views/password/password_view.form.dart';

class PasswordViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final dashboardService = locator<DashboardService>();
  final DialogService dialogService = locator<DialogService>();
  bool isPasswordVisible1 = false;
  bool isPasswordVisible2 = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<bool> runPasswordReset() async {
    final bool isReset = await dashboardService.resetPassword(
        oldPassword: oldPasswordValue ?? '',
        newPassword: newPasswordValue ?? '');
    return isReset;
  }

  Future resetPasswordData() async {
    final result = await runBusyFuture(runPasswordReset());

    if (result != null) {
      // navigate to success route
      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Sucessful!',
          description: 'Password successfully updated',
          barrierDismissible: true,
          mainButtonTitle: 'Ok');

      await navigationService.replaceWith(Routes.settingsView);
    }

    // else if (result.error != null) {
    //   setValidationMessage(result.error?.message);
    // } else {
    //   // handle other errors
    // }
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
