import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/mark_expense_item_as_received/mark_expense_item_as_received_view.form.dart';

class MarkExpenseItemAsReceivedViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _expenseService = locator<ExpenseService>();
  final DialogService dialogService = locator<DialogService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // List to store form keys for each purchase item
  final List<GlobalKey<FormState>>? expenseItemFormKeys = [];

  DateTime? pickedDate = DateTime.now();

  late Expenses expense;

  MarkExpenseItemAsReceivedViewModel({required this.expense}) {
// Initialize controllers based on the number of purchase items
    for (int i = 0; i < expense.expenseItems.length; i++) {
      expenseItemFormKeys?.add(GlobalKey<FormState>());
      quantityReceivedControllers.add(TextEditingController());
    }
  }

  // List to hold controllers for quantity received
  List<TextEditingController> quantityReceivedControllers = [];

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

  Future<ExpenseStatusResult> markExpenseItemAsRecieved(
      String expenseItemId, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    final ExpenseStatusResult markItemSuccessful =
        await _expenseService.markExpenseItemAsReceived(
            expenseItemId: expenseItemId,
            businessId: businessIdValue,
            quantityReceived:
                int.parse(quantityReceivedControllers[index].text),
            transactionDate: transactionDateValue ?? '');

    if (markItemSuccessful.isCompleted) {
      // Payment was successful, handle further actions if needed
      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Item Confirmed!',
          description: 'Your item has been successfully received',
          barrierDismissible: true,
          mainButtonTitle: 'Ok');

      expense.expenseStatusId = markItemSuccessful.expenseStatus;
    }

    expense.expenseStatusId = markItemSuccessful.expenseStatus;

    rebuildUi();

    return markItemSuccessful;
  }

  void navigateBack() => navigationService.back();
}
