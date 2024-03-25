import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/typesense.dart';

class SalesViewModel extends FutureViewModel<List<Sales>> {
  final navigationService = locator<NavigationService>();
  final _saleService = locator<SalesService>();
  final DialogService dialogService = locator<DialogService>();
  TextEditingController searchController = TextEditingController();

  List<Sales> sales = [];
  List<Sales> archivedSales = [];
  List<Sales> allSales = [];

  List<Sales> searchResults = [];

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
  Future<List<Sales>> futureToRun() => getSaleByBusiness();

  Future<List<Sales>> getSaleByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing expense categories
    sales = await _saleService.getSaleByBusiness(businessId: businessIdValue);
    rebuildUi();

    // Retrieve existing expense categories
    archivedSales = await _saleService.getArchivedSaleByBusiness(
        businessId: businessIdValue);
    rebuildUi();

    // Combine both lists and return
    allSales = [...sales, ...archivedSales];
    rebuildUi();
    return allSales;
  }

  // Future<List<Sales>> getArchivedSaleByBusiness() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String businessIdValue = prefs.getString('businessId') ?? '';

  //   // Retrieve existing expense categories
  //   archivedSales = await _saleService.getArchivedSaleByBusiness(
  //       businessId: businessIdValue);

  //   rebuildUi();

  //   return archivedSales;
  // }

  Future<void> searchSale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    String userIdValue = prefs.getString('userId') ?? '';
    final searchValue = searchController.text;

    // Ensure the search value is not empty4
    if (searchValue.isNotEmpty) {
      try {
        // Call your searchAllCollections function to search expenses
        searchResults =
            await searchSales(searchValue, businessIdValue, userIdValue);
      } catch (error) {
        print('Error searching expenses: $error');
      }
    } else {
      // searchResults =
      //     expenses; // Reset to original list when the search query is empty
    }
    // print(searchResults);

    sales = searchResults;
    archivedSales = searchResults;
    rebuildUi();
    // return searchResults;
  }

  Future<bool> deleteSale(String saleId) async {
    final db = await getSalesDatabase2();
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
        await dbWeeklyInvoices.delete('weekly_invoices');
        await dbMonthlyInvoices.delete('monthly_invoices');
      }

      await reloadSaleData();

      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> archiveSale(String saleId) async {
    final db = await getSalesDatabase2();
    final dbWeeklyInvoices = await getWeeklyInvoicesDatabase();
    final dbMonthlyInvoices = await getMonthlyInvoicesDatabase();

    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.archive,
        title: 'Archive invoice',
        description:
            "Are you sure you want to archive this invoice? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Archive'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );

    if (response?.confirmed == true) {
      final bool isArchived = await _saleService.archiveSale(saleId: saleId);
      if (isArchived) {
        await dialogService.showCustomDialog(
          variant: DialogType.archiveSuccess,
          title: 'Archived!',
          description: 'Your invoice has been successfully archived.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
        await db.delete('sales');
        await dbWeeklyInvoices.delete('weekly_invoices');
        await dbMonthlyInvoices.delete('monthly_invoices');
      }

      await reloadSaleData();

      return isArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> unArchiveSale(String saleId) async {
    final db = await getSalesDatabase2();
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
        await dbWeeklyInvoices.delete('weekly_invoices');
        await dbMonthlyInvoices.delete('monthly_invoices');
      }

      await reloadSaleData();

      return isUnArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<void> reloadSaleData() async {
    final allSales = await getSaleByBusiness();

    // Update the data with the new list of sales
    data = allSales;
    rebuildUi();
  }

  Future<List<Sales>> reloadSale() async {
    allSales = await getSaleByBusiness();
    rebuildUi();
    return allSales;
  }

  Future reload() async {
    runBusyFuture(reloadSale());
  }
}
