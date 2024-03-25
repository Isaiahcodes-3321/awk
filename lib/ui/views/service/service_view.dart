import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
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

class _ServiceViewState extends State<ServiceView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

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
                backgroundColor: kcPrimaryColor,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 0, left: 28, right: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              SizedBox(
                                width: 300,
                              ),
                            ],
                          ),
                          Text(
                            'Services',
                            style: ktsHeaderText,
                          ),
                          verticalSpaceTinyt,
                          Text(
                            'Manage your inventory',
                            style: ktsSubtitleTextAuthentication,
                          ),
                          verticalSpaceSmallMid,
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.zero,
                              // height: MediaQuery.of(context).size.height * 0.3,
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!viewModel.isSearchActive)
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: kcArchiveColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 35,
                                      child: TabBar(
                                        indicatorPadding: EdgeInsets.zero,
                                        indicatorSize: TabBarIndicatorSize
                                            .tab, // Adjust the indicatorSize
                                        indicator: BoxDecoration(
                                          color:
                                              kcButtonTextColor, // Use your desired color
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        dividerColor: kcArchiveColor,
                                        indicatorColor: kcTextSubTitleColor,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        labelColor: kcTextTitleColor,
                                        labelStyle: const TextStyle(
                                          fontSize: 11.44,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                          letterSpacing: -0.25,
                                        ),
                                        // Use your desired label color
                                        unselectedLabelColor:
                                            kcTextSubTitleColor,
                                        unselectedLabelStyle: const TextStyle(
                                          fontSize: 11.44,
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                          letterSpacing: -0.25,
                                        ), // Use your desired unselected label color
                                        tabs: [
                                          Tab(
                                            child: Text(
                                              'All (${viewModel.services.length})', // Use your label text
                                            ),
                                          ),
                                          Tab(
                                            child: Text(
                                              'Archived (${viewModel.archivedServices.length})', // Use your label text
                                            ),
                                          ),
                                        ],
                                        controller: tabController,
                                      ),
                                    ),
                                  verticalSpaceSmallMid,
                                  Expanded(
                                    child: TabBarView(
                                        controller: tabController,
                                        children: [
                                          Builder(builder: (context) {
                                            if (viewModel.isBusy) {
                                              return const SizedBox(
                                                  height: 400,
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircularProgressIndicator(
                                                        color: kcPrimaryColor,
                                                      ),
                                                    ],
                                                  )));
                                            }
                                            if (viewModel.isSearchActive &&
                                                viewModel.services.isEmpty) {
                                              return SizedBox(
                                                  height: 400,
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/images/Group 1000007841.svg',
                                                        width: 200,
                                                        height: 150,
                                                      ),
                                                      verticalSpaceSmall,
                                                      Text(
                                                        'Service not available',
                                                        style:
                                                            ktsSubtitleTextAuthentication,
                                                      ),
                                                    ],
                                                  )));
                                            }
                                            if (viewModel.isSearchActive &&
                                                viewModel.services.isNotEmpty) {
                                              Container(
                                                clipBehavior: Clip.antiAlias,
                                                padding: EdgeInsets.zero,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  // color: kcButtonTextColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: kcBorderColor),
                                                ),
                                                child: ListView.separated(
                                                  padding: EdgeInsets.zero,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      viewModel.services.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var service = viewModel
                                                        .services[index];
                                                    return ServiceCard(
                                                      service: service,
                                                      serviceId: service.id,
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return const Divider(
                                                      thickness: 0.2,
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                            if (viewModel.services.isEmpty) {
                                              return SizedBox(
                                                  height: 400,
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/images/Group_1000007816.svg',
                                                        width: 200,
                                                        height: 150,
                                                      ),
                                                      verticalSpaceSmall,
                                                      Text(
                                                        'No services added',
                                                        style:
                                                            ktsSubtitleTextAuthentication,
                                                      ),
                                                    ],
                                                  )));
                                            }
                                            return Container(
                                              clipBehavior: Clip.antiAlias,
                                              padding: EdgeInsets.zero,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                // color: kcButtonTextColor,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    width: 1,
                                                    color: kcBorderColor),
                                              ),
                                              child: ListView.separated(
                                                padding: EdgeInsets.zero,
                                                scrollDirection: Axis.vertical,
                                                primary: false,
                                                shrinkWrap: true,
                                                itemCount:
                                                    viewModel.services.length,
                                                itemBuilder: (context, index) {
                                                  var service =
                                                      viewModel.services[index];
                                                  return ServiceCard(
                                                    service: service,
                                                    serviceId: service.id,
                                                  );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return const Divider(
                                                    thickness: 0.2,
                                                  );
                                                },
                                              ),
                                            );
                                          }),
                                          Builder(builder: (context) {
                                            if (viewModel.isBusy) {
                                              return const SizedBox(
                                                  height: 400,
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircularProgressIndicator(
                                                        color: kcPrimaryColor,
                                                      ),
                                                    ],
                                                  )));
                                            }

                                            if (viewModel
                                                .archivedServices.isEmpty) {
                                              return SizedBox(
                                                  height: 400,
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/images/Group_1000007816.svg',
                                                        width: 200,
                                                        height: 150,
                                                      ),
                                                      verticalSpaceSmall,
                                                      Text(
                                                        'No services added',
                                                        style:
                                                            ktsSubtitleTextAuthentication,
                                                      ),
                                                    ],
                                                  )));
                                            }
                                            return Container(
                                              clipBehavior: Clip.antiAlias,
                                              padding: EdgeInsets.zero,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                // color: kcButtonTextColor,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    width: 1,
                                                    color: kcBorderColor),
                                              ),
                                              child: ListView.separated(
                                                padding: EdgeInsets.zero,
                                                scrollDirection: Axis.vertical,
                                                primary: false,
                                                shrinkWrap: true,
                                                itemCount: viewModel
                                                    .archivedServices.length,
                                                itemBuilder: (context, index) {
                                                  var service = viewModel
                                                      .archivedServices[index];
                                                  return ArchivedServiceCard(
                                                    service: service,
                                                    serviceId: service.id,
                                                  );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return const Divider(
                                                    thickness: 0.2,
                                                  );
                                                },
                                              ),
                                            );
                                          }),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      title: Text(
        service.name,
      ),
      titleTextStyle: ktsBorderText,
      subtitle: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: NumberFormat.currency(locale: 'en_NGN', symbol: '₦')
                  .currencySymbol, // The remaining digits without the symbol
              style: ktsSubtitleTileText.copyWith(fontFamily: 'Roboto'),
            ),
            TextSpan(
              text: NumberFormat.currency(locale: 'en_NGN', symbol: '').format(
                  service.price), // The remaining digits without the symbol
              style: ktsSubtitleTileText,
            ),
          ],
        ),
      ),
      trailing: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.arrow_forward,
          size: 20,
          color: kcTextSubTitleColor.withOpacity(0.62),
        ),
        onPressed: (() {
          viewModel.navigationService
              .navigateTo(Routes.updateServiceView, arguments: serviceId);
        }),
      ),
    );
  }
}

class ArchivedServiceCard extends ViewModelWidget<ServiceViewModel> {
  const ArchivedServiceCard(
      {Key? key, required this.service, required this.serviceId})
      : super(key: key);
  final Services service;
  final String serviceId;

  @override
  Widget build(BuildContext context, ServiceViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      title: Text(
        service.name,
      ),
      titleTextStyle: ktsBorderText,
      subtitle: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: NumberFormat.currency(locale: 'en_NGN', symbol: '₦')
                  .currencySymbol, // The remaining digits without the symbol
              style: ktsSubtitleTileText.copyWith(fontFamily: 'Roboto'),
            ),
            TextSpan(
              text: NumberFormat.currency(locale: 'en_NGN', symbol: '').format(
                  service.price), // The remaining digits without the symbol
              style: ktsSubtitleTileText,
            ),
          ],
        ),
      ),
      trailing: IconButton(
        padding: EdgeInsets.zero,
        icon: SvgPicture.asset(
          'assets/images/unarchive2.svg',
          // width: 20,
          // height: 20,
        ),
        onPressed: (() {
          viewModel.unArchiveService(serviceId);
        }),
      ),
    );
  }
}
