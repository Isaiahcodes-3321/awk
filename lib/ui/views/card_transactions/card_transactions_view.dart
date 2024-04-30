import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'card_transactions_viewmodel.dart';

class CardTransactionsView extends StackedView<CardTransactionsViewModel> {
  const CardTransactionsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CardTransactionsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: ListView(children: [
        verticalSpaceSmall,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: () {
              viewModel.navigateBack();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: kcFormBorderColor.withOpacity(0.3),
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            fill: 0.9,
                            color: kcTextSubTitleColor,
                            size: 16,
                          ),
                          onPressed: () {
                            viewModel.navigateBack();
                          }),
                    ),
                    horizontalSpaceTiny,
                    Text(
                      'back',
                      style: ktsSubtitleTextAuthentication,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        verticalSpaceSmallMid,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Card Transactions',
            style: ktsTitleTextAuthentication,
          ),
        ),
        verticalSpaceTiny,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'View your latest transactions ',
            style: ktsSubtitleTextAuthentication,
          ),
        ),
        verticalSpaceIntermitent,
        Builder(builder: (context) {
          if (viewModel.isBusy) {
            return const SizedBox(
                height: 500,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: kcPrimaryColor,
                    ),
                  ],
                )));
          }
          if (viewModel.data!.isEmpty) {
            return SizedBox(
                height: 400,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/Group 1000007963.svg',
                      width: 200,
                      height: 150,
                    ),
                    verticalSpaceSmall,
                    Text(
                      'No history available',
                      style: ktsSubtitleTextAuthentication,
                    ),
                  ],
                )));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(2),
            scrollDirection: Axis.vertical,
            // physics: const NeverScrollableScrollPhysics(),
            primary: true,
            shrinkWrap: true,
            itemCount: viewModel.data!.length,
            itemBuilder: (context, index) {
              var cardTransactions = viewModel.data![index];
              return CardTransaction(
                cardTransactions: cardTransactions,

                // ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: 0.2,
              );
            },
          );
        }),
      ]),
    );
  }

  @override
  CardTransactionsViewModel viewModelBuilder(
    BuildContext context,
  ) {
    final String cardId = ModalRoute.of(context)!.settings.arguments as String;
    return CardTransactionsViewModel(cardId: cardId);
  }
}

class CardTransaction extends ViewModelWidget<CardTransactionsViewModel> {
  const CardTransaction({Key? key, required this.cardTransactions
      // required this.expenseId,
      })
      : super(key: key);

  final CardTransactions cardTransactions;

  // final String expenseId;

  @override
  Widget build(BuildContext context, CardTransactionsViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      title: Text(
        cardTransactions.type,
        // '#${purchase.reference}',
        // expenses.merchantName,
        // '${expenses.description[0].toUpperCase()}${expenses.description.substring(1)}',
        style: TextStyle(
          fontFamily: 'Satoshi',
          color: kcTextTitleColor.withOpacity(0.9),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        // expenses.expenseDate,
        cardTransactions.amount.toString(),
        style: TextStyle(
          fontFamily: 'Satoshi',
          color: kcTextSubTitleColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: Text(
        // expenses.merchantName,
        cardTransactions.currency,
        style: TextStyle(
          fontFamily: 'Satoshi',
          color: kcTextSubTitleColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text(
    //             businessTask.userFullname,
    //             // '#${purchase.reference}',
    //             // expenses.merchantName,
    //             // '${expenses.description[0].toUpperCase()}${expenses.description.substring(1)}',
    //             style: TextStyle(
    //               fontFamily: 'Satoshi',
    //               color: kcTextTitleColor.withOpacity(0.9),
    //               fontSize: 18,
    //               fontWeight: FontWeight.w600,
    //             ),
    //             overflow: TextOverflow.ellipsis,
    //             maxLines: 1,
    //           ),
    //         ],
    //       ),
    //       // verticalSpaceTinyt1,
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text(
    //             // expenses.expenseDate,
    //             businessTask.userEmail,
    //             style: TextStyle(
    //               fontFamily: 'Satoshi',
    //               color: kcTextSubTitleColor,
    //               fontSize: 14,
    //               fontWeight: FontWeight.w400,
    //             ),
    //             overflow: TextOverflow.ellipsis,
    //             maxLines: 1,
    //           ),
    //           Text(
    //             // expenses.merchantName,
    //             businessTask.taskType,
    //             style: TextStyle(
    //               fontFamily: 'Satoshi',
    //               color: kcTextSubTitleColor,
    //               fontSize: 14,
    //               fontWeight: FontWeight.w400,
    //             ),
    //             overflow: TextOverflow.ellipsis,
    //             maxLines: 1,
    //           ),
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }
}
