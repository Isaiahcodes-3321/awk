import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/login/login_view.form.dart';

class LoginViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _dashboardService = locator<DashboardService>();
  final _authenticationService = locator<AuthenticationService>();
  bool isPasswordVisible = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> getUserAndBusinessData() async {
    final result = await _dashboardService.getUserAndBusinessData();
    // if (result.user != null) {
    //   user = result.user;
    // }
    // if (result.businesses != null) {
    //   businesses = result.businesses;
    // }
    if (result.businesses.isEmpty || result.businesses == null) {
      navigationService.replaceWith(Routes.businessCreationView);
    }
    rebuildUi();
  }

  Future<AuthenticationResult> runAuthentication() => _authenticationService
      .loginWithEmail(email: emailValue ?? '', password: passwordValue ?? '');

  Future saveData(BuildContext context) async {
    final result = await runBusyFuture(runAuthentication());

    if (result.tokens != null) {
      if (result.tokens!.verified != true) {
        await navigationService.replaceWith(Routes.verificationView);
      }
      await getUserAndBusinessData();
      // navigate to success route
      navigationService.replaceWith(Routes.homeView);
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

  void navigateToCreateAccount() =>
      navigationService.navigateTo(Routes.createAccountView);

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    rebuildUi();
  }
}
