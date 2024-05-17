import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/record_sale_expense/record_sale_expense_view.form.dart';

import 'record_sale_expense_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'transactionDate'),
])
class RecordSaleExpenseView extends StackedView<RecordSaleExpenseViewModel>
    with $RecordSaleExpenseView {
  final Sales selectedSale;

  const RecordSaleExpenseView({Key? key, required this.selectedSale})
      : super(key: key);

  @override
  void onDispose(RecordSaleExpenseViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(RecordSaleExpenseViewModel viewModel) async {
    syncFormWithViewModel(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    RecordSaleExpenseViewModel viewModel,
    Widget? child,
  ) {
    return AuthenticationLayout(
        busy: viewModel.isBusy,
        // validationMessage: viewModel.validationMessage,
        title: 'Record expense',
        subtitle: 'Add extra expense',
        mainButtonTitle: 'Next',
        onMainButtonTapped: () => Navigator.pop(context),
        form: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Expense date', style: ktsFormTitleText),
                verticalSpaceTiny,
                TextFormField(
                  onTap: () async {
                    await viewModel.showDatePickerDialog(context);
                    if (viewModel.pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd')
                          .format(viewModel.pickedDate!);
                      transactionDateController.text = formattedDate;
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
                  controller: transactionDateController,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                verticalSpaceSmallMid,
                Text('Sale and Sale Service expenses', style: ktsFormTitleText),
                SingleChildScrollView(
                  primary: false,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: viewModel.sale.saleExpenses?.length,
                        itemBuilder: (context, index) {
                          final saleExpenses =
                              viewModel.sale.saleExpenses?[index];
                          final descriptionController =
                              viewModel.descriptionControllers[index];
                          return Form(
                            key: viewModel.saleExpenseFormKeys?[index],
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                verticalSpaceSmall,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        viewModel.rebuildUi();

                                        if (saleExpenses?.effected == true) {
                                          //nothing happens
                                        } else {
                                          if (viewModel.formKey.currentState!
                                                  .validate() &&
                                              viewModel
                                                  .saleExpenseFormKeys![index]
                                                  .currentState!
                                                  .validate()) {
                                            await viewModel
                                                .effectSaleExpenseSaleExpense(
                                                    saleExpenses!.id,
                                                    index,
                                                    context);
                                            viewModel.rebuildUi();
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      child: Text(
                                        saleExpenses?.effected == true
                                            ? '✓ Expense Effected'
                                            : '✓ Effect Sale Expense',
                                        style: ktsAddNewText,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Title', style: ktsFormTitleText),
                                        verticalSpaceTiny,
                                        TextFormField(
                                          readOnly: true,
                                          initialValue:
                                              saleExpenses?.description,
                                          cursorColor: kcPrimaryColor,
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: kcOTPColor,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              border: defaultFormBorder,
                                              enabledBorder: defaultFormBorder,
                                              focusedBorder:
                                                  defaultFocusedFormBorder,
                                              errorBorder:
                                                  defaultErrorFormBorder),
                                          // textCapitalization: TextCapitalization.words,
                                          style: ktsBodyText,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                      ],
                                    )),
                                    horizontalSpaceSmall,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Amount',
                                              style: ktsFormTitleText),
                                          verticalSpaceTiny,
                                          TextFormField(
                                            readOnly: true,

                                            initialValue: NumberFormat.currency(
                                              locale: 'en_NGN',
                                              symbol: '₦',
                                            ).format(
                                              saleExpenses?.amount,
                                            ),
                                            cursorColor: kcPrimaryColor,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: kcOTPColor,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                border: defaultFormBorder,
                                                enabledBorder:
                                                    defaultFormBorder,
                                                focusedBorder:
                                                    defaultFocusedFormBorder,
                                                errorBorder:
                                                    defaultErrorFormBorder),
                                            // textCapitalization: TextCapitalization.words,
                                            style: ktsBodyText.copyWith(
                                                fontFamily: 'Roboto'),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Text('Description',
                                    style: ktsSubtitleTextAuthentication),
                                verticalSpaceTiny,
                                TextFormField(
                                  readOnly: saleExpenses?.effected == true,
                                  cursorColor: kcPrimaryColor,
                                  decoration: InputDecoration(
                                      filled: saleExpenses?.effected == true,
                                      fillColor: kcOTPColor,
                                      // hintText: 'Say more to your customer',
                                      // hintStyle: ktsFormHintText,
                                      // border: defaultFormBorder,
                                      enabledBorder: defaultFormBorder,
                                      focusedBorder: defaultFocusedFormBorder,
                                      focusedErrorBorder:
                                          defaultErrorFormBorder,
                                      errorStyle: ktsErrorText,
                                      errorBorder: defaultErrorFormBorder),
                                  textCapitalization: TextCapitalization.words,
                                  style: ktsBodyText,
                                  controller: descriptionController,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter a description';
                                    }

                                    return null;
                                  },
                                ),
                                verticalSpaceSmall
                              ],
                            ),
                          );
                        },
                      ),
                      verticalSpaceSmall,
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: viewModel.sale.saleServiceExpenses?.length,
                        itemBuilder: (context, index) {
                          final saleServiceExpenses =
                              viewModel.sale.saleServiceExpenses?[index];
                          final descriptionController = viewModel
                              .saleServiceDescriptionControllers[index];
                          return Form(
                            key: viewModel.saleServiceExpenseFormKeys?[index],
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                verticalSpaceSmall,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        viewModel.rebuildUi();
                                        if (saleServiceExpenses?.effected ==
                                            true) {
                                          //nothing happens
                                        } else {
                                          if (viewModel.formKey.currentState!
                                                  .validate() &&
                                              viewModel
                                                  .saleServiceExpenseFormKeys![
                                                      index]
                                                  .currentState!
                                                  .validate()) {
                                            await viewModel
                                                .effectSaleExpenseSaleServiceExpense(
                                                    saleServiceExpenses!.id,
                                                    index,
                                                    context);
                                            viewModel.rebuildUi();
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      child: Text(
                                        saleServiceExpenses?.effected == true
                                            ? '✓ Expense Effected'
                                            : '✓ Effect Sale Expense',
                                        style: ktsAddNewText,
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Title', style: ktsFormTitleText),
                                        verticalSpaceTiny,
                                        TextFormField(
                                          readOnly: true,
                                          initialValue:
                                              saleServiceExpenses?.serviceName,
                                          // 'Expense assigned to ${saleServiceExpenses?.serviceName}',
                                          cursorColor: kcPrimaryColor,
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: kcOTPColor,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              border: defaultFormBorder,
                                              enabledBorder: defaultFormBorder,
                                              focusedBorder:
                                                  defaultFocusedFormBorder,
                                              errorBorder:
                                                  defaultErrorFormBorder),
                                          // textCapitalization: TextCapitalization.words,
                                          style: ktsBodyText,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                      ],
                                    )),
                                    horizontalSpaceSmall,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Amount',
                                              style: ktsFormTitleText),
                                          verticalSpaceTiny,
                                          TextFormField(
                                            readOnly: true,
                                            initialValue: NumberFormat.currency(
                                              locale: 'en_NGN',
                                              symbol: '₦',
                                            ).format(
                                                saleServiceExpenses?.amount),
                                            cursorColor: kcPrimaryColor,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: kcOTPColor,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                border: defaultFormBorder,
                                                enabledBorder:
                                                    defaultFormBorder,
                                                focusedBorder:
                                                    defaultFocusedFormBorder,
                                                focusedErrorBorder:
                                                    defaultErrorFormBorder,
                                                errorStyle: ktsErrorText,
                                                errorBorder:
                                                    defaultErrorFormBorder),
                                            // textCapitalization: TextCapitalization.words,
                                            style: ktsBodyText.copyWith(
                                                fontFamily: 'Roboto'),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Text('Description',
                                    style: ktsSubtitleTextAuthentication),
                                verticalSpaceTiny,
                                TextFormField(
                                  readOnly:
                                      saleServiceExpenses?.effected == true,
                                  cursorColor: kcPrimaryColor,
                                  decoration: InputDecoration(
                                      filled:
                                          saleServiceExpenses?.effected == true,
                                      fillColor: kcOTPColor,
                                      // hintText: 'Say more to your customer',
                                      // hintStyle: ktsFormHintText,
                                      // border: defaultFormBorder,
                                      enabledBorder: defaultFormBorder,
                                      focusedBorder: defaultFocusedFormBorder,
                                      focusedErrorBorder:
                                          defaultErrorFormBorder,
                                      errorStyle: ktsErrorText,
                                      errorBorder: defaultErrorFormBorder),
                                  textCapitalization: TextCapitalization.words,
                                  style: ktsBodyText,
                                  controller: descriptionController,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter a description';
                                    }

                                    return null;
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  @override
  RecordSaleExpenseViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RecordSaleExpenseViewModel(sale: selectedSale);
}
