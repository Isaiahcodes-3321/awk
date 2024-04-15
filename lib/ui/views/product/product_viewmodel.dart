import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/typesense.dart';

class ProductViewModel extends FutureViewModel<List<Products>> {
  final navigationService = locator<NavigationService>();
  final _productservicesService = locator<ProductsServicesService>();
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
  Future<List<Products>> futureToRun() => getProductByBusiness();
  Future<List<Products>> getProductByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing products/services
    products = await _productservicesService.getProductsByBusiness(
        businessId: businessIdValue);

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
    // print(searchResults);

    data = searchResults;

    rebuildUi();
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
