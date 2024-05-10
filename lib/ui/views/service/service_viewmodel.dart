import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/typesense.dart';

class ServiceViewModel extends FutureViewModel<List<Services>> {
  final navigationService = locator<NavigationService>();
  final _productservicesService = locator<ProductsServicesService>();
  final DialogService dialogService = locator<DialogService>();
  final TextEditingController searchController = TextEditingController();

  List<Services> services = [];
  List<Services> searchResults = [];

  bool isSearchActive = false;
  void toggleSearch() {
    isSearchActive = !isSearchActive;
    if (!isSearchActive) {
      // Clear the search controller and reload data if needed
      searchController.clear();
      reloadServiceData();
    }
    rebuildUi();
  }

  @override
  Future<List<Services>> futureToRun() async {
    final db = await getServiceDatabase();

    //retrieveExpensesfromDatabase
    final List<Map<String, dynamic>> maps = await db.query('services');
    List<Services> servicesFromDatabase;
    if (maps.isNotEmpty) {
      servicesFromDatabase = List.generate(maps.length, (i) {
        return Services(
          id: maps[i]['id'],
          name: maps[i]['name'],
          price: maps[i]['price'],
        );
      });
    } else {
      servicesFromDatabase = [];
    }

    if (servicesFromDatabase != null && servicesFromDatabase.isNotEmpty) {
      // If there are expenses in the database, set them in your ViewModel.
      services = servicesFromDatabase;
    } else {
      // If the database is empty, fetch data from your service.
      final serviceList = await getServiceByBusiness();

      // Save expenses to the SQLite database.
      for (final service in serviceList) {
        await db.insert(
          'services',
          service.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      // expenses.addAll(expenseList);
      rebuildUi();
    }

    return services;
  }

  Future<List<Services>> getServiceByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing products/services
    services = await _productservicesService.getServiceByBusiness(
        businessId: businessIdValue);

    rebuildUi();

    return services;
  }

  Future<void> searchService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    String userIdValue = prefs.getString('userId') ?? '';
    final searchValue = searchController.text;

    // Ensure the search value is not empty4
    if (searchValue.isNotEmpty) {
      try {
        // Call your searchAllCollections function to search expenses
        searchResults =
            await searchServices(searchValue, businessIdValue, userIdValue);
      } catch (error) {
        print('Error searching expenses: $error');
      }
    } else {
      // searchResults =
      //     expenses; // Reset to original list when the search query is empty
    }
    // print(searchResults);

    data = searchResults;

    rebuildUi();
    // return searchResults;
  }

  Future<void> reloadServiceData() async {
    final allServices = await getServiceByBusiness();
    // Update the data with the new list of purchases
    data = allServices;
    rebuildUi();
  }

  Future<List<Services>> reloadService() async {
    services = await getServiceByBusiness();
    rebuildUi();
    return services;
  }

  Future reload() async {
    runBusyFuture(reloadService());
  }
}
