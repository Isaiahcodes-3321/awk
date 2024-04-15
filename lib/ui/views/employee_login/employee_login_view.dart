import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'employee_login_viewmodel.dart';

class EmployeeLoginView extends StackedView<EmployeeLoginViewModel> {
  const EmployeeLoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EmployeeLoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  EmployeeLoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EmployeeLoginViewModel();
}
