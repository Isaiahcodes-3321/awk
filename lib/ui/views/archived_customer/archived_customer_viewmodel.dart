import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/sales_service.dart';

class ArchivedCustomerViewModel extends FutureViewModel<List<Customers>> {
  final navigationService = locator<NavigationService>();
  final _saleService = locator<SalesService>();
  final DialogService dialogService = locator<DialogService>();

  List<Customers> customers = [];

  @override
  Future<List<Customers>> futureToRun() => getArchivedCustomersByBusiness();
  Future<List<Customers>> getArchivedCustomersByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing customers
    customers = await _saleService.getArchivedCustomerByBusiness(
        businessId: businessIdValue);

    rebuildUi();

    return customers;
  }

  Future<bool> unArchiveCustomer(String customerId) async {
    // final db = await getCustomerDatabase();

    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.archive,
        title: 'Unarchive Customer',
        description:
            "Are you sure you want to unarchive this customer? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Unarchive');

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      // Proceed with archiving if confirmed
      final bool isUnArchived =
          await _saleService.unArchiveCustomer(customerId: customerId);

      if (isUnArchived) {
        await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Unarchived!',
            description: 'Your customer has been successfully unarchived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
        // await db.delete('customers');
      }

      reloadCustomer();

      return isUnArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> deleteCustomer(String customerId) async {
    // final db = await getCustomerDatabase();

    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.delete,
        title: 'Delete Customer',
        description:
            "Are you sure you want to delete this customer? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Delete');

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      // Proceed with deleting if confirmed
      final bool isDeleted =
          await _saleService.deleteCustomer(customerId: customerId);

      if (isDeleted) {
        await dialogService.showCustomDialog(
            variant: DialogType.deleteSuccess,
            title: 'Deleted!',
            description: 'Your customer has been successfully deleted.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
        // await db.delete('customers');
      }

      // Navigate to the customer view
      reloadCustomer();

      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  void reloadCustomer() async {
    final customer = await getArchivedCustomersByBusiness();
    data = customer;
    rebuildUi();
  }

  void navigateBack(BuildContext context) {
    navigationService.back(result: true);
    rebuildUi();
  }
}
