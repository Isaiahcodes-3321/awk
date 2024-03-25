import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/database_helper.dart';

class ViewPurchaseViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final _purchaseService = locator<PurchaseService>();
  final DialogService dialogService = locator<DialogService>();

  Purchases? purchase;
  late final String purchaseId;

  ViewPurchaseViewModel({required this.purchaseId});

  Future<Purchases> getPurchaseById() async {
    final purchases =
        await _purchaseService.getPurchaseById(purchaseId: purchaseId);
    purchase = purchases;
    rebuildUi();
    return purchases;
  }

  Future<bool> deletePurchase() async {
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
      navigationService.replaceWith(Routes.purchaseView);

      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> sendPurchase() async {
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
      final bool purchaseSent = await _purchaseService.sendPurchase(
          purchaseId: purchaseId, copy: true);
      if (purchaseSent) {
        await dialogService.showCustomDialog(
          variant: DialogType.sendSuccess,
          title: 'Sent!',
          description: 'Your purchase has been successfully sent.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
      }
      return purchaseSent;
    } else {
      // User canceled the action
      return false;
    }
  }

  void reloadView() async {
    final purchases = await getPurchaseById();
    purchase = purchases;
    rebuildUi();
  }

  void navigateBack() => navigationService.back();
}
