import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/business_creation_service.dart';

class ReportTransactionsViewModel
    extends FutureViewModel<List<BusinessAccountStatement>> {
  final navigationService = locator<NavigationService>();
  final businessCreationService = locator<BusinessCreationService>();
  final authService = locator<AuthenticationService>();
  List<BusinessAccountStatement> businessStatement = [];

  @override
  Future<List<BusinessAccountStatement>> futureToRun() =>
      viewCardTransactions();

  Future<List<BusinessAccountStatement>> viewCardTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      final businessStatement1 = await businessCreationService
          .viewBusinessAccountStatement(businessId: businessIdValue);
      // Reverse the order of the business statements
      businessStatement = businessStatement1.reversed.toList();
    }

    rebuildUi();
    return businessStatement;
  }

  void navigateBack() => navigationService.back();
}
