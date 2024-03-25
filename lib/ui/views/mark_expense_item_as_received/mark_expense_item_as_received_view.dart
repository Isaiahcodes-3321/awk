import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/mark_expense_item_as_received/mark_expense_item_as_received_view.form.dart';

import 'mark_expense_item_as_received_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'transactionDate'),
])
class MarkExpenseItemAsReceivedView
    extends StackedView<MarkExpenseItemAsReceivedViewModel>
    with $MarkExpenseItemAsReceivedView {
  final Expenses selectedExpense;
  const MarkExpenseItemAsReceivedView({Key? key, required this.selectedExpense})
      : super(key: key);

  @override
  void onDispose(MarkExpenseItemAsReceivedViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  void onViewModelReady(MarkExpenseItemAsReceivedViewModel viewModel) async {
    syncFormWithViewModel(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    MarkExpenseItemAsReceivedViewModel viewModel,
    Widget? child,
  ) {
    return AuthenticationLayout(
        busy: viewModel.isBusy,
        // validationMessage: viewModel.validationMessage,
        title: 'Confirm items',
        subtitle: 'Add extra information to this expense',
        mainButtonTitle: 'Next',
        onMainButtonTapped: () => Navigator.pop(context),
        form: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Issue date', style: ktsFormTitleText),
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
                Text('Expense items', style: ktsFormTitleText),
                Container(
                  height: 380,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.expense.expenseItems.length,
                    itemBuilder: (context, index) {
                      final expenseItem = viewModel.expense.expenseItems[index];
                      final quantityReceivedController =
                          viewModel.quantityReceivedControllers[index];
                      return Form(
                        key: viewModel.expenseItemFormKeys?[index],
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
                                    if (expenseItem.quantity ==
                                        expenseItem.quantityRecieved) {
                                      //nothing happens
                                    } else {
                                      if (viewModel.formKey.currentState!
                                              .validate() &&
                                          viewModel.expenseItemFormKeys![index]
                                              .currentState!
                                              .validate()) {
                                        await viewModel
                                            .markExpenseItemAsRecieved(
                                                expenseItem.id, index);
                                        viewModel.rebuildUi();
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  child: Text(
                                    expenseItem.quantity ==
                                            expenseItem.quantityRecieved
                                        ? '✓ Item Received'
                                        : '✓ Mark item as received',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Title', style: ktsFormTitleText),
                                    verticalSpaceTiny,
                                    TextFormField(
                                      readOnly: true,
                                      initialValue: expenseItem.description,
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
                                          errorBorder: defaultErrorFormBorder),
                                      // textCapitalization: TextCapitalization.words,
                                      style: ktsBodyText,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ],
                                )),
                                horizontalSpaceSmall,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Amount', style: ktsFormTitleText),
                                      verticalSpaceTiny,
                                      TextFormField(
                                        readOnly: true,
                                        initialValue: NumberFormat.currency(
                                          locale: 'en_NGN',
                                          symbol: '₦',
                                        ).format(expenseItem.unitPrice),
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
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Quantity ordered',
                                        style: ktsFormTitleText),
                                    verticalSpaceTiny,
                                    TextFormField(
                                      readOnly: true,
                                      initialValue:
                                          expenseItem.quantity.toString(),
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
                                          errorBorder: defaultErrorFormBorder),
                                      // textCapitalization: TextCapitalization.words,
                                      style: ktsBodyText,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ],
                                )),
                                horizontalSpaceSmall,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Quantity received',
                                          style: ktsFormTitleText),
                                      verticalSpaceTiny,
                                      TextFormField(
                                        readOnly:
                                            expenseItem.quantityRecieved ==
                                                expenseItem.quantity,
                                        controller:
                                            expenseItem.quantityRecieved ==
                                                    expenseItem.quantity
                                                ? quantityReceivedController
                                                : null,
                                        cursorColor: kcPrimaryColor,
                                        decoration: InputDecoration(
                                            filled:
                                                expenseItem.quantityRecieved ==
                                                    expenseItem.quantity,
                                            fillColor: kcOTPColor,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12),
                                            hintText: 'Enter quantity',
                                            hintStyle: ktsFormHintText,
                                            border: defaultFormBorder,
                                            enabledBorder: defaultFormBorder,
                                            focusedBorder:
                                                defaultFocusedFormBorder,
                                            focusedErrorBorder:
                                                defaultErrorFormBorder,
                                            errorStyle: ktsErrorText,
                                            errorBorder:
                                                defaultErrorFormBorder),
                                        style: ktsBodyText,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '';
                                          }

                                          // Check if the value is not a whole number (non-integer) or is negative
                                          final parsedValue =
                                              int.tryParse(value);
                                          if (parsedValue == null ||
                                              parsedValue < 0 ||
                                              parsedValue >
                                                  expenseItem.quantity) {
                                            return '';
                                          }

                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceSmall
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )));
  }

  @override
  MarkExpenseItemAsReceivedViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MarkExpenseItemAsReceivedViewModel(expense: selectedExpense);
}
