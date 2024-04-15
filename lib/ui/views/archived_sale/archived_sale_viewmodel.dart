import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/database_helper.dart';

class ArchivedSaleViewModel extends FutureViewModel<List<Sales>> {
  final navigationService = locator<NavigationService>();
  final _saleService = locator<SalesService>();
  final DialogService dialogService = locator<DialogService>();

  List<Sales> sales = [];

  @override
  Future<List<Sales>> futureToRun() => getArchivedSaleByBusiness();

  Future<List<Sales>> getArchivedSaleByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing expense categories
    sales = await _saleService.getArchivedSaleByBusiness(
        businessId: businessIdValue);
    rebuildUi();
    return sales;
  }

  Future<bool> deleteSale(String saleId) async {
    final db = await getSalesDatabase2();
    final db2 = await getSalesDatabaseList();
    final dbWeeklyInvoices = await getWeeklyInvoicesDatabase();
    final dbMonthlyInvoices = await getMonthlyInvoicesDatabase();

    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.delete,
        title: 'Delete invoice',
        description:
            "Are you sure you want to delete this invoice? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Delete'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );

    if (response?.confirmed == true) {
      final bool isDeleted = await _saleService.deleteSale(saleId: saleId);
      if (isDeleted) {
        await dialogService.showCustomDialog(
          variant: DialogType.deleteSuccess,
          title: 'Deleted!',
          description: 'Your invoice has been successfully deleted.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
        await db.delete('sales');
        await db2.delete('sales');
        await dbWeeklyInvoices.delete('weekly_invoices');
        await dbMonthlyInvoices.delete('monthly_invoices');
      }

      reloadSale();

      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> unArchiveSale(String saleId) async {
    final db = await getSalesDatabase2();
    final db2 = await getSalesDatabaseList();
    final dbWeeklyInvoices = await getWeeklyInvoicesDatabase();
    final dbMonthlyInvoices = await getMonthlyInvoicesDatabase();

    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.archive,
        title: 'Unarchive invoice',
        description:
            "Are you sure you want to unarchive this invoice? It will be visible",
        barrierDismissible: true,
        mainButtonTitle: 'Unarchive'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );

    if (response?.confirmed == true) {
      final bool isUnArchived =
          await _saleService.unarchiveSale(saleId: saleId);
      if (isUnArchived) {
        await dialogService.showCustomDialog(
          variant: DialogType.archiveSuccess,
          title: 'Unarchived!',
          description: 'Your invoice has been successfully unarchived.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
        await db.delete('sales');
        await db2.delete('sales');
        await dbWeeklyInvoices.delete('weekly_invoices');
        await dbMonthlyInvoices.delete('monthly_invoices');
      }

      reloadSale();

      return isUnArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  void reloadSale() async {
    final sale = await getArchivedSaleByBusiness();
    data = sale;
    rebuildUi();
  }

  void navigateBack(BuildContext context) {
    navigationService.back(result: true);
    rebuildUi();
  }
}
