import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/merchant_service.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

class UpdatePurchaseViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _purchaseService = locator<PurchaseService>();
  final _merchantService = locator<MerchantService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyBottomSheet = GlobalKey<FormState>();

  String selectedMerchantName = '';

  late Purchases purchase;
  late final String purchaseId;

  DateTime? pickedDate = DateTime.now();

  UpdatePurchaseViewModel({required this.purchaseId});

  Future<Purchases> getPurchaseById() async {
    final purchases =
        await _purchaseService.getPurchaseById(purchaseId: purchaseId);
    purchase = purchases;
    rebuildUi();
    return purchases;
  }

  Future getPurchaseById1() async {
    await runBusyFuture(getPurchaseById());
    await runBusyFuture(getMerchantsByBusiness());
  }

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

  List<PurchaseItemDetail> get selectedItems => selectedPurchaseItems;

  void setSelectedPurchase() {
    // Set the form field values based on the selected expense properties
    updateDescriptionController.text = purchase.description;
    updateMerchantIdController.text = purchase.merchantId;
    updateMerchantEmailController.text = purchase.merchantEmail;
    updateTransactionDateController.text = purchase.transactionDate;
    selectedPurchaseItems = purchase.purchaseItems;
    calculateTotal();
    rebuildUi();
  }

  TextEditingController updateDescriptionController = TextEditingController();
  TextEditingController updateMerchantIdController = TextEditingController();
  TextEditingController updateMerchantEmailController = TextEditingController();
  TextEditingController updateTransactionDateController =
      TextEditingController();

  List<PurchaseItemDetail> selectedPurchaseItems = [];
  List<Products> newlySelectedPurchaseItems = [];
  double total = 0.00;

  // void addselectedItems(List<PurchaseItemDetail> purchaseItems) {
  //   if (purchaseItems.isNotEmpty) {
  //     selectedPurchaseItems.addAll(purchaseItems);
  //   }
  //   calculateTotal();
  //   notifyListeners();
  // }

  void addselectedItems(List<PurchaseItemDetail> purchaseItems) {
    if (purchaseItems.isNotEmpty) {
      // Find the maximum index in the currently selected items
      num maxIndex = selectedPurchaseItems.fold(
          0, (max, item) => item.index > max ? item.index : max);

      // Increment the maxIndex to get the next available index
      maxIndex++;

      // Update the indexes of the new items and add them to the selectedPurchaseItems list
      for (var item in purchaseItems) {
        item.index = maxIndex;
        selectedPurchaseItems.add(item);
        maxIndex++;
      }
    }
    calculateTotal();
    rebuildUi();
  }

  void removeSelectedItem(PurchaseItemDetail purchaseItems) {
    selectedPurchaseItems.remove(purchaseItems);
    calculateTotal();
    rebuildUi();
  }

  void calculateTotal() {
    total = selectedPurchaseItems.fold(0.00, (sum, purchaseItem) {
      return sum + (purchaseItem.unitPrice * (purchaseItem.quantity));
    });
  }

  void openEditBottomSheet(PurchaseItemDetail purchaseItem) {
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
                      initialValue: purchaseItem.unitPrice.toString(),
                      // Handle price input
                      onChanged: (value) {
                        // Update the item price
                        num newPrice = num.tryParse(value) ?? 0;
                        purchaseItem.unitPrice = newPrice;
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

  List<DropdownMenuItem<String>> merchantdropdownItems = [];
  List<Merchants> merchantList = [];
  // List<Merchants> newMerchant = [];

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
    rebuildUi();

    return merchants;
  }

  Future<PurchaseUpdateResult> runPurchaseUpdate() async {
    return _purchaseService.updatePurchases(
      purchaseId: purchaseId,
      description: updateDescriptionController.text,
      merchantId: updateMerchantIdController.text,
      purchaseItem: selectedPurchaseItems,
      transactionDate: updateTransactionDateController.text,
    );
  }

  Future updatePurchaseData(BuildContext context) async {
    final db = await getPurchaseDatabase();
    final dbPurchaseWeek = await getPurchasesForWeekDatabase();
    final dbPurchaseMonth = await getPurchasesForMonthDatabase();
    final result = await runBusyFuture(runPurchaseUpdate());

    if (result.purchase != null) {
      await db.delete('purchases');
      await dbPurchaseWeek.delete('purchases_for_week');
      await dbPurchaseMonth.delete('purchases_for_month');
      // navigate to success route
      navigationService.replaceWith(Routes.purchaseView);
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
