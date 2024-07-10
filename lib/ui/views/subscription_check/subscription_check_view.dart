import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

import 'subscription_check_viewmodel.dart';

class SubscriptionCheckView extends StackedView<SubscriptionCheckViewModel> {
  const SubscriptionCheckView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SubscriptionCheckViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kcButtonTextColor,
        appBar: AppBar(
          backgroundColor: kcPrimaryColor,
          automaticallyImplyLeading: false, // Remove the default back button
          // title: Text(''), // Empty title to center the icon
          centerTitle: true, // Center the title and the leading icon
          actions: [
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              icon: const Icon(Icons.close),
              color: kcButtonTextColor,
              iconSize: 24, // Use Icons.close for 'x' icon
              onPressed: () {
                // Handle close button press
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              verticalSpaceTiny1,
              Text(
                'No active subscription',
                textAlign: TextAlign.center,
                style: ktsHeaderText,
              ),
              verticalSpaceTiny,
              Text(
                'Visit the web to select a plan and continue',
                textAlign: TextAlign.center,
                style: ktsFormHintText,
              ),
              Center(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: 'Need help? Send a mail to our support team ',
                      style: ktsFormHintText,
                    ),
                    TextSpan(
                      text: 'here',
                      style: const TextStyle(
                        color: kcPrimaryColor,
                        fontSize: 14,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: kcPrimaryColor,
                        height: 0,
                        letterSpacing: 0,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          String? encodeQueryParameters(
                              Map<String, String> params) {
                            return params.entries
                                .map((MapEntry<String, String> e) =>
                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                .join('&');
                          }

                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: 'info@verzo.app',
                            query: encodeQueryParameters(<String, String>{
                              'subject':
                                  'Example Subject & Symbols are allowed!',
                            }),
                          );
                          if (await canLaunch(emailUri.toString())) {
                            await launchUrl(emailUri);
                          } else {
                            throw Exception('Could not launch $emailUri');
                          }
                        },
                    ),
                  ]),
                ),
              ),
              verticalSpaceTiny1,
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: kcBorderColor, width: 1.5),
                  color: kcOTPColor.withOpacity(.3),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Basic', style: ktsTitleText),
                    verticalSpaceTinyt,
                    Text(
                      'Ideal for freelancers and small businesses',
                      style: ktsFormHintText1,
                    ),
                    verticalSpaceSmallMid,
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG', symbol: '₦')
                                          .currencySymbol,
                                      style: GoogleFonts.openSans(
                                        color:
                                            kcTextTitleColor.withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ).copyWith(fontFamily: 'Roboto'),
                                    ),
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG',
                                              symbol: '',
                                              decimalDigits: 0)
                                          .format(5500),
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        color:
                                            kcTextTitleColor.withOpacity(0.9),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '/month',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  color: kcTextTitleColor.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceTiny,
                          const Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 16,
                              color: kcTextTitleColor,
                            ),
                          ),
                          verticalSpaceTiny,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG', symbol: '₦')
                                          .currencySymbol,
                                      style: GoogleFonts.openSans(
                                        color:
                                            kcTextTitleColor.withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ).copyWith(fontFamily: 'Roboto'),
                                    ),
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG',
                                              symbol: '',
                                              decimalDigits: 0)
                                          .format(55000),
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        color:
                                            kcTextTitleColor.withOpacity(0.9),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '/year',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  color: kcTextTitleColor.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceIntermitent,
                    PricingFeature(
                      name: 'Create 100 invoice',
                    ),
                    PricingFeature(
                      name: 'Send 100 invoices',
                    ),
                    PricingFeature(
                      name: 'Create 100 purchase orders',
                    ),
                    PricingFeature(
                      name: 'Create 100 customers',
                    ),
                    PricingFeature(
                      name: 'Create 100 products and services',
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: kcBorderColor, width: 1.5),
                  color: kcOTPColor.withOpacity(0.3), // Add background color
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Standard', style: ktsTitleText),
                    verticalSpaceTinyt,
                    Text(
                      'Tailored for growing businesses and entrepreneurs',
                      style: ktsFormHintText1,
                    ),
                    verticalSpaceSmallMid,
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG', symbol: '₦')
                                          .currencySymbol,
                                      style: GoogleFonts.openSans(
                                        color:
                                            kcTextTitleColor.withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ).copyWith(fontFamily: 'Roboto'),
                                    ),
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG',
                                              symbol: '',
                                              decimalDigits: 0)
                                          .format(12500),
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        color:
                                            kcTextTitleColor.withOpacity(0.9),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '/month',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  color: kcTextTitleColor.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceTiny,
                          const Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 16,
                              color: kcTextTitleColor,
                            ),
                          ),
                          verticalSpaceTiny,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG', symbol: '₦')
                                          .currencySymbol,
                                      style: GoogleFonts.openSans(
                                        color:
                                            kcTextTitleColor.withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ).copyWith(fontFamily: 'Roboto'),
                                    ),
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG',
                                              symbol: '',
                                              decimalDigits: 0)
                                          .format(125000),
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        color:
                                            kcTextTitleColor.withOpacity(0.9),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '/year',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  color: kcTextTitleColor.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceIntermitent,
                    PricingFeature(
                      name: 'Create 500 invoices',
                    ),
                    PricingFeature(
                      name: 'Send 500 invoices',
                    ),
                    PricingFeature(
                      name: 'Create 500 purchase orders',
                    ),
                    PricingFeature(
                      name: 'Create 500 customers',
                    ),
                    PricingFeature(
                      name: 'Create 500 products and services',
                    ),
                    PricingFeature(
                      name: 'Assign 1 admin, manager or staff',
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: kcBorderColor, width: 1.5),
                  color: kcOTPColor.withOpacity(0.3), // Add background color
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Premium', style: ktsTitleText),
                    verticalSpaceTinyt,
                    Text(
                      'Tailored for larger enterprises and complex financial needs',
                      style: ktsFormHintText1,
                    ),
                    verticalSpaceSmallMid,
                    Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG', symbol: '₦')
                                          .currencySymbol,
                                      style: GoogleFonts.openSans(
                                        color:
                                            kcTextTitleColor.withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ).copyWith(fontFamily: 'Roboto'),
                                    ),
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG',
                                              symbol: '',
                                              decimalDigits: 0)
                                          .format(25000),
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        color:
                                            kcTextTitleColor.withOpacity(0.9),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '/month',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  color: kcTextTitleColor.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceTiny,
                          const Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 16,
                              color: kcTextTitleColor,
                            ),
                          ),
                          verticalSpaceTiny,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG', symbol: '₦')
                                          .currencySymbol,
                                      style: GoogleFonts.openSans(
                                        color:
                                            kcTextTitleColor.withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ).copyWith(fontFamily: 'Roboto'),
                                    ),
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              locale: 'en_NG',
                                              symbol: '',
                                              decimalDigits: 0)
                                          .format(250000),
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        color:
                                            kcTextTitleColor.withOpacity(0.9),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '/year',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  color: kcTextTitleColor.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceIntermitent,
                    PricingFeature(
                      name: 'Create unlimited invoices',
                    ),
                    PricingFeature(
                      name: 'Send unlimited invoices',
                    ),
                    PricingFeature(
                      name: 'Create unlimited purchase orders',
                    ),
                    PricingFeature(
                      name: 'Create unlimited customers',
                    ),
                    PricingFeature(
                      name: 'Create unlimited products and services',
                    ),
                    PricingFeature(
                      name: 'Assign 5 admins, managers or staff',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  SubscriptionCheckViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SubscriptionCheckViewModel();
}

class PricingFeature extends ViewModelWidget<SubscriptionCheckViewModel> {
  const PricingFeature({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context, SubscriptionCheckViewModel viewModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.check,
              color: kcPrimaryColor,
              size: 20,
            ),
            horizontalSpaceTiny,
            Text(
              name,
              style: ktsSubtitleTextAuthentication,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        verticalSpaceTiny
      ],
    );
    // return ListTile(
    //   contentPadding: EdgeInsets.zero,
    //   leading: const Icon(
    //     Icons.check,
    //     color: kcPrimaryColor,
    //     size: 20,
    //   ),
    //   title: Text(
    //     name,
    //     style: ktsSubtitleTextAuthentication,
    //     maxLines: 2,
    //     overflow: TextOverflow.ellipsis,
    //   ),
    // );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 4),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text(
    //         name,
    //         style: ktsSubtitleTextAuthentication,
    //         maxLines: 1,
    //         overflow: TextOverflow.ellipsis,
    //       ),
    //       Text(
    //         description,
    //         style: ktsSubtitleTextAuthentication,
    //       )
    //     ],
    //   ),
    // );
  }
}
