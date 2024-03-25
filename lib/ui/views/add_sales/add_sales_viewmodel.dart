import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/add_sales/add_sales_view.form.dart';

class AddSalesViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _saleService = locator<SalesService>();
  final _serviceService = locator<ProductsServicesService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyBottomSheet = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyBottomSheetSaleExpense =
      GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyBottomSheetSaleServiceExpense =
      GlobalKey<FormState>();
  List<Customers> customerList = [];
  List<Services> serviceList = [];
  List<DropdownMenuItem<String>> customerdropdownItems = [];
  List<DropdownMenuItem<String>> servicedropdownItems = [];

  String selectedServiceName = '';
  List<Items> selectedItems = [];
  List<Items> newlySelectedItems = [];
  List<SaleExpenses> saleExpenseItems = [];
  List<SaleServiceExpenseEntry> saleServiceExpense = [];
  double subtotal = 0.00;
  double total = 0.00;
  num saleExpensesAmount = 0;
  int currentIndex = 0;

  DateTime? pickedDate = DateTime.now();

  Future<void> showDatePickerDialog(BuildContext context) async {
    pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime tempPickedDate = DateTime.now();
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.48,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarViewMode: DatePickerMode.day,
                    currentDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 2),
                    firstDate: DateTime(DateTime.now().year - 2),
                    calendarType: CalendarDatePicker2Type.single,
                    controlsHeight: 50,
                    selectedDayHighlightColor: kcPrimaryColor,

                    // Add more configurations as needed
                  ),
                  onValueChanged: (value) {
                    if (value.isNotEmpty) {
                      // Check if the list is not empty
                      tempPickedDate = value
                          .first!; // Update the temp date with the first item
                    }
                  },
                  value: [],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(tempPickedDate),
                      child: Container(
                        height: 50,
                        // color: kcPrimaryColor,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: kcPrimaryColor,
                        ),
                        child: Text(
                          "Select Date",
                          style: ktsButtonText,
                        ),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
    rebuildUi();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController serviceNameController = TextEditingController();

  Future<List<Services>> getServiceByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing products/services
    final services =
        await _serviceService.getServiceByBusiness(businessId: businessIdValue);

    servicedropdownItems = services.map((service) {
      return DropdownMenuItem<String>(
        value: service.id.toString(),
        child: Text(service.name),
      );
    }).toList();

    serviceList = services;
    rebuildUi();

    return services;
  }

  Future<List<Customers>> getCustomersByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing customers
    final customers =
        await _saleService.getCustomerByBusiness(businessId: businessIdValue);

    customerdropdownItems = customers.map((customer) {
      return DropdownMenuItem<String>(
        value: customer.id.toString(),
        child: Text(customer.name),
      );
    }).toList();
    customerList = customers;
    rebuildUi();

    return customers;
  }

  void addSaleExpenseItem(SaleExpenses saleExpense) {
    currentIndex++; // Increment the index for each new expense detail
    saleExpense.index = currentIndex;
    saleExpenseItems.add(saleExpense);
    calculateTotal();
    rebuildUi();
  }

  void removeSaleExpenseItem(SaleExpenses saleExpense) {
    // Find the index of the expense detail to be removed
    final indexToRemove = saleExpenseItems.indexOf(saleExpense);

    // If the expense detail is found in the list, remove it
    if (indexToRemove != -1) {
      saleExpenseItems.removeAt(indexToRemove);

      // Update the indexes of the remaining expense details
      for (int i = indexToRemove; i < saleExpenseItems.length; i++) {
        saleExpenseItems[i].index = i + 1;
      }

      calculateTotal();

      rebuildUi();
    }
  }

  void addSaleServiceExpense(SaleServiceExpenseEntry saleService) {
    currentIndex++; // Increment the index for each new expense detail
    saleService.index = currentIndex;
    saleServiceExpense.add(saleService);
    rebuildUi();
  }

  void removeSaleServiceExpense(SaleServiceExpenseEntry saleService) {
    // Find the index of the expense detail to be removed
    final indexToRemove = saleServiceExpense.indexOf(saleService);

    // If the expense detail is found in the list, remove it
    if (indexToRemove != -1) {
      saleServiceExpense.removeAt(indexToRemove);

      // Update the indexes of the remaining expense details
      for (int i = indexToRemove; i < saleServiceExpense.length; i++) {
        saleServiceExpense[i].index = i + 1;
      }

      rebuildUi();
    }
  }

  List<ItemDetail> convertItemsToItemDetails(List<Items> items) {
    List<ItemDetail> itemDetails = [];

    for (int i = 0; i < items.length; i++) {
      Items item = items[i];
      ItemDetail itemDetail = ItemDetail(
          id: item.id,
          type: item.type,
          price: item.price,
          index: i + 1,
          quantity: item.quantity,
          name: item.title);
      itemDetails.add(itemDetail);
    }

    return itemDetails;
  }

  void addselectedItems(List<Items> items) {
    if (items.isNotEmpty) {
      selectedItems.addAll(items);
    }
    calculateSubtotal();
    calculateTotal();
    rebuildUi();
  }

  void removeSelectedItem(Items items) {
    selectedItems.remove(items);
    calculateSubtotal();
    calculateTotal();
    rebuildUi();
  }

  void calculateSubtotal() {
    subtotal = selectedItems.fold(0.00, (sum, item) {
      return sum + (item.price * (item.quantity));
    });
    rebuildUi();
  }

  void calculateTotal() {
    double vatAmount = subtotal * (7.5 / 100);

    if (saleExpenseItems.isNotEmpty) {
      saleExpensesAmount = saleExpenseItems
          .map((saleExpense) => saleExpense.amount)
          .reduce((value, element) => value + element);
    } else {
      saleExpensesAmount = 0;
    }
    total = subtotal + vatAmount + saleExpensesAmount;
    rebuildUi();
  }

  Future<SaleCreationResult> runSaleCreation() async {
    final prefs = await SharedPreferences.getInstance();
    final businessIdValue = prefs.getString('businessId');
    return _saleService.createSales(
      saleExpense: saleExpenseItems.isNotEmpty ? saleExpenseItems : null,
      saleServiceExpense:
          saleServiceExpense.isNotEmpty ? saleServiceExpense : null,
      description: descriptionValue ?? '',
      customerId: customerIdValue ?? '',
      businessId: businessIdValue ?? '',
      item: convertItemsToItemDetails(selectedItems),
      dueDate: dueDateValue ?? '',
      dateOfIssue: dateOfIssueValue ?? '',
      vat: 7.5,
    );
  }

  Future saveSalesData(BuildContext context) async {
    final db = await getSalesDatabase2();
    final dbWeeklyInvoices = await getWeeklyInvoicesDatabase();
    final dbMonthlyInvoices = await getMonthlyInvoicesDatabase();
    final result = await runBusyFuture(runSaleCreation());

    if (result.sale != null) {
      await db.delete('sales');
      await dbWeeklyInvoices.delete('weekly_invoices');
      await dbMonthlyInvoices.delete('monthly_invoices');
      // navigate to success route
      navigationService.replaceWith(Routes.salesView);
    } else if (result.error != null) {
      setValidationMessage(result.error?.message);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            validationMessage ?? 'An error occurred, Try again.',
            textAlign: TextAlign.start,
            style: ktsSubtitleTileText2,
          ),
          elevation: 2,
          duration: const Duration(seconds: 3), // Adjust as needed
          backgroundColor: kcErrorColor,
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.fixed,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4))),
          padding: const EdgeInsets.all(12),
          // margin:
          //     EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.9),
        ),
      );
    } else {
      // handle other errors
    }
  }

  void navigateBack() => navigationService.back();
  void navigateTo2() => navigationService.navigateTo(Routes.addSales2View);
  void openEditBottomSheet(Items item) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: navigationService.navigatorKey!.currentContext!,
      builder: (BuildContext context) {
        // num quantity = 1;
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Form(
                key: formKeyBottomSheet,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpaceSmallMid,
                    Text(
                      'Edit item',
                      style: ktsBottomSheetHeaderText,
                    ),
                    verticalSpaceSmallMid,
                    Text('Price', style: ktsFormTitleText),
                    verticalSpaceTiny,
                    TextFormField(
                      cursorColor: kcPrimaryColor,
                      initialValue: item.price.toString(),
                      // Handle price input
                      onChanged: (value) {
                        // Update the item price
                        num newPrice = num.tryParse(value) ?? 0;
                        item.price = newPrice;
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),

                          // border: defaultFormBorder,
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder),
                      // textCapitalization: TextCapitalization.words,
                      style: ktsBodyText,
                      // controller: mobileController,
                      keyboardType: TextInputType.number,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid number';
                        }

                        // Check if the value is not a whole number (non-integer) or is negative
                        final parsedValue = int.tryParse(value);
                        if (parsedValue == null || parsedValue < 0) {
                          return 'Please enter a valid non-negative whole number (integer)';
                        }

                        return null;
                      },
                    ),
                    verticalSpaceSmall,
                    Text('Quantity', style: ktsFormTitleText),
                    verticalSpaceTiny,
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid number';
                        }

                        // Check if the value is not a whole number (non-integer) or is negative
                        final parsedValue = int.tryParse(value);
                        if (parsedValue == null || parsedValue < 0) {
                          return 'Please enter a valid non-negative whole number (integer)';
                        }

                        return null;
                      },
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),

                          // border: defaultFormBorder,
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder),
                      initialValue: item.quantity
                          .toString(), // Set the initial value to quantity
                      // Handle quantity input
                      onChanged: (value) {
                        // Update the item quantity
                        num newQuantity = num.tryParse(value) ?? 1;
                        item.quantity = newQuantity;
                      },
                      style: ktsBodyText,
                    ),
                    verticalSpaceSmallMid,
                    GestureDetector(
                      onTap: () {
                        if (formKeyBottomSheet.currentState!.validate()) {
                          calculateSubtotal();
                          calculateTotal();
                          rebuildUi();

                          // Close the bottom sheet
                          Navigator.of(context).pop();
                        }
                      },
                      // onTap: viewModel.saveMerchantData,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: defaultBorderRadius,
                          color: kcPrimaryColor,
                        ),
                        child: isBusy
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : Text(
                                "Save",
                                style: ktsButtonText,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
