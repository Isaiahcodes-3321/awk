import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/ui/common/database_helper.dart';

class ArchivedExpenseViewModel extends FutureViewModel<List<Expenses>> {
  final navigationService = locator<NavigationService>();
  final _expenseService = locator<ExpenseService>();
  final DialogService dialogService = locator<DialogService>();

  List<Expenses> expenses = [];

  @override
  Future<List<Expenses>> futureToRun() => getArchivedExpenseByBusiness();

  Future<List<Expenses>> getArchivedExpenseByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing expense categories
    expenses = await _expenseService.getArchivedExpenseByBusiness(
        businessId: businessIdValue);

    rebuildUi();
    return expenses;
  }

  Future<bool> deleteExpense(String expenseId) async {
    final db = await getExpenseDatabase();
    final db2 = await getExpenseDatabaseList();
    final dbExpenseWeek = await getExpensesForWeekDatabase();
    final dbExpenseMonth = await getExpensesForMonthDatabase();
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.delete,
        title: 'Delete Expense',
        description:
            "Are you sure you want to delete this expense? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Delete'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );
    if (response?.confirmed == true) {
      final bool isDeleted =
          await _expenseService.deleteExpense(expenseId: expenseId);

      if (isDeleted) {
        // await futureToRun();
        await dialogService.showCustomDialog(
          variant: DialogType.deleteSuccess,
          title: 'Deleted!',
          description: 'Your expense has been successfully deleted.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
        await db.delete('expenses');
        await db2.delete('expenses');
        await dbExpenseWeek.delete('expenses_for_week');
        await dbExpenseMonth.delete('expenses_for_month');
      }

      reloadExpense();
      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> unArchiveExpense(String expenseId) async {
    final db = await getExpenseDatabase();
    final db2 = await getExpenseDatabaseList();
    final dbExpenseWeek = await getExpensesForWeekDatabase();
    final dbExpenseMonth = await getExpensesForMonthDatabase();

    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.archive,
        title: 'Unarchive Expense',
        description:
            "Are you sure you want to unarchive this expense? It will be visible",
        barrierDismissible: true,
        mainButtonTitle: 'Unarchive'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );

    if (response?.confirmed == true) {
      final bool isUnArchived =
          await _expenseService.unarchiveExpense(expenseId: expenseId);

      if (isUnArchived) {
        await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Unarchived!',
            description: 'Your expense has been successfully unarchived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');

        await db.delete('expenses');
        await db2.delete('expenses');
        await dbExpenseWeek.delete('expenses_for_week');
        await dbExpenseMonth.delete('expenses_for_month');
      }
      reloadExpense();
      return isUnArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  void reloadExpense() async {
    final expense = await getArchivedExpenseByBusiness();
    data = expense;
    rebuildUi();
  }

  void navigateBack(BuildContext context) {
    navigationService.back(result: true);
    rebuildUi();
  }
}
