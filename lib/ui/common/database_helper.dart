import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getExpenseDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'expense_database.db'),
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE expenses(id TEXT PRIMARY KEY, description TEXT, reference TEXT, amount REAL, expenseDate TEXT, expenseCategoryId TEXT, expenseCategoryName TEXT, merchantId TEXT, merchantName TEXT, recurring INTEGER, expenseItems TEXT, expenseStatusId REAL)');
    },
    version: 1,
  );

  return database;
}

Future<Database> getPurchaseDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'purchase_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE purchases(id TEXT PRIMARY KEY, transactionDate TEXT, description TEXT, reference TEXT, merchantId TEXT, merchantName TEXT, merchantEmail TEXT, paid INTEGER, total REAL, purchaseItems TEXT, purchaseStatusId REAL)',
      );
    },
    version: 1,
  );

  return database;
}

// Future<Database> getSalesDatabase() async {
//   final database = openDatabase(
//     join(await getDatabasesPath(), 'sales_database.db'),
//     onCreate: (db, version) {
//       db.execute(
//         'CREATE TABLE sales(id TEXT PRIMARY KEY, description TEXT, reference TEXT, customerName TEXT, subtotal REAL, totalAmount REAL, discount REAL, VAT REAL, dueDate TEXT, paid INTEGER, customerId TEXT, overdue INTEGER, invoiceDetails TEXT, saleServiceExpenses TEXT, saleExpenses TEXT, invoiceId TEXT, saleStatusId REAL)',
//       );
//     },
//     version: 1,
//   );

//   return database;
// }

Future<Database> getSalesDatabase2() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'sales_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE sales(id TEXT PRIMARY KEY, description TEXT, reference TEXT,  paid INTEGER, customerName TEXT, subtotal REAL, totalAmount REAL, discount REAL, VAT REAL, dueDate TEXT, transactionDate TEXT, customerId TEXT, overdue INTEGER, invoiceDetails TEXT, saleServiceExpenses TEXT, saleExpenses TEXT, invoiceId TEXT, saleStatusId REAL)',
      );
    },
    // onUpgrade: (db, oldVersion, newVersion) {
    //   if (oldVersion == 2 && newVersion == 3) {
    //     db.execute('ALTER TABLE sales ADD COLUMN transactionDate TEXT');
    //   }
    // },
    version: 1,
  );

  return database;
}

Future<Database> getCustomerDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'customer_database.db'),
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE customers(id TEXT PRIMARY KEY, name TEXT, email TEXT, mobile TEXT, address TEXT, invoiceTotalAmount REAL, invoiceCreatedAt TEXT)');
    },
    version: 1,
  );

  return database;
}

Future<Database> getExpensesForWeekDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'expenses_for_week_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE expenses_for_week(totalExpenseAmountThisWeek REAL, percentageOfExpenseToInvoiceThisWeek REAL, percentageIncreaseInExpenseThisWeek REAL)',
      );
    },
    version: 1,
  );

  return database;
}

Future<Database> getExpensesForMonthDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'expenses_for_month_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE expenses_for_month(totalExpenseAmountThisMonth REAL, percentageOfExpenseToInvoiceThisMonth REAL, percentageIncreaseInExpenseThisMonth REAL)',
      );
    },
    version: 1,
  );

  return database;
}

Future<Database> getPurchasesForWeekDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'purchases_for_week_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE purchases_for_week(totalPurchaseAmountThisWeek REAL, totalPendingPurchaseAmountThisWeek REAL, percentageIncreaseInPurchaseThisWeek REAL)',
      );
    },
    version: 1,
  );

  return database;
}

Future<Database> getPurchasesForMonthDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'purchases_for_month_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE purchases_for_month(totalPurchaseAmountThisMonth REAL, totalPendingPurchaseAmountThisMonth REAL, percentageIncreaseInPurchaseThisMonth REAL)',
      );
    },
    version: 1,
  );

  return database;
}

Future<Database> getWeeklyInvoicesDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'weekly_invoices_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE weekly_invoices(totalInvoiceAmountForWeek REAL, percentageOfIncreaseInInvoicesThisWeek REAL, percentageOfPaidInvoices REAL, totalPendingInvoiceAmountThisWeek REAL, percentageIncreaseInPendingInvoiceThisWeek REAL, totalOverDueInvoiceAmountThisWeek REAL, percentageIncreaseInOverdueInvoicesThisWeek REAL)',
      );
    },
    version: 1,
  );

  return database;
}

Future<Database> getMonthlyInvoicesDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'monthly_invoices_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE monthly_invoices(totalInvoiceAmountForMonth REAL, percentageIncreaseInInvoicesThisMonth REAL, percentageOfPaidInvoicesForMonth REAL, totalPendingInvoiceAmountThisMonth REAL, percentageIncreaseInPendingInvoiceThisMonth REAL, totalOverDueInvoiceAmountThisMonth REAL, percentageIncreaseInOverdueInvoicesThisMonth REAL)',
      );
    },
    version: 1,
  );

  return database;
}
