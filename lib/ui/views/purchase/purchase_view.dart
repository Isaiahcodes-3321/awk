import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/purchase/purchase_viewmodel.dart';

class PurchaseView extends StatefulWidget {
  const PurchaseView({
    Key? key,
  }) : super(key: key);

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PurchaseViewModel>.reactive(
      viewModelBuilder: () => PurchaseViewModel(),
      onViewModelReady: (viewModel) async {},
      builder: (
        BuildContext context,
        PurchaseViewModel viewModel,
        Widget? child,
      ) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Color(0XFF2A5DC8),
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
              onPressed: () async {
                final result = await viewModel.navigationService
                    .navigateTo(Routes.addPurchaseView);

                if (result == true) {
                  viewModel.reloadPurchaseData();
                }
              },
              child: const Icon(
                Icons.add,
                size: 24,
              ),
            ),
            body: SizedBox(
              height: 100.h,
              width: 100.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 14.h,
                    color: Color(0XFF2A5DC8),
                    padding: const EdgeInsets.only(left: 28, right: 28, top: 4),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpaceRegular,
                        if (!viewModel.isSearchActive)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Purchase',
                                    style: ktsHeaderText1,
                                  ),
                                  verticalSpaceTinyt,
                                  Text(
                                    'Create and manage orders',
                                    style: ktsSubtitleTextAuthentication1,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        final result = await viewModel
                                            .navigationService
                                            .navigateTo(
                                                Routes.archivedPurchaseView);
                                        if (result == true) {
                                          viewModel.reloadPurchaseData();
                                        }
                                      },
                                      child: const Icon(
                                        Icons.inventory_2_outlined,
                                        color: kcButtonTextColor,
                                        size: 20,
                                      )),
                                  horizontalSpaceRegular,
                                  // GestureDetector(
                                  //     onTap: () {
                                  //       viewModel.toggleSearch();
                                  //     },
                                  //     child: const Icon(
                                  //       Icons.search,
                                  //       color: kcButtonTextColor,
                                  //     )),
                                ],
                              ),
                            ],
                          ),
                        if (viewModel.isSearchActive)
                          TextField(
                            controller: viewModel
                                .searchController, // Use the search controller
                            onChanged: (value) {
                              if (value.isEmpty) {
                                viewModel.reloadPurchase();
                              } // Call the search function as you type
                              else {
                                viewModel.searchPurchase();
                              }
                            },
                            style: ktsBodyTextWhite,
                            cursorColor: kcButtonTextColor,
                            decoration: InputDecoration(
                              focusColor: kcButtonTextColor,
                              hoverColor: kcPrimaryColor,
                              fillColor: kcButtonTextColor,
                              contentPadding: const EdgeInsets.only(top: 10),
                              prefixIconColor: kcButtonTextColor,
                              hintText: 'Search purchases...',
                              hintStyle: TextStyle(
                                  color: kcButtonTextColor.withOpacity(0.4),
                                  fontSize: 16,
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: -0.3),
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 20,
                              ),
                              suffixIconColor: kcButtonTextColor,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () {
                                  viewModel
                                      .toggleSearch(); // Call toggleSearch to hide the search bar
                                },
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: kcBorderColor)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: kcPrimaryColor)),
                              // border: const UnderlineInputBorder(
                              //     borderSide: BorderSide(
                              //         width: 1, color: kcPrimaryColor)),
                            ),
                          ),
                        if (viewModel.isSearchActive) verticalSpaceTinyt,
                      ],
                    ),
                  ),
                  verticalSpaceSmall,
                  Container(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 6),
                    height: 76.h,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24)),
                        color: kcButtonTextColor),
                    child: Column(
                      children: [
                        verticalSpaceSmall,
                        Expanded(
                          child: Builder(builder: (context) {
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
                                        'No purchase available',
                                        style: ktsSubtitleTextAuthentication,
                                      ),
                                    ],
                                  )));
                            }
                            if (viewModel.isSearchActive &&
                                viewModel.data!.isNotEmpty) {
                              Material(
                                color: Colors.transparent,
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(2),
                                  scrollDirection: Axis.vertical,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  primary: true,
                                  shrinkWrap: true,
                                  itemCount: viewModel.data!.length,
                                  itemBuilder: (context, index) {
                                    var purchase = viewModel.data![index];
                                    return
                                        // Container(
                                        //   clipBehavior: Clip.antiAlias,
                                        //   padding: EdgeInsets.zero,
                                        //   width: double.infinity,
                                        //   decoration: BoxDecoration(
                                        //     // color: kcButtonTextColor,
                                        //     borderRadius: BorderRadius.circular(12),
                                        //     border: Border.all(
                                        //         width: 1.3, color: kcBorderColor),
                                        //   ),
                                        //   child:
                                        PurchaseOrderCard(
                                      purchase: purchase,
                                      purchaseId: purchase.id,
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
                                        'assets/images/Group 1000007944.svg',
                                        width: 200,
                                        height: 150,
                                      ),
                                      verticalSpaceSmall,
                                      Text(
                                        'No purchase available',
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
                                  var purchase = viewModel.data![index];
                                  return PurchaseOrderCard(
                                    purchase: purchase,
                                    purchaseId: purchase.id,
                                    // ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    thickness: 0.2,
                                  );
                                  // return verticalSpaceTiny1;
                                },
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PurchaseOrderCard extends ViewModelWidget<PurchaseViewModel> {
  const PurchaseOrderCard({
    Key? key,
    required this.purchase,
    required this.purchaseId,
  }) : super(key: key);

  final Purchases purchase;

  final String purchaseId;

  @override
  Widget build(BuildContext context, PurchaseViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: kcFormBorderColor.withOpacity(0.3),
        onTap: (() async {
          final result = await viewModel.navigationService
              .navigateTo(Routes.viewPurchaseView, arguments: purchaseId);
          if (result == true) {
            viewModel.reloadPurchaseData();
          }
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
                    // purchase.merchantName,
                    purchase.merchantName.length <= 15
                        ? '${purchase.merchantName[0].toUpperCase()}${purchase.merchantName.substring(1)}'
                        : '${purchase.merchantName[0].toUpperCase()}${purchase.merchantName.substring(1, 15)}...',
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
