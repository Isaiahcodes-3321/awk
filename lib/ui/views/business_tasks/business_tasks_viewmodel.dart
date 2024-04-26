import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/business_creation_service.dart';

class BusinessTasksViewModel extends FutureViewModel<List<BusinessTask>> {
  final navigationService = locator<NavigationService>();
  final _businessCreationService = locator<BusinessCreationService>();
  // final DialogService dialogService = locator<DialogService>();

  List<BusinessTask> businessTasks = [];
  @override
  Future<List<BusinessTask>> futureToRun() => getBusinessTasks();

  Future<List<BusinessTask>> getBusinessTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing expense categories
    businessTasks = await _businessCreationService.getBusinessTasks(
        businessId: businessIdValue);

    rebuildUi();
    return businessTasks;
  }

  void navigateBack() => navigationService.back();
}
