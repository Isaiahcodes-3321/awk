import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:verzo/services/billing_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'billing_viewmodel.dart';

class BillingView extends StackedView<BillingViewModel> {
  const BillingView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(BillingViewModel viewModel) async {
    await viewModel.getCurrentSubscription();
  }

  @override
  Widget builder(
    BuildContext context,
    BillingViewModel viewModel,
    Widget? child,
  ) {
    // Check if viewModel.subs is null and show a loading indicator
    if (viewModel.subs == null) {
      return Scaffold(
          backgroundColor: kcButtonTextColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ListView(
              children: [
                verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                              onPressed: () {
                                viewModel.navigateBack();
                              }),
                        ),
                        horizontalSpaceTiny,
                        Text(
                          'back',
                          style: ktsSubtitleTextAuthentication,
                        ),
                      ],
                    ),
                  ],
                ),
                verticalSpaceSmallMid,
                const SizedBox(
                    height: 500,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: kcPrimaryColor,
                        ),
                      ],
                    )))
              ],
            ),
          ));
    } else {
      return Scaffold(
        backgroundColor: kcButtonTextColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: ListView(
            children: [
              verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                            onPressed: () {
                              viewModel.navigateBack();
                            }),
                      ),
                      horizontalSpaceTiny,
                      Text(
                        'back',
                        style: ktsSubtitleTextAuthentication,
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpaceSmallMid,
              Text('Pricing plans', style: ktsTitleTextAuthentication),
              verticalSpaceTinyt,
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: 'Upgrade or cancel plans on the ',
                    style: ktsSubtitleTextAuthentication,
                  ),
                  TextSpan(
                    text: 'website',
                    style: const TextStyle(
                      color: kcPrimaryColor,
                      fontSize: 16,
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
                        String url = "https://verzo.app/pricing";
                        var urllaunchable = await canLaunchUrlString(
                            url); //canLaunch is from url_launcher package
                        if (urllaunchable) {
                          await launchUrlString(
                              url); //launch is from url_launcher package to launch URL
                        } else {}
                      },
                  ),
                ]),
              ),
              verticalSpaceSmallMid,
              Text.rich(
                TextSpan(
                  text: 'You are currently on ', // The normal text
                  style: ktsFormHintText3,
                  children: <TextSpan>[
                    TextSpan(
                      text: viewModel.subs?.planName ?? '', // The plan name
                      style: const TextStyle(
                          color:
                              kcPrimaryColor), // Apply blue color to plan name
                    ),
                  ],
                ),
              ),
              verticalSpaceTinyt,
              Text(
                'Valid to:  ${viewModel.subs?.validTo ?? ''}',
                style: ktsFormHintText3,
              ),
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
      );
    }

    // return Scaffold(
    //     backgroundColor: kcButtonTextColor,
    //     body: AuthenticationLayout(
    //         title: 'Billing',
    //         subtitle: 'Switch plan or billing frequency',
    //         mainButtonTitle: 'Next',
    //         onMainButtonTapped: () async {
    //           final DialogResponse? response = await viewModel.dialogService
    //               .showCustomDialog(
    //                   variant: DialogType.billing,
    //                   title: 'Confirm plan',
    //                   description:
    //                       "Are you sure you want to switch plans? This will affect your access to features",
    //                   barrierDismissible: true,
    //                   mainButtonTitle: 'Proceed'
    //                   // cancelTitle: 'Cancel',
    //                   // confirmationTitle: 'Ok',
    //                   );
    //           if (response!.confirmed == true) {
    //             viewModel.saveSubscriptionData(context);
    //           }
    //         },
    //         onBackPressed: viewModel.navigateBack,
    //         form: Center(child: Builder(builder: (context) {
    //           if (viewModel.isBusy) {
    //             return const Center(
    //                 child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 CircularProgressIndicator(
    //                   color: kcPrimaryColor,
    //                 ),
    //               ],
    //             ));
    //           }
    //           if (viewModel.plans.isEmpty) {
    //             Center(
    //                 child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 SvgPicture.asset(
    //                   'assets/images/Group 1000007841.svg',
    //                   width: 200,
    //                   height: 150,
    //                 ),
    //                 verticalSpaceSmall,
    //                 Text(
    //                   'No plans available',
    //                   style: ktsSubtitleTextAuthentication,
    //                 ),
    //               ],
    //             ));
    //           }
    //           return ListView.separated(
    //             primary: true,
    //             shrinkWrap: true,
    //             itemBuilder: (context, index) {
    //               var plan = viewModel.plans[index];
    //               return PlanCard(
    //                 plan: plan,
    //                 isSelected: viewModel.currentPlanId ==
    //                     plan.id, // Check if plan is selected
    //                 onSelect: () {
    //                   viewModel.setCurrentPlanId(
    //                       plan.id); // Update currentPlanId in view model
    //                 },
    //               );
    //             },
    //             itemCount: viewModel.plans.length,
    //             separatorBuilder: (BuildContext context, int index) {
    //               return verticalSpaceRegular;
    //             },
    //           );
    //         }))));
  }

  @override
  BillingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BillingViewModel();
}

class PricingFeature extends ViewModelWidget<BillingViewModel> {
  const PricingFeature({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context, BillingViewModel viewModel) {
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

class PlanCard extends ViewModelWidget<BillingViewModel> {
  const PlanCard(
      {Key? key,
      required this.plan,
      required this.isSelected,
      required this.onSelect})
      : super(key: key);
  final Plans plan;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context, BillingViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kcStrokeColor),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: ListTile(
        style: ListTileStyle.list,
        tileColor: isSelected ? kcOTPColor : null,
        onTap: onSelect, // Add onTap property to trigger onSelect callback
        contentPadding: EdgeInsets.symmetric(horizontal: 24),
        title: Text(
          plan.planName,
          style: TextStyle(
            fontFamily: 'Satoshi',
            color: kcTextTitleColor.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: RichText(
            text: TextSpan(children: [
          TextSpan(
            text: NumberFormat.currency(locale: 'en_NGN', symbol: '₦')
                .currencySymbol, // The remaining digits without the symbol
            style: GoogleFonts.openSans(
              color: kcTextSubTitleColor.withOpacity(0.8),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ).copyWith(fontFamily: 'Roboto'),
          ),
          TextSpan(
            text: NumberFormat.currency(locale: 'en_NGN', symbol: '').format(
                plan.currentPrice), // The remaining digits without the symbol
            style: TextStyle(
                fontFamily: 'Satoshi',
                color: kcTextSubTitleColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5),
          ),
          TextSpan(
            text: ' monthly', // Add 'monthly' text after the current price
            style: TextStyle(
              fontFamily: 'Satoshi',
              color: kcTextSubTitleColor.withOpacity(0.7),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ])),
        // subtitle: Text(plan.currentPrice.toString(),
        //     style: TextStyle(
        //       fontFamily: 'Satoshi',
        //       color: kcTextSubTitleColor,
        //       fontSize: 14,
        //       fontWeight: FontWeight.w400,
        //     )
        //     // overflow: TextOverflow.values,
        //     ),
        trailing: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kcFormBorderColor // Stroke color
                ),
            color: isSelected ? kcPrimaryColor : null, // Fill color
          ),
        ),
      ),
    );
  }
}
