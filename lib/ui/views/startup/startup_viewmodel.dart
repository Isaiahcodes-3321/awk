import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/ui/common/database_helper.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dashboardService = locator<DashboardService>();
  final _authenticationService = locator<AuthenticationService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    final dbExpense = await getExpenseDatabase();
    final dbExpense2 = await getExpenseDatabaseList();
    final dbPurchase = await getPurchaseDatabase();
    final dbPurchase2 = await getPurchaseDatabaseList();
    final dbSales = await getSalesDatabase2();
    final dbSales2 = await getSalesDatabaseList();
    final dbCustomers = await getCustomerDatabase();
    final dbProducts = await getProductDatabase();
    final dbServices = await getServiceDatabase();
    final dbExpenseWeek = await getExpensesForWeekDatabase();
    final dbExpenseMonth = await getExpensesForMonthDatabase();
    final dbPurchaseWeek = await getPurchasesForWeekDatabase();
    final dbPurchaseMonth = await getPurchasesForMonthDatabase();
    final dbWeeklyInvoices = await getWeeklyInvoicesDatabase();
    final dbMonthlyInvoices = await getMonthlyInvoicesDatabase();
    // Delete data from the 'expenses' table
    await dbExpense.delete('expenses');
    await dbExpense2.delete('expenses');

    // Delete data from the 'purchases' table
    await dbPurchase.delete('purchases');
    await dbPurchase2.delete('purchases');

    // Delete data from the 'sales' table
    await dbSales.delete('sales');
    await dbSales2.delete('sales');

    // Delete data from the 'customers' table
    await dbCustomers.delete('customers');

    // Delete data from the 'products' table
    await dbProducts.delete('products');

    // Delete data from the 'services' table
    await dbServices.delete('services');

    // Delete data from the 'expenses_for_week' table
    await dbExpenseWeek.delete('expenses_for_week');

    // Delete data from the 'expenses_for_month' table
    await dbExpenseMonth.delete('expenses_for_month');

    // Delete data from the 'purchases_for_week' table
    await dbPurchaseWeek.delete('purchases_for_week');

    // Delete data from the 'purchases_for_month' table
    await dbPurchaseMonth.delete('purchases_for_month');

    // Delete data from the 'weekly_invoices' table
    await dbWeeklyInvoices.delete('weekly_invoices');

    // Delete data from the 'monthly_invoices' table
    await dbMonthlyInvoices.delete('monthly_invoices');
    await Future.delayed(const Duration(seconds: 3));

    if (await _authenticationService.isLoggedIn() == true) {
      final result = await _authenticationService.refreshToken();
      if (result.tokens != null) {
        await getUserAndRoleData();
        // await _navigationService.replaceWith(Routes.homeView);
      } else if (result.error != null) {
        await _navigationService.replaceWithLoginView();
      }
    } else {
      _navigationService.replaceWithLoginView();
    }

    //   // This is where you can make decisions on where your app should navigate when
    //   // you have custom startup logic
    // }
  }

  Future<void> getUserAndRoleData() async {
    final result = await _dashboardService.getUserAndRoleData();

    if (result.roleName != 'Owner') {
      // await getUserAndBusinessData();
      await _navigationService.replaceWith(Routes.employeeHomeView);
    } else {
      // await getUserAndBusinessData();
      // navigate to success route
      await _navigationService.replaceWith(Routes.homeView);
    }
  }
}
