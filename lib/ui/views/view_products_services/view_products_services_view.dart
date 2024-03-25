import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/ui/common/app_colors.dart';

import 'view_products_services_viewmodel.dart';

class ViewProductsServicesView
    extends StackedView<ViewProductsServicesViewModel> {
  const ViewProductsServicesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ViewProductsServicesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  ViewProductsServicesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ViewProductsServicesViewModel();
}
