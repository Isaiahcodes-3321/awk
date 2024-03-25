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
import 'package:verzo/ui/views/product/product_viewmodel.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView>
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
    return ViewModelBuilder<ProductViewModel>.reactive(
      viewModelBuilder: () => ProductViewModel(),
      onViewModelReady: (viewModel) async {},
      builder: (
        BuildContext context,
        ProductViewModel viewModel,
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
                  viewModel.navigationService.navigateTo(Routes.addProductView);
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
                                  'Products',
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
                              controller: viewModel
                                  .searchController, // Use the search controller
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  viewModel.reloadProducts();
                                } // Call the search function as you type
                                else {
                                  viewModel.searchProduct();
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
                            'Products',
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
                              // height: MediaQuery.of(context).size.height * 0.7,
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
                                              'All (${viewModel.products.length})', // Use your label text
                                            ),
                                          ),
                                          Tab(
                                            child: Text(
                                              ''
                                              'Archived (${viewModel.archiveProducts.length})', // Use your label text
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CircularProgressIndicator(
                                                      color: kcPrimaryColor,
                                                    ),
                                                  ],
                                                )));
                                          }
                                          if (viewModel.isSearchActive &&
                                              viewModel.products.isEmpty) {
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
                                                      'Product not available',
                                                      style:
                                                          ktsSubtitleTextAuthentication,
                                                    ),
                                                  ],
                                                )));
                                          }
                                          if (viewModel.isSearchActive &&
                                              viewModel.products.isNotEmpty) {
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
                                                scrollDirection: Axis.vertical,
                                                primary: false,
                                                shrinkWrap: true,
                                                itemCount:
                                                    viewModel.products.length,
                                                itemBuilder: (context, index) {
                                                  var product =
                                                      viewModel.products[index];
                                                  return ProductCard(
                                                    product: product,
                                                    productId: product.id,
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
                                          if (viewModel.products.isEmpty) {
                                            return SizedBox(
                                                height: 400,
                                                child: Center(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/images/Group_1000007844.svg',
                                                      width: 200,
                                                      height: 150,
                                                    ),
                                                    verticalSpaceSmall,
                                                    Text(
                                                      'No products added',
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
                                                  viewModel.products.length,
                                              itemBuilder: (context, index) {
                                                var product =
                                                    viewModel.products[index];
                                                return ProductCard(
                                                  product: product,
                                                  productId: product.id,
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CircularProgressIndicator(
                                                      color: kcPrimaryColor,
                                                    ),
                                                  ],
                                                )));
                                          }

                                          if (viewModel
                                              .archiveProducts.isEmpty) {
                                            return SizedBox(
                                                height: 400,
                                                child: Center(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/images/Group_1000007844.svg',
                                                      width: 200,
                                                      height: 150,
                                                    ),
                                                    verticalSpaceSmall,
                                                    Text(
                                                      'No products added',
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
                                                  .archiveProducts.length,
                                              itemBuilder: (context, index) {
                                                var product = viewModel
                                                    .archiveProducts[index];
                                                return ArchivedProductCard(
                                                  product: product,
                                                  productId: product.id,
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
                                      ]))
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

class ProductCard extends ViewModelWidget<ProductViewModel> {
  const ProductCard({Key? key, required this.product, required this.productId})
      : super(key: key);

  final Products product;

  final String productId;

  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      title: Text(
        product.productName,
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
                  product.price), // The remaining digits without the symbol
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
          viewModel.navigationService.navigateTo(
            Routes.updateProductView,
            arguments: productId,
          );
        }),
      ),
    );
  }
}

class ArchivedProductCard extends ViewModelWidget<ProductViewModel> {
  const ArchivedProductCard(
      {Key? key, required this.product, required this.productId})
      : super(key: key);

  final Products product;

  final String productId;

  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      title: Text(
        product.productName,
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
                  product.price), // The remaining digits without the symbol
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
          viewModel.unArchiveProduct(productId);
        }),
      ),
    );
  }
}
