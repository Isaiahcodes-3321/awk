import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/dashboard_service.dart';

class EmployeeSettingsViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final dashboardService = locator<DashboardService>();

  final prefs = SharedPreferences.getInstance();
  // bool isPasswordVisible = false;

  String userName = '';
  String userEmail = '';
  String businessName = '';

  void setUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    // Set the form field values based on the selected expense properties
    userName = prefs.getString('userName') ?? '';
    userEmail = prefs.getString('userEmail') ?? '';

    businessName = prefs.getString('businessName') ?? '';
    rebuildUi();
  }
}
