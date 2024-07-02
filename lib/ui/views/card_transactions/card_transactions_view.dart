import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
            'View your transactions ',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: NumberFormat.currency(
                                  locale: 'en_NGN', symbol: '₦')
                              .currencySymbol, // The remaining digits without the symbol
                          style: GoogleFonts.openSans(
                            color: kcTextTitleColor.withOpacity(0.8),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ).copyWith(fontFamily: 'Roboto'),
                        ),
                        TextSpan(
                          text: NumberFormat.currency(
                                  locale: 'en_NGN', symbol: '')
                              .format(cardTransactions
                                  .amount), // The remaining digits without the symbol
                          style: TextStyle(
                              fontFamily: 'Satoshi',
                              color: kcTextTitleColor.withOpacity(0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    cardTransactions.createdAt.substring(0, 10),
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: kcTextTitleColor.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
              // verticalSpaceTinyt1,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cardTransactions.type,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      color: kcTextSubTitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    cardTransactions.createdAt.substring(11, 16),
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      color: kcTextSubTitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
