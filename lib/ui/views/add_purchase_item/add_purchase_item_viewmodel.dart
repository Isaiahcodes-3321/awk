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
import 'package:verzo/ui/views/add_purchase_item/add_purchase_item_view.form.dart';

class AddPurchaseItemViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _productxService = locator<ProductsServicesService>();
  final authService = locator<AuthenticationService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> productUnitdropdownItems = [];

  Future<List<ProductUnit>> getProductUnits() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final unfilteredproductUnits = await _productxService.getProductUnits();
    // Filter out the product unit with the name 'others'
    final productUnits = unfilteredproductUnits
        .where((productUnit) => productUnit.unitName.toLowerCase() != 'other')
        .toList();

    productUnitdropdownItems = productUnits.map((productUnit) {
      String displayText = productUnit.unitName;
      if (productUnit.description != null &&
          productUnit.description!.isNotEmpty) {
        displayText += ' - ${productUnit.description}';
      }
      return DropdownMenuItem<String>(
        value: productUnit.id.toString(),
        child: Text(displayText),
      );
    }).toList();
    return productUnits;
  }

  Future<ProductCreationResult> runProductCreation() async {
    final prefs = await SharedPreferences.getInstance();
    final businessIdValue = prefs.getString('businessId');
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    return _productxService.createProducts(
        productName: productNameValue ?? '',
        businessId: businessIdValue ?? '',
        price: double.parse(priceValue ?? ''),
        initialStockLevel: double.parse(initialStockLevelValue ?? ''),
        productUnitId: productUnitIdValue ?? '');
  }

  Future saveProductData(BuildContext context) async {
    final result = await runBusyFuture(runProductCreation());

    if (result.product != null) {
      // navigate to success route
      navigationService.back(result: true);
      rebuildUi();
      // navigationService.replaceWith(Routes.productView);
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
