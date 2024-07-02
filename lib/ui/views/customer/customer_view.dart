import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/customer/customer_viewmodel.dart';
import 'package:verzo/ui/views/home/home_view.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CustomerViewModel>.reactive(
      viewModelBuilder: () => CustomerViewModel(),
      onViewModelReady: (model) async {},
      builder: (
        BuildContext context,
        CustomerViewModel viewModel,
        Widget? child,
      ) {
        return PopScope(
          canPop: false,
          child: Scaffold(
              backgroundColor: kcButtonTextColor,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniEndFloat,
              floatingActionButton: FloatingActionButton(
                elevation: 4,
                highlightElevation: 8.0, // Elevation when button is pressed
                focusElevation: 4.0, // Elevation when button is focused
                hoverElevation: 4.0,
                foregroundColor: kcButtonTextColor,
                backgroundColor: Color(0XFF2A5DC8).withOpacity(0.7),
                shape: const CircleBorder(
                  eccentricity: 1,
                  side: BorderSide.none,
                ),
                onPressed: () {
                  viewModel.navigationService
                      .navigateTo(Routes.addCustomerView);
                },
                child: const Icon(
                  Icons.add,
                  size: 24,
                ),
              ),
              key: globalKey,
              drawer: const CustomDrawer(),
              body: Column(
                children: [
                  Container(
                    height: 120,
                    color: Color(0XFF2A5DC8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          verticalSpaceRegular2,
                          if (!viewModel.isSearchActive)
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    globalKey.currentState?.openDrawer();
                                  },
                                  child: const Icon(
                                    Icons.menu,
                                    size: 20,
                                    color: kcButtonTextColor,
                                  ),
                                ),
                                Text(
                                  'Customers',
                                  style: ktsButtonText,
                                  textAlign: TextAlign.center,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    viewModel.toggleSearch();
                                  },
                                  child: const Icon(Icons.search,
                                      size: 20, color: kcButtonTextColor),
                                ),
                              ],
                            ),
                          if (viewModel.isSearchActive)
                            TextFormField(
                              controller: viewModel
                                  .searchController, // Use the search controller
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  viewModel.reloadCustomer();
                                } // Call the search function as you type
                                else {
                                  viewModel.searchCustomer();
                                }
                              },
                              style: ktsBodyTextWhite,
                              cursorColor: kcButtonTextColor,
                              decoration: InputDecoration(
                                focusColor: kcButtonTextColor,
                                hoverColor: kcPrimaryColor,
                                fillColor: kcButtonTextColor,
                                contentPadding: const EdgeInsets.all(12),
                                prefixIconColor:
                                    kcButtonTextColor.withOpacity(0.4),
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                    color: kcButtonTextColor.withOpacity(0.4),
                                    fontSize: 16,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.3),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 16,
                                ),
                                suffixIconColor: kcButtonTextColor,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    viewModel.toggleSearch();
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .8, color: kcButtonTextColor)),
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .8, color: kcButtonTextColor)),
                                // border: UnderlineInputBorder(
                                //     borderSide: BorderSide(
                                //         width: 1, color: kcButtonTextColor)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpaceSmall,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Customers',
                              style: ktsHeaderText,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final result = await viewModel.navigationService
                                    .navigateTo(Routes.archivedCustomerView);
                                if (result == true) {
                                  viewModel.reloadCustomerData();
                                }
                              },
                              child: SvgPicture.asset(
                                'assets/images/archive-2.svg',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpaceTinyt,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(
                          'Manage your customers',
                          style: ktsSubtitleTextAuthentication,
                        ),
                      ),
                      verticalSpaceSmallMid,
                      Builder(builder: (context) {
                        if (viewModel.isBusy) {
                          return const SizedBox(
                              height: 400,
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
                        if (viewModel.isSearchActive &&
                            viewModel.data!.isEmpty) {
                          return SizedBox(
                              height: 400,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Group 1000007841.svg',
                                    width: 200,
                                    height: 150,
                                  ),
                                  verticalSpaceSmall,
                                  Text(
                                    'Customer not available',
                                    style: ktsSubtitleTextAuthentication,
                                  ),
                                ],
                              )));
                        }
                        if (viewModel.isSearchActive &&
                            viewModel.customers.isNotEmpty) {
                          return SizedBox(
                            height: 74.h,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: viewModel.data!.length,
                              itemBuilder: (context, index) {
                                var customer = viewModel.data![index];
                                return CustomerCard(
                                  customer: customer,
                                  customerId: customer.id,
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
                        }
                        if (viewModel.data!.isEmpty) {
                          return SizedBox(
                              height: 400,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Group_1000007828.svg',
                                    width: 200,
                                    height: 150,
                                  ),
                                  verticalSpaceSmall,
                                  Text(
                                    'No customers added',
                                    style: ktsSubtitleTextAuthentication,
                                  ),
                                ],
                              )));
                        }
                        return SizedBox(
                          height: 74.h,
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            itemCount: viewModel.data!.length,
                            itemBuilder: (context, index) {
                              var customer = viewModel.data![index];
                              return CustomerCard(
                                customer: customer,
                                customerId: customer.id,
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
                ],
              )),
        );
      },
    );
  }
}

class CustomerCard extends ViewModelWidget<CustomerViewModel> {
  const CustomerCard(
      {Key? key, required this.customer, required this.customerId})
      : super(key: key);
  final Customers customer;

  final String customerId;

  @override
  Widget build(BuildContext context, CustomerViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          viewModel.navigationService
              .navigateTo(Routes.updateCustomerView, arguments: customerId);
        },
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
          title: Text(
            customer.name,
            style: TextStyle(
              fontFamily: 'Satoshi',
              color: kcTextTitleColor.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Text(customer.email,
              style: TextStyle(
                fontFamily: 'Satoshi',
                color: kcTextSubTitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )
              // overflow: TextOverflow.values,
              ),

          // trailing: IconButton(
          //   padding: EdgeInsets.zero,
          //   icon: Icon(
          //     Icons.arrow_forward,
          //     size: 20,
          //     color: kcTextSubTitleColor.withOpacity(0.62),
          //   ),
          //   onPressed: (() {
          //     viewModel.navigationService
          //         .navigateTo(Routes.updateCustomerView, arguments: customerId);
          //   }),
          // ),
        ),
      ),
    );
  }
}
