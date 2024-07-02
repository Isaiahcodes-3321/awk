import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/database_helper.dart';

import 'package:verzo/ui/common/typesense.dart';

class PurchaseViewModel extends FutureViewModel<List<Purchases>> {
  final navigationService = locator<NavigationService>();
  final _purchaseService = locator<PurchaseService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();
  TextEditingController searchController = TextEditingController();

  List<Purchases> purchases = [];
  // List<Purchases> archivedPurchases = [];
  // List<Purchases> allPurchases = [];
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
  Future<List<Purchases>> futureToRun() async {
    final db = await getPurchaseDatabaseList();

    // Retrieve purchases from the database.
    final List<Map<String, dynamic>> maps = await db.query('purchases');
    List<Purchases> purchasesFromDatabase;

    if (maps.isNotEmpty) {
      purchasesFromDatabase = List.generate(maps.length, (i) {
        return Purchases(
          id: maps[i]['id'],
          transactionDate: maps[i]['transactionDate'],
          description: maps[i]['description'],
          reference: maps[i]['reference'],
          merchantId: maps[i]['merchantId'],
          merchantName: maps[i]['merchantName'],
          merchantEmail: maps[i]['merchantEmail'],
          paid: maps[i]['paid'] == 1 ? true : false,
          total: maps[i]['total'],
          purchaseItems: List<PurchaseItemDetail>.from(
            (jsonDecode(maps[i]['purchaseItems']) as List)
                .map((item) => PurchaseItemDetail.fromMap(item)),
          ),
          purchaseStatusId: maps[i]['purchaseStatusId'],
        );
      });
    } else {
      purchasesFromDatabase = [];
    }

    if (purchasesFromDatabase != null && purchasesFromDatabase.isNotEmpty) {
      // If there are purchases in the database, set them in your ViewModel.
      purchases = purchasesFromDatabase;
    } else {
      // If the database is empty, fetch data from your service.
      final purchaseList = await getPurchaseByBusiness();

      // Save purchases to the SQLite database.
      for (final purchase in purchaseList) {
        await db.insert(
          'purchases',
          purchase.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      rebuildUi();
      // purchases.addAll(purchaseList);
    }

    return purchases;
  }

  // @override
  // Future<List<Purchases>> futureToRun() => getPurchaseByBusiness();
  Future<List<Purchases>> getPurchaseByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      // Retrieve existing customers
      purchases = await _purchaseService.getPurchaseByBusiness(
          businessId: businessIdValue);
    }

    rebuildUi();
    return purchases;
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

    data = searchResults;

    rebuildUi();
    // return searchResults;
  }

  Future<void> reloadPurchaseData() async {
    final purchases = await getPurchaseByBusiness();
    // Update the data with the new list of purchases
    data = purchases;
    rebuildUi();
  }

  Future<List<Purchases>> reloadPurchase() async {
    purchases = await getPurchaseByBusiness();
    rebuildUi();
    return purchases;
  }

  Future reload() async {
    runBusyFuture(reloadPurchase());
  }
}
