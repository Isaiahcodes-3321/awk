import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/views/home/home_view.dart';

const double _tinySize = 5.0;
const double _smallSize = 10.0;
const double _mediumSize = 25.0;
const double _largeSize = 50.0;
const double _massiveSize = 120.0;

// const Widget horizontalSpaceTiny = SizedBox(width: _tinySize);
// const Widget horizontalSpaceSmall = SizedBox(width: _smallSize);
// const Widget horizontalSpaceMedium = SizedBox(width: _mediumSize);
// const Widget horizontalSpaceLarge = SizedBox(width: _largeSize);

// const Widget verticalSpaceTiny = SizedBox(height: _tinySize);
// const Widget verticalSpaceSmall = SizedBox(height: _smallSize);
// const Widget verticalSpaceMedium = SizedBox(height: _mediumSize);
// const Widget verticalSpaceLarge = SizedBox(height: _largeSize);
// const Widget verticalSpaceMassive = SizedBox(height: _massiveSize);

Widget spacedDivider = const Column(
  children: <Widget>[
    verticalSpaceMedium,
    Divider(color: Colors.blueGrey, height: 5.0),
    verticalSpaceMedium,
  ],
);

Widget verticalSpace(double height) => SizedBox(height: height);

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    min((screenHeight(context) - offsetBy) / dividedBy, max);

double screenWidthFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    min((screenWidth(context) - offsetBy) / dividedBy, max);

double halfScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 2);

double thirdScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 3);

double quarterScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 4);

double getResponsiveHorizontalSpaceMedium(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 10);
double getResponsiveSmallFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 14, max: 15);

double getResponsiveMediumFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 16, max: 17);

double getResponsiveLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 21, max: 31);

double getResponsiveExtraLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 25);

double getResponsiveMassiveFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 30);

double getResponsiveFontSize(BuildContext context,
    {double? fontSize, double? max}) {
  max ??= 100;

  var responsiveSize = min(
      screenWidthFraction(context, dividedBy: 10) * ((fontSize ?? 100) / 100),
      max);

  return responsiveSize;
}

// Horizontal Spacing
const Widget horizontalSpaceminute = SizedBox(
  width: 2,
);
const Widget horizontalSpaceminute2 = SizedBox(
  width: 4,
);
const Widget horizontalSpaceTiny = SizedBox(
  width: 8,
);
const Widget horizontalSpaceSmall = SizedBox(
  width: 16,
);
const Widget horizontalSpaceRegular = SizedBox(
  width: 18,
);
const Widget horizontalSpaceMedium = SizedBox(
  width: 25,
);
const Widget horizontalSpaceLarge = SizedBox(
  width: 50,
);
const Widget horizontalSpaceHeader = SizedBox(
  width: 106,
);
// Vertical Spacing
const Widget verticalSpaceMinute = SizedBox(
  height: 4,
);
const Widget verticalSpaceTinyt1 = SizedBox(
  height: 2,
);
const Widget verticalSpaceTinyt = SizedBox(
  height: 4,
);
const Widget verticalSpaceTiny = SizedBox(
  height: 8,
);

const Widget verticalSpaceTiny1 = SizedBox(
  height: 12,
);
const Widget verticalSpaceSmall = SizedBox(
  height: 18,
);

const Widget verticalSpaceSmallMid = SizedBox(
  height: 24,
);

const Widget verticalSpaceIntermitent = SizedBox(
  height: 36,
);
const Widget verticalSpaceRegular = SizedBox(
  height: 48,
);
const Widget verticalSpaceRegular2 = SizedBox(
  height: 64,
);

const Widget verticalSpaceMedium = SizedBox(
  height: 72,
);
const Widget verticalSpaceLarge = SizedBox(
  height: 128,
);

// Screen Size helpers

double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;

double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;

Future<void> logout() async {
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

  final authenticationService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();
  final navigationService = locator<NavigationService>();
  final DialogResponse? response = await dialogService.showCustomDialog(
    variant: DialogType.logout,
    title: 'Log out?',
    description: 'Are you sure you want to logout?',
    barrierDismissible: true,
    mainButtonTitle: 'Log out',
  );
  if (response?.confirmed == true) {
    final result = await authenticationService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      await authenticationService.logout();
    }

    selectedindex = 0;
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

    navigationService.replaceWith(Routes.loginView);
    // Perform any additional logout actions
  }
}
