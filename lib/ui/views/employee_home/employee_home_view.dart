import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'employee_home_viewmodel.dart';

class EmployeeHomeView extends StackedView<EmployeeHomeViewModel> {
  const EmployeeHomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EmployeeHomeViewModel viewModel,
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
  EmployeeHomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EmployeeHomeViewModel();
}
