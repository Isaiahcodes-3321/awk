import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

class UpdateSalesViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _saleService = locator<SalesService>();
  final authService = locator<AuthenticationService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyBottomSheet = GlobalKey<FormState>();
  List<Customers> customerList = [];
  List<Services> serviceList = [];
  List<DropdownMenuItem<String>> customerdropdownItems = [];
  List<DropdownMenuItem<String>> servicedropdownItems = [];
  List<SaleExpenses> saleExpenseItems = [];
  List<SaleServiceExpenseEntry> saleServiceExpense = [];
  List<ItemDetail> selectedItems = [];
  List<Items> newlySelectedItems = [];
  double subtotal = 0.00;
  double total = 0.00;
  num saleExpensesAmount = 0.0;
  String selectedCustomerName = '';

  late Sales sale; // Add selectedExpense variable
  late final String saleId;
  // bool? recurringValue;

  DateTime? pickedDate = DateTime.now();

  UpdateSalesViewModel({required this.saleId});

  Future<void> showDatePickerDialog(BuildContext context) async {
    pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime tempPickedDate = DateTime.now();
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.48,
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
        );
      },
    );
    rebuildUi();
  }

  Future<Sales> getSaleById() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final sales = await _saleService.getSaleById(saleId: saleId);
    sale = sales;

    rebuildUi();
    return sales;
  }

  Future getSaleById1() async {
    await runBusyFuture(getSaleById());
    await runBusyFuture(getCustomersByBusiness());
  }

  List<SaleExpenses> get selectedSaleExpenseItem => saleExpenseItems;
  List<SaleServiceExpenseEntry> get selectedSaleServiceExpenseItem =>
      saleServiceExpense;

  void setSelectedSale() {
    // Set the form field values based on the selected expense properties
    updateDueDateController.text = sale.dueDate;
    updateDateOfIssueController.text = sale.transactionDate;
    updateDescriptionController.text = sale.description;
    updateNoteController.text = sale.note!;
    updateCustomerIdController.text = sale.customerId;
    updateCustomerEmailController.text = sale.customerEmail!;

    saleExpenseItems = sale.saleExpenses!;
    saleServiceExpense = sale.saleServiceExpenses!;
    selectedItems = sale.invoiceDetails;
    calculateSubtotal();
    calculateTotal();
    rebuildUi();
  }

  TextEditingController updateDueDateController = TextEditingController();
  TextEditingController updateDateOfIssueController = TextEditingController();
  TextEditingController updateDescriptionController = TextEditingController();
  TextEditingController updateNoteController = TextEditingController();

  TextEditingController updateCustomerIdController = TextEditingController();
  TextEditingController updateCustomerEmailController = TextEditingController();
  TextEditingController updateSelectedCustomerName = TextEditingController();

  Future<List<Customers>> getCustomersByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }

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

  //Items
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

  List<ItemDetail> get selectedItem => selectedItems;

  void addItems(List<ItemDetail> items) {
    if (items.isNotEmpty) {
      // Find the maximum index in the currently selected items
      num maxIndex = selectedItems.fold(
          0, (max, item) => item.index > max ? item.index : max);

      // Increment the maxIndex to get the next available index
      maxIndex++;

      // Update the indexes of the new items and add them to the selectedPurchaseItems list
      for (var item in items) {
        item.index = maxIndex;
        selectedItems.add(item);
        maxIndex++;
      }
    }
    calculateSubtotal();
    calculateTotal();
    rebuildUi();
  }

  void removeItem(ItemDetail items) {
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

  //Sale Expense
  void addSaleExpenseItem(SaleExpenses saleExpense) {
    num maxIndex = saleExpenseItems.fold(
        0, (max, item) => item.index > max ? item.index : max);

    // Increment the maxIndex to get the next available index
    maxIndex++;
    // Update the index of the new item and add it to the selectedPurchaseItems list
    saleExpense.index = maxIndex;
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

  //ServiceExpense
  void addSaleServiceExpenseItem(SaleServiceExpenseEntry serviceExpense) {
    num maxIndex = saleServiceExpense.fold(
        0, (max, item) => item.index > max ? item.index : max);

    // Increment the maxIndex to get the next available index
    maxIndex++;
    // Update the index of the new item and add it to the selectedPurchaseItems list
    serviceExpense.index = maxIndex;
    saleServiceExpense.add(serviceExpense);
    rebuildUi();
  }

  void removeSaleServiceExpenseItem(SaleServiceExpenseEntry serviceExpense) {
    // Find the index of the expense detail to be removed
    final indexToRemove = saleServiceExpense.indexOf(serviceExpense);

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

  Future<SaleUpdateResult> runSalesUpdate() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    return _saleService.updateSales(
        saleId: sale.id,
        description: updateDescriptionController.text,
        note: updateNoteController.text,
        saleExpense: saleExpenseItems.isNotEmpty ? saleExpenseItems : null,
        saleServiceExpense:
            saleServiceExpense.isNotEmpty ? saleServiceExpense : null,
        item: selectedItems,
        customerId: updateCustomerIdController.text,
        dueDate: updateDueDateController.text,
        dateOfIssue: updateDateOfIssueController.text,
        vat: 7.5);
  }

  Future updateSalesData(BuildContext context) async {
    final db = await getSalesDatabase2();
    final db2 = await getSalesDatabaseList();
    final dbWeeklyInvoices = await getWeeklyInvoicesDatabase();
    final dbMonthlyInvoices = await getMonthlyInvoicesDatabase();
    final result = await runBusyFuture(runSalesUpdate());

    if (result.sale != null) {
      await db.delete('sales');
      await db2.delete('sales');
      await dbWeeklyInvoices.delete('weekly_invoices');
      await dbMonthlyInvoices.delete('monthly_invoices');
      // navigate to success route
      navigationService.back(result: true);
      navigationService.back(result: true);
      rebuildUi();
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

  void openEditBottomSheet(ItemDetail item) {
    showModalBottomSheet(
      backgroundColor: kcButtonTextColor,
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
                      initialValue: item.price.toStringAsFixed(0),
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
