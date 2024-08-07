import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/business_creation_service.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/add_sales/add_sales_view.form.dart';

import 'add_sales_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'description'),
  FormTextField(name: 'note'),
  FormTextField(name: 'customerId'),
  FormTextField(name: 'currencyId'),
  FormTextField(name: 'dueDate'),
  FormTextField(name: 'dateOfIssue'),
  FormTextField(name: 'serviceId'),
  FormTextField(name: 'serviceExpenseAmount'),
  FormTextField(name: 'serviceExpenseBaseAmount'),
  FormTextField(name: 'serviceExpenseDescription'),
  FormTextField(name: 'saleExpenseItemDescription'),
  FormTextField(name: 'saleExpenseItemAmount'),
  FormTextField(name: 'saleExpenseItemBaseAmount'),
])
class AddSalesView extends StackedView<AddSalesViewModel> with $AddSalesView {
  const AddSalesView({Key? key}) : super(key: key);

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
        onMainButtonTapped: () {
          if (viewModel.formKey.currentState!.validate()) {
            viewModel.navigateTo2();
          }
        },
        mainButtonTitle: 'Next',
        title: 'New Invoice',
        subtitle: 'Fill out the information below to create an invoice',
        form: Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset('assets/images/Group_1000007830.svg'),
              ),
              verticalSpaceSmallMid,
              Text('Currency', style: ktsFormTitleText),
              verticalSpaceTiny,
              DropdownButtonFormField(
                // hint: Text(
                //   'Select',
                //   style: ktsFormHintText,
                // ),
                menuMaxHeight: 320,
                elevation: 4,

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
                style: GoogleFonts.openSans(
                        color: kcTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)
                    .copyWith(fontFamily: 'Roboto'),
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
                items: viewModel.currencydropdownItems,
                value: viewModel.currencyIdController.text.isEmpty
                    ? null
                    : viewModel.currencyIdController.text,
                onChanged: (value) async {
                  viewModel.currencyIdController.text = value.toString();
                  viewModel.rebuildUi();
                  // Find the selected currency
                  Currency selectedCurrency = viewModel.currencyList.firstWhere(
                    (currency) => currency.id.toString() == value.toString(),
                  );

                  viewModel.currencyIdController.text = selectedCurrency.id;
                  viewModel.selectedCurrencySymbol =
                      selectedCurrency.symbol; // Update the symbo
                  await viewModel.setSelectedCurrencySymbol(selectedCurrency
                      .symbol); // Save the symbol to SharedPreferences
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
                items: viewModel.customerdropdownItems,
                value: customerIdController.text.isEmpty
                    ? null
                    : customerIdController.text,
                onChanged: (value) {
                  customerIdController.text = value.toString();
                  // Find the selected customer
                  Customers selectedCustomer =
                      viewModel.customerList.firstWhere(
                    (customer) => customer.id.toString() == value.toString(),
                  );
                  viewModel.emailController.text = selectedCustomer.email;
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
              Text('Date', style: ktsSubtitleTextAuthentication),
              verticalSpaceSmallMid,
              Text('Issue date', style: ktsFormTitleText),
              verticalSpaceTiny,
              TextFormField(
                onTap: () async {
                  await viewModel.showDatePickerDialog(context);
                  if (viewModel.pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(viewModel.pickedDate!);
                    dateOfIssueController.text = formattedDate;
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
                controller: dateOfIssueController,
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
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(viewModel.pickedDate!);
                    dueDateController.text = formattedDate;
                  }
                },
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
                controller: dueDateController,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              verticalSpaceIntermitent,
              verticalSpaceSmall,
              Text('Description', style: ktsFormTitleText),
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
                keyboardType: TextInputType.text,
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                controller: noteController,
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
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // void onDispose(AddSalesViewModel viewModel) {
  //   super.onDispose(viewModel);
  //   disposeForm();
  // }

  @override
  void onViewModelReady(AddSalesViewModel viewModel) async {
    syncFormWithViewModel(viewModel);
    await viewModel.getCurrencies();
    await viewModel.getCustomersByBusiness();

    // await viewModel.getServiceByBusiness();
  }

  @override
  AddSalesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddSalesViewModel();
}
