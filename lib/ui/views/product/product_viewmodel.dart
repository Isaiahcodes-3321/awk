import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/typesense.dart';

class ProductViewModel extends FutureViewModel<List<Products>> {
  final navigationService = locator<NavigationService>();
  final _productservicesService = locator<ProductsServicesService>();
  final DialogService dialogService = locator<DialogService>();
  final TextEditingController searchController = TextEditingController();

  List<Products> products = [];
  List<Products> archiveProducts = [];
  List<Products> allProducts = [];
  List<Products> searchResults = [];

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
  Future<List<Products>> futureToRun() => getProductByBusiness();
  Future<List<Products>> getProductByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing products/services
    products = await _productservicesService.getProductsByBusiness(
        businessId: businessIdValue);

    rebuildUi();

    archiveProducts = await _productservicesService
        .getArchivedProductsByBusiness(businessId: businessIdValue);

    rebuildUi();

    allProducts = [...products, ...archiveProducts];

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

    products = searchResults;
    archiveProducts = searchResults;
    rebuildUi();
    // return searchResults;
  }

  Future<bool> unArchiveProduct(String productId) async {
    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.archive,
      title: 'Unarchive Product',
      description:
          "Are you sure you want to unarchive this product? You can’t undo this action",
      barrierDismissible: true,
      mainButtonTitle: 'Unarchive',
    );

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      // Proceed with archiving if confirmed
      final bool isUnArchived =
          await _productservicesService.unArchiveProduct(productId: productId);

      if (isUnArchived) {
        await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Unarchived!',
            description: 'Your product has been successfully unarchived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
      }

      await reloadProductsData();

      return isUnArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<void> reloadProductsData() async {
    final allProducts = await getProductByBusiness();
    // Update the data with the new list of purchases
    data = allProducts;
    rebuildUi();
  }

  Future<List<Products>> reloadProducts() async {
    allProducts = await getProductByBusiness();
    rebuildUi();
    return allProducts;
  }

  Future reload() async {
    runBusyFuture(reloadProducts());
  }
}
