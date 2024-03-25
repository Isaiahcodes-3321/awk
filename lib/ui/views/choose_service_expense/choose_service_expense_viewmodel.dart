import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/products_services_service.dart';

class ChooseServiceExpenseViewModel extends FutureViewModel<List<Services>> {
  final navigationService = locator<NavigationService>();
  final _productservicesService = locator<ProductsServicesService>();

  List<Services> serviceExpenses = [];
  List<Services> selectedServiceExpenses = [];
  List<Services> newServiceExpense = [];
  @override
  Future<List<Services>> futureToRun() => getServiceByBusiness();
  Future<List<Services>> getServiceByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing products/services
    final services = await _productservicesService.getServiceByBusiness(
        businessId: businessIdValue);

    rebuildUi();

    return services;
  }

  void addNewItem(List<Services> serviceExpense) {
    if (serviceExpense.isNotEmpty) {
      newServiceExpense.addAll(serviceExpense);
    }

    rebuildUi();
  }

  void navigateBack() => navigationService.back();
}
