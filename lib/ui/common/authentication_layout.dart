import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

class AuthenticationLayout extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? mainButtonTitle;
  final String? archiveButtonTitle;
  final String? secondaryButtonTitle;
  final Widget? form;
  final bool showTermsText;
  final Function()? onMainButtonTapped;
  final Function()? onArchiveButtonTapped;
  final Function()? onDeleteButtonTapped;
  final Function()? onSecondaryButtonTapped;
  final Function()? onCreateAccountTapped;
  final Function()? onLoginTapped;
  final Function()? onResendVerificationCodeTapped;
  final Function()? onForgotPassword;
  // final Function()? onForgotPasswordResend;
  final Function()? onBackPressed;
  final String? validationMessage;
  final bool busy;

  const AuthenticationLayout({
    Key? key,
    required this.title,
    this.archiveButtonTitle,
    required this.subtitle,
    this.mainButtonTitle,
    this.onArchiveButtonTapped,
    this.onDeleteButtonTapped,
    this.secondaryButtonTitle,
    required this.form,
    this.showTermsText = false,
    this.onMainButtonTapped,
    this.onSecondaryButtonTapped,
    this.onCreateAccountTapped,
    this.onLoginTapped,
    this.onResendVerificationCodeTapped,
    this.onForgotPassword,
    // this.onForgotPasswordResend,
    this.onBackPressed,
    this.validationMessage,
    this.busy = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: ListView(children: [
        if (onBackPressed == null) verticalSpaceTiny,
        if (onBackPressed != null) verticalSpaceSmall,
        if (onBackPressed != null)
          GestureDetector(
            onTap: onBackPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: kcFormBorderColor.withOpacity(0.3),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          fill: 0.9,
                          color: kcTextSubTitleColor,
                          size: 16,
                        ),
                        onPressed: onBackPressed,
                      ),
                    ),
                    horizontalSpaceTiny,
                    Text(
                      'back',
                      style: ktsSubtitleTextAuthentication,
                    ),
                  ],
                ),
                if (onDeleteButtonTapped != null)
                  IconButton(
                    onPressed: onDeleteButtonTapped,
                    icon: SvgPicture.asset(
                      'assets/images/trash-01.svg',
                      width: 22,
                      height: 22,
                    ),
                  )
              ],
            ),
          ),
        verticalSpaceSmall,
        Text(
          title!,
          style: ktsTitleTextAuthentication,
        ),
        verticalSpaceTiny,
        Text(
          subtitle!,
          style: ktsSubtitleTextAuthentication,
        ),
        verticalSpaceIntermitent,
        form!,
        if (validationMessage == null) verticalSpaceIntermitent,
        if (validationMessage != null) verticalSpaceTiny,
        if (validationMessage != null)
          Text(
            validationMessage!,
            style: const TextStyle(
              color: kcErrorColor,
              fontSize: kBodyTextSize,
            ),
          ),
        if (validationMessage != null) verticalSpaceRegular,
        if (onForgotPassword != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Forgot Password? ',
                style: ktsForgotPassword,
              ),
              GestureDetector(
                onTap: () async {
                  String url = "https://alpha.verzo.app/auth/resetlink";
                  var urllaunchable = await canLaunchUrlString(
                      url); //canLaunch is from url_launcher package
                  if (urllaunchable) {
                    await launchUrlString(
                        url); //launch is from url_launcher package to launch URL
                  } else {}
                },
                child: const Text('Reset here',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      letterSpacing: 0,
                      height: 0,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: kcPrimaryColor,
                      color: kcPrimaryColor,
                    )),
              )
            ],
          ),
        if (onForgotPassword != null) verticalSpaceIntermitent,
        if (onArchiveButtonTapped != null)
          Container(
            width: double.infinity,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 1.5, color: kcArchiveColor), // Line at the top
                bottom: BorderSide(
                    width: 1.5, color: kcArchiveColor), // Line at the bottom
              ),
            ),
            child: GestureDetector(
              onTap: onArchiveButtonTapped,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/archive-2.svg',
                    width: 20,
                    height: 20,
                  ),
                  horizontalSpaceTiny,
                  Text(
                    archiveButtonTitle!,
                    style: ktsAddNewText,
                  ),
                ],
              ),
            ),
          ),
        if (onArchiveButtonTapped != null) verticalSpaceSmall,

        GestureDetector(
          onTap: onMainButtonTapped,
          child: Container(
            width: double.infinity,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kcPrimaryColor,
            ),
            child: busy
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : Text(
                    mainButtonTitle!,
                    style: ktsButtonText,
                  ),
          ),
        ),
        if (onMainButtonTapped != null) verticalSpaceTiny1,
        if (secondaryButtonTitle != null)
          GestureDetector(
            onTap: onSecondaryButtonTapped,
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: defaultBorderRadius,
                  color: kcButtonTextColor,
                  border: Border.all(
                      color: kcPrimaryColor.withOpacity(0.6), width: 1)),
              child: busy
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(kcPrimaryColor),
                    )
                  : Text(
                      secondaryButtonTitle!,
                      style: ktsButtonTextBlue,
                    ),
            ),
          ),
        // verticalSpaceMedium,

        if (onCreateAccountTapped != null) verticalSpaceRegular,
        if (onCreateAccountTapped != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: ktsTextAuthentication,
              ),
              GestureDetector(
                onTap: onCreateAccountTapped,
                child: const Text('Create one',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      letterSpacing: -0.3,
                      height: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: kcPrimaryColor,
                      color: kcPrimaryColor,
                    )),
              )
            ],
          ),
        if (onLoginTapped != null) verticalSpaceRegular,
        if (onLoginTapped != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: ktsTextAuthentication,
              ),
              GestureDetector(
                onTap: onLoginTapped,
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    letterSpacing: -0.3,
                    height: 0,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: kcPrimaryColor,
                    color: kcPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        if (onResendVerificationCodeTapped != null) verticalSpaceTiny,
        if (onResendVerificationCodeTapped != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Didn\'t recieve the code? ',
                style: ktsTextAuthentication,
              ),
              GestureDetector(
                onTap: onResendVerificationCodeTapped,
                child: const Text('Re-send',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      letterSpacing: -0.3,
                      height: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: kcPrimaryColor,
                      color: kcPrimaryColor,
                    )),
              )
            ],
          ),
        if (showTermsText == true) verticalSpaceRegular,
        if (showTermsText == true)
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kcTermsColor,
              ),
              width: double.infinity,
              height: 62,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: kcAccentColor,
                      weight: 24,
                    ),
                    horizontalSpaceTiny,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.72,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'By using the platform you agree to our ',
                              style: ktsFormHintText,
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                color: kcPrimaryColor,
                                fontSize: 14,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: kcPrimaryColor,
                                height: 0,
                                letterSpacing: -0.30,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  // Handle tap on Privacy Policy
                                  // Navigate to the designated URL
                                  String url = "https://verzo.app/privacy";
                                  var urllaunchable = await canLaunchUrlString(
                                      url); //canLaunch is from url_launcher package
                                  if (urllaunchable) {
                                    await launchUrlString(
                                        url); //launch is from url_launcher package to launch URL
                                  } else {}
                                },
                            ),
                            TextSpan(text: ' and ', style: ktsFormHintText),
                            TextSpan(
                              text: 'Terms of Use',
                              style: const TextStyle(
                                color: kcPrimaryColor,
                                fontSize: 14,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: kcPrimaryColor,
                                height: 0,
                                letterSpacing: -0.30,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  // Handle tap on Privacy Policy
                                  // Navigate to the designated URL
                                  String url = "https://verzo.app/terms";
                                  var urllaunchable = await canLaunchUrlString(
                                      url); //canLaunch is from url_launcher package
                                  if (urllaunchable) {
                                    await launchUrlString(
                                        url); //launch is from url_launcher package to launch URL
                                  } else {}
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       'By using the platform you agree to our Privacy Policy and Terms of use ',
        //       style: ktsSmallBodyText,
        //     ),
        //   ],
        // ),
        // if (onForgotPasswordResend != null) verticalSpaceSmall,
        // if (onForgotPasswordResend != null)
        // Align(
        //   alignment: Alignment.center,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         'Didn\'t recieve an email? Change email address or ',
        //         style: ktsBodyTextLight,
        //       ),
        //       GestureDetector(
        //         onTap: (() {}),
        //         child: const Text('Resend email',
        //             style: TextStyle(
        //               decoration: TextDecoration.underline,
        //               color: kcPrimaryColor,
        //             )),
        //       )
        //     ],
        //   ),
        // ),
      ]),
    );
  }
}
