import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/verification_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/verification/verification_view.form.dart';

class VerificationViewModel extends FormViewModel {
  final VerificationService _otpVerificationService =
      locator<VerificationService>();
  final FocusNode digit2FocusNode = FocusNode();
  final FocusNode digit3FocusNode = FocusNode();
  final FocusNode digit4FocusNode = FocusNode();
  final NavigationService navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();
  final authService = locator<AuthenticationService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int resendCounter = 0;
  Timer? resendCooldownTimer;

  String otpDigit1 = '';
  String otpDigit2 = '';
  String otpDigit3 = '';
  String otpDigit4 = '';

  void setOTPDigit1(String value) {
    otpDigit1 = value;
    if (value.length == 1) {
      digit2FocusNode.requestFocus();
    }
  }

  void setOTPDigit2(String value) {
    otpDigit2 = value;
    if (value.length == 1) {
      digit3FocusNode.requestFocus();
    }
  }

  void setOTPDigit3(String value) {
    otpDigit3 = value;
    if (value.length == 1) {
      digit4FocusNode.requestFocus();
    }
  }

  void setOTPDigit4(String value) {
    otpDigit4 = value;
  }

  @override
  void setFormStatus() {}

  Future<bool> resendVerification() async {
    if (resendCounter >= 1) {
      // Check if the resend counter has reached the limit
      if (resendCooldownTimer == null || !resendCooldownTimer!.isActive) {
        // Start the cooldown timer for 3 minutes
        resendCooldownTimer = Timer(const Duration(minutes: 3), () {
          resendCooldownTimer = null;
          resendCounter = 0;
          rebuildUi(); // Update the UI after cooldown
        });
        final result = await authService.refreshToken();
        if (result.error != null) {
          await navigationService.replaceWithLoginView();
        }
        final bool verificationResent =
            await _otpVerificationService.resendVerification();

        await dialogService.showCustomDialog(
            variant: DialogType.info,
            title: 'Resend Verification',
            description: 'We have resent a verification code to your email',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');

        return verificationResent;
      } else {
        // Resend button is on cooldown

        await dialogService.showCustomDialog(
            variant: DialogType.info,
            title: "Resend Verification Failed",
            description: 'Resend button disabled: try again in 3 minutes',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
        return false;
      }
    } else {
      // Increment the resend counter and resend the verification code
      resendCounter++;
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      }
      bool verificationResent =
          await _otpVerificationService.resendVerification();

      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Resend Verification',
          description: 'We have resent a verification code to your email',
          barrierDismissible: true,
          mainButtonTitle: 'Ok');

      return verificationResent;
    }
  }

  Future<VerificationResult> runVerification() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final otpValue =
        '${otp1Value ?? ''}${otp2Value ?? ''}${otp3Value ?? ''}${otp4Value ?? ''}';
    final otpCode = int.tryParse(otpValue) ?? 0.0;

    return _otpVerificationService.verifyOTP(code: otpCode);
  }

  Future getVerificationResponse(BuildContext context) async {
    final result = await runBusyFuture(runVerification());

    if (result.verificationResponse?.isSuccessful != null) {
      navigationService.replaceWith(Routes.businessCreationView);
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
