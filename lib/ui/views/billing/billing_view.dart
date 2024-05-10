import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/services/billing_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'billing_viewmodel.dart';

class BillingView extends StackedView<BillingViewModel> {
  const BillingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BillingViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: kcButtonTextColor,
        body: AuthenticationLayout(
            title: 'Billing',
            subtitle: 'Switch plan or billing frequency',
            mainButtonTitle: 'Next',
            onMainButtonTapped: () async {
              final DialogResponse? response = await viewModel.dialogService
                  .showCustomDialog(
                      variant: DialogType.billing,
                      title: 'Confirm plan',
                      description:
                          "Are you sure you want to switch plans? This will affect your access to features",
                      barrierDismissible: true,
                      mainButtonTitle: 'Proceed'
                      // cancelTitle: 'Cancel',
                      // confirmationTitle: 'Ok',
                      );
              if (response!.confirmed == true) {
                viewModel.saveSubscriptionData(context);
              }
            },
            onBackPressed: viewModel.navigateBack,
            form: Center(child: Builder(builder: (context) {
              if (viewModel.isBusy) {
                return const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: kcPrimaryColor,
                    ),
                  ],
                ));
              }
              if (viewModel.plans.isEmpty) {
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/Group 1000007841.svg',
                      width: 200,
                      height: 150,
                    ),
                    verticalSpaceSmall,
                    Text(
                      'No plans available',
                      style: ktsSubtitleTextAuthentication,
                    ),
                  ],
                ));
              }
              return ListView.separated(
                primary: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var plan = viewModel.plans[index];
                  return PlanCard(
                    plan: plan,
                    isSelected: viewModel.currentPlanId ==
                        plan.id, // Check if plan is selected
                    onSelect: () {
                      viewModel.setCurrentPlanId(
                          plan.id); // Update currentPlanId in view model
                    },
                  );
                },
                itemCount: viewModel.plans.length,
                separatorBuilder: (BuildContext context, int index) {
                  return verticalSpaceRegular;
                },
              );
            }))));
  }

  @override
  void onViewModelReady(BillingViewModel viewModel) async {
    await viewModel.getPlans();
  }

  @override
  BillingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BillingViewModel();
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

// class PaymentView extends StatelessWidget {
//   const PaymentView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<BillingViewModel>.nonReactive(
//       viewModelBuilder: () => BillingViewModel(),
//       builder: (
//         BuildContext context,
//         BillingViewModel model,
//         Widget? child,
//       ) {
//         return Scaffold(
//             body: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Builder(builder: (context) {
//             return WebView(
//               initialUrl: 'https://paystack.com/pay/subcri',
//               javascriptMode: JavascriptMode.unrestricted,
//               onWebViewCreated: (WebViewController webViewController) {
//                 _controller.complete(webViewController);
//               },
//               onProgress: (int progress) {
//                 print("progress $progress%");
//               },
//               javascriptChannels: <JavascriptChannel>{
//                 _toasterJavascriptChannel(context)
//               },
//             );
//           }),
//         ));
//       },
//     );
//   }
// }
