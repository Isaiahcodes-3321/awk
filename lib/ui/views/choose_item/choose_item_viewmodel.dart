import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/products_services_service.dart';

class ChooseItemViewModel extends FutureViewModel<List<Items>> {
  final navigationService = locator<NavigationService>();
  final _productservicesService = locator<ProductsServicesService>();
  final authService = locator<AuthenticationService>();

  List<Items> items = [];
  List<Items> selectedItems = [];

  @override
  Future<List<Items>> futureToRun() => getProductOrServiceByBusiness();
  Future<List<Items>> getProductOrServiceByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }

    // Retrieve existing products/services
    items = await _productservicesService.getProductOrServiceByBusiness(
        businessId: businessIdValue);

    rebuildUi();

    return items;
  }

  void reloadItems() async {
    final items = await getProductOrServiceByBusiness();
    data = items;
    rebuildUi();
  }

  void navigateBack() => navigationService.back();
}
