import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/expense_service.dart';

class ExpenseCategoriesViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final expenseService = locator<ExpenseService>();

  List<String> expenseCategoryList = [];

  Future<List<ExpenseCategory>> getExpenseCategoryWithSets() async {
    final expenseCategories = await expenseService.getExpenseCategoryWithSets();
    expenseCategoryList = expenseCategories.map((expenseCategory) {
      return expenseCategory.name;
    }).toList();
    rebuildUi();
    return expenseCategories;
  }

  void navigateBack() => navigationService.back();
}
