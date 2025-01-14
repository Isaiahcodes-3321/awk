import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/products_services_service.dart';

class ChoosePurchaseItemViewModel extends FutureViewModel<List<Products>> {
  final navigationService = locator<NavigationService>();
  final _productservicesService = locator<ProductsServicesService>();
  final authService = locator<AuthenticationService>();

  List<Products> products = [];
  List<Products> selectedItems = [];

  @override
  Future<List<Products>> futureToRun() => getProductByBusiness();
  Future<List<Products>> getProductByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }

    // Retrieve existing products/services
    products = await _productservicesService.getProductsByBusiness(
        businessId: businessIdValue);

    rebuildUi();

    return products;
  }

  void reloadItems() async {
    final items = await getProductByBusiness();
    data = items;
    rebuildUi();
  }

  void navigateBack() => navigationService.back();
}
