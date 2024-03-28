import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/services/merchant_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';

class UpdateExpenseViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _expenseService = locator<ExpenseService>();
  final _merchantService = locator<MerchantService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formBottomSheetKey = GlobalKey<FormState>();
  List<Merchants> merchantList = [];
  String selectedMerchantName = '';

  late Expenses expense; // Add selectedExpense variable
  late final String expenseId;
  // bool? recurringValue;

  DateTime? pickedDate = DateTime.now();

  UpdateExpenseViewModel({required this.expenseId});

  Future<Expenses> getExpenseById() async {
    final expenses = await _expenseService.getExpenseById(expenseId: expenseId);
    expense = expenses;
    rebuildUi();
    return expenses;
  }

  Future getExpenseById1() async {
    await runBusyFuture(getExpenseById());
    await runBusyFuture(getMerchantsByBusiness());
    await runBusyFuture(getExpenseCategoryWithSets());
  }

  List<ExpenseDetail> get selectedItems => expenseItems;

  void setSelectedExpense() {
    // Set the form field values based on the selected expense properties
    updateExpenseCategoryIdController.text = expense.expenseCategoryId;
    updateMerchantIdController.text = expense.merchantId;
    updateMerchantEmailController.text = expense.merchantEmail!;
    updateDescriptionController.text = expense.description;
    updateExpenseDateController.text = expense.expenseDate;

    expenseItems = expense.expenseItems;
    // recurringValue = expense.recurring;
    calculateTotal();
    rebuildUi();
  }

  // void setRecurring(bool value) {
  //   recurringValue = value;
  //   notifyListeners();
  // }

  TextEditingController updateDescriptionController = TextEditingController();
  TextEditingController updateExpenseDateController = TextEditingController();
  TextEditingController updateMerchantIdController = TextEditingController();
  TextEditingController updateMerchantEmailController = TextEditingController();
  TextEditingController updateExpenseCategoryIdController =
      TextEditingController();

  List<DropdownMenuItem<String>> expenseCategorydropdownItems = [];
  List<DropdownMenuItem<String>> merchantdropdownItems = [];
  List<Merchants> newMerchant = [];
  List<ExpenseDetail> expenseItems = [];
  // List<ExpenseDetail> newExpenseItems = [];
  double total = 0.00;
  int currentIndex = 0;

  // void addExpenseItem(ExpenseDetail expenseDetail) {
  //   expenseItems.add(expenseDetail);
  //   calculateTotal();
  //   notifyListeners();
  // }

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

  void addExpenseItem(ExpenseDetail expenseDetail) {
    num maxIndex = expenseItems.fold(
        0, (max, item) => item.index > max ? item.index : max);

    // Increment the maxIndex to get the next available index
    maxIndex++;

    // Update the index of the new item and add it to the selectedPurchaseItems list
    expenseDetail.index = maxIndex;
    expenseItems.add(expenseDetail);

    calculateTotal();
    rebuildUi();
  }

  void removeExpenseItem(ExpenseDetail expenseDetail) {
    // Find the index of the expense detail to be removed
    final indexToRemove = expenseItems.indexOf(expenseDetail);

    // If the expense detail is found in the list, remove it
    if (indexToRemove != -1) {
      expenseItems.removeAt(indexToRemove);

      // Update the indexes of the remaining expense details
      for (int i = indexToRemove; i < expenseItems.length; i++) {
        expenseItems[i].index = i + 1;
      }

      calculateTotal();
      rebuildUi();
    }
  }

  void calculateTotal() {
    total = expenseItems.fold(0.00, (sum, expenseItem) {
      return sum + (expenseItem.unitPrice * (expenseItem.quantity));
    });
  }

  Future<List<ExpenseCategory>> getExpenseCategoryWithSets() async {
    final expenseCategories =
        await _expenseService.getExpenseCategoryWithSets();
    expenseCategorydropdownItems = expenseCategories.map((expenseCategory) {
      return DropdownMenuItem<String>(
        value: expenseCategory.id.toString(),
        child: Text(expenseCategory.name),
      );
    }).toList();
    return expenseCategories;
  }

  Future<List<Merchants>> getMerchantsByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('id') ?? '';

// Retrieve existing expense categories
    final merchants = await _merchantService.getMerchantsByBusiness(
        businessId: businessIdValue);
    merchantdropdownItems = merchants.map((merchant) {
      return DropdownMenuItem<String>(
        value: merchant.id.toString(),
        child: Text(merchant.name),
      );
    }).toList();

    merchantList = merchants;

    return merchants;
  }

  void addNewMerchant(List<Merchants> merchant) {
    if (merchant.isNotEmpty) {
      newMerchant.addAll(merchant);
    }
    notifyListeners();
  }

  Future<ExpenseUpdateResult> runExpenseUpdate() async {
    return _expenseService.updateExpenses(
      expenseId: expenseId,
      description: updateDescriptionController.text,
      expenseItem: expenseItems.isNotEmpty ? expenseItems : null,
      expenseCategoryId: updateExpenseCategoryIdController.text,
      merchantId: updateMerchantIdController.text,
      expenseDate: updateExpenseDateController.text,
      // reccuring: recurringValue
    );
  }

  Future updateExpenseData(BuildContext context) async {
    final db = await getExpenseDatabase();
    final dbExpenseWeek = await getExpensesForWeekDatabase();
    final dbExpenseMonth = await getExpensesForMonthDatabase();
    final result = await runBusyFuture(runExpenseUpdate());

    if (result.expense != null) {
      await db.delete('expenses');
      await dbExpenseWeek.delete('expenses_for_week');
      await dbExpenseMonth.delete('expenses_for_month');

      // navigate to success route
      navigationService.replaceWith(Routes.expenseView);
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
}
