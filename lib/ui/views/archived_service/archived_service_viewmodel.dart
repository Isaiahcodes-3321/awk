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

class ArchivedServiceViewModel extends FutureViewModel<List<Services>> {
  final navigationService = locator<NavigationService>();
  final _productservicesService = locator<ProductsServicesService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();

  List<Services> services = [];
  @override
  Future<List<Services>> futureToRun() => getArchivedServiceByBusiness();
  Future<List<Services>> getArchivedServiceByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      // Retrieve existing products/services
      services = await _productservicesService.getArchivedServiceByBusiness(
          businessId: businessIdValue);
    }

    rebuildUi();
    return services;
  }

  Future<bool> unArchiveService(String serviceId) async {
    final db = await getServiceDatabase();
    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.archive,
      title: 'Unarchive Service',
      description:
          "Are you sure you want to unarchive this service? You can’t undo this action",
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
            .unArchiveService(serviceId: serviceId);

        if (isUnArchived) {
          await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Unarchived!',
            description: 'Your service has been successfully unarchived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok',
          );
          await db.delete('services');
        }

        reloadService();

        return isUnArchived;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  Future<bool> deleteService(String serviceId) async {
    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.delete,
      title: 'Delete Service',
      description:
          "Are you sure you want to delete this service? You can’t undo this action",
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
            await _productservicesService.deleteService(serviceId: serviceId);

        if (isDeleted) {
          await dialogService.showCustomDialog(
            variant: DialogType.deleteSuccess,
            title: 'Deleted!',
            description: 'Your service has been successfully deleted.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok',
          );
        }

        reloadService();

        return isDeleted;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  void reloadService() async {
    final service = await getArchivedServiceByBusiness();
    data = service;
    rebuildUi();
  }

  void navigateBack(BuildContext context) {
    navigationService.back(result: true);
    rebuildUi();
  }
}
