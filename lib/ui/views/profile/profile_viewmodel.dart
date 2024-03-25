import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';

class ProfileViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final dashboardService = locator<DashboardService>();
  final DialogService dialogService = locator<DialogService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late User user;

  Future<void> getUserAndBusinessData() async {
    final result = await dashboardService.getUserAndBusinessData();
    user = result.user;

    rebuildUi();
  }

  void setSelectedUser() {
    updateUserEmailController.text = user.email;
    updateUserNameController.text = user.fullname;
    rebuildUi();
  }

  TextEditingController updateUserNameController = TextEditingController();
  TextEditingController updateUserEmailController = TextEditingController();

  Future<UserUpdateResult> runUserUpdate() async {
    return dashboardService.updateUser(
      fullname: updateUserNameController.text,
      email: updateUserEmailController.text,
    );
  }

  Future updateUserData(BuildContext context) async {
    final result = await runBusyFuture(runUserUpdate());

    if (result.user != null) {
      // navigate to success route
      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Sucessful!',
          description: 'User information successfully updated',
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
