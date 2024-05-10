import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/services/expense_service.dart';

import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/employee_inbox/employee_inbox_view.dart';
import 'package:verzo/ui/views/employee_settings/employee_settings_view.dart';

import 'employee_home_viewmodel.dart';

class EmployeeHomeView extends StatefulWidget {
  const EmployeeHomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeHomeView> createState() => _EmployeeHomeViewState();
}

class _EmployeeHomeViewState extends State<EmployeeHomeView> {
  int selectedPageIndex = 0;
  List<Widget> bottomnav = [
    const EmployeeNewView(),
    const EmployeeInboxView(),
    const EmployeeSettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return ViewModelBuilder<EmployeeHomeViewModel>.reactive(
        viewModelBuilder: () => EmployeeHomeViewModel(),
        onViewModelReady: (viewModel) async {
          // viewModel.setUserDetails();
          // await viewModel.getUserAndBusinessData();
          await viewModel.getUserCardsByBusiness();
          await viewModel.getExpenseByBusiness();

          viewModel.setUserDetails();
        },
        builder: (
          BuildContext context,
          EmployeeHomeViewModel viewModel,
          Widget? child,
        ) {
          return PopScope(
            canPop: false,
            child: Scaffold(
              backgroundColor: Color(0XFF2A5DC8),
              body: bottomnav[selectedPageIndex],
              bottomNavigationBar: SizedBox(
                height: 60,
                child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: kcButtonTextColor,
                    selectedItemColor: kcIconColor,
                    unselectedItemColor:
                        kcTextColorLight, // Set unselected item color
                    selectedLabelStyle:
                        ktsFormHintText, // Set selected label color
                    unselectedLabelStyle: ktsFormHintText,
                    iconSize: 24,
                    currentIndex: selectedPageIndex,
                    onTap: (index) {
                      setState(() {
                        selectedPageIndex = index;
                      });
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          selectedPageIndex == 0
                              ? 'assets/images/home-02-2.svg'
                              : 'assets/images/home-02.svg',
                          width: 24,
                          height: 24,
                        ),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            selectedPageIndex == 1
                                ? 'assets/images/notification-02.svg'
                                : 'assets/images/notification-02-2.svg',
                            width: 24,
                            height: 24,
                          ),
                          label: 'Inbox'),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          selectedPageIndex == 2
                              ? 'assets/images/employee_settings.svg'
                              : 'assets/images/employee_settings-2.svg',
                          width: 24,
                          height: 24,
                        ),
                        label: 'Settings',
                      ),
                    ]),
              ),
            ),
          );
        });
  }
}

class EmployeeNewView extends StatefulWidget {
  const EmployeeNewView({Key? key}) : super(key: key);

  @override
  State<EmployeeNewView> createState() => _NewViewState();
}

class _NewViewState extends State<EmployeeNewView>
    with SingleTickerProviderStateMixin {
  final navigationService = locator<NavigationService>();

  // GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EmployeeHomeViewModel>.reactive(
        viewModelBuilder: () => EmployeeHomeViewModel(),
        onViewModelReady: (viewModel) async {
          viewModel.setUserDetails();

          await viewModel.getUserCardsByBusiness();
          await viewModel.getExpenseByBusiness();
        },
        builder: (
          BuildContext context,
          EmployeeHomeViewModel viewModel,
          Widget? child,
        ) {
          return Scaffold(
            backgroundColor: Color(0XFF2A5DC8),
            floatingActionButton: FloatingActionButton(
              elevation: 4,
              highlightElevation: 8.0, // Elevation when button is pressed
              focusElevation: 4.0, // Elevation when button is focused
              hoverElevation: 4.0,
              foregroundColor: kcButtonTextColor,
              backgroundColor: kcPrimaryColor.withOpacity(0.7),
              shape: const CircleBorder(
                eccentricity: 1,
                side: BorderSide.none,
              ),
              onPressed: () async {
                final result = await viewModel.navigationService
                    .navigateTo(Routes.addExpenseView);

                if (result == true) {
                  viewModel.reloadExpenseData();
                }
              },
              child: const Icon(
                Icons.add,
                size: 24,
              ),
            ),
            // key: globalKey,
            // drawer: const CustomDrawer(),
            body: Stack(fit: StackFit.expand, children: [
              Container(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: MediaQuery.of(context).size.height * 0.06),
                color: Color(0XFF2A5DC8),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Text(
                          'Dashboard',
                          // style: GoogleFonts.openSans(
                          //   color: kcButtonTextColor,
                          //   fontSize: 28,
                          //   fontWeight: FontWeight.w600,
                          // )
                          style: ktsHeroTextWhiteDashboardHeader,
                        ),
                      ),
                      verticalSpaceTiny1,
                      Builder(builder: (context) {
                        if (viewModel.isBusy) {
                          return const CircularProgressIndicator(
                            color: kcPrimaryColor,
                          );
                        }
                        if (viewModel.businessCard.isEmpty) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: kcCardColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(viewModel.userName,
                                              style:
                                                  ktsHeroTextWhiteDashboard1),
                                          SvgPicture.asset(
                                            'assets/images/eye.svg',
                                            width: 22,
                                            height: 22,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Card number',
                                            style: ktsButtonText2,
                                          ),
                                          verticalSpaceTinyt1,
                                          Text(
                                            'XXXX XXXX XXXX XXXX',
                                            style: ktsHeroTextWhiteDashboard1,
                                          )
                                        ],
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Expiry date',
                                                      style: ktsButtonText2,
                                                    ),
                                                    verticalSpaceTinyt1,
                                                    Text(
                                                      'XX/XX',
                                                      style:
                                                          ktsHeroTextWhiteDashboard2,
                                                    )
                                                  ],
                                                ),
                                                horizontalSpaceRegular,
                                                Column(
                                                  children: [
                                                    Text(
                                                      'CVV',
                                                      style: ktsButtonText2,
                                                    ),
                                                    verticalSpaceTinyt1,
                                                    Text(
                                                      'XXX',
                                                      style:
                                                          ktsHeroTextWhiteDashboard2,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            SvgPicture.asset(
                                              'assets/images/MasterCard.svg',
                                              // width: 20,
                                              // height: 20,
                                            ),
                                          ]),
                                    ]),
                              ),
                              verticalSpaceSmall,
                              Container(
                                padding: EdgeInsets.zero,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        viewModel.userRequestCard();
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                kcPrimaryColor.withOpacity(0.6),
                                            child: const Icon(
                                              Icons.credit_card_outlined,
                                              color: kcButtonTextColor,
                                              size: 24,
                                            ),
                                          ),
                                          verticalSpaceTiny,
                                          Text(
                                            'Request card',
                                            style: GoogleFonts.dmSans(
                                              color: kcButtonTextColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                        return Material(
                          color: Colors.transparent,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: viewModel.businessCard.length,
                            itemBuilder: (context, index) {
                              var businessCard = viewModel.businessCard[index];
                              return Cards(
                                businessCard: businessCard,
                                cardId: businessCard.id,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return verticalSpaceTiny;
                            },
                          ),
                        );
                      }),
                    ]),
              ),
              DraggableScrollableSheet(
                snap: false,
                initialChildSize: 0.8,
                minChildSize: 0.2,
                maxChildSize: 0.8,
                builder: (context, controller) => Container(
                  decoration: const BoxDecoration(
                      color: kcButtonTextColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24),
                          topLeft: Radius.circular(24))),
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(bottom: 2),
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpaceTiny1,
                        Center(
                          child: Container(
                            width: 80,
                            height: 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: kcTextSubTitleColor.withOpacity(0.3)),
                          ),
                        ),
                        verticalSpaceIntermitent,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Text(
                            'Latest expenses',
                            style: ktsHeaderText,
                          ),
                        ),
                        verticalSpaceSmallMid,
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
                          if (
                              // viewModel.data == null ||

                              viewModel.expenses.isEmpty) {
                            return SizedBox(
                                height: 400,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/Group 1000007942.svg',
                                      width: 200,
                                      height: 150,
                                    ),
                                    verticalSpaceSmall,
                                    Text(
                                      'No expense available',
                                      style: ktsSubtitleTextAuthentication,
                                    ),
                                  ],
                                )));
                          }
                          return Material(
                            color: Colors.transparent,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(2),
                              scrollDirection: Axis.vertical,
                              // physics: const NeverScrollableScrollPhysics(),
                              primary: true,
                              shrinkWrap: true,
                              itemCount: viewModel.data!.length,
                              itemBuilder: (context, index) {
                                var expense = viewModel.data![index];
                                return
                                    // Container(
                                    //   clipBehavior: Clip.antiAlias,
                                    //   padding: EdgeInsets.zero,
                                    //   width: double.infinity,
                                    //   decoration: BoxDecoration(
                                    //     // color: kcButtonTextColor,
                                    //     borderRadius:
                                    //         BorderRadius.circular(12),
                                    //     border: Border.all(
                                    //         width: 1.3,
                                    //         color: kcBorderColor),
                                    //   ),
                                    //   child:
                                    ExpenseCard(
                                  expenses: expense,
                                  expenseId: expense.id,
                                  // ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider(
                                  thickness: 0.2,
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          );
        });
  }
}

class Cards extends ViewModelWidget<EmployeeHomeViewModel> {
  const Cards({Key? key, required this.businessCard, required this.cardId})
      : super(key: key);

  final BusinessCard businessCard;

  final String cardId;

  @override
  Widget build(BuildContext context, EmployeeHomeViewModel viewModel) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: kcCardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(viewModel.userName, style: ktsHeroTextWhiteDashboard1),
                    // SvgPicture.asset(
                    //   'assets/images/eye.svg',
                    //   width: 22,
                    //   height: 22,
                    //   color: Colors.white,
                    // ),
                  ],
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card number',
                      style: ktsButtonText2,
                    ),
                    verticalSpaceTinyt1,
                    Text(
                      businessCard.maskedPan,
                      style: ktsHeroTextWhiteDashboard1,
                    )
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expiry date',
                                style: ktsButtonText2,
                              ),
                              verticalSpaceTinyt1,
                              Text(
                                businessCard.expiryDate,
                                style: ktsHeroTextWhiteDashboard2,
                              )
                            ],
                          ),
                          horizontalSpaceRegular,
                          Column(
                            children: [
                              Text(
                                'CVV',
                                style: ktsButtonText2,
                              ),
                              verticalSpaceTinyt1,
                              Text(
                                'XXX',
                                style: ktsHeroTextWhiteDashboard2,
                              )
                            ],
                          )
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/images/MasterCard.svg',
                        // width: 20,
                        // height: 20,
                      ),
                    ]),
              ]),
        ),
        // verticalSpaceSmall,
        // Container(
        //   padding: EdgeInsets.zero,
        //   width: MediaQuery.of(context).size.width * 0.9,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Text('Billing address',
        //           style: GoogleFonts.dmSans(
        //             color: kcButtonTextColor.withOpacity(0.7),
        //             fontSize: 16,
        //             fontWeight: FontWeight.w300,
        //           )),
        //       verticalSpaceTiny,
        //       Text('No',
        //           // '${businessCard.line1},${businessCard.city},${businessCard.state},${businessCard.postalCode}',
        //           style: GoogleFonts.openSans(
        //             color: kcButtonTextColor,
        //             fontSize: 18,
        //             fontWeight: FontWeight.w500,
        //           ))
        //     ],
        //   ),
        // ),
        verticalSpaceSmallMid,
        Container(
          padding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  viewModel.userRequestCard();
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: kcPrimaryColor.withOpacity(0.6),
                      child: const Icon(
                        Icons.credit_card_outlined,
                        color: kcButtonTextColor,
                        size: 24,
                      ),
                    ),
                    verticalSpaceTiny,
                    Text(
                      'Request card',
                      style: GoogleFonts.dmSans(
                        color: kcButtonTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  viewModel.navigationService.navigateTo(
                      Routes.cardTransactionsView,
                      arguments: cardId);
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: kcPrimaryColor.withOpacity(0.6),
                      child: const Icon(
                        Icons.receipt_outlined,
                        color: kcButtonTextColor,
                        size: 24,
                      ),
                    ),
                    verticalSpaceTiny,
                    Text(
                      'Transactions',
                      style: GoogleFonts.dmSans(
                        color: kcButtonTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ExpenseCard extends ViewModelWidget<EmployeeHomeViewModel> {
  const ExpenseCard({
    Key? key,
    required this.expenses,
    required this.expenseId,
  }) : super(key: key);

  final Expenses expenses;

  final String expenseId;

  @override
  Widget build(BuildContext context, EmployeeHomeViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: kcFormBorderColor.withOpacity(0.3),
        onTap: (() async {
          final result = await viewModel.navigationService
              .navigateTo(Routes.viewExpenseView, arguments: expenseId);

          if (result == true) {
            viewModel.reloadExpenseData();
          }
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // '#${purchase.reference}',
                    // expenses.merchantName,
                    '${expenses.description[0].toUpperCase()}${expenses.description.substring(1)}',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: kcTextTitleColor.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
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
                              .format(expenses
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
                ],
              ),
              // verticalSpaceTinyt1,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    expenses.expenseDate,
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: kcTextSubTitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    expenses.merchantName,
                    style: TextStyle(
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
        ),
      ),
    );
  }
}
