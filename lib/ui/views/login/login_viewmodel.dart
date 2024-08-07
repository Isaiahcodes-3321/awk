import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  void setEmailPassword() async {
    final prefs = await SharedPreferences.getInstance();
    emailController1.text = prefs.getString('email') ?? '';
    passwordController1.text = prefs.getString('password') ?? '';
  }

  TextEditingController emailController1 = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  // void getDateByLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final date = prefs.getString('date');
  // }

  Future<void> getUserAndRoleData() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceToken = prefs.getString('device_token');
    final result = await _dashboardService.getUserAndRoleData();

    if (result.roleName != 'Owner') {
      await getUserAndBusinessData();
      await _authenticationService.addUserDeviceToken(
          deviceToken: deviceToken!);
      await navigationService.replaceWith(Routes.employeeHomeView);
    } else {
      await getUserAndBusinessData();
      // navigate to success route
      await _authenticationService.addUserDeviceToken(
          deviceToken: deviceToken!);
      await navigationService.replaceWith(Routes.homeView);
    }
  }

  Future<void> getUserAndBusinessData() async {
    final result = await _dashboardService.getUserAndBusinessData();
    if (result.businesses == [] || result.businesses.isEmpty) {
      await navigationService.replaceWith(Routes.businessCreationView);
    }
    rebuildUi();
  }

  Future<AuthenticationResult> runAuthentication() =>
      _authenticationService.loginWithEmail(
          email: emailController1.text, password: passwordController1.text);

  Future saveData(BuildContext context) async {
    final result = await runBusyFuture(runAuthentication());

    if (result.tokens != null) {
      if (result.tokens!.verified != true) {
        await navigationService.replaceWith(Routes.verificationView);
      } else {
        await getUserAndRoleData();
      }

      // await getUserAndBusinessData();
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
