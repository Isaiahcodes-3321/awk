import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/database_helper.dart';

class ArchivedProductViewModel extends FutureViewModel<List<Products>> {
  final navigationService = locator<NavigationService>();
  final _productservicesService = locator<ProductsServicesService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();

  List<Products> products = [];

  @override
  Future<List<Products>> futureToRun() => getArchivedProductByBusiness();
  Future<List<Products>> getArchivedProductByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      // Retrieve existing products/services
      products = await _productservicesService.getArchivedProductsByBusiness(
          businessId: businessIdValue);
    }

    rebuildUi();

    return products;
  }

  Future<bool> unArchiveProduct(String productId) async {
    final db = await getProductDatabase();
    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.archive,
      title: 'Unarchive Product',
      description:
          "Are you sure you want to unarchive this product? You can’t undo this action",
      barrierDismissible: true,
      mainButtonTitle: 'Unarchive',
    );

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
        // Proceed with archiving if confirmed
        final bool isUnArchived = await _productservicesService
            .unArchiveProduct(productId: productId);

        if (isUnArchived) {
          await dialogService.showCustomDialog(
              variant: DialogType.archiveSuccess,
              title: 'Unarchived!',
              description: 'Your product has been successfully unarchived.',
              barrierDismissible: true,
              mainButtonTitle: 'Ok');
          await db.delete('products');
        }

        reloadProduct();

        return isUnArchived;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  Future<bool> deleteProduct(String productId) async {
    final db = await getProductDatabase();
    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.delete,
      title: 'Delete Product',
      description:
          "Are you sure you want to delete this product? You can’t undo this action",
      barrierDismissible: true,
      mainButtonTitle: 'Delete',
    );

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
        // Proceed with deleting if confirmed
        final bool isDeleted =
            await _productservicesService.deleteProduct(productId: productId);

        if (isDeleted) {
          await dialogService.showCustomDialog(
            variant: DialogType.deleteSuccess,
            title: 'Deleted!',
            description: 'Your product has been successfully deleted.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok',
          );
          await db.delete('products');
        }

        reloadProduct();
        return isDeleted;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  void reloadProduct() async {
    final product = await getArchivedProductByBusiness();
    data = product;
    rebuildUi();
  }

  void navigateBack(BuildContext context) {
    navigationService.back(result: true);
    rebuildUi();
  }
}
