import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/add_sales/add_sales_view.form.dart';
import 'package:verzo/ui/views/add_sales/add_sales_viewmodel.dart';

class AddSales2View extends StackedView<AddSalesViewModel> with $AddSalesView {
  const AddSales2View({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddSalesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        busy: viewModel.isBusy,
        onBackPressed: viewModel.navigateBack,
        // validationMessage: viewModel.validationMessage,
        onMainButtonTapped: () => viewModel.saveSalesData(context),
        mainButtonTitle: 'Save invoice',
        title: 'New Invoice',
        subtitle: 'Continue filling out the information below',
        form: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset('assets/images/Rectangle-331.svg'),
            ),
            verticalSpaceSmallMid,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items', style: ktsSubtitleTextAuthentication),
                horizontalSpaceTiny,
                GestureDetector(
                  onTap: () async {
                    viewModel.newlySelectedItems = await viewModel
                        .navigationService
                        .navigateTo(Routes.chooseItemView);
                    // Receive the selected items from ChooseItemView
                    viewModel.addselectedItems(viewModel.newlySelectedItems);
                  },
                  child: Text(
                    '+ Add item',
                    style: ktsAddNewText,
                  ),
                )
              ],
            ),
            if (viewModel.selectedItems.isNotEmpty) verticalSpaceTiny,
            if (viewModel.selectedItems.isNotEmpty)
              ...viewModel.selectedItems.map(
                (item) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 2,
                  ),
                  minVerticalPadding: 0,
                  leading: Text(
                    '${item.quantity}x',
                    style: ktsQuantityText,
                  ),
                  title: Text(item.title),
                  titleTextStyle: ktsBorderText,
                  subtitle: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: NumberFormat.currency(
                                  symbol: viewModel.selectedCurrencySymbol)
                              .currencySymbol, // The remaining digits without the symbol
                          style: ktsFormHintText.copyWith(fontFamily: 'Roboto'),
                        ),
                        TextSpan(
                          text: NumberFormat.currency(
                                  locale: 'en_NGN', symbol: '')
                              .format(item
                                  .price), // The remaining digits without the symbol
                          style: ktsFormHintText,
                        ),
                      ],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/edit-03.svg',
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () {
                          viewModel.openEditBottomSheet(item);
                        },
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/trash-01.svg',
                          width: 18,
                          height: 18,
                        ),
                        onPressed: () {
                          viewModel.removeSelectedItem(item);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            // if (viewModel.selectedItems.isNotEmpty) verticalSpaceTinyt,
            if (viewModel.selectedItems.isNotEmpty) const Divider(),
            if (viewModel.selectedItems.isNotEmpty) verticalSpaceTinyt,
            if (viewModel.selectedItems.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: ktsBorderText,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: NumberFormat.currency(
                                  symbol: viewModel.selectedCurrencySymbol)
                              .currencySymbol, // The remaining digits without the symbol
                          style: ktsBorderText2.copyWith(fontFamily: 'Roboto'),
                        ),
                        TextSpan(
                          text: NumberFormat.currency(
                                  locale: 'en_NGN', symbol: '')
                              .format(viewModel
                                  .subtotal), // The remaining digits without the symbol
                          style: ktsBorderText2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (viewModel.selectedItems.isNotEmpty) verticalSpaceSmallMid,
            if (viewModel.selectedItems.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VAT',
                    style: ktsBorderText,
                  ),
                  Text(
                    '+7.5%',
                    style: ktsBorderText3,
                  ),
                ],
              ),
            if (viewModel.saleExpenseItems.isNotEmpty &&
                viewModel.selectedItems.isNotEmpty)
              verticalSpaceSmallMid,
            if (viewModel.saleExpenseItems.isNotEmpty &&
                viewModel.selectedItems.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sale expense',
                    style: ktsBorderText,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: NumberFormat.currency(
                                  symbol: viewModel.selectedCurrencySymbol)
                              .currencySymbol, // The remaining digits without the symbol
                          style: ktsBorderText2.copyWith(fontFamily: 'Roboto'),
                        ),
                        TextSpan(
                          text: NumberFormat.currency(
                                  locale: 'en_NGN', symbol: '')
                              .format(viewModel
                                  .saleExpensesAmount), // The remaining digits without the symbol
                          style: ktsBorderText2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (viewModel.selectedItems.isNotEmpty) verticalSpaceTiny,
            if (viewModel.selectedItems.isNotEmpty) const Divider(),
            if (viewModel.selectedItems.isNotEmpty) verticalSpaceTinyt,
            if (viewModel.selectedItems.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount due', style: ktsBorderText),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: NumberFormat.currency(
                                  symbol: viewModel.selectedCurrencySymbol)
                              .currencySymbol, // The remaining digits without the symbol
                          style: ktsBorderText2.copyWith(fontFamily: 'Roboto'),
                        ),
                        TextSpan(
                          text: NumberFormat.currency(
                                  locale: 'en_NGN', symbol: '')
                              .format(viewModel
                                  .total), // The remaining digits without the symbol
                          style: ktsBorderText2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (viewModel.selectedItems.isNotEmpty) verticalSpaceTiny,
            if (viewModel.selectedItems.isNotEmpty) const Divider(),
            verticalSpaceIntermitent,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Sale expense', style: ktsSubtitleTextAuthentication),
                    horizontalSpaceTiny,
                    SvgPicture.asset(
                      'assets/images/info-circle.svg',
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    SaleExpenses? result = await showModalBottomSheet(
                      backgroundColor: kcButtonTextColor,
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const AddSaleExpenseItemBottomSheet(),
                          ),
                        );
                      },
                    );
                    if (result is SaleExpenses) {
                      // If a result is returned from the bottom sheet, add it to the list
                      viewModel.addSaleExpenseItem(result);
                    }
                  },
                  child: Text(
                    '+ Add expense',
                    style: ktsAddNewText,
                  ),
                )
              ],
            ),
            if (viewModel.saleExpenseItems.isNotEmpty) verticalSpaceTinyt,
            if (viewModel.saleExpenseItems.isNotEmpty)
              ...viewModel.saleExpenseItems.map((saleExpenseItem) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                    title: Text(saleExpenseItem.description),
                    titleTextStyle: ktsTextAuthentication2,
                    subtitle: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: NumberFormat.currency(
                                    symbol: viewModel.selectedCurrencySymbol)
                                .currencySymbol, // The remaining digits without the symbol
                            style: ktsSubtitleTextAuthentication.copyWith(
                                fontFamily: 'Roboto'),
                          ),
                          TextSpan(
                            text: NumberFormat.currency(
                                    locale: 'en_NGN', symbol: '')
                                .format(saleExpenseItem
                                    .amount), // The remaining digits without the symbol
                            style: ktsSubtitleTextAuthentication,
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/trash-01.svg',
                        width: 22,
                        height: 22,
                      ),
                      onPressed: () {
                        viewModel.removeSaleExpenseItem(saleExpenseItem);
                      },
                    ),
                  )),
            verticalSpaceIntermitent,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Service expense',
                        style: ktsSubtitleTextAuthentication),
                    horizontalSpaceTiny,
                    SvgPicture.asset(
                      'assets/images/info-circle.svg',
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    SaleServiceExpenseEntry? result =
                        await showModalBottomSheet(
                      backgroundColor: kcButtonTextColor,
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: const AddServiceExpenseItemBottomSheet()),
                        );
                      },
                    );
                    if (result is SaleServiceExpenseEntry) {
                      // If a result is returned from the bottom sheet, add it to the list
                      viewModel.addSaleServiceExpense(result);
                    }
                  },
                  child: Text(
                    '+ Add expense',
                    style: ktsAddNewText,
                  ),
                )
              ],
            ),
            if (viewModel.saleServiceExpense.isNotEmpty) verticalSpaceTinyt,
            if (viewModel.saleServiceExpense.isNotEmpty)
              ...viewModel.saleServiceExpense.map((serviceExpense) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                    title: Text(serviceExpense.serviceName.toString()),
                    titleTextStyle: ktsTextAuthentication2,
                    subtitle: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: NumberFormat.currency(
                                    symbol: viewModel.selectedCurrencySymbol)
                                .currencySymbol, // The remaining digits without the symbol
                            style: ktsSubtitleTextAuthentication.copyWith(
                                fontFamily: 'Roboto'),
                          ),
                          TextSpan(
                            text: NumberFormat.currency(
                                    locale: 'en_NGN', symbol: '')
                                .format(serviceExpense
                                    .amount), // The remaining digits without the symbol
                            style: ktsSubtitleTextAuthentication,
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/trash-01.svg',
                        width: 22,
                        height: 22,
                      ),
                      onPressed: () {
                        viewModel.removeSaleServiceExpense(serviceExpense);
                      },
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(AddSalesViewModel viewModel) async {
    await viewModel.getCurrencySymbol();
    syncFormWithViewModel(viewModel);
  }

  @override
  AddSalesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddSalesViewModel();
}

class AddSaleExpenseItemBottomSheet extends StackedView<AddSalesViewModel>
    with $AddSalesView {
  const AddSaleExpenseItemBottomSheet({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddSalesViewModel viewModel,
    Widget? child,
  ) {
    return SingleChildScrollView(
      primary: false,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Form(
        key: viewModel.formKeyBottomSheetSaleExpense,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpaceSmallMid,
            SvgPicture.asset('assets/images/Group_1000007808.svg'),
            verticalSpaceSmallMid,
            Text(
              'Include extra expense',
              style: ktsBottomSheetHeaderText,
            ),
            verticalSpaceSmallMid,
            Text('Expense title', style: ktsFormTitleText),
            verticalSpaceTiny,
            TextFormField(
              cursorColor: kcPrimaryColor,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintText: 'Enter title',
                hintStyle: ktsFormHintText,
                // border: defaultFormBorder,
                enabledBorder: defaultFormBorder,
                focusedBorder: defaultFocusedFormBorder,
                focusedErrorBorder: defaultErrorFormBorder,
                errorStyle: ktsErrorText,
                errorBorder: defaultErrorFormBorder,
              ), // textCapitalization: TextCapitalization.words,
              style: ktsBodyText,
              // controller: mobileController,
              keyboardType: TextInputType.name,
              controller: saleExpenseItemDescriptionController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }

                return null;
              },
            ),
            verticalSpaceSmall,
            Text(
              'Expense amount (${viewModel.selectedCurrencySymbol})',
              style: GoogleFonts.openSans(
                color: kcTextTitleColor,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ).copyWith(fontFamily: 'Roboto'),
            ),
            verticalSpaceTiny,
            TextFormField(
              cursorColor: kcPrimaryColor,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: 'Enter amount',
                  hintStyle: ktsFormHintText,
                  // border: defaultFormBorder,
                  enabledBorder: defaultFormBorder,
                  focusedBorder: defaultFocusedFormBorder,
                  focusedErrorBorder: defaultErrorFormBorder,
                  errorStyle: ktsErrorText,
                  errorBorder: defaultErrorFormBorder),
              // textCapitalization: TextCapitalization.words,
              style: ktsBodyText,
              keyboardType: TextInputType.number,
              controller: saleExpenseItemAmountController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid price';
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
            if (viewModel.baseCurrencySymbol !=
                viewModel.selectedCurrencySymbol)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense base amount (${viewModel.baseCurrencySymbol})',
                    style: GoogleFonts.openSans(
                      color: kcTextTitleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ).copyWith(fontFamily: 'Roboto'),
                  ),
                  verticalSpaceTiny,
                  TextFormField(
                    cursorColor: kcPrimaryColor,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        hintText: 'Enter base amount',
                        hintStyle: ktsFormHintText,
                        // border: defaultFormBorder,
                        enabledBorder: defaultFormBorder,
                        focusedBorder: defaultFocusedFormBorder,
                        focusedErrorBorder: defaultErrorFormBorder,
                        errorStyle: ktsErrorText,
                        errorBorder: defaultErrorFormBorder),
                    // textCapitalization: TextCapitalization.words,
                    style: ktsBodyText,
                    keyboardType: TextInputType.number,
                    controller: saleExpenseItemBaseAmountController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid price';
                      }

                      // Check if the value is not a whole number (non-integer) or is negative
                      final parsedValue = int.tryParse(value);
                      if (parsedValue == null || parsedValue < 0) {
                        return 'Please enter a valid non-negative whole number (integer)';
                      }

                      return null;
                    },
                  ),
                ],
              ),

            verticalSpaceSmallMid,
            GestureDetector(
              onTap: () {
                if (viewModel.formKeyBottomSheetSaleExpense.currentState!
                    .validate()) {
                  SaleExpenses saleExpense = SaleExpenses(
                    id: '',
                    index: 1,
                    description: saleExpenseItemDescriptionController.text,
                    amount: double.parse(saleExpenseItemAmountController.text),
                    baseAmount: viewModel.baseCurrencySymbol !=
                            viewModel.selectedCurrencySymbol
                        ? double.parse(saleExpenseItemBaseAmountController.text)
                        : double.parse(saleExpenseItemAmountController.text),
                  );
                  // Close the bottom sheet
                  Navigator.of(context).pop(saleExpense);
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
                child: viewModel.isBusy
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Text(
                        "Save",
                        style: ktsButtonText,
                      ),
              ),
            ),
            // verticalSpaceSmallMid,
          ],
        ),
      ),
    );
  }

  @override
  void onDispose(AddSalesViewModel viewModel) {
    super.onDispose(viewModel);

    disposeForm();
  }

  @override
  void onViewModelReady(AddSalesViewModel viewModel) async {
    // await viewModel.getServiceByBusiness();
    await viewModel.getCurrencySymbol();
    syncFormWithViewModel(viewModel);
  }

  @override
  AddSalesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddSalesViewModel();
}

class AddServiceExpenseItemBottomSheet extends StackedView<AddSalesViewModel>
    with $AddSalesView {
  const AddServiceExpenseItemBottomSheet({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddSalesViewModel viewModel,
    Widget? child,
  ) {
    return SingleChildScrollView(
      primary: false,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Form(
        key: viewModel.formKeyBottomSheetSaleServiceExpense,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpaceSmallMid,
            SvgPicture.asset('assets/images/Group_1000007808.svg'),
            verticalSpaceSmallMid,
            Text(
              'Include extra expense',
              style: ktsBottomSheetHeaderText,
            ),
            verticalSpaceSmallMid,
            Text('Service', style: ktsFormTitleText),
            verticalSpaceTiny,
            DropdownButtonFormField(
              hint: Text(
                'Select',
                style: ktsFormHintText,
              ),
              menuMaxHeight: 320,
              elevation: 4,
              // padding: EdgeInsets.symmetric(horizontal: 12),
              dropdownColor: kcButtonTextColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a service';
                }
                return null;
              },
              icon: const Icon(Icons.expand_more),
              iconSize: 20,
              isExpanded: true,

              focusColor: kcPrimaryColor,
              style: ktsBodyText,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  // hintStyle: ktsFormHintText,
                  // hintText: 'Select',
                  enabledBorder: defaultFormBorder,
                  focusedBorder: defaultFocusedFormBorder,
                  focusedErrorBorder: defaultErrorFormBorder,
                  errorStyle: ktsErrorText,
                  errorBorder: defaultErrorFormBorder
                  // labelStyle: ktsFormText,
                  // border: defaultFormBorder
                  ),
              items: viewModel.servicedropdownItems,
              value: serviceIdController.text.isEmpty
                  ? null
                  : serviceIdController.text,
              onChanged: (value) {
                serviceIdController.text = value.toString();

                // Find the selected service
                Services selectedService = viewModel.serviceList.firstWhere(
                  (service) => service.id.toString() == value.toString(),
                );

                // Update the selectedServiceName
                viewModel.selectedServiceName = selectedService.name;
              },
            ),
            verticalSpaceSmall,
            Text(
              'Amount (${viewModel.selectedCurrencySymbol})',
              style: GoogleFonts.openSans(
                color: kcTextTitleColor,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ).copyWith(fontFamily: 'Roboto'),
            ),
            verticalSpaceTiny,
            TextFormField(
              cursorColor: kcPrimaryColor,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: 'Enter amount',
                  hintStyle: ktsFormHintText,
                  // border: defaultFormBorder,
                  enabledBorder: defaultFormBorder,
                  focusedBorder: defaultFocusedFormBorder,
                  focusedErrorBorder: defaultErrorFormBorder,
                  errorStyle: ktsErrorText,
                  errorBorder: defaultErrorFormBorder),
              style: ktsBodyText,
              keyboardType: TextInputType.number,
              controller: serviceExpenseAmountController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid price';
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
            if (viewModel.baseCurrencySymbol !=
                viewModel.selectedCurrencySymbol)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Base Amount (${viewModel.baseCurrencySymbol})',
                    style: GoogleFonts.openSans(
                      color: kcTextTitleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ).copyWith(fontFamily: 'Roboto'),
                  ),
                  verticalSpaceTiny,
                  TextFormField(
                    cursorColor: kcPrimaryColor,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        hintText: 'Enter base amount',
                        hintStyle: ktsFormHintText,
                        // border: defaultFormBorder,
                        enabledBorder: defaultFormBorder,
                        focusedBorder: defaultFocusedFormBorder,
                        focusedErrorBorder: defaultErrorFormBorder,
                        errorStyle: ktsErrorText,
                        errorBorder: defaultErrorFormBorder),
                    style: ktsBodyText,
                    keyboardType: TextInputType.number,
                    controller: serviceExpenseBaseAmountController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid price';
                      }
                      // Check if the value is not a whole number (non-integer) or is negative
                      final parsedValue = int.tryParse(value);
                      if (parsedValue == null || parsedValue < 0) {
                        return 'Please enter a valid non-negative whole number (integer)';
                      }
                      return null;
                    },
                  ),
                ],
              ),

            Text('Description', style: ktsFormTitleText),
            verticalSpaceTiny,
            TextFormField(
              cursorColor: kcPrimaryColor,
              decoration: InputDecoration(
                  hintText: 'Enter a description',
                  hintStyle: ktsFormHintText,
                  // border: defaultFormBorder,
                  enabledBorder: defaultFormBorder,
                  focusedBorder: defaultFocusedFormBorder,
                  focusedErrorBorder: defaultErrorFormBorder,
                  errorStyle: ktsErrorText,
                  errorBorder: defaultErrorFormBorder),
              // textCapitalization: TextCapitalization.words,
              style: ktsBodyText,
              // controller: mobileController,
              keyboardType: TextInputType.name,
              controller: serviceExpenseDescriptionController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }

                return null;
              },
            ),
            verticalSpaceSmallMid,
            GestureDetector(
              onTap: () {
                if (viewModel.formKeyBottomSheetSaleServiceExpense.currentState!
                    .validate()) {
                  SaleServiceExpenseEntry saleService = SaleServiceExpenseEntry(
                    id: '',
                    index: 1,
                    description: serviceExpenseDescriptionController.text,
                    amount: num.parse(serviceExpenseAmountController.text),
                    serviceId: serviceIdController.text,
                    serviceName: viewModel.selectedServiceName,
                    baseAmount: viewModel.baseCurrencySymbol !=
                            viewModel.selectedCurrencySymbol
                        ? double.parse(serviceExpenseBaseAmountController.text)
                        : double.parse(serviceExpenseAmountController.text),
                  );

                  // Close the bottom sheet
                  Navigator.of(context).pop(saleService);
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
                child: viewModel.isBusy
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Text(
                        "Save",
                        style: ktsButtonText,
                      ),
              ),
            ),

            // verticalSpaceSmallMid
          ],
        ),
      ),
    );
  }

  // @override
  // void onDispose(AddSalesViewModel viewModel) {
  //   super.onDispose(viewModel);
  //   disposeForm();
  //   // viewModel.emailController.dispose();
  //   // viewModel.serviceNameController.dispose();
  // }

  @override
  void onViewModelReady(AddSalesViewModel viewModel) async {
    await viewModel.getCurrencySymbol();
    await viewModel.getServiceByBusiness();
    syncFormWithViewModel(viewModel);
  }

  @override
  AddSalesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddSalesViewModel();
}
