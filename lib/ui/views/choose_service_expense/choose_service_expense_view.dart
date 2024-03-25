import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'choose_service_expense_viewmodel.dart';

class ChooseServiceExpenseView extends StatefulWidget {
  const ChooseServiceExpenseView({
    Key? key,
  }) : super(key: key);

  @override
  State<ChooseServiceExpenseView> createState() =>
      _ChooseServiceExpenseViewState();
}

class _ChooseServiceExpenseViewState extends State<ChooseServiceExpenseView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChooseServiceExpenseViewModel>.reactive(
      viewModelBuilder: () => ChooseServiceExpenseViewModel(),
      onViewModelReady: (model) async {},
      builder: (context, model, child) => Scaffold(
        backgroundColor: kcButtonTextColor,
        body: Column(
          children: [
            Container(
              height: 130,
              color: kcPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    verticalSpaceMedium,
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 32,
                          ),
                          color: kcButtonTextColor,
                          onPressed: () {
                            Navigator.of(context)
                                .pop(model.selectedServiceExpenses);
                          },
                        ),
                        Text(
                          'Choose Service Expense',
                          style: ktsHeaderTextWhite,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                primary: false,
                scrollDirection: Axis.vertical,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kcButtonTextColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: kcTextColorLight.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 0,
                        // changes position of shadow
                      ),
                    ],
                  ),
                  child: Builder(builder: (context) {
                    if (model.isBusy) {
                      return const Column(children: [
                        verticalSpaceLarge,
                        CircularProgressIndicator(
                          color: kcPrimaryColor,
                        ),
                        verticalSpaceLarge
                      ]);
                    }
                    if (model.data!.isEmpty) {
                      return const SizedBox(
                          height: 400,
                          child: Center(child: Text('No Service Expense')));
                    }
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      primary: true,
                      shrinkWrap: true,
                      itemCount: model.data!.length,
                      itemBuilder: (context, index) {
                        return ServiceExpenseCard(
                          serviceExpenses: model.data![index],
                          isSelected: model.selectedServiceExpenses
                              .contains(model.data![index]),
                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                model.selectedServiceExpenses
                                    .add(model.data![index]);
                              } else {
                                model.selectedServiceExpenses
                                    .remove(model.data![index]);
                              }
                            });
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return verticalSpaceTiny;
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if (model.selectedServiceExpenses.isNotEmpty) {
                Navigator.of(context).pop(model.selectedServiceExpenses);
              }
            },
            child: const Text('Add Selected Service Expense'),
          ),
        ),
      ),
    );
  }
}

class ServiceExpenseCard extends StatelessWidget {
  const ServiceExpenseCard({
    Key? key,
    required this.serviceExpenses,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  final Services serviceExpenses;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isSelected ? kcPrimaryColor : kcStrokeColor,
      title: Text(
        serviceExpenses.name,
        style: ktsBodyText,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),

      // trailing: Text(
      //   NumberFormat.currency(locale: 'en', symbol: '\N')
      //       .format(purchaseItems.price),
      //   style: ktsBodyText,
      // ),
      onTap: () {
        onSelected(!isSelected);
      },
    );
  }
}
