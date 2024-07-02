import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/views/add_service/add_service_view.form.dart';

class AddServiceViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _productxService = locator<ProductsServicesService>();
  final authService = locator<AuthenticationService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> serviceUnitdropdownItems = [];

  Future<List<ServiceUnit>> getServiceUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final businessIdValue = prefs.getString('businessId');
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final unfilteredserviceUnits = await _productxService.getServiceUnits(
        businessId: businessIdValue ?? '');

    // Filter out the service unit with the name 'others'
    final serviceUnits = unfilteredserviceUnits
        .where((serviceUnit) => serviceUnit.unitName.toLowerCase() != 'other')
        .toList();

    serviceUnitdropdownItems = serviceUnits.map((serviceUnit) {
      String displayText = serviceUnit.unitName;
      if (serviceUnit.description != null &&
          serviceUnit.description!.isNotEmpty) {
        displayText += ' - ${serviceUnit.description}';
      }
      return DropdownMenuItem<String>(
        value: serviceUnit.id.toString(),
        child: Text(displayText),
      );
    }).toList();
    return serviceUnits;
  }

  List<DropdownMenuItem<String>> addDividersAfterItems(
      List<DropdownMenuItem<String>> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final item in items) {
      menuItems.addAll(
        [
          item,
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> getCustomItemsHeights(int length) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  Future<ServiceCreationResult> runServiceCreation() async {
    final prefs = await SharedPreferences.getInstance();
    final businessIdValue = prefs.getString('businessId');
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    return _productxService.createServices(
        name: serviceNameValue ?? '',
        businessId: businessIdValue ?? '',
        price: double.parse(priceValue ?? ''),
        serviceUnitId: serviceUnitIdValue ?? '');
  }

  Future saveServiceData(BuildContext context) async {
    final db = await getServiceDatabase();
    final result = await runBusyFuture(runServiceCreation());

    if (result.service != null) {
      await db.delete('services');
      // navigate to success route
      navigationService.replaceWith(Routes.serviceView);
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
