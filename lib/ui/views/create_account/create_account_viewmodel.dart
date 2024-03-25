import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/create_account/create_account_view.form.dart';

class CreateAccountViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  bool isPasswordVisible = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // CreateAccountViewModel() : super(successRoute: Routes.verificationRoute);

  Future<CreateAccountWithEmailResult> runAuthentication() =>
      _authenticationService.createAccountWithEmail(
          email: emailValue ?? '',
          password: passwordValue ?? '',
          fullName: fullNameValue ?? '');

  Future saveData(BuildContext context) async {
    final result = await runBusyFuture(runAuthentication());

    if (result.tokens != null) {
      // navigate to success route
      navigationService.replaceWith(Routes.verificationView);
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

  void navigateToLogin() => navigationService.navigateTo(Routes.loginView);

  void navigateBack() => navigationService.back();

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    rebuildUi();
  }
}
