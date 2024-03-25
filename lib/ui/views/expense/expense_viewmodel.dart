import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/typesense.dart';

class ExpenseViewModel extends FutureViewModel<List<Expenses>> {
  final navigationService = locator<NavigationService>();
  final _expenseService = locator<ExpenseService>();
  final DialogService dialogService = locator<DialogService>();
  final TextEditingController searchController = TextEditingController();

  List<Expenses> expenses = []; // Original list of expenses
  List<Expenses> archivedExpenses = []; // Original list of expenses
  List<Expenses> allExpenses = []; // Original list of expenses
  List<Expenses> searchResults = [];

  bool isSearchActive = false;
  void toggleSearch() {
    isSearchActive = !isSearchActive;
    if (!isSearchActive) {
      // Clear the search controller and reload data if needed
      searchController.clear();
      reload();
    }
    rebuildUi();
  }

  @override
  Future<List<Expenses>> futureToRun() => getExpenseByBusiness();
  Future<List<Expenses>> getExpenseByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing expense categories
    expenses =
        await _expenseService.getExpenseByBusiness(businessId: businessIdValue);

    rebuildUi();

    archivedExpenses = await _expenseService.getArchivedExpenseByBusiness(
        businessId: businessIdValue);

    rebuildUi();

    allExpenses = [...expenses, ...archivedExpenses];
    rebuildUi();
    return allExpenses;
  }

  // Add a function to perform the search
  Future<void> searchExpense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    String userIdValue = prefs.getString('userId') ?? '';
    final searchValue = searchController.text;

    // Ensure the search value is not empty4
    if (searchValue.isNotEmpty) {
      try {
        // Call your searchAllCollections function to search expenses
        searchResults =
            await searchExpenses(searchValue, businessIdValue, userIdValue);
      } catch (error) {
        print('Error searching expenses: $error');
      }
    } else {
      // searchResults =
      //     expenses; // Reset to original list when the search query is empty
    }
    // print(searchResults);

    expenses = searchResults;
    archivedExpenses = searchResults;
    rebuildUi();
    // return searchResults;
  }

  Future<bool> deleteExpense(String expenseId) async {
    final db = await getExpenseDatabase();
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
        await dbExpenseWeek.delete('expenses_for_week');
        await dbExpenseMonth.delete('expenses_for_month');
      }

      await reloadExpenseData();
      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> archiveExpense(String expenseId) async {
    final db = await getExpenseDatabase();
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

      if (isArchived) {
        await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Archived!',
            description: 'Your expense has been successfully archived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');

        await db.delete('expenses');
        await dbExpenseWeek.delete('expenses_for_week');
        await dbExpenseMonth.delete('expenses_for_month');
      }
      await reloadExpenseData();
      return isArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> unArchiveExpense(String expenseId) async {
    final db = await getExpenseDatabase();
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
        await dbExpenseWeek.delete('expenses_for_week');
        await dbExpenseMonth.delete('expenses_for_month');
      }
      await reloadExpenseData();
      return isUnArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<void> reloadExpenseData() async {
    final allExpenses = await getExpenseByBusiness();
    // Update the data with the new list of purchases
    data = allExpenses;
    rebuildUi();
  }

  Future<List<Expenses>> reloadExpense() async {
    allExpenses = await getExpenseByBusiness();
    rebuildUi();
    return allExpenses;
  }

  Future reload() async {
    runBusyFuture(reloadExpense());
  }
}
