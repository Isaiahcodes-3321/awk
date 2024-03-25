import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/merchant_invoice_to_purchase/merchant_invoice_to_purchase_view.form.dart';

class MerchantInvoiceToPurchaseViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _purchaseService = locator<PurchaseService>();
  final DialogService dialogService = locator<DialogService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateTime? pickedDate = DateTime.now();

  late Purchases purchase;

  MerchantInvoiceToPurchaseViewModel({required this.purchase});

  bool _matchValue = false;

  bool get matchValue => _matchValue;

  void setMatch(bool value) {
    _matchValue = value;
    rebuildUi();
  }

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

  Future<PurchaseStatusResult> uploadMerchantInvoiceToPurchase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    final PurchaseStatusResult isUploaded =
        await _purchaseService.uploadMerchantInvoiceToPurchase(
      purchaseId: purchase.id,
      businessId: businessIdValue,
      match: true,
      // match: matchValue,
      invoiceDate: dateValue ?? '',
    );

    purchase.purchaseStatusId = isUploaded.purchaseStatus;
    rebuildUi();

    return isUploaded;
  }

  Future upload(BuildContext context) async {
    final result = await runBusyFuture(uploadMerchantInvoiceToPurchase());

    if (result.isCompleted) {
      // navigationService.back();
      Navigator.pop(context);
    }
  }

  void navigateBack() => navigationService.back();
}
