import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';

import 'package:verzo/services/expense_service.dart';
import 'package:verzo/ui/common/database_helper.dart';

class ViewExpenseViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final _expenseService = locator<ExpenseService>();
  final DialogService dialogService = locator<DialogService>();

  Expenses? expense;
  late final String expenseId;
  // bool? recurringValue;

  ViewExpenseViewModel({required this.expenseId});

  Future<Expenses> getExpenseById() async {
    final expenses = await _expenseService.getExpenseById(expenseId: expenseId);
    expense = expenses;
    rebuildUi();
    return expenses;
  }

  Future<bool> deleteExpense(BuildContext context) async {
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

      if (isDeleted == true) {
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
        navigationService.back(result: true);
      } else {
        await dialogService.showCustomDialog(
            variant: DialogType.deleteSuccess,
            title: 'Unauthorized!',
            description: "Your expense can't be deleted.",
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
      }

      rebuildUi();
      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> archiveExpense(BuildContext context) async {
    final db = await getExpenseDatabase();
    final db2 = await getExpenseDatabaseList();
    final dbExpenseWeek = await getExpensesForWeekDatabase();
    final dbExpenseMonth = await getExpensesForMonthDatabase();

    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.archive,
        title: 'Archive Expense',
        description:
            "Are you sure you want to archive this expense? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Archive'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );

    if (response?.confirmed == true) {
      final bool isArchived =
          await _expenseService.archiveExpense(expenseId: expenseId);

      if (isArchived == true) {
        await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Archived!',
            description: 'Your expense has been successfully archived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');

        await db.delete('expenses');
        await db2.delete('expenses');
        await dbExpenseWeek.delete('expenses_for_week');
        await dbExpenseMonth.delete('expenses_for_month');
        navigationService.back(result: true);
      } else {
        await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Unauthorized!',
            description: "Your expense can't be archived.",
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
      }

      rebuildUi();
      return isArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  void reloadView() async {
    final expenses = await getExpenseById();
    expense = expenses;
    rebuildUi();
  }

  void navigateBack() => navigationService.back();
}
