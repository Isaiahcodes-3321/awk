import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/verification_service.dart';
import 'package:verzo/services/business_creation_service.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/services/merchant_service.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/services/billing_service.dart';
import 'package:verzo/services/notification_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AuthenticationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<VerificationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BusinessCreationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DashboardService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<MerchantService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ExpenseService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<PurchaseService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SalesService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ProductsServicesService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BillingService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<NotificationService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterAuthenticationService();
  getAndRegisterVerificationService();
  getAndRegisterBusinessCreationService();
  getAndRegisterDashboardService();
  getAndRegisterMerchantService();
  getAndRegisterExpenseService();
  getAndRegisterPurchaseService();
  getAndRegisterSalesService();
  getAndRegisterProductsServicesService();
  getAndRegisterBillingService();
  getAndRegisterNotificationService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) =>
      Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockAuthenticationService getAndRegisterAuthenticationService() {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = MockAuthenticationService();
  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

MockVerificationService getAndRegisterVerificationService() {
  _removeRegistrationIfExists<VerificationService>();
  final service = MockVerificationService();
  locator.registerSingleton<VerificationService>(service);
  return service;
}

MockBusinessCreationService getAndRegisterBusinessCreationService() {
  _removeRegistrationIfExists<BusinessCreationService>();
  final service = MockBusinessCreationService();
  locator.registerSingleton<BusinessCreationService>(service);
  return service;
}

MockDashboardService getAndRegisterDashboardService() {
  _removeRegistrationIfExists<DashboardService>();
  final service = MockDashboardService();
  locator.registerSingleton<DashboardService>(service);
  return service;
}

MockMerchantService getAndRegisterMerchantService() {
  _removeRegistrationIfExists<MerchantService>();
  final service = MockMerchantService();
  locator.registerSingleton<MerchantService>(service);
  return service;
}

MockExpenseService getAndRegisterExpenseService() {
  _removeRegistrationIfExists<ExpenseService>();
  final service = MockExpenseService();
  locator.registerSingleton<ExpenseService>(service);
  return service;
}

MockPurchaseService getAndRegisterPurchaseService() {
  _removeRegistrationIfExists<PurchaseService>();
  final service = MockPurchaseService();
  locator.registerSingleton<PurchaseService>(service);
  return service;
}

MockSalesService getAndRegisterSalesService() {
  _removeRegistrationIfExists<SalesService>();
  final service = MockSalesService();
  locator.registerSingleton<SalesService>(service);
  return service;
}

MockProductsServicesService getAndRegisterProductsServicesService() {
  _removeRegistrationIfExists<ProductsServicesService>();
  final service = MockProductsServicesService();
  locator.registerSingleton<ProductsServicesService>(service);
  return service;
}

MockBillingService getAndRegisterBillingService() {
  _removeRegistrationIfExists<BillingService>();
  final service = MockBillingService();
  locator.registerSingleton<BillingService>(service);
  return service;
}

MockNotificationService getAndRegisterNotificationService() {
  _removeRegistrationIfExists<NotificationService>();
  final service = MockNotificationService();
  locator.registerSingleton<NotificationService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
