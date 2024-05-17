import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/billing_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillingViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final billingService = locator<BillingService>();
  final DialogService dialogService = locator<DialogService>();

  List<Plans> plans = [];
  String currentPlanId = ''; // Track the currently selected plan ID
  String reference = '';
  // @override
  // Future<List<Plans>> futureToRun() {
  //   return getPlans();
  // }

  Future<List<Plans>> getPlans() async {
    plans = await billingService.getPlans();

    if (plans.isNotEmpty) {
      currentPlanId = plans.last.id;
    }
    rebuildUi();
    return plans;
  }

  void setCurrentPlanId(String planId) {
    currentPlanId = planId;
    rebuildUi(); // Notify listeners about the change
  }

  Future<SubscriptionCreationResult> runSubscriptionCreation() async {
    final prefs = await SharedPreferences.getInstance();
    final businessIdValue = prefs.getString('businessId');
    return billingService.createSubscriptionNewCardA(
        tax: 0,
        businessId: businessIdValue ?? '',
        currentPlanId: currentPlanId);
  }

  Future<SubscriptionCreationResultB> runSubscriptionCreationB() async {
    final prefs = await SharedPreferences.getInstance();
    final businessIdValue = prefs.getString('businessId');
    return billingService.createSubscriptionNewCardB(
        tax: 0,
        reference: reference,
        businessId: businessIdValue ?? '',
        currentPlanId: currentPlanId);
  }

  Future saveSubscriptionData(BuildContext context) async {
    final result = await
        // runBusyFuture(
        runSubscriptionCreation();
    // );

    // if (result.subscription != null) {
    //   reference = result.subscription!.paymentReference;
    //   // navigate to success route
    //   final url = result.subscription!.paymentLink;
    //   var urllaunchable = await canLaunchUrlString(
    //       url); //canLaunch is from url_launcher package
    //   if (urllaunchable) {
    //     await launchUrlString(
    //         url); //launch is from url_launcher package to launch URL
    //   }
    // }
    if (result.subscription != null) {
      reference = result.subscription!.paymentReference;
      // Generate Paystack payment link based on the reference or other parameters
      final paystackPaymentLink = result.subscription!.paymentLink;

      // Construct the success URL with the payment reference
      final successURL =
          'https://alpha.verzo.app/dashboard/settings?trxref=$reference&reference=$reference';

      // Show Paystack payment page in a container with WebView
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Paystack Payment'),
              leading: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.close,
                    fill: 0.9,
                    color: kcTextSubTitleColor,
                    size: 24,
                  ),
                  onPressed: () {
                    navigateBack2(context);
                  }),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: WebView(
                initialUrl: paystackPaymentLink,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest request) {
                  // Check if the request URL matches the success URL
                  if (request.url == successURL) {
                    // Payment successful, navigate back to the billing view
                    // Navigator.of(context).pop();
                    navigateBack2(context);
                    // Return NavigationDecision.prevent to stop further navigation
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            ),
          );
        },
      ));
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

    rebuildUi();
  }

  void navigateBack() => navigationService.replaceWith(Routes.settingsView);
  void navigateBack2(BuildContext context) async {
    navigationService.replaceWith(Routes.billingView);
    final result = await runSubscriptionCreationB();
    if (result.subscription != null) {
      await dialogService.showCustomDialog(
          variant: DialogType.billingSuccess,
          title: 'Successful!',
          description: "Your payment was successfully completed",
          barrierDismissible: true,
          mainButtonTitle: 'Ok'
          // cancelTitle: 'Cancel',
          // confirmationTitle: 'Ok',
          );
    } else {
      if (result.error != null) {
        await dialogService.showCustomDialog(
            variant: DialogType.billingSuccess,
            title: 'Unsuccessful!',
            description: "Your payment was not completed",
            barrierDismissible: true,
            mainButtonTitle: 'Ok'
            // cancelTitle: 'Cancel',
            // confirmationTitle: 'Ok',
            );

        // setValidationMessage(result.error?.message);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       validationMessage ?? 'An error occurred, Try again.',
        //       textAlign: TextAlign.start,
        //       style: ktsSubtitleTileText2,
        //     ),
        //     elevation: 2,
        //     duration: const Duration(seconds: 3), // Adjust as needed
        //     backgroundColor: kcErrorColor,
        //     dismissDirection: DismissDirection.up,
        //     behavior: SnackBarBehavior.fixed,
        //     shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.only(
        //             bottomLeft: Radius.circular(4),
        //             bottomRight: Radius.circular(4))),
        //     padding: const EdgeInsets.all(12),
        //     // margin:
        //     //     EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.9),
        //   ),
        // );
      }
    }
  }
}
