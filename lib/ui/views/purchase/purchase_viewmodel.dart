import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/typesense.dart';

class PurchaseViewModel extends FutureViewModel<List<Purchases>> {
  final navigationService = locator<NavigationService>();
  final _purchaseService = locator<PurchaseService>();
  final DialogService dialogService = locator<DialogService>();
  TextEditingController searchController = TextEditingController();

  List<Purchases> purchases = [];
  List<Purchases> archivedPurchases = [];
  List<Purchases> allPurchases = [];
  List<Purchases> searchResults = [];

  bool isSearchActive = false;
  void toggleSearch() {
    isSearchActive = !isSearchActive;
    if (!isSearchActive) {
      // Clear the search controller and reload data if needed
      searchController.clear();
      reload();
    }
    rebuildUi();
  }

  @override
  Future<List<Purchases>> futureToRun() => getPurchaseByBusiness();
  Future<List<Purchases>> getPurchaseByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing customers
    purchases = await _purchaseService.getPurchaseByBusiness(
        businessId: businessIdValue);
    rebuildUi();

    archivedPurchases = await _purchaseService.getArchivedPurchaseByBusiness(
        businessId: businessIdValue);
    rebuildUi();

    allPurchases = [...purchases, ...archivedPurchases];
    rebuildUi();

    return allPurchases;
  }

  Future<void> searchPurchase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    String userIdValue = prefs.getString('userId') ?? '';
    final searchValue = searchController.text;

    // Ensure the search value is not empty4
    if (searchValue.isNotEmpty) {
      try {
        // Call your searchAllCollections function to search expenses
        searchResults =
            await searchPurchases(searchValue, businessIdValue, userIdValue);
      } catch (error) {
        print('Error searching expenses: $error');
      }
    } else {
      // searchResults =
      //     expenses; // Reset to original list when the search query is empty
    }
    // print(searchResults);

    purchases = searchResults;
    archivedPurchases = searchResults;
    rebuildUi();
    // return searchResults;
  }

  Future<bool> deletePurchase(String purchaseId) async {
    final db = await getPurchaseDatabase();
    final dbPurchaseWeek = await getPurchasesForWeekDatabase();
    final dbPurchaseMonth = await getPurchasesForMonthDatabase();
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.delete,
        title: 'Delete Purchase',
        description:
            "Are you sure you want to delete this purchase? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Delete'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );

    if (response?.confirmed == true) {
      final bool isDeleted =
          await _purchaseService.deletePurchase(purchaseId: purchaseId);
      if (isDeleted) {
        await dialogService.showCustomDialog(
          variant: DialogType.deleteSuccess,
          title: 'Deleted!',
          description: 'Your purchase has been successfully deleted.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
        await db.delete('purchases');
        await dbPurchaseWeek.delete('purchases_for_week');
        await dbPurchaseMonth.delete('purchases_for_month');
      }
      await reloadPurchaseData();

      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> archivePurchase(String purchaseId) async {
    final db = await getPurchaseDatabase();
    final dbPurchaseWeek = await getPurchasesForWeekDatabase();
    final dbPurchaseMonth = await getPurchasesForMonthDatabase();
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.archive,
        title: 'Archive Purchase',
        description:
            "Are you sure you want to archive this purchase? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Archive'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );
    if (response?.confirmed == true) {
      final bool isArchived =
          await _purchaseService.archivePurchase(purchaseId: purchaseId);
      if (isArchived) {
        await dialogService.showCustomDialog(
          variant: DialogType.archiveSuccess,
          title: 'Archived!',
          description: 'Your purchase has been successfully archived.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
        await db.delete('purchases');
        await dbPurchaseWeek.delete('purchases_for_week');
        await dbPurchaseMonth.delete('purchases_for_month');
      }
      await reloadPurchaseData();
      return isArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> unArchivePurchase(String purchaseId) async {
    final db = await getPurchaseDatabase();
    final dbPurchaseWeek = await getPurchasesForWeekDatabase();
    final dbPurchaseMonth = await getPurchasesForMonthDatabase();
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.archive,
        title: 'Unarchive Purchase',
        description:
            "Are you sure you want to unarchive this purchase? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Unarchive'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );
    if (response?.confirmed == true) {
      final bool isArchived =
          await _purchaseService.unArchivePurchase(purchaseId: purchaseId);
      if (isArchived) {
        await dialogService.showCustomDialog(
          variant: DialogType.archiveSuccess,
          title: 'Unarchived!',
          description: 'Your purchase has been successfully unarchived.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
        await db.delete('purchases');
        await dbPurchaseWeek.delete('purchases_for_week');
        await dbPurchaseMonth.delete('purchases_for_month');
      }
      await reloadPurchaseData();
      return isArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<void> reloadPurchaseData() async {
    final allPurchases = await getPurchaseByBusiness();
    // Update the data with the new list of purchases
    data = allPurchases;
    rebuildUi();
  }

  Future<List<Purchases>> reloadPurchase() async {
    allPurchases = await getPurchaseByBusiness();
    rebuildUi();
    return allPurchases;
  }

  Future reload() async {
    runBusyFuture(reloadPurchase());
  }
}
