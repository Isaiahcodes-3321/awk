// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../services/authentication_service.dart';
import '../services/billing_service.dart';
import '../services/business_creation_service.dart';
import '../services/dashboard_service.dart';
import '../services/expense_service.dart';
import '../services/merchant_service.dart';
import '../services/notification_service.dart';
import '../services/products_services_service.dart';
import '../services/purchase_service.dart';
import '../services/sales_service.dart';
import '../services/verification_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => VerificationService());
  locator.registerLazySingleton(() => BusinessCreationService());
  locator.registerLazySingleton(() => DashboardService());
  locator.registerLazySingleton(() => MerchantService());
  locator.registerLazySingleton(() => ExpenseService());
  locator.registerLazySingleton(() => PurchaseService());
  locator.registerLazySingleton(() => SalesService());
  locator.registerLazySingleton(() => ProductsServicesService());
  locator.registerLazySingleton(() => BillingService());
  locator.registerLazySingleton(() => NotificationService());
}
