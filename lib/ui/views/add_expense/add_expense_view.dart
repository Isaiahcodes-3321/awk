import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/services/merchant_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/add_expense/add_expense_view.form.dart';

import 'add_expense_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'description'),
  FormTextField(name: 'reference'),
  FormTextField(name: 'expenseCategoryId'),
  FormTextField(name: 'expenseDate'),
  FormTextField(name: 'merchantId'),
  FormTextField(name: 'expenseItemDescription'),
  FormTextField(name: 'expenseItemQuantity'),
  FormTextField(name: 'expenseItemUnitPrice'),
  FormTextField(name: 'creditAccountId')
])
class AddExpenseView extends StackedView<AddExpenseViewModel>
    with $AddExpenseView {
  const AddExpenseView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddExpenseViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        busy: viewModel.isBusy,
        // validationMessage: viewModel.validationMessage,
        onBackPressed: viewModel.navigateBack,
        onMainButtonTapped: () {
          if (viewModel.formKey.currentState!.validate()) {
            viewModel.saveExpenseData(context);
          }
        },
        title: 'Record Expense',
        subtitle: 'Fill out the information below to record an expense',
        mainButtonTitle: 'Save',
        form: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Expense details', style: ktsSubtitleTextAuthentication),
              verticalSpaceSmallMid,
              Text('Category', style: ktsFormTitleText),
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
                    return 'Please select a category';
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
                  errorBorder: defaultErrorFormBorder,
                  // labelStyle: ktsFormText,
                  // border: defaultFormBorder
                ),
                items: viewModel.expenseCategorydropdownItems,
                value: expenseCategoryIdController.text.isEmpty
                    ? null
                    : expenseCategoryIdController.text,
                onChanged: (value) {
                  expenseCategoryIdController.text = value.toString();
                },
              ),
              verticalSpaceSmall,
              Text('Date', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                onTap: () async {
                  await viewModel.showDatePickerDialog(context);
                  if (viewModel.pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(viewModel.pickedDate!);
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(viewModel.pickedDate!);
                    expenseDateController.text = formattedDate;
                  }
                },
                readOnly: true, // Set readOnly property to true
                cursorColor: kcPrimaryColor,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'assets/images/calendar-03.svg',
                        color: kcFormBorderColor,
                      ),
                    ),
                    // suffixIconColor: kcFormBorderColor,
                    hintText: 'Pick a date',
                    hintStyle: ktsFormHintText,
                    // border: defaultFormBorder,
                    enabledBorder: defaultFormBorder,
                    focusedBorder: defaultFocusedFormBorder,
                    focusedErrorBorder: defaultErrorFormBorder,
                    errorStyle: ktsErrorText,
                    errorBorder: defaultErrorFormBorder),
                style: ktsBodyText,
                controller: expenseDateController,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              verticalSpaceIntermitent,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Merchant details',
                      style: ktsSubtitleTextAuthentication),
                  GestureDetector(
                    onTap: () async {
                      // Navigate to the create customer view
                      await viewModel.navigationService
                          .navigateTo(Routes.createMerchantView);
                      await viewModel.getMerchantsByBusiness();
                    },
                    child: Text(
                      '+ Add merchant',
                      style: ktsAddNewText,
                    ),
                  )
                ],
              ),
              verticalSpaceSmallMid,
              Text('Merchant', style: ktsFormTitleText),
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
                    return 'Please select a merchant';
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
                    errorBorder: defaultErrorFormBorder,
                    // labelStyle: ktsFormText,
                    border: defaultFormBorder),
                items: viewModel.merchantdropdownItems,
                value: merchantIdController.text.isEmpty
                    ? null
                    : merchantIdController.text,
                onChanged: (value) {
                  merchantIdController.text = value.toString();
                  // Find the selected customer
                  Merchants selectedMerchant =
                      viewModel.merchantList.firstWhere(
                    (customer) => customer.id.toString() == value.toString(),
                  );
                  viewModel.emailController.text = selectedMerchant.email;
                },
              ),
              verticalSpaceSmall,
              Text('Email address', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                readOnly: true,
                controller: viewModel.emailController,
                cursorColor: kcPrimaryColor,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Items', style: ktsSubtitleTextAuthentication),
                  horizontalSpaceTiny,
                  GestureDetector(
                    onTap: () async {
                      ExpenseDetail? result = await showModalBottomSheet(
                        backgroundColor: kcButtonTextColor,
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.72,
                                child: const AddExpenseItemBottomSheet()),
                          );
                        },
                      );
                      if (result is ExpenseDetail) {
                        // If a result is returned from the bottom sheet, add it to the list
                        viewModel.addExpenseItem(result);
                      }
                    },
                    child: Text(
                      '+ Add expense',
                      style: ktsAddNewText,
                    ),
                  )
                ],
              ),
              if (viewModel.expenseItems.isNotEmpty) verticalSpaceTinyt,
              if (viewModel.expenseItems.isNotEmpty)
                ...viewModel.expenseItems.map((expenseItem) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                      minVerticalPadding: 0,
                      leading: Text(
                        '${expenseItem.quantity}x',
                        style: ktsQuantityText,
                      ),
                      title: Text(expenseItem.description),
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
                                  .format(expenseItem
                                      .unitPrice), // The remaining digits without the symbol
                              style: ktsFormHintText,
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/trash-01.svg',
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () {
                          viewModel.removeExpenseItem(expenseItem);
                        },
                      ),
                    )),
              if (viewModel.expenseItems.isNotEmpty) const Divider(),
              if (viewModel.expenseItems.isNotEmpty) verticalSpaceTinyt,
              if (viewModel.expenseItems.isNotEmpty)
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
                            style:
                                ktsBorderText2.copyWith(fontFamily: 'Roboto'),
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
              if (viewModel.expenseItems.isNotEmpty) verticalSpaceTiny,
              if (viewModel.expenseItems.isNotEmpty) const Divider(),
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
                controller: descriptionController,
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

              // TextFormField(
              //   // inputFormatters: [
              //   //   FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              //   //   TextInputFormatter.withFunction((oldValue, newValue) {
              //   //     final doubleValue = double.tryParse(newValue.text);
              //   //     if (doubleValue != null) {
              //   //       final newAmount =
              //   //           NumberFormat.currency(locale: 'en_US', symbol: '\$')
              //   //               .format(doubleValue);
              //   //       amountController.value = amountController.value.copyWith(
              //   //         text: newAmount,
              //   //         selection:
              //   //             TextSelection.collapsed(offset: newAmount.length),
              //   //       );
              //   //     }
              //   //   }),
              //   // ],
              //   decoration: InputDecoration(
              //       labelText: 'Amount',
              //       labelStyle: ktsFormText,
              //       border: defaultFormBorder),
              //   keyboardType: TextInputType.number,
              //   controller: amountController,
              // ),

              // verticalSpaceSmall,
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Recurring',
              //       style: ktsFormText,
              //     ),
              //     // Spacer(),
              //     Switch(
              //       value: model.recurringValue,
              //       onChanged: (value) {
              //         model.setRecurring(value);
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void onDispose(AddExpenseViewModel viewModel) {
  //   super.onDispose(viewModel);
  //   viewModel.emailController.dispose();
  //   disposeForm();
  // }

  @override
  void onViewModelReady(AddExpenseViewModel viewModel) async {
    await viewModel.getMerchantsByBusiness();
    await viewModel.getExpenseCategoryWithSets();
    await viewModel.getCOAs();
    syncFormWithViewModel(viewModel);
  }

  @override
  AddExpenseViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddExpenseViewModel();
}

class AddExpenseItemBottomSheet extends StackedView<AddExpenseViewModel>
    with $AddExpenseView {
  const AddExpenseItemBottomSheet({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddExpenseViewModel viewModel,
    Widget? child,
  ) {
    return SingleChildScrollView(
      primary: false,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Form(
        key: viewModel.formBottomSheetKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            verticalSpaceSmallMid,
            SvgPicture.asset('assets/images/Group_1000007808.svg'),
            verticalSpaceSmallMid,
            Text(
              'Include expense detail',
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
                  errorBorder: defaultErrorFormBorder),
              // textCapitalization: TextCapitalization.words,
              style: ktsBodyText,
              // controller: mobileController,
              keyboardType: TextInputType.name,
              controller: expenseItemDescriptionController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }

                return null;
              },
            ),
            verticalSpaceSmall,
            Text('Amount', style: ktsFormTitleText),
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
              controller: expenseItemUnitPriceController,
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
            Text('Quantity', style: ktsFormTitleText),
            verticalSpaceTiny,
            TextFormField(
              cursorColor: kcPrimaryColor,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: '0',
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
              controller: expenseItemQuantityController,
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
            Text('Account', style: ktsFormTitleText),
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
                  return 'Please select an account';
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
                  // hintText: 'Select account',
                  enabledBorder: defaultFormBorder,
                  focusedBorder: defaultFocusedFormBorder,
                  focusedErrorBorder: defaultErrorFormBorder,
                  errorStyle: ktsErrorText,
                  errorBorder: defaultErrorFormBorder,
                  // labelStyle: ktsFormText,
                  border: defaultFormBorder),
              items: viewModel.cOAsdropdownItems,
              value: creditAccountIdController.text.isEmpty
                  ? null
                  : creditAccountIdController.text,
              onChanged: (value) {
                creditAccountIdController.text = value.toString();
              },
            ),
            verticalSpaceIntermitent,
            GestureDetector(
              onTap: () {
                if (viewModel.formBottomSheetKey.currentState!.validate()) {
                  ExpenseDetail expenseDetail = ExpenseDetail(
                    id: '',
                    index: 1,
                    description: expenseItemDescriptionController.text,
                    unitPrice: num.parse(expenseItemUnitPriceController.text),
                    quantity: num.parse(expenseItemQuantityController.text),
                    creditAccountId: creditAccountIdController.text,
                  );
                  // Close the bottom sheet
                  Navigator.of(context).pop(expenseDetail);
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
          ],
        ),
      ),
    );
  }

  // @override
  // void onDispose(AddExpenseViewModel viewModel) {
  //   super.onDispose(viewModel);
  //   disposeForm();
  // }

  @override
  void onViewModelReady(AddExpenseViewModel viewModel) async {
    await viewModel.getCOAs();
    syncFormWithViewModel(viewModel);
  }

  @override
  AddExpenseViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddExpenseViewModel();
}
