import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/merchant_service.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/add_purchase/add_purchase_view.form.dart';

class AddPurchaseViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _merchantService = locator<MerchantService>();
  final _purchaseService = locator<PurchaseService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyBottomSheet = GlobalKey<FormState>();
  List<Products> selectedPurchaseItems = [];
  List<Products> newlySelectedPurchaseItems = [];
  double total = 0.00;

  DateTime? pickedDate = DateTime.now();

  TextEditingController emailController = TextEditingController();

  List<PurchaseItemDetail> convertProductsToPurchaseItemDetails(
      List<Products> purchaseItems) {
    List<PurchaseItemDetail> purchaseItemDetails = [];

    for (int i = 0; i < purchaseItems.length; i++) {
      Products purchaseitem = purchaseItems[i];
      PurchaseItemDetail purchaseItemDetail = PurchaseItemDetail(
          id: '',
          productId: purchaseitem.id,
          unitPrice: purchaseitem.price,
          index: i + 1,
          quantity: purchaseitem.quantity,
          itemDescription: purchaseitem.productName);
      purchaseItemDetails.add(purchaseItemDetail);
    }

    return purchaseItemDetails;
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

  List<Merchants> merchantList = [];
  List<DropdownMenuItem<String>> merchantdropdownItems = [];
  List<Merchants> newMerchant = [];
  void addselectedItems(List<Products> purchaseItems) {
    if (purchaseItems.isNotEmpty) {
      selectedPurchaseItems.addAll(purchaseItems);
    }
    calculateTotal();
    rebuildUi();
  }

  void removeSelectedItem(Products purchaseItems) {
    selectedPurchaseItems.remove(purchaseItems);
    calculateTotal();
    rebuildUi();
  }

  void openEditBottomSheet(Products purchaseItem) {
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
                      'Edit purchase Item',
                      style: ktsBottomSheetHeaderText,
                    ),
                    verticalSpaceSmallMid,
                    Text('Price', style: ktsFormTitleText),
                    verticalSpaceTiny,
                    TextFormField(
                      cursorColor: kcPrimaryColor,
                      initialValue: purchaseItem.price.toString(),
                      // Handle price input
                      onChanged: (value) {
                        // Update the item price
                        num newPrice = num.tryParse(value) ?? 0;
                        purchaseItem.price = newPrice;
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
                      initialValue: purchaseItem.quantity
                          .toString(), // Set the initial value to quantity
                      // Handle quantity input
                      onChanged: (value) {
                        // Update the item quantity
                        int newQuantity = int.tryParse(value) ?? 1;
                        purchaseItem.quantity = newQuantity;
                      },
                      style: ktsBodyText,
                    ),
                    verticalSpaceSmallMid,
                    GestureDetector(
                      onTap: () {
                        if (formKeyBottomSheet.currentState!.validate()) {
                          calculateTotal();
                          rebuildUi();

                          // Close the bottom sheet
                          Navigator.of(context).pop();
                        }
                      },
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

  void calculateTotal() {
    total = selectedPurchaseItems.fold(0.00, (sum, purchaseItem) {
      return sum + (purchaseItem.price * (purchaseItem.quantity));
    });
  }

  Future<List<Merchants>> getMerchantsByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

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
    rebuildUi();

    return merchants;
  }

  Future<PurchaseCreationResult> runPurchaseCreation() async {
    final prefs = await SharedPreferences.getInstance();
    final businessIdValue = prefs.getString('businessId');
    return _purchaseService.createPurchaseEntry(
        description: descriptionValue ?? '',
        businessId: businessIdValue ?? '',
        purchaseItem:
            convertProductsToPurchaseItemDetails(selectedPurchaseItems),
        transactionDate: transactionDateValue ?? '',
        merchantId: merchantIdValue ?? '');
  }

  Future savePurchaseData(BuildContext context) async {
    final db = await getPurchaseDatabase();
    final db2 = await getPurchaseDatabaseList();
    final dbPurchaseWeek = await getPurchasesForWeekDatabase();
    final dbPurchaseMonth = await getPurchasesForMonthDatabase();
    final result = await runBusyFuture(runPurchaseCreation());

    if (result.purchase != null) {
      await db.delete('purchases');
      await db2.delete('purchases');
      await dbPurchaseWeek.delete('purchases_for_week');
      await dbPurchaseMonth.delete('purchases_for_month');
      // navigate to success route
      navigationService.back(result: true);
      rebuildUi();
      // navigationService.replaceWith(Routes.purchaseView);
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
