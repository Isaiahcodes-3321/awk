import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/services/expense_service.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/views/sales/sales_view.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/ui/views/home/home_viewmodel.dart';
import 'package:verzo/ui/views/expense/expense_view.dart';
import 'package:verzo/ui/views/home/reveal_card_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verzo/ui/views/purchase/purchase_view.dart';


class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  int selectedPageIndex = 0;
  List<Widget> bottomnav = [
    const NewView(),
    const SalesView(),
    const ExpenseView(),
    const PurchaseView(),
  ];

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (viewModel) async {
          viewModel.setUserDetails();
          await viewModel.getBusinessById();
          await viewModel.getInvoiceByBusiness();
          await viewModel.getExpenseByBusiness();
          await viewModel.getPurchasesByBusiness();
          //refresh token on invoice,expense,purchase list
        },
        builder: (
          BuildContext context,
          HomeViewModel viewModel,
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
                                ? 'assets/images/receipt-lines-2.svg'
                                : 'assets/images/receipt-lines.svg',
                            width: 24,
                            height: 24,
                          ),
                          label: 'Invoice'),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          selectedPageIndex == 2
                              ? 'assets/images/card-minus-2.svg'
                              : 'assets/images/card-minus.svg',
                          width: 24,
                          height: 24,
                        ),
                        label: 'Expense',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          selectedPageIndex == 3
                              ? 'assets/images/cart-2.svg'
                              : 'assets/images/cart.svg',
                          width: 24,
                          height: 24,
                        ),
                        label: 'Purchase',
                      )
                    ]),
              ),
            ),
          );
        });
  }
}

class NewView extends StatefulWidget {
  const NewView({Key? key}) : super(key: key);

  @override
  State<NewView> createState() => _NewViewState();
}

class _NewViewState extends State<NewView> with SingleTickerProviderStateMixin {
  final navigationService = locator<NavigationService>();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (viewModel) async {
          await viewModel.getCardsByBusiness();
          viewModel.setUserDetails();
          await viewModel.subscriptionValidation();
          // await viewModel.getUserAndBusinessData();
          await viewModel.totalWeeklyInvoicesAmount();
          await viewModel.getExpensesForWeek();
          await viewModel.getPurchasesForWeek();
          await viewModel.totalMonthlyInvoicesAmount();
          await viewModel.getExpensesForMonth();
          await viewModel.getPurchasesForMonth();
          //refresh token on weekly invoice expense purchase.
        },
        builder: (
          BuildContext context,
          HomeViewModel viewModel,
          Widget? child,
        ) {
          return Scaffold(
            backgroundColor: Color(0XFF2A5DC8),
            key: globalKey,
            drawer: const CustomDrawer(),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    globalKey.currentState?.openDrawer();
                                  },
                                  child: const Icon(Icons.menu,
                                      size: 24, color: kcButtonTextColor),
                                ),
                                horizontalSpaceTiny,
                                Text(
                                  'Dashboard',
                                  style: ktsHeroTextWhiteDashboardHeader,
                                ),
                              ],
                            ),
                            PopupMenuButton(
                              iconColor: kcButtonTextColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 64),
                              surfaceTintColor: kcButtonTextColor,
                              elevation: 3,
                              color: kcButtonTextColor,
                              offset: const Offset(0, 38),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor:
                                    kcButtonTextColor.withOpacity(0.1),
                                child: const Icon(
                                  Icons.filter_list,
                                  color: kcButtonTextColor,
                                  size: 18,
                                ),
                              ),

                              // SvgPicture.asset(
                              //   'assets/images/Frame 1000007915.svg',
                              //   width: 30,
                              //   height: 30,
                              //   // color: kcPrimaryColor.withOpacity(0.3),
                              // ),
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    onTap: () {
                                      setState(() {
                                        viewModel.isChecked =
                                            true; // Set the checkbox state to true for 'Last 7 days'
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          fillColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                              return viewModel.isChecked
                                                  ? kcFormBorderColor
                                                      .withOpacity(.7)
                                                  : null;

                                              // kcFormBorderColor.withOpacity(
                                              //     .2); // You can customize the fill color if needed
                                            },
                                          ),
                                          checkColor: kcTextTitleColor,
                                          side: const BorderSide(
                                            width: 1,
                                            color:
                                                kcFormBorderColor, // Set the border color
                                          ),
                                          value: viewModel.isChecked,
                                          onChanged: null,
                                        ),
                                        Text(
                                          'This week',
                                          style: ktsFormHintText,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      setState(() {
                                        viewModel.isChecked =
                                            false; // Set the checkbox state to false for 'Last 30 days'
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          fillColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                              return !viewModel.isChecked
                                                  ? kcFormBorderColor
                                                      .withOpacity(.7)
                                                  : null;
                                              // You can customize the fill color if needed
                                            },
                                          ),
                                          checkColor: kcTextTitleColor,
                                          side: const BorderSide(
                                            width: 1,
                                            color:
                                                kcFormBorderColor, // Set the border color
                                          ),
                                          value: !viewModel.isChecked,
                                          onChanged: null,
                                        ),
                                        Text(
                                          'This month',
                                          style: ktsFormHintText,
                                        ),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                            )
                          ],
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
                                  border: Border.all(
                                      strokeAlign: BorderSide.strokeAlignInside,
                                      width: 2,
                                      color: kcCardBorderColor),
                                  color: kcCardColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/verzo_logo22.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const Text(
                                        '**** **** **** ****',
                                        // style: ktsHeroTextWhiteDashboard1,
                                        style: TextStyle(
                                            color: kcButtonTextColor,
                                            fontSize: 30),
                                      ),
                                      Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text('CARD HOLDER',
                                                    style:
                                                        ktsSubtitleTextAuthentication1),
                                              ],
                                            ),
                                            SvgPicture.asset(
                                              'assets/images/verve.svg',
                                              width: 20,
                                              height: 20,
                                            ),
                                          ]),
                                    ]),
                              ),
                              verticalSpaceTiny1,
                              Center(
                                child: Text(
                                  'You have no card',
                                  style: ktsButtonText,
                                ),
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
                                        viewModel.checkbusinessAcccount();
                                        // viewModel.navigationService
                                        //     .navigateTo(Routes.addCardView);
                                        // viewModel.createSudoCard();
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                kcPrimaryColor.withOpacity(0.6),
                                            child: const Icon(
                                              Icons.add,
                                              color: kcButtonTextColor,
                                              size: 24,
                                            ),
                                          ),
                                          verticalSpaceTiny,
                                          Text(
                                            'New card',
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
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: viewModel.businessCard.length,
                            itemBuilder: (context, index) {
                              var businessCard = viewModel.businessCard[index];

                              return Cards(
                                cardId: businessCard.id,
                                businessCard: businessCard,
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
                    // physics: const NeverScrollableScrollPhysics(),
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
                        verticalSpaceSmallMid,
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            top: 0,
                            bottom: 16,
                          ),
                          scrollDirection: Axis.vertical,
                          primary: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 110,
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: false,
                                    primary: false,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.76,
                                        decoration: BoxDecoration(
                                          color: const Color(0XFF2A5DC8),
                                          // color: Colors.white,
                                          // gradient: const LinearGradient(
                                          //   colors: [
                                          //     // kcBackgroundColor,
                                          //     Colors.white,
                                          //     Color(0xFF6275E9),
                                          //   ],
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              width: 0.1,
                                              color: kcPrimaryColor
                                                  .withOpacity(0.9)),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              // style: ktsButtonText,
                                              'Revenue',
                                              style: TextStyle(
                                                fontFamily: 'Satoshi',
                                                color: kcButtonTextColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            // verticalSpaceSmallMid,
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        kcButtonTextColor,
                                                    child: SvgPicture.asset(
                                                        'assets/images/trending_up.svg',
                                                        width: 14,
                                                        height: 14,
                                                        color: kcSuccessColor),
                                                  ),
                                                  horizontalSpaceminute2,
                                                  Text(
                                                    "${viewModel.isChecked ? (viewModel.weeklyInvoices?.percentageOfIncreaseInInvoicesThisWeek ?? 0) : (viewModel.monthlyInvoices?.percentageIncreaseInInvoicesThisMonth ?? 0)}%",
                                                    style: const TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      color: kcButtonTextColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ]),
                                            // verticalSpaceTiny,
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: NumberFormat.currency(
                                                            locale: 'en_NGN',
                                                            symbol: '₦')
                                                        .currencySymbol, // The remaining digits without the symbol
                                                    style: const TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      color: kcButtonTextColor,
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ).copyWith(
                                                        fontFamily: 'Roboto'),
                                                  ),
                                                  TextSpan(
                                                    text: viewModel.isChecked
                                                        ? NumberFormat.currency(
                                                                locale:
                                                                    'en_NGN',
                                                                symbol: '')
                                                            .format(viewModel
                                                                    .weeklyInvoices
                                                                    ?.totalInvoiceAmountForWeek ??
                                                                0)
                                                        : NumberFormat.currency(
                                                                locale:
                                                                    'en_NGN',
                                                                symbol: '')
                                                            .format(viewModel
                                                                    .monthlyInvoices
                                                                    ?.totalInvoiceAmountForMonth ??
                                                                0), // The remaining digits without the symbol
                                                    style: const TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      color: kcButtonTextColor,
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      horizontalSpaceSmall,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.76,
                                        decoration: BoxDecoration(
                                          color: const Color(0XFF2A5DC8),
                                          // gradient: const LinearGradient(
                                          //   colors: [
                                          //     Color(0xFF6275E9),
                                          //     kcBackgroundColor,
                                          //   ],
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              width: 0.1,
                                              color: kcPrimaryColor
                                                  .withOpacity(0.9)),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                                style: TextStyle(
                                                  fontFamily: 'Satoshi',
                                                  color: kcButtonTextColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                'Expenses'),
                                            // verticalSpaceSmallMid,
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        kcButtonTextColor,
                                                    child: SvgPicture.asset(
                                                        'assets/images/trending_up.svg',
                                                        width: 14,
                                                        height: 14,
                                                        color: kcSuccessColor),
                                                  ),
                                                  horizontalSpaceminute2,
                                                  Text(
                                                    "${viewModel.isChecked ? (viewModel.expenseForWeek?.percentageIncreaseInExpenseThisWeek ?? 0) : (viewModel.expenseForMonth?.percentageIncreaseInExpenseThisMonth ?? 0)}%",
                                                    style: const TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      color: kcButtonTextColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ]),
                                            // verticalSpaceTiny,
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: NumberFormat.currency(
                                                            locale: 'en_NGN',
                                                            symbol: '₦')
                                                        .currencySymbol, // The remaining digits without the symbol
                                                    style: const TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      color: kcButtonTextColor,
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ).copyWith(
                                                        fontFamily: 'Roboto'),
                                                  ),
                                                  TextSpan(
                                                    text: viewModel.isChecked
                                                        ? NumberFormat.currency(
                                                                locale:
                                                                    'en_NGN',
                                                                symbol: '')
                                                            .format(viewModel
                                                                    .expenseForWeek
                                                                    ?.totalExpenseAmountThisWeek ??
                                                                0)
                                                        : NumberFormat.currency(
                                                                locale:
                                                                    'en_NGN',
                                                                symbol: '')
                                                            .format(viewModel
                                                                    .expenseForMonth
                                                                    ?.totalExpenseAmountThisMonth ??
                                                                0), // The remaining digits without the symbol
                                                    // style:
                                                    //     ktsCardMetricsAmount2,
                                                    style: const TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      color: kcButtonTextColor,
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      horizontalSpaceSmall,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.76,
                                        decoration: BoxDecoration(
                                          color: Color(0XFF2A5DC8),
                                          // gradient: const LinearGradient(
                                          //   colors: [
                                          //     kcBackgroundColor,
                                          //     Color(0xFF6275E9),
                                          //   ],
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              width: 0.1,
                                              color: kcPrimaryColor
                                                  .withOpacity(0.9)),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                                style: TextStyle(
                                                  fontFamily: 'Satoshi',
                                                  color: kcButtonTextColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                'Purchases'),
                                            // verticalSpaceSmallMid,
                                            // verticalSpaceTiny,
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        kcButtonTextColor,
                                                    child: SvgPicture.asset(
                                                        'assets/images/trending_up.svg',
                                                        width: 14,
                                                        height: 14,
                                                        color: kcSuccessColor),
                                                  ),
                                                  horizontalSpaceminute2,
                                                  Text(
                                                    "${viewModel.isChecked ? (viewModel.purchaseForWeek?.percentageIncreaseInPurchaseThisWeek ?? 0) : (viewModel.purchaseForMonth?.percentageIncreaseInPurchaseThisMonth ?? 0)}%",
                                                    style: const TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      color: kcButtonTextColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ]),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: NumberFormat.currency(
                                                            locale: 'en_NGN',
                                                            symbol: '₦')
                                                        .currencySymbol, // The remaining digits without the symbol
                                                    style: const TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      color: kcButtonTextColor,
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ).copyWith(
                                                        fontFamily: 'Roboto'),
                                                  ),
                                                  TextSpan(
                                                    text: viewModel.isChecked
                                                        ? NumberFormat.currency(
                                                                locale:
                                                                    'en_NGN',
                                                                symbol: '')
                                                            .format(viewModel
                                                                    .purchaseForWeek
                                                                    ?.totalPurchaseAmountThisWeek ??
                                                                0)
                                                        : NumberFormat.currency(
                                                                locale:
                                                                    'en_NGN',
                                                                symbol: '')
                                                            .format(viewModel
                                                                    .purchaseForMonth
                                                                    ?.totalPurchaseAmountThisMonth ??
                                                                0), // The remaining digits without the symbol
                                                    style: const TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      color: kcButtonTextColor,
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                              verticalSpaceIntermitent,
                              SizedBox(
                                height: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      height: 32,
                                      child: TabBar(
                                        // indicatorPadding:
                                        //     const EdgeInsets.symmetric(
                                        //         horizontal: 12),
                                        // indicatorColor: Color(0xFF6275E9),
                                        indicatorColor: kcPrimaryColor,
                                        indicatorWeight: 1,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        // indicator: BoxDecoration(
                                        //     color: kcStrokeColor.withOpacity(0.3),
                                        //     borderRadius: BorderRadius.circular(12)),
                                        padding: EdgeInsets.zero,
                                        unselectedLabelColor:
                                            kcTextSubTitleColor,
                                        // unselectedLabelStyle:
                                        //     GoogleFonts.openSans(
                                        //   // color: kcPrimaryColor,
                                        //   fontSize: 16,
                                        //   fontWeight: FontWeight.w500,
                                        // ),
                                        unselectedLabelStyle: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                            letterSpacing: 0),
                                        // labelColor: Color(0xFF6275E9),
                                        labelColor: kcPrimaryColor,
                                        labelStyle: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                          letterSpacing: 0,
                                        ),
                                        // labelStyle: GoogleFonts.openSans(
                                        //   // color: kcPrimaryColor,
                                        //   fontSize: 16,
                                        //   fontWeight: FontWeight.w500,
                                        // ),

                                        labelPadding: EdgeInsets.zero,
                                        tabs: const [
                                          Tab(
                                            text: 'Invoices',
                                          ),
                                          Tab(
                                            text: 'Expenses',
                                          ),
                                          Tab(
                                            text: 'Purchases',
                                          ),
                                        ],
                                        controller: tabController,
                                      ),
                                    ),
                                    Flexible(
                                      // <-- Move Expanded here
                                      child: TabBarView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        controller: tabController,
                                        children: [
                                          ListView(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            children: const [InvoiceListView()],
                                          ),
                                          ListView(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            children: const [ExpenseListView()],
                                          ),
                                          ListView(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            children: const [
                                              PurchaseListView()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

class Cards extends ViewModelWidget<HomeViewModel> {
  const Cards({Key? key, required this.businessCard, required this.cardId})
      : super(key: key);

  final BusinessCard businessCard;

  final String cardId;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(
                strokeAlign: BorderSide.strokeAlignInside,
                width: 2,
                color: kcCardBorderColor),
            color: kcCardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/images/verzo_logo22.svg',
                      width: 20,
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String businessIdValue =
                              prefs.getString('businessId') ?? '';
                          // Construct the URL
                          String url =
                              "https://beta.verzo.app/verzo/viewcard?businessId=${businessIdValue}&cardId=${cardId}";
                          debugPrint("Generated URL: $cardId");
                          // Print the full URL to the console
                          debugPrint("Generated URL: $url");
                          debugPrint("Generated URL: $cardId");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RevealCardInfoView(
                                url: url,
                                cardId: cardId,
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.visibility_sharp,
                          color: kcButtonTextColor.withOpacity(0.9),
                        ))
                  ],
                ),
                Text(
                  businessCard.maskedPan,
                  style: ktsHeroTextWhiteDashboard1,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(viewModel.userName,
                        style: ktsSubtitleTextAuthentication1),
                    SvgPicture.asset(
                      'assets/images/verve.svg',
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ]),
        ),
        verticalSpaceSmallMid,
        Container(
          padding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Opacity(
                opacity: 0.65,
                child: GestureDetector(
                  onTap: () {
                    null;
                    // viewModel.checkbusinessAcccount();
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: kcPrimaryColor.withOpacity(0.6),
                        child: const Icon(
                          Icons.add,
                          color: kcButtonTextColor,
                          size: 24,
                        ),
                      ),
                      verticalSpaceTiny,
                      Text(
                        'New card',
                        style: GoogleFonts.dmSans(
                          color: kcButtonTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InvoiceListView extends StatefulWidget {
  const InvoiceListView({Key? key}) : super(key: key);

  @override
  _InvoiceListViewState createState() => _InvoiceListViewState();
}

class _InvoiceListViewState extends State<InvoiceListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (viewModel) async {
        await viewModel.getInvoiceByBusiness();
      },
      builder: (BuildContext context, HomeViewModel viewModel, Widget? child) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 0.4,
                        color: kcBorderColor), // Border only on the bottom
                  ),
                ),
                // decoration: BoxDecoration(
                //   border: Border.all(width: 1, color: kcBorderColor),
                // ),
                child: Builder(builder: (context) {
                  if (viewModel.isBusy) {
                    return const CircularProgressIndicator(
                      color: kcPrimaryColor,
                    );
                  }
                  if (viewModel.invoices.isEmpty) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/Group_2780.svg',
                              width: 100,
                              height: 75,
                            ),
                            verticalSpaceSmall,
                            Text(
                              'No invoice available',
                              style: GoogleFonts.roboto(
                                color: kcTextSubTitleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            verticalSpaceTiny,
                            GestureDetector(
                              onTap: () => viewModel.navigationService
                                  .navigateTo(Routes.addSalesView),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_circle_outline,
                                    size: 18,
                                    color: kcPrimaryColor,
                                  ),
                                  horizontalSpaceminute,
                                  Text(
                                    'Create invoice',
                                    style: GoogleFonts.roboto(
                                      color: kcPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Material(
                    color: Colors.transparent,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: viewModel.invoices.length,
                      itemBuilder: (context, index) {
                        var invoices = viewModel.invoices[index];
                        return SalesCard(
                          sales: invoices,
                          saleId: invoices.id,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          thickness: 0.2,
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SalesCard extends ViewModelWidget<HomeViewModel> {
  const SalesCard({
    Key? key,
    required this.sales,
    required this.saleId,
  }) : super(key: key);
  final Sales sales;
  final String saleId;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: kcFormBorderColor.withOpacity(0.3),
        // highlightColor: kcPrimaryColor,
        onTap: (() {
          viewModel.navigationService
              .navigateTo(Routes.viewSalesView, arguments: saleId);
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
                    // '${sales.description[0].toUpperCase()}${sales.description.substring(1)}',
                    sales.customerName.length <= 15
                        ? '${sales.customerName[0].toUpperCase()}${sales.customerName.substring(1)}'
                        : '${sales.customerName[0].toUpperCase()}${sales.customerName.substring(1, 15)}...',
                    // sales.customerName,
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
                                  symbol: sales.currencySymbol)
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
                              .format(sales
                                  .totalAmount), // The remaining digits without the symbol
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
                    sales.transactionDate,
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
                    sales.paid
                        ? 'Paid'
                        : (sales.overdue! ? 'Overdue' : 'Pending'),
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: sales.paid
                          ? kcSuccessColor
                          : (sales.overdue!
                              ? kcErrorColor
                              : kcTextSubTitleColor),
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

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({Key? key}) : super(key: key);

  @override
  _ExpenseListViewState createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (viewModel) async {
        await viewModel.getExpenseByBusiness();
      },
      builder: (BuildContext context, HomeViewModel viewModel, Widget? child) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 0.4,
                        color: kcBorderColor), // Border only on the bottom
                  ),
                ),
                child: Builder(builder: (context) {
                  if (viewModel.isBusy) {
                    return const CircularProgressIndicator(
                      color: kcPrimaryColor,
                    );
                  }
                  if (viewModel.expenses.isEmpty) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/Group 1000007942.svg',
                              width: 100,
                              height: 75,
                            ),
                            verticalSpaceSmall,
                            Text(
                              'No expense available',
                              style: GoogleFonts.roboto(
                                color: kcTextSubTitleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              // style: ktsSubtitleTextAuthentication,
                            ),
                            verticalSpaceTiny,
                            GestureDetector(
                              onTap: () => viewModel.navigationService
                                  .navigateTo(Routes.addExpenseView),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_circle_outline,
                                    size: 18,
                                    color: kcPrimaryColor,
                                  ),
                                  horizontalSpaceminute,
                                  Text(
                                    'Create expense',
                                    style: GoogleFonts.roboto(
                                      color: kcPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    // style: ktsAddNewText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Material(
                    color: Colors.transparent,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: viewModel.expenses.length,
                      itemBuilder: (context, index) {
                        var expenses = viewModel.expenses[index];
                        return ExpenseCard(
                          expenses: expenses,
                          expenseId: expenses.id,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          thickness: 0.2,
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ExpenseCard extends ViewModelWidget<HomeViewModel> {
  const ExpenseCard({
    Key? key,
    required this.expenses,
    required this.expenseId,
  }) : super(key: key);

  final Expenses expenses;

  final String expenseId;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: kcFormBorderColor.withOpacity(0.3),
        onTap: (() {
          viewModel.navigationService
              .navigateTo(Routes.viewExpenseView, arguments: expenseId);
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
                    // '${expenses.description[0].toUpperCase()}${expenses.description.substring(1)}',
                    expenses.description.length <= 15
                        ? '${expenses.description[0].toUpperCase()}${expenses.description.substring(1)}'
                        : '${expenses.description[0].toUpperCase()}${expenses.description.substring(1, 15)}...',
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

class PurchaseListView extends StatefulWidget {
  const PurchaseListView({Key? key}) : super(key: key);

  @override
  _PurchaseListViewState createState() => _PurchaseListViewState();
}

class _PurchaseListViewState extends State<PurchaseListView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (viewModel) async {
        await viewModel.getPurchasesByBusiness();
      },
      builder: (BuildContext context, HomeViewModel viewModel, Widget? child) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 0.4,
                        color: kcBorderColor), // Border only on the bottom
                  ),
                ),
                child: Builder(builder: (context) {
                  if (viewModel.isBusy) {
                    return const CircularProgressIndicator(
                      color: kcPrimaryColor,
                    );
                  }
                  if (viewModel.purchases.isEmpty) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/Group 1000007944.svg',
                              width: 100,
                              height: 75,
                            ),
                            verticalSpaceSmall,
                            Text(
                              'No purchase available',
                              style: GoogleFonts.roboto(
                                color: kcTextSubTitleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              // style: ktsSubtitleTextAuthentication,
                            ),
                            verticalSpaceTiny,
                            GestureDetector(
                              onTap: () => viewModel.navigationService
                                  .navigateTo(Routes.addPurchaseView),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_circle_outline,
                                    size: 18,
                                    color: kcPrimaryColor,
                                  ),
                                  horizontalSpaceminute,
                                  Text(
                                    'Create purchase',
                                    style: GoogleFonts.roboto(
                                      color: kcPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Material(
                    color: Colors.transparent,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: viewModel.purchases.length,
                      itemBuilder: (context, index) {
                        var purchases = viewModel.purchases[index];
                        return PurchaseOrderCard(
                          purchase: purchases,
                          purchaseId: purchases.id,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          thickness: 0.2,
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PurchaseOrderCard extends ViewModelWidget<HomeViewModel> {
  const PurchaseOrderCard({
    Key? key,
    required this.purchase,
    required this.purchaseId,
  }) : super(key: key);

  final Purchases purchase;

  final String purchaseId;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: kcFormBorderColor.withOpacity(0.3),
        onTap: (() {
          viewModel.navigationService
              .navigateTo(Routes.viewPurchaseView, arguments: purchaseId);
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // '#${purchase.reference}',
                    purchase.merchantName.length <= 15
                        ? '${purchase.merchantName[0].toUpperCase()}${purchase.merchantName.substring(1)}'
                        : '${purchase.merchantName[0].toUpperCase()}${purchase.merchantName.substring(1, 15)}...',
                    // purchase.merchantName,
                    // '${purchase.description[0].toUpperCase()}${purchase.description.substring(1)}',
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
                              .format(purchase
                                  .total), // The remaining digits without the symbol
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
                    purchase.transactionDate,
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
                    purchase.paid ? 'Paid' : 'Pending',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color:
                          purchase.paid ? kcSuccessColor : kcTextSubTitleColor,
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

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

int selectedindex = 0;

class _CustomDrawerState extends State<CustomDrawer> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (HomeViewModel viewModel) async {
          // await viewModel.getUserAndBusinessData();
          viewModel.setUserDetails();
          viewModel.setSelectedItem;
        },
        builder: (
          BuildContext context,
          HomeViewModel viewModel,
          Widget? child,
        ) {
          return Drawer(
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            surfaceTintColor: kcButtonTextColor,
            backgroundColor: kcButtonTextColor,
            width: MediaQuery.of(context).size.width * 0.8,
            elevation: 100,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 78),
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Replace Icon with Container
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kcPrimaryColor,
                      ),
                      padding:
                          const EdgeInsets.all(16), // Adjust padding as needed
                      child: Text(
                        viewModel.businessName.isNotEmpty
                            ? viewModel.businessName[0].toUpperCase()
                            : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Adjust font size as needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    horizontalSpaceTiny,
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            viewModel.userName,
                            style: ktsFormHintText1,
                          ),
                          Text(
                            viewModel.businessName,
                            // Use 'businessName' from SharedPreferences
                            style: ktsTextAuthentication2,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                verticalSpaceIntermitent,
                Container(
                  decoration: selectedindex == 0
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kcPrimaryColor.withOpacity(.1),
                        )
                      : null,
                  child: ListTile(
                      selected: selectedindex == 0,
                      // selectedTileColor: kcPrimaryColor.withOpacity(.1),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      leading: selectedindex == 0
                          ? SvgPicture.asset(
                              'assets/images/home-02-2-3.svg',
                              width: 24,
                              height: 24,
                            )
                          : SvgPicture.asset(
                              'assets/images/home-02.svg',
                              width: 24,
                              height: 24,
                              color: kcTextSubTitleColor,
                            ),
                      title: Text(
                        'Home',
                        // style: TextStyle(
                        //     color: viewModel.selectedItem == DrawerItem.home
                        //         ? kcPrimaryColor
                        //         : kcErrorColor),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: -0.30,
                            color: selectedindex == 0
                                ? kcPrimaryColor
                                : kcTextTitleColor),
                      ),
                      onTap: () {
                        setState(() {
                          selectedindex = 0;
                        });
                        viewModel.navigationService
                            .replaceWith(Routes.homeView);
                        // viewModel.setSelectedItem(DrawerItem.home);
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //   builder: (context) => const HomeView(),
                        // )

                        // );
                      }),
                ),
                Container(
                  decoration: selectedindex == 1
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kcPrimaryColor.withOpacity(.1),
                        )
                      : null,
                  child: ListTile(
                    selected: selectedindex == 1,
                    // selectedTileColor: kcPrimaryColor.withOpacity(.1),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: selectedindex == 1
                        ? SvgPicture.asset(
                            'assets/images/users-profiles-03.svg',
                            width: 24,
                            height: 24,
                          )
                        : SvgPicture.asset(
                            'assets/images/users-profiles-02.svg',
                            width: 24,
                            height: 24,
                          ),
                    title: Text(
                      'Customers',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.30,
                          color: selectedindex == 1
                              ? kcPrimaryColor
                              : kcTextTitleColor),
                      // style: TextStyle(
                      //     color: viewModel.selectedItem == DrawerItem.customers
                      //         ? kcPrimaryColor
                      //         : kcErrorColor),
                    ),
                    onTap: () {
                      setState(() {
                        selectedindex = 1;
                      });
                      // viewModel.setSelectedItem(DrawerItem.customers);
                      viewModel.navigationService
                          .replaceWith(Routes.customerView);
                    },
                  ),
                ),
                Container(
                  decoration: selectedindex == 2
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kcPrimaryColor.withOpacity(.1),
                        )
                      : null,
                  child: ListTile(
                    selected: selectedindex == 2,
                    // selectedTileColor: kcPrimaryColor.withOpacity(.1),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: selectedindex == 2
                        ? SvgPicture.asset(
                            'assets/images/box2.svg',
                            width: 24,
                            height: 24,
                          )
                        : SvgPicture.asset(
                            'assets/images/box.svg',
                            width: 24,
                            height: 24,
                          ),
                    title: Text(
                      'Products',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.30,
                          color: selectedindex == 2
                              ? kcPrimaryColor
                              : kcTextTitleColor),
                    ),
                    onTap: () {
                      setState(() {
                        selectedindex = 2;
                      });
                      // viewModel.setSelectedItem(DrawerItem.products);
                      viewModel.navigationService
                          .replaceWith(Routes.productView);
                    },
                  ),
                ),
                Container(
                  decoration: selectedindex == 3
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kcPrimaryColor.withOpacity(.1),
                        )
                      : null,
                  child: ListTile(
                    selected: selectedindex == 3,
                    // selectedTileColor: kcPrimaryColor.withOpacity(.1),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: selectedindex == 3
                        ? SvgPicture.asset(
                            'assets/images/coin-hand2.svg',
                            width: 24,
                            height: 24,
                          )
                        : SvgPicture.asset(
                            'assets/images/coin-hand.svg',
                            width: 24,
                            height: 24,
                          ),
                    title: Text(
                      'Services',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.30,
                          color: selectedindex == 3
                              ? kcPrimaryColor
                              : kcTextTitleColor),
                    ),
                    onTap: () {
                      setState(() {
                        selectedindex = 3;
                      });
                      // viewModel.setSelectedItem(DrawerItem.services);
                      viewModel.navigationService
                          .replaceWith(Routes.serviceView);
                    },
                  ),
                ),
                Container(
                  decoration: selectedindex == 4
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kcPrimaryColor.withOpacity(.1),
                        )
                      : null,
                  child: ListTile(
                    selected: selectedindex == 4,
                    // selectedTileColor: kcPrimaryColor.withOpacity(.1),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: selectedindex == 4
                        ? SvgPicture.asset(
                            'assets/images/settings2.svg',
                            width: 24,
                            height: 24,
                          )
                        : SvgPicture.asset(
                            'assets/images/settings.svg',
                            width: 24,
                            height: 24,
                          ),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.30,
                          color: selectedindex == 4
                              ? kcPrimaryColor
                              : kcTextTitleColor),
                    ),
                    onTap: () {
                      setState(() {
                        selectedindex = 4;
                      });
                      // viewModel.setSelectedItem(DrawerItem.settings);
                      viewModel.navigationService
                          .replaceWith(Routes.settingsView);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
