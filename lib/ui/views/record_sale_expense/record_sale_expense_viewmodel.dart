import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/record_sale_expense/record_sale_expense_view.form.dart';

class RecordSaleExpenseViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _saleService = locator<SalesService>();
  final DialogService dialogService = locator<DialogService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<GlobalKey<FormState>>? saleExpenseFormKeys = [];
  final List<GlobalKey<FormState>>? saleServiceExpenseFormKeys = [];

  DateTime? pickedDate = DateTime.now();

  late Sales sale;

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

  RecordSaleExpenseViewModel({
    required this.sale,
  }) {
    // Initialize controllers based on the number of purchase items
    for (int i = 0; i < sale.saleExpenses!.length; i++) {
      saleExpenseFormKeys?.add(GlobalKey<FormState>());
      descriptionControllers.add(TextEditingController());
    }

    for (int i = 0; i < sale.saleServiceExpenses!.length; i++) {
      saleServiceExpenseFormKeys?.add(GlobalKey<FormState>());
      saleServiceDescriptionControllers.add(TextEditingController());
    }
  }

  // List to hold controllers for quantity received
  List<TextEditingController> descriptionControllers = [];
  List<TextEditingController> saleServiceDescriptionControllers = [];

  Future<SaleStatusResult> effectSaleExpenseSaleExpense(
      String expenseId, int index, BuildContext context) async {
    final SaleStatusResult effectSaleExpenseSuccessful =
        await _saleService.effectSaleExpense(
            expenseId: expenseId,
            description: descriptionControllers[index].text,
            transactionDate: transactionDateValue ?? '');

    if (effectSaleExpenseSuccessful.isCompleted) {
      // Payment was successful, handle further actions if needed
      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Successful!',
          description: 'Your expense has been successfully effected',
          barrierDismissible: true,
          mainButtonTitle: 'Ok');

      sale.saleStatusId = effectSaleExpenseSuccessful.saleStatus;
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

    sale.saleStatusId = effectSaleExpenseSuccessful.saleStatus;

    rebuildUi();

    return effectSaleExpenseSuccessful;
  }

  Future<SaleStatusResult> effectSaleExpenseSaleServiceExpense(
      String expenseId, int index, BuildContext context) async {
    final SaleStatusResult effectSaleExpenseSuccessful =
        await _saleService.effectSaleExpense(
            expenseId: expenseId,
            description: saleServiceDescriptionControllers[index].text,
            transactionDate: transactionDateValue ?? '');

    if (effectSaleExpenseSuccessful.isCompleted) {
      // Payment was successful, handle further actions if needed
      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Successful!',
          description: 'Your expense has been successfully effected',
          barrierDismissible: true,
          mainButtonTitle: 'Ok');

      sale.saleStatusId = effectSaleExpenseSuccessful.saleStatus;
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

    sale.saleStatusId = effectSaleExpenseSuccessful.saleStatus;

    rebuildUi();

    return effectSaleExpenseSuccessful;
  }
}
