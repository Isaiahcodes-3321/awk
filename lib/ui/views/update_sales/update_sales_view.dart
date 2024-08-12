import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/business_creation_service.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/update_sales/update_sales_view.form.dart';

import 'update_sales_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'serviceId'),
  FormTextField(name: 'serviceExpenseAmount'),
  FormTextField(name: 'serviceExpenseBaseAmount'),
  FormTextField(name: 'serviceExpenseDescription'),
  FormTextField(name: 'saleExpenseItemDescription'),
  FormTextField(name: 'saleExpenseItemAmount'),
  FormTextField(name: 'saleExpenseItemBaseAmount'),
])
class UpdateSalesView extends StackedView<UpdateSalesViewModel>
    with $UpdateSalesView {
  const UpdateSalesView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(UpdateSalesViewModel viewModel) async {
    syncFormWithViewModel(viewModel);
    await viewModel.getSaleById1();
    // await viewModel.getCustomersByBusiness();

    viewModel.setSelectedSale();

    // syncFormWithViewModel(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    UpdateSalesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: kcButtonTextColor,
        body: AuthenticationLayout(
            busy: viewModel.isBusy,
            onBackPressed: viewModel.navigateBack,
            // validationMessage: viewModel.validationMessage,
            onMainButtonTapped: () {
              if (viewModel.formKey.currentState!.validate()) {
                viewModel.updateSalesData(context);
              }
            },
            title: 'Update Invoice',
            subtitle: 'Fill out the information below to edit your invoice',
            mainButtonTitle: 'Save',
            form: Form(
              key: viewModel.formKey,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Currency', style: ktsFormTitleText),
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
                          return 'Please select a currency';
                        }
                        return null;
                      },
                      icon: const Icon(Icons.expand_more),
                      iconSize: 20,
                      isExpanded: true,
                      focusColor: kcPrimaryColor,
                      style: ktsBodyText,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          hintStyle: ktsFormHintText,
                          hintText: 'Select',
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder,
                          // labelStyle: ktsFormText,
                          border: defaultFormBorder),
                      items: viewModel.currencydropdownItems,
                      value: viewModel.updateCurrencyIdController.text.isEmpty
                          ? null
                          : viewModel.updateCurrencyIdController.text,
                      onChanged: (value) async {
                        viewModel.updateCurrencyIdController.text =
                            value.toString();
                        // Find the selected currency
                        Currency selectedCurrency =
                            viewModel.currencyList.firstWhere(
                          (currency) =>
                              currency.id.toString() == value.toString(),
                        );

                        viewModel.selectedUpdatedCurrencySymbol =
                            selectedCurrency.symbol;

                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString(
                            'selectedUpdatedSymbol', selectedCurrency.symbol);
                        await viewModel.getCurrencySymbol();
                      },
                    ),
                    verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Customer details',
                            style: ktsSubtitleTextAuthentication),
                        GestureDetector(
                          onTap: () async {
                            // Navigate to the create customer view
                            await viewModel.navigationService
                                .navigateTo(Routes.createCustomerView);
                            await viewModel.getCustomersByBusiness();
                          },
                          child: Text(
                            '+ Add customer',
                            style: ktsAddNewText,
                          ),
                        )
                      ],
                    ),
                    verticalSpaceSmallMid,
                    Text('Customer', style: ktsFormTitleText),
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
                          return 'Please select a customer';
                        }
                        return null;
                      },
                      icon: const Icon(Icons.expand_more),
                      iconSize: 20,
                      isExpanded: true,
                      focusColor: kcPrimaryColor,
                      style: ktsBodyText,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          hintStyle: ktsFormHintText,
                          hintText: 'Select',
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder,
                          // labelStyle: ktsFormText,
                          border: defaultFormBorder),
                      items: viewModel.customerdropdownItems,
                      value: viewModel.updateCustomerIdController.text.isEmpty
                          ? null
                          : viewModel.updateCustomerIdController.text,
                      onChanged: (value) {
                        viewModel.updateCustomerIdController.text =
                            value.toString();
                        // Find the selected customer
                        Customers selectedCustomer =
                            viewModel.customerList.firstWhere(
                          (customer) =>
                              customer.id.toString() == value.toString(),
                        );
                        // Update the email field based on the selected customer
                        viewModel.updateCustomerEmailController.text =
                            selectedCustomer.email;

                        // Update the selected customer name
                        viewModel.selectedCustomerName = selectedCustomer.email;
                      },
                    ),
                    verticalSpaceSmall,
                    Text('Email address', style: ktsFormTitleText),
                    verticalSpaceTiny,
                    TextFormField(
                      readOnly: true,
                      controller: viewModel.updateCustomerEmailController,
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          // hintText: 'Enter email address',
                          // hintStyle: ktsFormHintText,
                          border: defaultFormBorder,
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          errorBorder: defaultErrorFormBorder),
                      // textCapitalization: TextCapitalization.words,
                      style: ktsBodyText,
                      keyboardType: TextInputType.emailAddress,
                      // validator: ((value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please enter a valid email';
                      //   }
                      //   return null;
                      // }),
                    ),
                    verticalSpaceIntermitent,
                    Text('Date', style: ktsSubtitleTextAuthentication),
                    verticalSpaceSmallMid,
                    Text('Issue date', style: ktsFormTitleText),
                    verticalSpaceTiny,
                    TextFormField(
                      onTap: () async {
                        await viewModel.showDatePickerDialog(context);
                        if (viewModel.pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd')
                              .format(viewModel.pickedDate!);
                          viewModel.updateDateOfIssueController.text =
                              formattedDate;
                        }
                      },
                      readOnly: true, // Set readOnly property to true
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              'assets/images/calendar-03.svg',
                              color: kcFormBorderColor,
                            ),
                          ),
                          suffixIconColor: kcFormBorderColor,
                          hintText: 'Pick a date',
                          hintStyle: ktsFormHintText,
                          // border: defaultFormBorder,
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder),
                      style: ktsBodyText,
                      controller: viewModel.updateDateOfIssueController,
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                    verticalSpaceSmall,
                    Text('Due date', style: ktsFormTitleText),
                    verticalSpaceTiny,
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        await viewModel.showDatePickerDialog(context);
                        if (viewModel.pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd')
                              .format(viewModel.pickedDate!);
                          viewModel.updateDueDateController.text =
                              formattedDate;
                        }
                      },
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              'assets/images/calendar-03.svg',
                              color: kcFormBorderColor,
                            ),
                          ),
                          suffixIconColor: kcFormBorderColor,
                          hintText: 'Pick a date',
                          hintStyle: ktsFormHintText,
                          // border: defaultFormBorder,
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder),
                      style: ktsBodyText,
                      controller: viewModel.updateDueDateController,
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                    verticalSpaceIntermitent,
                    Text('Description', style: ktsSubtitleTextAuthentication),
                    verticalSpaceTiny,
                    TextFormField(
                      maxLines: 3,
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                          hintText: 'Say more to your customer',
                          hintStyle: ktsFormHintText,
                          // border: defaultFormBorder,
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder),
                      textCapitalization: TextCapitalization.sentences,
                      style: ktsBodyText,
                      controller: viewModel.updateDescriptionController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }

                        return null;
                      },
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          // Ensure the first letter of the input is capitalized
                          if (newValue.text.isNotEmpty) {
                            return TextEditingValue(
                              text: newValue.text[0].toUpperCase() +
                                  newValue.text.substring(1),
                              selection: newValue.selection,
                            );
                          }
                          return newValue;
                        }),
                      ],
                    ),
                    verticalSpaceSmall,
                    Text('Note', style: ktsFormTitleText),
                    verticalSpaceTiny,
                    TextFormField(
                      // maxLines: 3,
                      cursorColor: kcPrimaryColor,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          hintText: 'Add notes / payment details',
                          hintStyle: ktsFormHintText,
                          // border: defaultFormBorder,
                          enabledBorder: defaultFormBorder,
                          focusedBorder: defaultFocusedFormBorder,
                          focusedErrorBorder: defaultErrorFormBorder,
                          errorStyle: ktsErrorText,
                          errorBorder: defaultErrorFormBorder),
                      textCapitalization: TextCapitalization.sentences,
                      style: ktsBodyText,
                      controller: viewModel.updateNoteController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a sales note';
                        }

                        return null;
                      },
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          // Ensure the first letter of the input is capitalized
                          if (newValue.text.isNotEmpty) {
                            return TextEditingValue(
                              text: newValue.text[0].toUpperCase() +
                                  newValue.text.substring(1),
                              selection: newValue.selection,
                            );
                          }
                          return newValue;
                        }),
                      ],
                    ),
                    verticalSpaceIntermitent,
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
                            viewModel.addItems(
                                viewModel.convertItemsToItemDetails(
                                    viewModel.newlySelectedItems));
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
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel.selectedItem.length,
                          itemBuilder: (context, index) {
                            final item = viewModel.selectedItem[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              minVerticalPadding: 0,
                              leading: Text(
                                '${item.quantity}x',
                                style: ktsQuantityText,
                              ),
                              title: Text(item.name),
                              titleTextStyle: ktsBorderText,
                              subtitle: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              symbol: viewModel
                                                  .selectedUpdatedCurrencySymbol)
                                          .currencySymbol, // The remaining digits without the symbol
                                      style: ktsFormHintText.copyWith(
                                          fontFamily: 'Roboto'),
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
                                      viewModel.removeItem(item);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
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
                                          symbol: viewModel
                                              .selectedUpdatedCurrencySymbol)
                                      .currencySymbol, // The remaining digits without the symbol
                                  style: ktsBorderText2.copyWith(
                                      fontFamily: 'Roboto'),
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
                    if (viewModel.selectedItems.isNotEmpty)
                      verticalSpaceSmallMid,
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
                                          symbol: viewModel
                                              .selectedUpdatedCurrencySymbol)
                                      .currencySymbol, // The remaining digits without the symbol
                                  style: ktsBorderText2.copyWith(
                                      fontFamily: 'Roboto'),
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
                                          symbol: viewModel
                                              .selectedUpdatedCurrencySymbol)
                                      .currencySymbol, // The remaining digits without the symbol
                                  style: ktsBorderText2.copyWith(
                                      fontFamily: 'Roboto'),
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
                            Text('Sale expense',
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
                            SaleExpenses? result = await showModalBottomSheet(
                              backgroundColor: kcButtonTextColor,
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child:
                                        const AddSaleExpenseItemBottomSheet2(),
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
                    if (viewModel.saleExpenseItems.isNotEmpty)
                      verticalSpaceTinyt,
                    if (viewModel.saleExpenseItems.isNotEmpty)
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel.saleExpenseItems.length,
                          itemBuilder: (context, index) {
                            final saleExpenseItem =
                                viewModel.saleExpenseItems[index];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              title: Text(saleExpenseItem.description),
                              titleTextStyle: ktsTextAuthentication2,
                              subtitle: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              symbol: viewModel
                                                  .selectedUpdatedCurrencySymbol)
                                          .currencySymbol, // The remaining digits without the symbol
                                      style: ktsSubtitleTextAuthentication
                                          .copyWith(fontFamily: 'Roboto'),
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
                                  viewModel
                                      .removeSaleExpenseItem(saleExpenseItem);
                                },
                              ),
                            );
                          }),

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
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child:
                                          const AddServiceExpenseItemBottomSheet2()),
                                );
                              },
                            );
                            if (result is SaleServiceExpenseEntry) {
                              // If a result is returned from the bottom sheet, add it to the list
                              viewModel.addSaleServiceExpenseItem(result);
                            }
                          },
                          child: Text(
                            '+ Add expense',
                            style: ktsAddNewText,
                          ),
                        )
                      ],
                    ),
                    if (viewModel.saleServiceExpense.isNotEmpty)
                      verticalSpaceTinyt,
                    if (viewModel.saleServiceExpense.isNotEmpty)
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel.saleServiceExpense.length,
                          itemBuilder: (context, index) {
                            final serviceExpense =
                                viewModel.saleServiceExpense[index];

                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              title:
                                  Text(serviceExpense.serviceName.toString()),
                              titleTextStyle: ktsTextAuthentication2,
                              subtitle: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: NumberFormat.currency(
                                              symbol: viewModel
                                                  .selectedUpdatedCurrencySymbol)
                                          .currencySymbol, // The remaining digits without the symbol
                                      style: ktsSubtitleTextAuthentication
                                          .copyWith(fontFamily: 'Roboto'),
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
                                  viewModel.removeSaleServiceExpenseItem(
                                      serviceExpense);
                                },
                              ),
                            );
                          }),
                  ]),
            )));
  }

  @override
  UpdateSalesViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final String saleId = ModalRoute.of(context)!.settings.arguments as String;
    return UpdateSalesViewModel(saleId: saleId);
  }
}

class AddSaleExpenseItemBottomSheet2 extends StackedView<UpdateSalesViewModel>
    with $UpdateSalesView {
  const AddSaleExpenseItemBottomSheet2({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UpdateSalesViewModel viewModel,
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
              'Expense amount (${viewModel.selectedUpdatedCurrencySymbol})',
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
                viewModel.selectedUpdatedCurrencySymbol)
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
                    index: 0,
                    description: saleExpenseItemDescriptionController.text,
                    amount: double.parse(saleExpenseItemAmountController.text),
                    baseAmount: viewModel.baseCurrencySymbol !=
                            viewModel.selectedUpdatedCurrencySymbol
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
  void onDispose(UpdateSalesViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(UpdateSalesViewModel viewModel) async {
    await viewModel.getCurrencySymbol();
    syncFormWithViewModel(viewModel);
  }

  @override
  UpdateSalesViewModel viewModelBuilder(
    BuildContext context,
  ) {
    // final String saleId = ModalRoute.of(context)!.settings.arguments as String;
    return UpdateSalesViewModel(saleId: '');
  }
}

class AddServiceExpenseItemBottomSheet2
    extends StackedView<UpdateSalesViewModel> with $UpdateSalesView {
  const AddServiceExpenseItemBottomSheet2({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    UpdateSalesViewModel viewModel,
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
              'Amount (${viewModel.selectedUpdatedCurrencySymbol})',
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
                viewModel.selectedUpdatedCurrencySymbol)
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
                    index: 0,
                    description: serviceExpenseDescriptionController.text,
                    amount: num.parse(serviceExpenseAmountController.text),
                    serviceId: serviceIdController.text,
                    serviceName: viewModel.selectedServiceName,
                    baseAmount: viewModel.baseCurrencySymbol !=
                            viewModel.selectedUpdatedCurrencySymbol
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
  void onViewModelReady(UpdateSalesViewModel viewModel) async {
    await viewModel.getCurrencySymbol();
    await viewModel.getServiceByBusiness();
    syncFormWithViewModel(viewModel);
  }

  @override
  UpdateSalesViewModel viewModelBuilder(
    BuildContext context,
  ) {
    // final String saleId = ModalRoute.of(context)!.settings.arguments as String;
    return UpdateSalesViewModel(saleId: '');
  }
}
