import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/typesense.dart';

class ProductViewModel extends FutureViewModel<List<Products>> {
  final navigationService = locator<NavigationService>();
  final _productservicesService = locator<ProductsServicesService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();
  final TextEditingController searchController = TextEditingController();

  List<Products> products = [];

  List<Products> searchResults = [];

  bool isSearchActive = false;
  void toggleSearch() {
    isSearchActive = !isSearchActive;
    if (!isSearchActive) {
      // Clear the search controller and reload data if needed
      searchController.clear();
      reloadProductsData();
    }
    rebuildUi();
  }

  @override
  Future<List<Products>> futureToRun() async {
    final db = await getProductDatabase();

    //retrieveExpensesfromDatabase
    final List<Map<String, dynamic>> maps = await db.query('products');
    List<Products> productsFromDatabase;
    if (maps.isNotEmpty) {
      productsFromDatabase = List.generate(maps.length, (i) {
        return Products(
          id: maps[i]['id'],
          productName: maps[i]['productName'],
          price: maps[i]['price'],
          quantity: 1,
          // stockCount: maps[i]['stockCount'],
          // stockStatus: maps[i]['stockStatus']
        );
      });
    } else {
      productsFromDatabase = [];
    }

    if (productsFromDatabase != null && productsFromDatabase.isNotEmpty) {
      // If there are expenses in the database, set them in your ViewModel.
      products = productsFromDatabase;
    } else {
      // If the database is empty, fetch data from your service.
      final productList = await getProductByBusiness();

      // Save expenses to the SQLite database.
      for (final product in productList) {
        await db.insert(
          'products',
          product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      // expenses.addAll(expenseList);
      rebuildUi();
    }

    return products;
  }

  Future<List<Products>> getProductByBusiness() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String businessIdValue = pref.getString('businessId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      // Retrieve existing products/services
      products = await _productservicesService.getProductsByBusiness(
          businessId: businessIdValue);
    }

    rebuildUi();

    return products;
  }

  Future<void> searchProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    String userIdValue = prefs.getString('userId') ?? '';
    final searchValue = searchController.text;

    // Ensure the search value is not empty4
    if (searchValue.isNotEmpty) {
      try {
        // Call your searchAllCollections function to search expenses
        searchResults =
            await searchProducts(searchValue, businessIdValue, userIdValue);
      } catch (error) {
        print('Error searching expenses: $error');
      }
    } else {
      // searchResults =
      //     expenses; // Reset to original list when the search query is empty
    }

    rebuildUi();
    data = searchResults;
    // return searchResults;
  }

  Future<void> reloadProductsData() async {
    final allProducts = await getProductByBusiness();
    // Update the data with the new list of purchases
    data = allProducts;
    rebuildUi();
  }

  Future<List<Products>> reloadProducts() async {
    products = await getProductByBusiness();
    rebuildUi();
    return products;
  }

  Future reload() async {
    runBusyFuture(reloadProducts());
  }
}
