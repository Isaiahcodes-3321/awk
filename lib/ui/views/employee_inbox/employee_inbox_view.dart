import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'employee_inbox_viewmodel.dart';

class EmployeeInboxView extends StackedView<EmployeeInboxViewModel> {
  const EmployeeInboxView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EmployeeInboxViewModel viewModel,
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
  EmployeeInboxViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EmployeeInboxViewModel();
}
