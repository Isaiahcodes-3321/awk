import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'employee_settings_viewmodel.dart';

class EmployeeSettingsView extends StackedView<EmployeeSettingsViewModel> {
  const EmployeeSettingsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EmployeeSettingsViewModel viewModel,
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
  EmployeeSettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EmployeeSettingsViewModel();
}
