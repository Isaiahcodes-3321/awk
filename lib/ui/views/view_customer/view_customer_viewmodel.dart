import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/sales_service.dart';

class ViewCustomerViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  // final _saleService = locator<SalesService>();

  late Customers customer; // Add selectedExpense variable

  // bool? recurringValue;

  ViewCustomerViewModel({required this.customer});

  // @override
  // void setFormStatus() {

  // }

  // Future<Customers> getExpenseById(String expenseId) async {
  //   final customers =
  //       await _invoiceService.getExpenseById(expenseId: expenseId);
  //   rebuildUi();
  //   return customers;
  // }

  void navigateBack() => navigationService.back();
}
