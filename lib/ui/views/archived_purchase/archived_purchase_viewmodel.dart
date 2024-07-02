import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/database_helper.dart';

class ArchivedPurchaseViewModel extends FutureViewModel<List<Purchases>> {
  final navigationService = locator<NavigationService>();
  final _purchaseService = locator<PurchaseService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();
  List<Purchases> purchases = [];
  @override
  Future<List<Purchases>> futureToRun() => getArchivedPurchaseByBusiness();

  Future<List<Purchases>> getArchivedPurchaseByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      // Retrieve existing customers
      purchases = await _purchaseService.getArchivedPurchaseByBusiness(
          businessId: businessIdValue);
    }
    rebuildUi();
    return purchases;
  }

  Future<bool> unArchivePurchase(String purchaseId) async {
    final db = await getPurchaseDatabase();
    final db2 = await getPurchaseDatabaseList();
    final dbPurchaseWeek = await getPurchasesForWeekDatabase();
    final dbPurchaseMonth = await getPurchasesForMonthDatabase();
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.archive,
        title: 'Unarchive Purchase',
        description:
            "Are you sure you want to unarchive this purchase? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Unarchive');

    if (response?.confirmed == true) {
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
        final bool isUnArchived =
            await _purchaseService.unArchivePurchase(purchaseId: purchaseId);
        if (isUnArchived) {
          await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Unarchived!',
            description: 'Your purchase has been successfully unarchived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok',
          );
          await db.delete('purchases');
          await db2.delete('purchases');
          await dbPurchaseWeek.delete('purchases_for_week');
          await dbPurchaseMonth.delete('purchases_for_month');
        }
        reloadPurchase();
        return isUnArchived;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false; // Fallback return false if the refresh token logic doesn't proceed as expected
  }

  Future<bool> deletePurchase(String purchaseId) async {
    final db = await getPurchaseDatabase();
    final db2 = await getPurchaseDatabaseList();
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
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
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
          await db2.delete('purchases');
          await dbPurchaseWeek.delete('purchases_for_week');
          await dbPurchaseMonth.delete('purchases_for_month');
        }
        reloadPurchase();

        return isDeleted;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  // Future<bool> unArchivePurchase(String purchaseId) async {
  //   final db = await getPurchaseDatabase();
  //   final db2 = await getPurchaseDatabaseList();
  //   final dbPurchaseWeek = await getPurchasesForWeekDatabase();
  //   final dbPurchaseMonth = await getPurchasesForMonthDatabase();
  //   final DialogResponse? response = await dialogService.showCustomDialog(
  //       variant: DialogType.archive,
  //       title: 'Unarchive Purchase',
  //       description:
  //           "Are you sure you want to unarchive this purchase? You can’t undo this action",
  //       barrierDismissible: true,
  //       mainButtonTitle: 'Unarchive'
  //       // cancelTitle: 'Cancel',
  //       // confirmationTitle: 'Ok',
  //       );
  //   if (response?.confirmed == true) {
  //     final bool isUnArchived =
  //         await _purchaseService.unArchivePurchase(purchaseId: purchaseId);
  //     if (isUnArchived) {
  //       await dialogService.showCustomDialog(
  //         variant: DialogType.archiveSuccess,
  //         title: 'Unarchived!',
  //         description: 'Your purchase has been successfully unarchived.',
  //         barrierDismissible: true,
  //         mainButtonTitle: 'Ok',
  //       );
  //       await db.delete('purchases');
  //       await db2.delete('purchases');
  //       await dbPurchaseWeek.delete('purchases_for_week');
  //       await dbPurchaseMonth.delete('purchases_for_month');
  //     }
  //     reloadPurchase();
  //     return isUnArchived;
  //   } else {
  //     // User canceled the action
  //     return false;
  //   }
  // }

  void reloadPurchase() async {
    final purchase = await getArchivedPurchaseByBusiness();
    data = purchase;
    rebuildUi();
  }

  void navigateBack(BuildContext context) {
    navigationService.back(result: true);
    rebuildUi();
  }
}
