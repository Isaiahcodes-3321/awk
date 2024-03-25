import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'view_customer_viewmodel.dart';

class ViewCustomerView extends StackedView<ViewCustomerViewModel> {
  final Customers selectedCustomer;
  const ViewCustomerView({Key? key, required this.selectedCustomer})
      : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ViewCustomerViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        busy: viewModel.isBusy,
        onMainButtonTapped: viewModel.navigateBack,
        title: 'View Customers',
        subtitle:
            'This information will be displayed publicly so be careful what you share.',
        mainButtonTitle: 'Done',
        form: Column(
          children: [
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Customer name',
                  labelStyle: ktsFormText,
                  border: defaultFormBorder),
              keyboardType: TextInputType.name,
              initialValue: viewModel.customer.name,
            ),
            verticalSpaceSmall,
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Customer mobile',
                  labelStyle: ktsFormText,
                  border: defaultFormBorder),
              keyboardType: TextInputType.number,
              initialValue: selectedCustomer.mobile,
            ),
            verticalSpaceSmall,
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Customer email',
                  labelStyle: ktsFormText,
                  border: defaultFormBorder),
              keyboardType: TextInputType.emailAddress,
              initialValue: selectedCustomer.email,
            ),
            verticalSpaceSmall,
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Customer address',
                  labelStyle: ktsFormText,
                  border: defaultFormBorder),
              keyboardType: TextInputType.name,
              initialValue: viewModel.customer.address,
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // void onDispose(ViewCustomerViewModel viewModel) {
  //   super.onDispose(viewModel);
  //   // disposeForm();
  // }

  @override
  void onViewModelReady(ViewCustomerViewModel viewModel) {}

  @override
  ViewCustomerViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ViewCustomerViewModel(customer: selectedCustomer);
}
