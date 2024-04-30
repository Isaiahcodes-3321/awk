import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/ui/common/database_helper.dart';

class EmployeeHomeViewModel extends FutureViewModel<List<Expenses>> {
  final navigationService = locator<NavigationService>();
  final _dashboardService = locator<DashboardService>();
  final _expenseService = locator<ExpenseService>();
  final DialogService dialogService = locator<DialogService>();

  String userName = '';
  String businessName = '';

  void setUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    // Set the form field values based on the selected expense properties
    userName = prefs.getString('userName') ?? '';

    businessName = prefs.getString('businessName') ?? '';
    rebuildUi();
  }

  List<Expenses> expenses = [];
  List<BusinessCard> businessCard = [];
  @override
  Future<List<Expenses>> futureToRun() async {
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

  Future<List<BusinessCard>> getUserCardsByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result = await _dashboardService.getUserCardsByBusiness(
        businessId: businessIdValue);
    businessCard = result;
    rebuildUi();
    return result;
  }

  Future<List<Expenses>> getExpenseByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing expense categories
    expenses =
        await _expenseService.getExpenseByBusiness(businessId: businessIdValue);

    rebuildUi();
    return expenses;
  }

  Future<bool> userRequestCard() async {
    final prefs = await SharedPreferences.getInstance();
    final businessId = prefs.getString('businessId') ?? '';
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.card,
        title: 'Request card',
        description:
            "Are you sure you want to request a card? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Request'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );
    if (response?.confirmed == true) {
      final bool isRequested =
          await _dashboardService.userRequestCard(businessId: businessId);

      if (isRequested == true) {
        // await futureToRun();
        await dialogService.showCustomDialog(
          variant: DialogType.cardSuccess,
          title: 'Card request!',
          description:
              'Your card has been successfully requested. Kindly wait for admin confirmation',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
      } else {
        await dialogService.showCustomDialog(
            variant: DialogType.cardSuccess,
            title: 'Card request!',
            description: "Your card hasn't been requested.",
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
      }

      rebuildUi();
      return isRequested;
    } else {
      // User canceled the action
      return false;
    }
  }

  void reloadExpenseData() async {
    final expenses = await getExpenseByBusiness();
    // Update the data with the new list of purchases
    data = expenses;
    rebuildUi();
  }
}
