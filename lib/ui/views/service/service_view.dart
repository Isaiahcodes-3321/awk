import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/home/home_view.dart';
import 'package:verzo/ui/views/service/service_viewmodel.dart';

class ServiceView extends StatefulWidget {
  const ServiceView({super.key});

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ServiceViewModel>.reactive(
      viewModelBuilder: () => ServiceViewModel(),
      onViewModelReady: (viewModel) async {},
      builder: (
        BuildContext context,
        ServiceViewModel viewModel,
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
                backgroundColor: kcPrimaryColor.withOpacity(0.7),
                shape: const CircleBorder(
                  eccentricity: 1,
                  side: BorderSide.none,
                ),
                onPressed: () {
                  viewModel.navigationService.navigateTo(Routes.addServiceView);
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
                    color: kcPrimaryColor,
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
                                  'Services',
                                  style: ktsButtonText,
                                  textAlign: TextAlign.center,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    viewModel.toggleSearch();
                                  },
                                  child: const Icon(
                                    Icons.search,
                                    size: 20,
                                    color: kcButtonTextColor,
                                  ),
                                ),
                              ],
                            ),
                          if (viewModel.isSearchActive)
                            TextFormField(
                              // scrollPadding: EdgeInsets.zero,
                              controller: viewModel
                                  .searchController, // Use the search controller
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  viewModel.reloadService();
                                } // Call the search function as you type
                                else {
                                  viewModel.searchService();
                                }
                              },
                              cursorColor: kcButtonTextColor,
                              style: ktsBodyTextWhite,
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
                              'Services',
                              style: ktsHeaderText,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final result = await viewModel.navigationService
                                    .navigateTo(Routes.archivedServiceView);
                                if (result == true) {
                                  viewModel.reloadServiceData();
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
                          'Manage your inventory',
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
                                    'Service not available',
                                    style: ktsSubtitleTextAuthentication,
                                  ),
                                ],
                              )));
                        }
                        if (viewModel.isSearchActive &&
                            viewModel.data!.isNotEmpty) {
                          return SizedBox(
                            height: 74.h,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: viewModel.data!.length,
                              itemBuilder: (context, index) {
                                var service = viewModel.data![index];
                                return ServiceCard(
                                  service: service,
                                  serviceId: service.id,
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
                                    'assets/images/Group_1000007816.svg',
                                    width: 200,
                                    height: 150,
                                  ),
                                  verticalSpaceSmall,
                                  Text(
                                    'No services added',
                                    style: ktsSubtitleTextAuthentication,
                                  ),
                                ],
                              )));
                        }
                        return SizedBox(
                          height: 74.h,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            primary: false,
                            shrinkWrap: true,
                            itemCount: viewModel.data!.length,
                            itemBuilder: (context, index) {
                              var service = viewModel.data![index];
                              return ServiceCard(
                                service: service,
                                serviceId: service.id,
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

class ServiceCard extends ViewModelWidget<ServiceViewModel> {
  const ServiceCard({Key? key, required this.service, required this.serviceId})
      : super(key: key);
  final Services service;
  final String serviceId;

  @override
  Widget build(BuildContext context, ServiceViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          viewModel.navigationService
              .navigateTo(Routes.updateServiceView, arguments: serviceId);
        },
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
          title: Text(
            service.name,
            style: TextStyle(
              fontFamily: 'Satoshi',
              color: kcTextTitleColor.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),

          subtitle: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: NumberFormat.currency(locale: 'en_NGN', symbol: '₦')
                      .currencySymbol, // The remaining digits without the symbol
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    color: kcTextSubTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ).copyWith(fontFamily: 'Roboto'),
                ),
                TextSpan(
                    text: NumberFormat.currency(locale: 'en_NGN', symbol: '')
                        .format(service
                            .price), // The remaining digits without the symbol
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      color: kcTextSubTitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
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
          //         .navigateTo(Routes.updateServiceView, arguments: serviceId);
          //   }),
          // ),
        ),
      ),
    );
  }
}
