import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';

class ViewPurchaseViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final _purchaseService = locator<PurchaseService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();

  Purchases? purchase;
  late final String purchaseId;

  ViewPurchaseViewModel({required this.purchaseId});

  Future<Purchases> getPurchaseById() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final purchases =
        await _purchaseService.getPurchaseById(purchaseId: purchaseId);
    purchase = purchases;
    rebuildUi();
    return purchases;
  }

  Future<bool> deletePurchase(BuildContext context) async {
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
        navigationService.back(result: true);
        rebuildUi();

        return isDeleted;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  Future<bool> archivePurchase(BuildContext context) async {
    final db = await getPurchaseDatabase();
    final db2 = await getPurchaseDatabaseList();
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
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
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
          await db2.delete('purchases');
          await dbPurchaseWeek.delete('purchases_for_week');
          await dbPurchaseMonth.delete('purchases_for_month');
        }
        navigationService.back(result: true);

        rebuildUi();
        return isArchived;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  Future<bool> sendPurchase(BuildContext context) async {
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.send,
        title: 'Send Purchase',
        description:
            "Are you sure you want to share this purchase? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Send'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );
    if (response?.confirmed == true) {
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
        final bool purchaseSent = await _purchaseService.sendPurchase(
            purchaseId: purchaseId, copy: true);
        if (purchaseSent == true) {
          await dialogService.showCustomDialog(
            variant: DialogType.sendSuccess,
            title: 'Sent!',
            description: 'Your purchase has been successfully sent.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok',
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Access denied: Business has no valid subscription',
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
        }
        return purchaseSent;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  void reloadView() async {
    final purchases = await getPurchaseById();
    purchase = purchases;
    rebuildUi();
  }

  void navigateBack() => navigationService.back();
}
