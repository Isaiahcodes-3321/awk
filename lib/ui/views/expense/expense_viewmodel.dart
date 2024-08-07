import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/typesense.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ExpenseViewModel extends FutureViewModel<List<Expenses>> {
  final navigationService = locator<NavigationService>();
  final _expenseService = locator<ExpenseService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();
  final TextEditingController searchController = TextEditingController();

  List<Expenses> expenses = []; // Original list of expenses
  List<Expenses> searchResults = [];
  String? timeZone;

  // @override
  // Future<List<Expenses>> futureToRun() => getExpenseByBusiness();

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

  // ExpenseViewModel() {
  //   listenToReactiveValues([allExpenses]);
  // }

  Future<void> _initializeTimeZone() async {
    final prefs = await SharedPreferences.getInstance();
    timeZone = prefs.getString('timeZone') ?? 'UTC';
    tz.initializeTimeZones();
  }

  tz.TZDateTime convertToTimeZone(DateTime utcDate) {
    final location = tz.getLocation(timeZone!);
    return tz.TZDateTime.from(utcDate, location);
  }

  @override
  Future<List<Expenses>> futureToRun() async {
    _initializeTimeZone();
    final db = await getExpenseDatabaseList();

    //retrieveExpensesfromDatabase
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    List<Expenses> expensesFromDatabase;
    if (maps.isNotEmpty) {
      expensesFromDatabase = List.generate(maps.length, (i) {
        return Expenses(
          id: maps[i]['id'],
          description: maps[i]['description'],
          reference: maps[i]['reference'],
          amount: maps[i]['amount'],
          expenseDate: maps[i]['expenseDate'],
          expenseCategoryId: maps[i]['expenseCategoryId'],
          expenseCategoryName: maps[i]['expenseCategoryName'],
          merchantId: maps[i]['merchantId'],
          merchantName: maps[i]['merchantName'],
          expenseStatusId: maps[i]['expenseStatusId'],
          expenseItems: List<ExpenseDetail>.from(
            (jsonDecode(maps[i]['expenseItems']) as List)
                .map((item) => ExpenseDetail.fromMap(item)),
          ),
        );
      });
    } else {
      expensesFromDatabase = [];
    }

    if (expensesFromDatabase != null && expensesFromDatabase.isNotEmpty) {
      // If there are expenses in the database, set them in your ViewModel.
      expenses = expensesFromDatabase;
    } else {
      // If the database is empty, fetch data from your service.
      final expenseList = await getExpenseByBusiness();

      // Save expenses to the SQLite database.
      for (final expense in expenseList) {
        await db.insert(
          'expenses',
          expense.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      // expenses.addAll(expenseList);
      rebuildUi();
    }

    return expenses;
  }

  Future<List<Expenses>> getExpenseByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      expenses = await _expenseService.getExpenseByBusiness(
          businessId: businessIdValue);
    }

    rebuildUi();

    // archivedExpenses = await _expenseService.getArchivedExpenseByBusiness(
    //     businessId: businessIdValue);

    // rebuildUi();

    // allExpenses = [...expenses, ...archivedExpenses];
    // rebuildUi();

    return expenses;
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

    data = searchResults;
    // archivedExpenses = searchResults;
    rebuildUi();
    // return searchResults;
  }

  void reloadExpenseData() async {
    final expenses = await getExpenseByBusiness();
    // Update the data with the new list of purchases
    data = expenses;
    rebuildUi();
  }

  Future<List<Expenses>> reloadExpense() async {
    expenses = await getExpenseByBusiness();
    rebuildUi();
    return expenses;
  }

  Future reload() async {
    runBusyFuture(reloadExpense());
  }

  Future<String> getFormattedExpenseDate(DateTime utcDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final timeZone = prefs.getString('timeZone') ?? 'UTC';
    final location = tz.getLocation(timeZone);
    final localDate = tz.TZDateTime.from(utcDate, location);
    return DateFormat('yyyy-MM-dd – kk:mm').format(localDate);
  }
}
