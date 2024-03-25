import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/merchant_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/create_merchant/create_merchant_view.form.dart';

class CreateMerchantViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _createMerchantService = locator<MerchantService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<MerchantCreationResult> runMerchantCreation() async {
    final prefs = await SharedPreferences.getInstance();
    final businessIdValue = prefs.getString('id');
    return _createMerchantService.createMerchant(
        name: nameValue ?? '',
        businessId: businessIdValue ?? '',
        email: emailValue ?? '');
  }

  Future saveMerchantData(context) async {
    final result = await runBusyFuture(runMerchantCreation());

    if (result.merchant != null) {
      // navigate to success route

      navigationService.back();
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
  @override
  void setFormStatus() {}
}
