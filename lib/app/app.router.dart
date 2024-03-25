// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i52;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i56;
import 'package:verzo/services/expense_service.dart' as _i54;
import 'package:verzo/services/purchase_service.dart' as _i55;
import 'package:verzo/services/sales_service.dart' as _i53;
import 'package:verzo/ui/views/add_customer/add_customer_view.dart' as _i24;
import 'package:verzo/ui/views/add_expense/add_expense_view.dart' as _i25;
import 'package:verzo/ui/views/add_item/add_item_view.dart' as _i42;
import 'package:verzo/ui/views/add_product/add_product_view.dart' as _i28;
import 'package:verzo/ui/views/add_purchase/add_purchase_view.dart' as _i26;
import 'package:verzo/ui/views/add_purchase_item/add_purchase_item_view.dart'
    as _i48;
import 'package:verzo/ui/views/add_sales/add_sales_view.dart' as _i27;
import 'package:verzo/ui/views/add_sales2/add_sales2_view.dart' as _i41;
import 'package:verzo/ui/views/add_service/add_service_view.dart' as _i39;
import 'package:verzo/ui/views/business_creation/business_creation_view.dart'
    as _i7;
import 'package:verzo/ui/views/business_profile/business_profile_view.dart'
    as _i35;
import 'package:verzo/ui/views/choose_item/choose_item_view.dart' as _i29;
import 'package:verzo/ui/views/choose_purchase_item/choose_purchase_item_view.dart'
    as _i30;
import 'package:verzo/ui/views/choose_service_expense/choose_service_expense_view.dart'
    as _i31;
import 'package:verzo/ui/views/create_account/create_account_view.dart' as _i5;
import 'package:verzo/ui/views/create_customer/create_customer_view.dart'
    as _i32;
import 'package:verzo/ui/views/create_merchant/create_merchant_view.dart'
    as _i33;
import 'package:verzo/ui/views/customer/customer_view.dart' as _i11;
import 'package:verzo/ui/views/expense/expense_view.dart' as _i8;
import 'package:verzo/ui/views/expense_categories/expense_categories_view.dart'
    as _i36;
import 'package:verzo/ui/views/home/home_view.dart' as _i2;
import 'package:verzo/ui/views/login/login_view.dart' as _i4;
import 'package:verzo/ui/views/make_expense_payment/make_expense_payment_view.dart'
    as _i45;
import 'package:verzo/ui/views/make_purchase_payment/make_purchase_payment_view.dart'
    as _i46;
import 'package:verzo/ui/views/make_sales_payment/make_sales_payment_view.dart'
    as _i43;
import 'package:verzo/ui/views/mark_expense_item_as_received/mark_expense_item_as_received_view.dart'
    as _i50;
import 'package:verzo/ui/views/mark_purchase_item_as_received/mark_purchase_item_as_received_view.dart'
    as _i49;
import 'package:verzo/ui/views/merchant_invoice/merchant_invoice_view.dart'
    as _i44;
import 'package:verzo/ui/views/merchant_invoice_to_purchase/merchant_invoice_to_purchase_view.dart'
    as _i47;
import 'package:verzo/ui/views/password/password_view.dart' as _i34;
import 'package:verzo/ui/views/product/product_view.dart' as _i37;
import 'package:verzo/ui/views/profile/profile_view.dart' as _i12;
import 'package:verzo/ui/views/purchase/purchase_view.dart' as _i9;
import 'package:verzo/ui/views/record_sale_expense/record_sale_expense_view.dart'
    as _i51;
import 'package:verzo/ui/views/sales/sales_view.dart' as _i10;
import 'package:verzo/ui/views/service/service_view.dart' as _i38;
import 'package:verzo/ui/views/settings/settings_view.dart' as _i13;
import 'package:verzo/ui/views/startup/startup_view.dart' as _i3;
import 'package:verzo/ui/views/update_customer/update_customer_view.dart'
    as _i22;
import 'package:verzo/ui/views/update_expense/update_expense_view.dart' as _i19;
import 'package:verzo/ui/views/update_product/update_product_view.dart' as _i23;
import 'package:verzo/ui/views/update_purchase/update_purchase_view.dart'
    as _i20;
import 'package:verzo/ui/views/update_sales/update_sales_view.dart' as _i21;
import 'package:verzo/ui/views/update_service/update_service_view.dart' as _i40;
import 'package:verzo/ui/views/verification/verification_view.dart' as _i6;
import 'package:verzo/ui/views/view_customer/view_customer_view.dart' as _i17;
import 'package:verzo/ui/views/view_expense/view_expense_view.dart' as _i14;
import 'package:verzo/ui/views/view_products_services/view_products_services_view.dart'
    as _i18;
import 'package:verzo/ui/views/view_purchase/view_purchase_view.dart' as _i15;
import 'package:verzo/ui/views/view_sales/view_sales_view.dart' as _i16;

class Routes {
  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const loginView = '/';

  static const createAccountView = '/create-account-view';

  static const verificationView = '/verification-view';

  static const businessCreationView = '/business-creation-view';

  static const expenseView = '/expense-view';

  static const purchaseView = '/purchase-view';

  static const salesView = '/sales-view';

  static const customerView = '/customer-view';

  static const profileView = '/profile-view';

  static const settingsView = '/settings-view';

  static const viewExpenseView = '/view-expense-view';

  static const viewPurchaseView = '/view-purchase-view';

  static const viewSalesView = '/view-sales-view';

  static const viewCustomerView = '/view-customer-view';

  static const viewProductsServicesView = '/view-products-services-view';

  static const updateExpenseView = '/update-expense-view';

  static const updatePurchaseView = '/update-purchase-view';

  static const updateSalesView = '/update-sales-view';

  static const updateCustomerView = '/update-customer-view';

  static const updateProductView = '/update-product-view';

  static const addCustomerView = '/add-customer-view';

  static const addExpenseView = '/add-expense-view';

  static const addPurchaseView = '/add-purchase-view';

  static const addSalesView = '/add-sales-view';

  static const addProductView = '/add-product-view';

  static const chooseItemView = '/choose-item-view';

  static const choosePurchaseItemView = '/choose-purchase-item-view';

  static const chooseServiceExpenseView = '/choose-service-expense-view';

  static const createCustomerView = '/create-customer-view';

  static const createMerchantView = '/create-merchant-view';

  static const passwordView = '/password-view';

  static const businessProfileView = '/business-profile-view';

  static const expenseCategoriesView = '/expense-categories-view';

  static const productView = '/product-view';

  static const serviceView = '/service-view';

  static const addServiceView = '/add-service-view';

  static const updateServiceView = '/update-service-view';

  static const addSales2View = '/add-sales2-view';

  static const addItemView = '/add-item-view';

  static const makeSalesPaymentView = '/make-sales-payment-view';

  static const merchantInvoiceView = '/merchant-invoice-view';

  static const makeExpensePaymentView = '/make-expense-payment-view';

  static const makePurchasePaymentView = '/make-purchase-payment-view';

  static const merchantInvoiceToPurchaseView =
      '/merchant-invoice-to-purchase-view';

  static const addPurchaseItemView = '/add-purchase-item-view';

  static const markPurchaseItemAsReceivedView =
      '/mark-purchase-item-as-received-view';

  static const markExpenseItemAsReceivedView =
      '/mark-expense-item-as-received-view';

  static const recordSaleExpenseView = '/record-sale-expense-view';

  static const all = <String>{
    homeView,
    startupView,
    loginView,
    createAccountView,
    verificationView,
    businessCreationView,
    expenseView,
    purchaseView,
    salesView,
    customerView,
    profileView,
    settingsView,
    viewExpenseView,
    viewPurchaseView,
    viewSalesView,
    viewCustomerView,
    viewProductsServicesView,
    updateExpenseView,
    updatePurchaseView,
    updateSalesView,
    updateCustomerView,
    updateProductView,
    addCustomerView,
    addExpenseView,
    addPurchaseView,
    addSalesView,
    addProductView,
    chooseItemView,
    choosePurchaseItemView,
    chooseServiceExpenseView,
    createCustomerView,
    createMerchantView,
    passwordView,
    businessProfileView,
    expenseCategoriesView,
    productView,
    serviceView,
    addServiceView,
    updateServiceView,
    addSales2View,
    addItemView,
    makeSalesPaymentView,
    merchantInvoiceView,
    makeExpensePaymentView,
    makePurchasePaymentView,
    merchantInvoiceToPurchaseView,
    addPurchaseItemView,
    markPurchaseItemAsReceivedView,
    markExpenseItemAsReceivedView,
    recordSaleExpenseView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i3.StartupView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i4.LoginView,
    ),
    _i1.RouteDef(
      Routes.createAccountView,
      page: _i5.CreateAccountView,
    ),
    _i1.RouteDef(
      Routes.verificationView,
      page: _i6.VerificationView,
    ),
    _i1.RouteDef(
      Routes.businessCreationView,
      page: _i7.BusinessCreationView,
    ),
    _i1.RouteDef(
      Routes.expenseView,
      page: _i8.ExpenseView,
    ),
    _i1.RouteDef(
      Routes.purchaseView,
      page: _i9.PurchaseView,
    ),
    _i1.RouteDef(
      Routes.salesView,
      page: _i10.SalesView,
    ),
    _i1.RouteDef(
      Routes.customerView,
      page: _i11.CustomerView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i12.ProfileView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i13.SettingsView,
    ),
    _i1.RouteDef(
      Routes.viewExpenseView,
      page: _i14.ViewExpenseView,
    ),
    _i1.RouteDef(
      Routes.viewPurchaseView,
      page: _i15.ViewPurchaseView,
    ),
    _i1.RouteDef(
      Routes.viewSalesView,
      page: _i16.ViewSalesView,
    ),
    _i1.RouteDef(
      Routes.viewCustomerView,
      page: _i17.ViewCustomerView,
    ),
    _i1.RouteDef(
      Routes.viewProductsServicesView,
      page: _i18.ViewProductsServicesView,
    ),
    _i1.RouteDef(
      Routes.updateExpenseView,
      page: _i19.UpdateExpenseView,
    ),
    _i1.RouteDef(
      Routes.updatePurchaseView,
      page: _i20.UpdatePurchaseView,
    ),
    _i1.RouteDef(
      Routes.updateSalesView,
      page: _i21.UpdateSalesView,
    ),
    _i1.RouteDef(
      Routes.updateCustomerView,
      page: _i22.UpdateCustomerView,
    ),
    _i1.RouteDef(
      Routes.updateProductView,
      page: _i23.UpdateProductView,
    ),
    _i1.RouteDef(
      Routes.addCustomerView,
      page: _i24.AddCustomerView,
    ),
    _i1.RouteDef(
      Routes.addExpenseView,
      page: _i25.AddExpenseView,
    ),
    _i1.RouteDef(
      Routes.addPurchaseView,
      page: _i26.AddPurchaseView,
    ),
    _i1.RouteDef(
      Routes.addSalesView,
      page: _i27.AddSalesView,
    ),
    _i1.RouteDef(
      Routes.addProductView,
      page: _i28.AddProductView,
    ),
    _i1.RouteDef(
      Routes.chooseItemView,
      page: _i29.ChooseItemView,
    ),
    _i1.RouteDef(
      Routes.choosePurchaseItemView,
      page: _i30.ChoosePurchaseItemView,
    ),
    _i1.RouteDef(
      Routes.chooseServiceExpenseView,
      page: _i31.ChooseServiceExpenseView,
    ),
    _i1.RouteDef(
      Routes.createCustomerView,
      page: _i32.CreateCustomerView,
    ),
    _i1.RouteDef(
      Routes.createMerchantView,
      page: _i33.CreateMerchantView,
    ),
    _i1.RouteDef(
      Routes.passwordView,
      page: _i34.PasswordView,
    ),
    _i1.RouteDef(
      Routes.businessProfileView,
      page: _i35.BusinessProfileView,
    ),
    _i1.RouteDef(
      Routes.expenseCategoriesView,
      page: _i36.ExpenseCategoriesView,
    ),
    _i1.RouteDef(
      Routes.productView,
      page: _i37.ProductView,
    ),
    _i1.RouteDef(
      Routes.serviceView,
      page: _i38.ServiceView,
    ),
    _i1.RouteDef(
      Routes.addServiceView,
      page: _i39.AddServiceView,
    ),
    _i1.RouteDef(
      Routes.updateServiceView,
      page: _i40.UpdateServiceView,
    ),
    _i1.RouteDef(
      Routes.addSales2View,
      page: _i41.AddSales2View,
    ),
    _i1.RouteDef(
      Routes.addItemView,
      page: _i42.AddItemView,
    ),
    _i1.RouteDef(
      Routes.makeSalesPaymentView,
      page: _i43.MakeSalesPaymentView,
    ),
    _i1.RouteDef(
      Routes.merchantInvoiceView,
      page: _i44.MerchantInvoiceView,
    ),
    _i1.RouteDef(
      Routes.makeExpensePaymentView,
      page: _i45.MakeExpensePaymentView,
    ),
    _i1.RouteDef(
      Routes.makePurchasePaymentView,
      page: _i46.MakePurchasePaymentView,
    ),
    _i1.RouteDef(
      Routes.merchantInvoiceToPurchaseView,
      page: _i47.MerchantInvoiceToPurchaseView,
    ),
    _i1.RouteDef(
      Routes.addPurchaseItemView,
      page: _i48.AddPurchaseItemView,
    ),
    _i1.RouteDef(
      Routes.markPurchaseItemAsReceivedView,
      page: _i49.MarkPurchaseItemAsReceivedView,
    ),
    _i1.RouteDef(
      Routes.markExpenseItemAsReceivedView,
      page: _i50.MarkExpenseItemAsReceivedView,
    ),
    _i1.RouteDef(
      Routes.recordSaleExpenseView,
      page: _i51.RecordSaleExpenseView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.StartupView(),
        settings: data,
      );
    },
    _i4.LoginView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.LoginView(),
        settings: data,
      );
    },
    _i5.CreateAccountView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.CreateAccountView(),
        settings: data,
      );
    },
    _i6.VerificationView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.VerificationView(),
        settings: data,
      );
    },
    _i7.BusinessCreationView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.BusinessCreationView(),
        settings: data,
      );
    },
    _i8.ExpenseView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.ExpenseView(),
        settings: data,
      );
    },
    _i9.PurchaseView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i9.PurchaseView(),
        settings: data,
      );
    },
    _i10.SalesView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.SalesView(),
        settings: data,
      );
    },
    _i11.CustomerView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i11.CustomerView(),
        settings: data,
      );
    },
    _i12.ProfileView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.ProfileView(),
        settings: data,
      );
    },
    _i13.SettingsView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.SettingsView(),
        settings: data,
      );
    },
    _i14.ViewExpenseView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i14.ViewExpenseView(),
        settings: data,
      );
    },
    _i15.ViewPurchaseView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i15.ViewPurchaseView(),
        settings: data,
      );
    },
    _i16.ViewSalesView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.ViewSalesView(),
        settings: data,
      );
    },
    _i17.ViewCustomerView: (data) {
      final args = data.getArgs<ViewCustomerViewArguments>(nullOk: false);
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => _i17.ViewCustomerView(
            key: args.key, selectedCustomer: args.selectedCustomer),
        settings: data,
      );
    },
    _i18.ViewProductsServicesView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i18.ViewProductsServicesView(),
        settings: data,
      );
    },
    _i19.UpdateExpenseView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i19.UpdateExpenseView(),
        settings: data,
      );
    },
    _i20.UpdatePurchaseView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i20.UpdatePurchaseView(),
        settings: data,
      );
    },
    _i21.UpdateSalesView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i21.UpdateSalesView(),
        settings: data,
      );
    },
    _i22.UpdateCustomerView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i22.UpdateCustomerView(),
        settings: data,
      );
    },
    _i23.UpdateProductView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i23.UpdateProductView(),
        settings: data,
      );
    },
    _i24.AddCustomerView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i24.AddCustomerView(),
        settings: data,
      );
    },
    _i25.AddExpenseView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i25.AddExpenseView(),
        settings: data,
      );
    },
    _i26.AddPurchaseView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i26.AddPurchaseView(),
        settings: data,
      );
    },
    _i27.AddSalesView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i27.AddSalesView(),
        settings: data,
      );
    },
    _i28.AddProductView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i28.AddProductView(),
        settings: data,
      );
    },
    _i29.ChooseItemView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i29.ChooseItemView(),
        settings: data,
      );
    },
    _i30.ChoosePurchaseItemView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i30.ChoosePurchaseItemView(),
        settings: data,
      );
    },
    _i31.ChooseServiceExpenseView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i31.ChooseServiceExpenseView(),
        settings: data,
      );
    },
    _i32.CreateCustomerView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i32.CreateCustomerView(),
        settings: data,
      );
    },
    _i33.CreateMerchantView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i33.CreateMerchantView(),
        settings: data,
      );
    },
    _i34.PasswordView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i34.PasswordView(),
        settings: data,
      );
    },
    _i35.BusinessProfileView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i35.BusinessProfileView(),
        settings: data,
      );
    },
    _i36.ExpenseCategoriesView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i36.ExpenseCategoriesView(),
        settings: data,
      );
    },
    _i37.ProductView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i37.ProductView(),
        settings: data,
      );
    },
    _i38.ServiceView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i38.ServiceView(),
        settings: data,
      );
    },
    _i39.AddServiceView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i39.AddServiceView(),
        settings: data,
      );
    },
    _i40.UpdateServiceView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i40.UpdateServiceView(),
        settings: data,
      );
    },
    _i41.AddSales2View: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i41.AddSales2View(),
        settings: data,
      );
    },
    _i42.AddItemView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i42.AddItemView(),
        settings: data,
      );
    },
    _i43.MakeSalesPaymentView: (data) {
      final args = data.getArgs<MakeSalesPaymentViewArguments>(nullOk: false);
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => _i43.MakeSalesPaymentView(
            key: args.key, selectedSales: args.selectedSales),
        settings: data,
      );
    },
    _i44.MerchantInvoiceView: (data) {
      final args = data.getArgs<MerchantInvoiceViewArguments>(nullOk: false);
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => _i44.MerchantInvoiceView(
            key: args.key, selectedExpense: args.selectedExpense),
        settings: data,
      );
    },
    _i45.MakeExpensePaymentView: (data) {
      final args = data.getArgs<MakeExpensePaymentViewArguments>(nullOk: false);
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => _i45.MakeExpensePaymentView(
            key: args.key, selectedExpense: args.selectedExpense),
        settings: data,
      );
    },
    _i46.MakePurchasePaymentView: (data) {
      final args =
          data.getArgs<MakePurchasePaymentViewArguments>(nullOk: false);
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => _i46.MakePurchasePaymentView(
            key: args.key, selectedPurchase: args.selectedPurchase),
        settings: data,
      );
    },
    _i47.MerchantInvoiceToPurchaseView: (data) {
      final args =
          data.getArgs<MerchantInvoiceToPurchaseViewArguments>(nullOk: false);
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => _i47.MerchantInvoiceToPurchaseView(
            key: args.key, selectedPurchase: args.selectedPurchase),
        settings: data,
      );
    },
    _i48.AddPurchaseItemView: (data) {
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => const _i48.AddPurchaseItemView(),
        settings: data,
      );
    },
    _i49.MarkPurchaseItemAsReceivedView: (data) {
      final args =
          data.getArgs<MarkPurchaseItemAsReceivedViewArguments>(nullOk: false);
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => _i49.MarkPurchaseItemAsReceivedView(
            key: args.key, selectedPurchase: args.selectedPurchase),
        settings: data,
      );
    },
    _i50.MarkExpenseItemAsReceivedView: (data) {
      final args =
          data.getArgs<MarkExpenseItemAsReceivedViewArguments>(nullOk: false);
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => _i50.MarkExpenseItemAsReceivedView(
            key: args.key, selectedExpense: args.selectedExpense),
        settings: data,
      );
    },
    _i51.RecordSaleExpenseView: (data) {
      final args = data.getArgs<RecordSaleExpenseViewArguments>(nullOk: false);
      return _i52.MaterialPageRoute<dynamic>(
        builder: (context) => _i51.RecordSaleExpenseView(
            key: args.key, selectedSale: args.selectedSale),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class ViewCustomerViewArguments {
  const ViewCustomerViewArguments({
    this.key,
    required this.selectedCustomer,
  });

  final _i52.Key? key;

  final _i53.Customers selectedCustomer;

  @override
  String toString() {
    return '{"key": "$key", "selectedCustomer": "$selectedCustomer"}';
  }

  @override
  bool operator ==(covariant ViewCustomerViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedCustomer == selectedCustomer;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedCustomer.hashCode;
  }
}

class MakeSalesPaymentViewArguments {
  const MakeSalesPaymentViewArguments({
    this.key,
    required this.selectedSales,
  });

  final _i52.Key? key;

  final _i53.Sales selectedSales;

  @override
  String toString() {
    return '{"key": "$key", "selectedSales": "$selectedSales"}';
  }

  @override
  bool operator ==(covariant MakeSalesPaymentViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedSales == selectedSales;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedSales.hashCode;
  }
}

class MerchantInvoiceViewArguments {
  const MerchantInvoiceViewArguments({
    this.key,
    required this.selectedExpense,
  });

  final _i52.Key? key;

  final _i54.Expenses selectedExpense;

  @override
  String toString() {
    return '{"key": "$key", "selectedExpense": "$selectedExpense"}';
  }

  @override
  bool operator ==(covariant MerchantInvoiceViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedExpense == selectedExpense;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedExpense.hashCode;
  }
}

class MakeExpensePaymentViewArguments {
  const MakeExpensePaymentViewArguments({
    this.key,
    required this.selectedExpense,
  });

  final _i52.Key? key;

  final _i54.Expenses selectedExpense;

  @override
  String toString() {
    return '{"key": "$key", "selectedExpense": "$selectedExpense"}';
  }

  @override
  bool operator ==(covariant MakeExpensePaymentViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedExpense == selectedExpense;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedExpense.hashCode;
  }
}

class MakePurchasePaymentViewArguments {
  const MakePurchasePaymentViewArguments({
    this.key,
    required this.selectedPurchase,
  });

  final _i52.Key? key;

  final _i55.Purchases selectedPurchase;

  @override
  String toString() {
    return '{"key": "$key", "selectedPurchase": "$selectedPurchase"}';
  }

  @override
  bool operator ==(covariant MakePurchasePaymentViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedPurchase == selectedPurchase;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedPurchase.hashCode;
  }
}

class MerchantInvoiceToPurchaseViewArguments {
  const MerchantInvoiceToPurchaseViewArguments({
    this.key,
    required this.selectedPurchase,
  });

  final _i52.Key? key;

  final _i55.Purchases selectedPurchase;

  @override
  String toString() {
    return '{"key": "$key", "selectedPurchase": "$selectedPurchase"}';
  }

  @override
  bool operator ==(covariant MerchantInvoiceToPurchaseViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedPurchase == selectedPurchase;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedPurchase.hashCode;
  }
}

class MarkPurchaseItemAsReceivedViewArguments {
  const MarkPurchaseItemAsReceivedViewArguments({
    this.key,
    required this.selectedPurchase,
  });

  final _i52.Key? key;

  final _i55.Purchases selectedPurchase;

  @override
  String toString() {
    return '{"key": "$key", "selectedPurchase": "$selectedPurchase"}';
  }

  @override
  bool operator ==(covariant MarkPurchaseItemAsReceivedViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedPurchase == selectedPurchase;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedPurchase.hashCode;
  }
}

class MarkExpenseItemAsReceivedViewArguments {
  const MarkExpenseItemAsReceivedViewArguments({
    this.key,
    required this.selectedExpense,
  });

  final _i52.Key? key;

  final _i54.Expenses selectedExpense;

  @override
  String toString() {
    return '{"key": "$key", "selectedExpense": "$selectedExpense"}';
  }

  @override
  bool operator ==(covariant MarkExpenseItemAsReceivedViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedExpense == selectedExpense;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedExpense.hashCode;
  }
}

class RecordSaleExpenseViewArguments {
  const RecordSaleExpenseViewArguments({
    this.key,
    required this.selectedSale,
  });

  final _i52.Key? key;

  final _i53.Sales selectedSale;

  @override
  String toString() {
    return '{"key": "$key", "selectedSale": "$selectedSale"}';
  }

  @override
  bool operator ==(covariant RecordSaleExpenseViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedSale == selectedSale;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedSale.hashCode;
  }
}

extension NavigatorStateExtension on _i56.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateAccountView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.createAccountView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToVerificationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.verificationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBusinessCreationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.businessCreationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToExpenseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.expenseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPurchaseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.purchaseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSalesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.salesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCustomerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.customerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToViewExpenseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.viewExpenseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToViewPurchaseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.viewPurchaseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToViewSalesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.viewSalesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToViewCustomerView({
    _i52.Key? key,
    required _i53.Customers selectedCustomer,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.viewCustomerView,
        arguments: ViewCustomerViewArguments(
            key: key, selectedCustomer: selectedCustomer),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToViewProductsServicesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.viewProductsServicesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToUpdateExpenseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.updateExpenseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToUpdatePurchaseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.updatePurchaseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToUpdateSalesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.updateSalesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToUpdateCustomerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.updateCustomerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToUpdateProductView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.updateProductView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddCustomerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addCustomerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddExpenseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addExpenseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddPurchaseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addPurchaseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddSalesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addSalesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddProductView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addProductView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChooseItemView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.chooseItemView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChoosePurchaseItemView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.choosePurchaseItemView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChooseServiceExpenseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.chooseServiceExpenseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateCustomerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.createCustomerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateMerchantView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.createMerchantView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPasswordView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.passwordView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBusinessProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.businessProfileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToExpenseCategoriesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.expenseCategoriesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProductView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.productView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.serviceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addServiceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToUpdateServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.updateServiceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddSales2View([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addSales2View,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddItemView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addItemView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMakeSalesPaymentView({
    _i52.Key? key,
    required _i53.Sales selectedSales,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.makeSalesPaymentView,
        arguments: MakeSalesPaymentViewArguments(
            key: key, selectedSales: selectedSales),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMerchantInvoiceView({
    _i52.Key? key,
    required _i54.Expenses selectedExpense,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.merchantInvoiceView,
        arguments: MerchantInvoiceViewArguments(
            key: key, selectedExpense: selectedExpense),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMakeExpensePaymentView({
    _i52.Key? key,
    required _i54.Expenses selectedExpense,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.makeExpensePaymentView,
        arguments: MakeExpensePaymentViewArguments(
            key: key, selectedExpense: selectedExpense),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMakePurchasePaymentView({
    _i52.Key? key,
    required _i55.Purchases selectedPurchase,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.makePurchasePaymentView,
        arguments: MakePurchasePaymentViewArguments(
            key: key, selectedPurchase: selectedPurchase),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMerchantInvoiceToPurchaseView({
    _i52.Key? key,
    required _i55.Purchases selectedPurchase,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.merchantInvoiceToPurchaseView,
        arguments: MerchantInvoiceToPurchaseViewArguments(
            key: key, selectedPurchase: selectedPurchase),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddPurchaseItemView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addPurchaseItemView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMarkPurchaseItemAsReceivedView({
    _i52.Key? key,
    required _i55.Purchases selectedPurchase,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.markPurchaseItemAsReceivedView,
        arguments: MarkPurchaseItemAsReceivedViewArguments(
            key: key, selectedPurchase: selectedPurchase),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMarkExpenseItemAsReceivedView({
    _i52.Key? key,
    required _i54.Expenses selectedExpense,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.markExpenseItemAsReceivedView,
        arguments: MarkExpenseItemAsReceivedViewArguments(
            key: key, selectedExpense: selectedExpense),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRecordSaleExpenseView({
    _i52.Key? key,
    required _i53.Sales selectedSale,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.recordSaleExpenseView,
        arguments: RecordSaleExpenseViewArguments(
            key: key, selectedSale: selectedSale),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreateAccountView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.createAccountView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithVerificationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.verificationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBusinessCreationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.businessCreationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithExpenseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.expenseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPurchaseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.purchaseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSalesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.salesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCustomerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.customerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithViewExpenseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.viewExpenseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithViewPurchaseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.viewPurchaseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithViewSalesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.viewSalesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithViewCustomerView({
    _i52.Key? key,
    required _i53.Customers selectedCustomer,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.viewCustomerView,
        arguments: ViewCustomerViewArguments(
            key: key, selectedCustomer: selectedCustomer),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithViewProductsServicesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.viewProductsServicesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithUpdateExpenseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.updateExpenseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithUpdatePurchaseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.updatePurchaseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithUpdateSalesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.updateSalesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithUpdateCustomerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.updateCustomerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithUpdateProductView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.updateProductView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddCustomerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addCustomerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddExpenseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addExpenseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddPurchaseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addPurchaseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddSalesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addSalesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddProductView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addProductView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithChooseItemView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.chooseItemView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithChoosePurchaseItemView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.choosePurchaseItemView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithChooseServiceExpenseView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.chooseServiceExpenseView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreateCustomerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.createCustomerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreateMerchantView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.createMerchantView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPasswordView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.passwordView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBusinessProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.businessProfileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithExpenseCategoriesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.expenseCategoriesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProductView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.productView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.serviceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addServiceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithUpdateServiceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.updateServiceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddSales2View([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addSales2View,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddItemView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addItemView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMakeSalesPaymentView({
    _i52.Key? key,
    required _i53.Sales selectedSales,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.makeSalesPaymentView,
        arguments: MakeSalesPaymentViewArguments(
            key: key, selectedSales: selectedSales),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMerchantInvoiceView({
    _i52.Key? key,
    required _i54.Expenses selectedExpense,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.merchantInvoiceView,
        arguments: MerchantInvoiceViewArguments(
            key: key, selectedExpense: selectedExpense),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMakeExpensePaymentView({
    _i52.Key? key,
    required _i54.Expenses selectedExpense,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.makeExpensePaymentView,
        arguments: MakeExpensePaymentViewArguments(
            key: key, selectedExpense: selectedExpense),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMakePurchasePaymentView({
    _i52.Key? key,
    required _i55.Purchases selectedPurchase,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.makePurchasePaymentView,
        arguments: MakePurchasePaymentViewArguments(
            key: key, selectedPurchase: selectedPurchase),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMerchantInvoiceToPurchaseView({
    _i52.Key? key,
    required _i55.Purchases selectedPurchase,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.merchantInvoiceToPurchaseView,
        arguments: MerchantInvoiceToPurchaseViewArguments(
            key: key, selectedPurchase: selectedPurchase),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddPurchaseItemView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addPurchaseItemView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMarkPurchaseItemAsReceivedView({
    _i52.Key? key,
    required _i55.Purchases selectedPurchase,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.markPurchaseItemAsReceivedView,
        arguments: MarkPurchaseItemAsReceivedViewArguments(
            key: key, selectedPurchase: selectedPurchase),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMarkExpenseItemAsReceivedView({
    _i52.Key? key,
    required _i54.Expenses selectedExpense,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.markExpenseItemAsReceivedView,
        arguments: MarkExpenseItemAsReceivedViewArguments(
            key: key, selectedExpense: selectedExpense),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRecordSaleExpenseView({
    _i52.Key? key,
    required _i53.Sales selectedSale,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.recordSaleExpenseView,
        arguments: RecordSaleExpenseViewArguments(
            key: key, selectedSale: selectedSale),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
