import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/views/add_customer/add_customer_view.form.dart';

class AddCustomerViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _createCustomerService = locator<SalesService>();
  final authService = locator<AuthenticationService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<CustomerCreationResult> runCustomerCreation() async {
    final prefs = await SharedPreferences.getInstance();
    final businessIdValue = prefs.getString('businessId');
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    return _createCustomerService.createCustomer(
        name: customerNameValue ?? '',
        mobile: mobileValue ?? '',
        email: emailValue ?? '',
        address: addressValue ?? '',
        businessId: businessIdValue ?? '');
  }

  Future saveCustomerData(BuildContext context) async {
    final db = await getCustomerDatabase();
    final result = await runBusyFuture(runCustomerCreation());

    if (result.customer != null) {
      await db.delete('customers');
      // navigate to success route
      navigationService.replaceWith(Routes.customerView);
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
