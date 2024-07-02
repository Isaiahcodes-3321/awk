import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/typesense.dart';

class SalesViewModel extends FutureViewModel<List<Sales>> {
  final navigationService = locator<NavigationService>();
  final _saleService = locator<SalesService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();
  TextEditingController searchController = TextEditingController();

  List<Sales> sales = [];
  // List<Sales> archivedSales = [];
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
  Future<List<Sales>> futureToRun() async {
    final db = await getSalesDatabaseList();

    // Retrieve existing sales data from the database
    final List<Map<String, dynamic>> maps = await db.query('sales');
    List<Sales> salesFromDatabase;

    if (maps.isNotEmpty) {
      salesFromDatabase = List.generate(maps.length, (i) {
        return Sales(
          id: maps[i]['id'],
          description: maps[i]['description'],
          reference: maps[i]['reference'],
          customerName: maps[i]['customerName'],
          subtotal: maps[i]['subtotal'],
          totalAmount: maps[i]['totalAmount'],
          discount: maps[i]['discount'],
          VAT: maps[i]['VAT'],
          dueDate: maps[i]['dueDate'],
          transactionDate: maps[i]['transactionDate'],
          customerId: maps[i]['customerId'],
          overdue: maps[i]['overdue'] == 1, // Convert integer to boolean
          paid: maps[i]['paid'] == 1 ? true : false,
          invoiceDetails: List<ItemDetail>.from(
            (jsonDecode(maps[i]['invoiceDetails']) as List)
                .map((item) => ItemDetail.fromMap(item)),
          ),
          saleServiceExpenses: maps[i]['saleServiceExpenses'] != null
              ? List<SaleServiceExpenseEntry>.from(
                  (jsonDecode(maps[i]['saleServiceExpenses']) as List)
                      .map((entry) => SaleServiceExpenseEntry.fromMap(entry)),
                )
              : null,
          saleExpenses: maps[i]['saleExpenses'] != null
              ? List<SaleExpenses>.from(
                  (jsonDecode(maps[i]['saleExpenses']) as List)
                      .map((expense) => SaleExpenses.fromMap(expense)),
                )
              : null,
          invoiceId: maps[i]['invoiceId'],
          saleStatusId: maps[i]['saleStatusId'],
        );
      });
    } else {
      salesFromDatabase = [];
    }

    if (salesFromDatabase != null && salesFromDatabase.isNotEmpty) {
      // If there are sales data in the database, set them in your ViewModel.
      sales = salesFromDatabase;
    } else {
      // If the database is empty, fetch data from your service.
      final invoiceList = await getSaleByBusiness();

      // Save sales data to the SQLite database.
      for (final invoice in invoiceList) {
        await db.insert(
          'sales',
          invoice.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      rebuildUi();
      // _invoices.value.addAll(invoiceList);
    }

    return sales;
  }

  // @override
  // Future<List<Sales>> futureToRun() => getSaleByBusiness();

  Future<List<Sales>> getSaleByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      sales = await _saleService.getSaleByBusiness(businessId: businessIdValue);
      rebuildUi();
    }
    // Retrieve existing expense categories

    rebuildUi();
    return sales;
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

    data = searchResults;
    // archivedSales = searchResults;
    rebuildUi();
    // return searchResults;
  }

  void reloadSaleData() async {
    final sales = await getSaleByBusiness();

    // Update the data with the new list of sales
    data = sales;
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
