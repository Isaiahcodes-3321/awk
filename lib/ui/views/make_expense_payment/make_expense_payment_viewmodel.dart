import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/views/make_sales_payment/make_sales_payment_view.form.dart';

class MakeExpensePaymentViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _expenseService = locator<ExpenseService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateTime? pickedDate = DateTime.now();

  late Expenses expense;

  MakeExpensePaymentViewModel({required this.expense});

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

  Future<ExpenseStatusResult> makeExpensePayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final ExpenseStatusResult isPayed =
        await _expenseService.makeExpensePayment(
            expenseId: expense.id,
            businessId: businessIdValue,
            description: paymentDescriptionValue ?? '',
            total: expense.amount,
            transactionDate: paymentTransactionDateValue ?? '');

    if (isPayed.isCompleted) {
      // Payment was successful, handle further actions if needed
      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Sucessful!',
          description: 'Payment information successfully saved',
          barrierDismissible: true,
          mainButtonTitle: 'Ok');

      navigateBack();
    }

    expense.expenseStatusId = isPayed.expenseStatus;

    rebuildUi();

    return isPayed;
  }

  Future payment(BuildContext context) async {
    final result = await runBusyFuture(makeExpensePayment());

    if (result.isCompleted) {
      // navigationService.back();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occured, try again later',
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
    }
  }

  void navigateBack() async {
    final db = await getExpenseDatabase();
    final db2 = await getExpenseDatabaseList();

    await db.delete('expenses');
    await db2.delete('expenses');
    rebuildUi();
    await navigationService.back(result: true);
    rebuildUi();
  }
}
