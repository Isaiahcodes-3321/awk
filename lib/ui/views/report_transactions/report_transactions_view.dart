import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/services/business_creation_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'report_transactions_viewmodel.dart';

class ReportTransactionsView extends StackedView<ReportTransactionsViewModel> {
  const ReportTransactionsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ReportTransactionsViewModel viewModel,
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
            'Transactions',
            style: ktsTitleTextAuthentication,
          ),
        ),
        verticalSpaceTiny,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'View and manage your transactions ',
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
            // physics: AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(2),
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            primary: true,
            shrinkWrap: true,
            itemCount: viewModel.data!.length,
            itemBuilder: (context, index) {
              var businessStatement = viewModel.data![index];
              return AccountStatement(
                businessStatement: businessStatement,

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
  ReportTransactionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReportTransactionsViewModel();
}

class AccountStatement extends ViewModelWidget<ReportTransactionsViewModel> {
  const AccountStatement({Key? key, required this.businessStatement
      // required this.expenseId,
      })
      : super(key: key);

  final BusinessAccountStatement businessStatement;

  // final String expenseId;

  @override
  Widget build(BuildContext context, ReportTransactionsViewModel viewModel) {
    // Parse the transactionDate to a DateTime object
    final transactionDate = DateTime.parse(businessStatement.transactionDate);

    // Format the date part
    final datePart = DateFormat('yyyy-MM-dd').format(transactionDate);

    // Format the time part to 12-hour format with AM/PM
    final timePart = DateFormat('h:mm a').format(transactionDate);
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
                              .format(businessStatement
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: businessStatement.type == 'Credit'
                          ? kcSuccessColor.withOpacity(.9)
                          : kcErrorColor.withOpacity(.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      businessStatement.type,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        color: Colors
                            .white, // Assuming you want the text color to be white for better contrast
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              // verticalSpaceTinyt1,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$datePart'
                    // , $timePart'
                    ,
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
                    businessStatement.paymentReference,
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
