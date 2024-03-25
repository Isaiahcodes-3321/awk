import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/dashboard_service.dart';

class SettingsViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final dashboardService = locator<DashboardService>();

  final prefs = SharedPreferences.getInstance();
  bool isPasswordVisible = false;

  String userName = '';
  String businessName = '';

  void setUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    // Set the form field values based on the selected expense properties
    userName = prefs.getString('userName') ?? '';

    businessName = prefs.getString('businessName') ?? '';
    rebuildUi();
  }

  Future<void> getUserAndBusinessData() async {
    final result = await dashboardService.getUserAndBusinessData();
    // if (result.user != null) {
    //   user = result.user;
    // }
    // if (result.businesses != null) {
    //   businesses = result.businesses;
    // }
    rebuildUi();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    rebuildUi();
  }
}
