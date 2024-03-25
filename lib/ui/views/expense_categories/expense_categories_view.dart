import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/authentication_layout.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'expense_categories_viewmodel.dart';

class ExpenseCategoriesView extends StackedView<ExpenseCategoriesViewModel> {
  const ExpenseCategoriesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ExpenseCategoriesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: AuthenticationLayout(
        onBackPressed: viewModel.navigateBack,
        busy: viewModel.isBusy,
        onMainButtonTapped: () {},
        title: 'Expense categories',
        subtitle: 'View categories',
        mainButtonTitle: 'Update categories',
        form: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: viewModel.expenseCategoryList.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.expenseCategoryList[index],
                      style: ktsTextAuthentication,
                    ),
                    verticalSpaceSmall,
                    // Add additional information if needed
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(ExpenseCategoriesViewModel viewModel) async {
    // syncFormWithViewModel(viewModel);
    await viewModel.getExpenseCategoryWithSets();
  }

  @override
  ExpenseCategoriesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ExpenseCategoriesViewModel();
}
