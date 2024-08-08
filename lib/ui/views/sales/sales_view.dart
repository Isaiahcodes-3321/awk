import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/sales/sales_viewmodel.dart';

class SalesView extends StatefulWidget {
  const SalesView({
    Key? key,
  }) : super(key: key);

  @override
  State<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesViewModel>.reactive(
        viewModelBuilder: () => SalesViewModel(),
        onViewModelReady: (viewModel) => () async {},
        builder:
            (BuildContext context, SalesViewModel viewModel, Widget? child) {
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
                      .navigateTo(Routes.addSalesView);

                  if (result == true) {
                    viewModel.reloadSaleData();
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
                      padding:
                          const EdgeInsets.only(left: 28, right: 28, top: 4),
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
                                      'Invoice',
                                      style: ktsHeaderText1,
                                    ),
                                    verticalSpaceTinyt,
                                    Text(
                                      'Create and manage invoices',
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
                                          final result = viewModel
                                              .navigationService
                                              .navigateTo(
                                                  Routes.archivedSaleView);
                                          if (result == true) {
                                            viewModel.reloadSaleData();
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
                                  viewModel.reloadSale();
                                } // Call the search function as you type
                                else {
                                  viewModel.searchSale();
                                }
                              },
                              style: ktsBodyTextWhite,
                              cursorColor: kcButtonTextColor,
                              decoration: InputDecoration(
                                focusColor: kcButtonTextColor,
                                hoverColor: kcPrimaryColor,
                                fillColor: kcButtonTextColor,
                                contentPadding: const EdgeInsets.only(top: 10),
                                hintText: 'Search invoice...',
                                hintStyle: TextStyle(
                                    color: kcButtonTextColor.withOpacity(0.4),
                                    fontSize: 16,
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: -0.3),
                                prefixIconColor: kcButtonTextColor,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 20,
                                ),
                                suffixIconColor: kcButtonTextColor,

                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    viewModel.toggleSearch();
                                    // Call toggleSearch to hide the search bar
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/Group 1000007841.svg',
                                          width: 200,
                                          height: 150,
                                        ),
                                        verticalSpaceSmall,
                                        Text(
                                          'No invoice available',
                                          style: ktsSubtitleTextAuthentication,
                                        ),
                                      ],
                                    )));
                              }
                              if (viewModel.isSearchActive &&
                                  viewModel.data!.isNotEmpty) {
                                return Material(
                                  color: Colors.transparent,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(2),
                                    scrollDirection: Axis.vertical,
                                    // physics:
                                    //     const NeverScrollableScrollPhysics(),
                                    primary: true,
                                    shrinkWrap: true,
                                    itemCount: viewModel.data!.length,
                                    itemBuilder: (context, index) {
                                      var sale = viewModel.data![index];
                                      return
                                          //  Container(
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
                                          SalesCard(
                                        sales: sale,
                                        saleId: sale.id,
                                      );
                                      // }
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/Group_2780.svg',
                                          width: 200,
                                          height: 150,
                                        ),
                                        verticalSpaceSmall,
                                        Text(
                                          'No invoice available',
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
                                  // physics:
                                  //     const NeverScrollableScrollPhysics(),
                                  primary: true,
                                  shrinkWrap: true,
                                  itemCount: viewModel.data!.length,
                                  itemBuilder: (context, index) {
                                    var sale = viewModel.data![index];
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
                                        //         width: 1.3, color: kcBorderColor),
                                        //   ),
                                        //   child:
                                        SalesCard(
                                      sales: sale,
                                      saleId: sale.id,
                                      // ),
                                    );
                                    // }
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class SalesCard extends ViewModelWidget<SalesViewModel> {
  const SalesCard({
    Key? key,
    required this.sales,
    required this.saleId,
  }) : super(key: key);
  final Sales sales;
  final String saleId;

  @override
  Widget build(BuildContext context, SalesViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: kcFormBorderColor.withOpacity(0.3),
        onTap: (() async {
          final result = await viewModel.navigationService
              .navigateTo(Routes.viewSalesView, arguments: saleId);
          if (result == true) {
            viewModel.reloadSaleData();
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
                    // sales.customerName,
                    sales.customerName.length <= 15
                        ? '${sales.customerName[0].toUpperCase()}${sales.customerName.substring(1)}'
                        : '${sales.customerName[0].toUpperCase()}${sales.customerName.substring(1, 15)}...',
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

class ArchivedSalesCard extends ViewModelWidget<SalesViewModel> {
  const ArchivedSalesCard({
    Key? key,
    required this.sales,
    required this.saleId,
  }) : super(key: key);
  final Sales sales;
  final String saleId;

  @override
  Widget build(BuildContext context, SalesViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      // tileColor: kcStrokeColor,
      title: Text(
        '#${sales.reference}',
        style: ktsBorderText,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
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
                  sales.totalAmount), // The remaining digits without the symbol
              style: ktsSubtitleTileText,
            ),
          ],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: const EdgeInsets.only(top: 2),
            onPressed: () {
              // viewModel.unArchiveSale(saleId);
            },
            icon: SvgPicture.asset(
              'assets/images/unarchive2.svg',
              // width: 20,
              // height: 20,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              'assets/images/trash-04.svg',
              width: 18,
              height: 18,
            ),
            onPressed: (() {
              // viewModel.deleteSale(saleId);
            }),
          ),
        ],
      ),
    );
  }
}
