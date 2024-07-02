import 'package:flutter/material.dart';
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

class CustomerViewModel extends FutureViewModel<List<Customers>> {
  final navigationService = locator<NavigationService>();
  final _saleService = locator<SalesService>();
  final DialogService dialogService = locator<DialogService>();
  final authService = locator<AuthenticationService>();
  final TextEditingController searchController = TextEditingController();

  List<Customers> customers = []; // Original list of expenses
  List<Customers> searchResults = [];

  bool isSearchActive = false;
  void toggleSearch() {
    isSearchActive = !isSearchActive;
    if (!isSearchActive) {
      // Clear the search controller and reload data if needed
      searchController.clear();
      reloadCustomerData();
    }
    rebuildUi();
  }

  @override
  Future<List<Customers>> futureToRun() async {
    final db = await getCustomerDatabase();

    //retrieveExpensesfromDatabase
    final List<Map<String, dynamic>> maps = await db.query('customers');
    List<Customers> customersFromDatabase;
    if (maps.isNotEmpty) {
      customersFromDatabase = List.generate(maps.length, (i) {
        return Customers(
          id: maps[i]['id'],
          name: maps[i]['name'],
          email: maps[i]['email'],
          mobile: maps[i]['mobile'],
        );
      });
    } else {
      customersFromDatabase = [];
    }

    if (customersFromDatabase != null && customersFromDatabase.isNotEmpty) {
      // If there are expenses in the database, set them in your ViewModel.
      customers = customersFromDatabase;
    } else {
      // If the database is empty, fetch data from your service.
      final customerList = await getCustomersByBusiness();

      // Save expenses to the SQLite database.
      for (final customer in customerList) {
        await db.insert(
          'customers',
          customer.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      // expenses.addAll(expenseList);
      rebuildUi();
    }

    return customers;
  }

  Future<List<Customers>> getCustomersByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      // Retrieve existing customers
      customers =
          await _saleService.getCustomerByBusiness(businessId: businessIdValue);
    }

    rebuildUi();

    return customers;
  }

  Future<void> searchCustomer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    String userIdValue = prefs.getString('userId') ?? '';
    final searchValue = searchController.text;

    // Ensure the search value is not empty4
    if (searchValue.isNotEmpty) {
      try {
        // Call your searchAllCollections function to search expenses
        searchResults =
            await searchCustomers(searchValue, businessIdValue, userIdValue);
      } catch (error) {
        print('Error searching expenses: $error');
      }
    } else {
      // searchResults =
      //     expenses; // Reset to original list when the search query is empty
    }

    data = searchResults;

    rebuildUi();
    // return searchResults;
  }

  Future<void> reloadCustomerData() async {
    final allCustomers = await getCustomersByBusiness();
    // Update the data with the new list of purchases
    data = allCustomers;
    rebuildUi();
  }

  Future<List<Customers>> reloadCustomer() async {
    customers = await getCustomersByBusiness();
    rebuildUi();
    return customers;
  }

  Future reload() async {
    runBusyFuture(reloadCustomer());
  }
}
