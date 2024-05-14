import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/ui/common/database_helper.dart';

enum DrawerItem {
  home,
  customers,
  products,
  services,
  settings,
}

enum FilterItems { weekly, monthly }

class HomeViewModel extends ReactiveViewModel with ListenableServiceMixin {
  final navigationService = locator<NavigationService>();
  final _dashboardService = locator<DashboardService>();
  final _expenseService = locator<ExpenseService>();
  final _purchaseService = locator<PurchaseService>();
  final _saleService = locator<SalesService>();
  final DialogService dialogService = locator<DialogService>();

  bool isChecked = true;

  List<BusinessCard> businessCard = [];

  final _expenses = ReactiveValue<List<Expenses>>([]);
  List<Expenses> get expenses => _expenses.value;

  final _take = ReactiveValue<int>(3);
  num get take => _take.value;

  final _purchases = ReactiveValue<List<Purchases>>([]);
  List<Purchases> get purchases => _purchases.value;

  final _invoices = ReactiveValue<List<Sales>>([]);
  List<Sales> get invoices => _invoices.value;

  final _overdueInvoices = ReactiveValue<List<Sales>>([]);
  List<Sales> get overdueInvoices => _overdueInvoices.value;

  final _customers = ReactiveValue<List<Customers>>([]);
  List<Customers> get customers => _customers.value;

  final _expenseForWeek = ReactiveValue<ExpensesForWeek?>(null);
  ExpensesForWeek? get expenseForWeek => _expenseForWeek.value;

  final _purchaseForWeek = ReactiveValue<PurchasesForWeek?>(null);
  PurchasesForWeek? get purchaseForWeek => _purchaseForWeek.value;

  final _weeklyInvoices = ReactiveValue<WeeklyInvoices?>(null);
  WeeklyInvoices? get weeklyInvoices => _weeklyInvoices.value;

  final _expenseForMonth = ReactiveValue<ExpensesForMonth?>(null);
  ExpensesForMonth? get expenseForMonth => _expenseForMonth.value;

  final _purchaseForMonth = ReactiveValue<PurchasesForMonth?>(null);
  PurchasesForMonth? get purchaseForMonth => _purchaseForMonth.value;

  final _monthlyInvoices = ReactiveValue<MonthlyInvoices?>(null);
  MonthlyInvoices? get monthlyInvoices => _monthlyInvoices.value;
  HomeViewModel() {
    listenToReactiveValues([
      _expenses,
      _purchases,
      _invoices,
      _customers,
      _take,
      _expenseForWeek,
      _purchaseForWeek,
      _expenseForMonth,
      _purchaseForMonth,
      _weeklyInvoices,
    ]);
  }

  DrawerItem _selectedItem = DrawerItem.home;

  DrawerItem get selectedItem => _selectedItem;

  void setSelectedItem(DrawerItem item) {
    _selectedItem = item;
    rebuildUi();
  }

  String userName = '';
  String businessName = '';

  void setUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    // Set the form field values based on the selected expense properties
    userName = prefs.getString('userName') ?? '';

    businessName = prefs.getString('businessName') ?? '';
    rebuildUi();
  }

  // User? user; // Store user data here
  // List<Business>? businesses;

  Future<void> getUserAndBusinessData() async {
    final result = await _dashboardService.getUserAndBusinessData();
    // if (result.user != null) {
    //   user = result.user;
    // }
    // if (result.businesses != null) {
    //   businesses = result.businesses;
    // }
    if (result.businesses.isEmpty) {
      navigationService.replaceWith(Routes.businessCreationView);
    }
    rebuildUi();
  }

  Future<List<BusinessCard>> getCardsByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result =
        await _dashboardService.getCardsByBusiness(businessId: businessIdValue);
    businessCard = result;
    rebuildUi();
    return result;
  }

  Future<List<Expenses>> getExpenseByBusiness() async {
    final db = await getExpenseDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

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
      _expenses.value = expensesFromDatabase;
    } else {
      // If the database is empty, fetch data from your service.
      final expenseList = await _expenseService.getExpenseByBusiness(
        businessId: businessIdValue,
        take: _take.value,
      );

      // Save expenses to the SQLite database.
      for (final expense in expenseList) {
        await db.insert(
          'expenses',
          expense.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      _expenses.value.addAll(expenseList);
    }

    rebuildUi();

    return _expenses.value;
  }

  Future<List<Purchases>> getPurchasesByBusiness() async {
    final db = await getPurchaseDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve purchases from the database.
    final List<Map<String, dynamic>> maps = await db.query('purchases');
    List<Purchases> purchasesFromDatabase;

    if (maps.isNotEmpty) {
      purchasesFromDatabase = List.generate(maps.length, (i) {
        return Purchases(
          id: maps[i]['id'],
          transactionDate: maps[i]['transactionDate'],
          description: maps[i]['description'],
          reference: maps[i]['reference'],
          merchantId: maps[i]['merchantId'],
          merchantName: maps[i]['merchantName'],
          merchantEmail: maps[i]['merchantEmail'],
          paid: maps[i]['paid'] == 1 ? true : false,
          total: maps[i]['total'],
          purchaseItems: List<PurchaseItemDetail>.from(
            (jsonDecode(maps[i]['purchaseItems']) as List)
                .map((item) => PurchaseItemDetail.fromMap(item)),
          ),
          purchaseStatusId: maps[i]['purchaseStatusId'],
        );
      });
    } else {
      purchasesFromDatabase = [];
    }

    if (purchasesFromDatabase != null && purchasesFromDatabase.isNotEmpty) {
      // If there are purchases in the database, set them in your ViewModel.
      _purchases.value = purchasesFromDatabase;
    } else {
      // If the database is empty, fetch data from your service.
      final purchaseList = await _purchaseService.getPurchaseByBusiness(
        businessId: businessIdValue,
        take: _take.value,
      );

      // Save purchases to the SQLite database.
      for (final purchase in purchaseList) {
        await db.insert(
          'purchases',
          purchase.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      _purchases.value.addAll(purchaseList);
    }

    rebuildUi();

    return _purchases.value;
  }

  Future<List<Sales>> getInvoiceByBusiness() async {
    final db = await getSalesDatabase2();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing sales data from the database
    final List<Map<String, dynamic>> maps = await db.query('sales');
    List<Sales> salesFromDatabase;

    if (maps.isNotEmpty) {
      salesFromDatabase = List.generate(maps.length, (i) {
        return Sales(
          id: maps[i]['id'],
          description: maps[i]['description'],
          reference: maps[i]['reference'],
          customerName: maps[i]['customerName'],
          subtotal: maps[i]['subtotal'],
          totalAmount: maps[i]['totalAmount'],
          discount: maps[i]['discount'],
          VAT: maps[i]['VAT'],
          dueDate: maps[i]['dueDate'],
          transactionDate: maps[i]['transactionDate'],
          customerId: maps[i]['customerId'],
          overdue: maps[i]['overdue'] == 1, // Convert integer to boolean
          paid: maps[i]['paid'] == 1 ? true : false,
          invoiceDetails: List<ItemDetail>.from(
            (jsonDecode(maps[i]['invoiceDetails']) as List)
                .map((item) => ItemDetail.fromMap(item)),
          ),
          saleServiceExpenses: maps[i]['saleServiceExpenses'] != null
              ? List<SaleServiceExpenseEntry>.from(
                  (jsonDecode(maps[i]['saleServiceExpenses']) as List)
                      .map((entry) => SaleServiceExpenseEntry.fromMap(entry)),
                )
              : null,
          saleExpenses: maps[i]['saleExpenses'] != null
              ? List<SaleExpenses>.from(
                  (jsonDecode(maps[i]['saleExpenses']) as List)
                      .map((expense) => SaleExpenses.fromMap(expense)),
                )
              : null,
          invoiceId: maps[i]['invoiceId'],
          saleStatusId: maps[i]['saleStatusId'],
        );
      });
    } else {
      salesFromDatabase = [];
    }

    if (salesFromDatabase != null && salesFromDatabase.isNotEmpty) {
      // If there are sales data in the database, set them in your ViewModel.
      _invoices.value = salesFromDatabase;
    } else {
      // If the database is empty, fetch data from your service.
      final invoiceList = await _saleService.getSaleByBusiness(
        businessId: businessIdValue,
        take: _take.value,
      );

      // Save sales data to the SQLite database.
      for (final invoice in invoiceList) {
        await db.insert(
          'sales',
          invoice.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      _invoices.value.addAll(invoiceList);
    }

    rebuildUi();

    return _invoices.value;
  }

  // Future<List<Sales>> getOverdueInvoiceByBusiness() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String businessIdValue = prefs.getString('businessId') ?? '';

  //   // Retrieve existing expense categories
  //   final invoiceList = await _saleService.getSaleByBusiness(
  //     businessId: businessIdValue,
  //   );

  //   final overdueInvoiceList =
  //       invoiceList.where((invoice) => invoice.overdue == true).toList();

  //   final limitedOverdueInvoiceList =
  //       overdueInvoiceList.take(_take.value).toList();

  //   _overdueInvoices.value.addAll(limitedOverdueInvoiceList);
  //   rebuildUi();
  //   return _overdueInvoices.value;
  // }

  Future<List<Customers>> getCustomersByBusiness() async {
    final db = await getCustomerDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve customers from the database.
    final List<Map<String, dynamic>> maps = await db.query('customers');
    List<Customers> customersFromDatabase;

    if (maps.isNotEmpty) {
      customersFromDatabase = List.generate(maps.length, (i) {
        return Customers(
          id: maps[i]['id'],
          name: maps[i]['name'],
          email: maps[i]['email'],
          mobile: maps[i]['mobile'],
          address: maps[i]['address'],
          invoiceTotalAmount: maps[i]['invoiceTotalAmount'],
          invoiceCreatedAt: maps[i]['invoiceCreatedAt'],
        );
      });
    } else {
      customersFromDatabase = [];
    }

    if (customersFromDatabase != null && customersFromDatabase.isNotEmpty) {
      // If there are customers in the database, set them in your ViewModel.
      _customers.value = customersFromDatabase;
    } else {
      // If the database is empty, fetch data from your service.
      final customerList = await _saleService.getCustomerByBusiness(
        businessId: businessIdValue,
        take: _take.value,
      );

      // Save customers to the SQLite database.
      for (final customer in customerList) {
        await db.insert(
          'customers',
          customer.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      _customers.value.addAll(customerList);
    }

    rebuildUi();

    return _customers.value;
  }

  // Future<ExpensesForWeek?> getExpensesForWeek() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String businessIdValue = prefs.getString('businessId') ?? '';
  //   _expenseForWeek.value =
  //       await _dashboardService.getExpensesForWeek(businessId: businessIdValue);
  //   return _expenseForWeek.value;
  // }

  Future<ExpensesForWeek?> getExpensesForWeek() async {
    final db = await getExpensesForWeekDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve expenses for the week from the database.
    final List<Map<String, dynamic>> data =
        await db.query('expenses_for_week', limit: 1);

    if (data.isNotEmpty) {
      // If there is data in the database, create an ExpensesForWeek object.
      final Map<String, dynamic> firstRecord = data.first;
      _expenseForWeek.value = ExpensesForWeek(
        totalExpenseAmountThisWeek: firstRecord['totalExpenseAmountThisWeek'],
        percentageOfExpenseToInvoiceThisWeek:
            firstRecord['percentageOfExpenseToInvoiceThisWeek'],
        percentageIncreaseInExpenseThisWeek:
            firstRecord['percentageIncreaseInExpenseThisWeek'],
      );
    } else {
      // If there's no data in the database, fetch data from your service.
      final expensesForWeek = await _dashboardService.getExpensesForWeek(
          businessId: businessIdValue);

      // Save expenses for the week to the SQLite database.
      await db.insert(
        'expenses_for_week',
        expensesForWeek.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _expenseForWeek.value = expensesForWeek;
    }

    return _expenseForWeek.value;
  }

  Future<PurchasesForWeek?> getPurchasesForWeek() async {
    final db = await getPurchasesForWeekDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve purchases for the week from the database.
    final List<Map<String, dynamic>> data =
        await db.query('purchases_for_week', limit: 1);

    if (data.isNotEmpty) {
      // If there is data in the database, create a PurchasesForWeek object.
      final Map<String, dynamic> firstRecord = data.first;
      _purchaseForWeek.value = PurchasesForWeek(
        percentageIncreaseInPurchaseThisWeek:
            firstRecord['percentageIncreaseInPurchaseThisWeek'],
        totalPurchaseAmountThisWeek: firstRecord['totalPurchaseAmountThisWeek'],
        totalPendingPurchaseAmountThisWeek:
            firstRecord['totalPendingPurchaseAmountThisWeek'],
      );
    } else {
      // If there's no data in the database, fetch data from your service.
      final purchasesForWeek = await _dashboardService.getPurchasesForWeek(
          businessId: businessIdValue);

      // Save purchases for the week to the SQLite database.
      await db.insert(
        'purchases_for_week',
        purchasesForWeek.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _purchaseForWeek.value = purchasesForWeek;
    }

    return _purchaseForWeek.value;
  }

  Future<ExpensesForMonth?> getExpensesForMonth() async {
    final db = await getExpensesForMonthDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve expenses for the month from the database.
    final List<Map<String, dynamic>> data =
        await db.query('expenses_for_month', limit: 1);

    if (data.isNotEmpty) {
      // If there is data in the database, create an ExpensesForMonth object.
      final Map<String, dynamic> firstRecord = data.first;
      _expenseForMonth.value = ExpensesForMonth(
        totalExpenseAmountThisMonth: firstRecord['totalExpenseAmountThisMonth'],
        percentageOfExpenseToInvoiceThisMonth:
            firstRecord['percentageOfExpenseToInvoiceThisMonth'],
        percentageIncreaseInExpenseThisMonth:
            firstRecord['percentageIncreaseInExpenseThisMonth'],
      );
    } else {
      // If there's no data in the database, fetch data from your service.
      final expensesForMonth = await _dashboardService.getExpensesForMonth(
          businessId: businessIdValue);

      // Save expenses for the month to the SQLite database.
      await db.insert(
        'expenses_for_month',
        expensesForMonth.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _expenseForMonth.value = expensesForMonth;
    }

    return _expenseForMonth.value;
  }

  Future<PurchasesForMonth?> getPurchasesForMonth() async {
    final db = await getPurchasesForMonthDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve purchases for the month from the database.
    final List<Map<String, dynamic>> data =
        await db.query('purchases_for_month', limit: 1);

    if (data.isNotEmpty) {
      // If there is data in the database, create a PurchasesForMonth object.
      final Map<String, dynamic> firstRecord = data.first;
      _purchaseForMonth.value = PurchasesForMonth(
        percentageIncreaseInPurchaseThisMonth:
            firstRecord['percentageIncreaseInPurchaseThisMonth'],
        totalPurchaseAmountThisMonth:
            firstRecord['totalPurchaseAmountThisMonth'],
        totalPendingPurchaseAmountThisMonth:
            firstRecord['totalPendingPurchaseAmountThisMonth'],
      );
    } else {
      // If there's no data in the database, fetch data from your service.
      final purchasesForMonth = await _dashboardService.getPurchasesForMonth(
          businessId: businessIdValue);

      // Save purchases for the month to the SQLite database.
      await db.insert(
        'purchases_for_month',
        purchasesForMonth.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _purchaseForMonth.value = purchasesForMonth;
    }

    return _purchaseForMonth.value;
  }

  Future<WeeklyInvoices?> totalWeeklyInvoicesAmount() async {
    final db = await getWeeklyInvoicesDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve weekly invoices from the database.
    final List<Map<String, dynamic>> data =
        await db.query('weekly_invoices', limit: 1);

    if (data.isNotEmpty) {
      // If there is data in the database, create a WeeklyInvoices object.
      final Map<String, dynamic> firstRecord = data.first;
      _weeklyInvoices.value = WeeklyInvoices(
        percentageOfIncreaseInInvoicesThisWeek:
            firstRecord['percentageOfIncreaseInInvoicesThisWeek'],
        totalInvoiceAmountForWeek: firstRecord['totalInvoiceAmountForWeek'],
        percentageOfPaidInvoices: firstRecord['percentageOfPaidInvoices'],
        totalPendingInvoiceAmountThisWeek:
            firstRecord['totalPendingInvoiceAmountThisWeek'],
        percentageIncreaseInPendingInvoiceThisWeek:
            firstRecord['percentageIncreaseInPendingInvoiceThisWeek'],
        totalOverDueInvoiceAmountThisWeek:
            firstRecord['totalOverDueInvoiceAmountThisWeek'],
        percentageIncreaseInOverdueInvoicesThisWeek:
            firstRecord['percentageIncreaseInOverdueInvoicesThisWeek'],
      );
    } else {
      // If there's no data in the database, fetch data from your service.
      final weeklyInvoices = await _dashboardService.totalWeeklyInvoicesAmount(
          businessId: businessIdValue);

      // Save weekly invoices to the SQLite database.
      await db.insert(
        'weekly_invoices',
        weeklyInvoices.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _weeklyInvoices.value = weeklyInvoices;
    }

    return _weeklyInvoices.value;
  }

  Future<MonthlyInvoices?> totalMonthlyInvoicesAmount() async {
    final db = await getMonthlyInvoicesDatabase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve monthly invoices from the database.
    final List<Map<String, dynamic>> data =
        await db.query('monthly_invoices', limit: 1);

    if (data.isNotEmpty) {
      // If there is data in the database, create a MonthlyInvoices object.
      final Map<String, dynamic> firstRecord = data.first;
      _monthlyInvoices.value = MonthlyInvoices(
        percentageIncreaseInInvoicesThisMonth:
            firstRecord['percentageIncreaseInInvoicesThisMonth'],
        totalInvoiceAmountForMonth: firstRecord['totalInvoiceAmountForMonth'],
        percentageOfPaidInvoicesForMonth:
            firstRecord['percentageOfPaidInvoicesForMonth'],
        totalPendingInvoiceAmountThisMonth:
            firstRecord['totalPendingInvoiceAmountThisMonth'],
        percentageIncreaseInPendingInvoiceThisMonth:
            firstRecord['percentageIncreaseInPendingInvoiceThisMonth'],
        totalOverDueInvoiceAmountThisMonth:
            firstRecord['totalOverDueInvoiceAmountThisMonth'],
        percentageIncreaseInOverdueInvoicesThisMonth:
            firstRecord['percentageIncreaseInOverdueInvoicesThisMonth'],
      );
    } else {
      // If there's no data in the database, fetch data from your service.
      final monthlyInvoices = await _dashboardService
          .totalMonthlyInvoicesAmount(businessId: businessIdValue);

      // Save monthly invoices to the SQLite database.
      await db.insert(
        'monthly_invoices',
        monthlyInvoices.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _monthlyInvoices.value = monthlyInvoices;
    }

    return _monthlyInvoices.value;
  }
}
