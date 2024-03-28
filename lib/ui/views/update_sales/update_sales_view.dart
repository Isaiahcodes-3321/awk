import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/add_sales2/add_sales2_view.dart';

import 'update_sales_viewmodel.dart';

class UpdateSalesView extends StackedView<UpdateSalesViewModel> {
  const UpdateSalesView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(UpdateSalesViewModel viewModel) async {
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
                                              locale: 'en_NGN', symbol: '₦')
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
                                          locale: 'en_NGN', symbol: '₦')
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
                            'Tax',
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
                                          locale: 'en_NGN', symbol: '₦')
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
                                          locale: 'en_NGN', symbol: '₦')
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
                                        const AddSaleExpenseItemBottomSheet(),
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
                                              locale: 'en_NGN', symbol: '₦')
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
                                          const AddServiceExpenseItemBottomSheet()),
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
                                              locale: 'en_NGN', symbol: '₦')
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
