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
import 'package:verzo/ui/views/product/product_viewmodel.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

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
                backgroundColor: kcPrimaryColor.withOpacity(0.7),
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
                              'Products',
                              style: ktsHeaderText,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final result = await viewModel.navigationService
                                    .navigateTo(Routes.archivedProductView);
                                if (result == true) {
                                  viewModel.reloadProductsData();
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
                                    'Product not available',
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
                              itemCount: viewModel.products.length,
                              itemBuilder: (context, index) {
                                var product = viewModel.products[index];
                                return ProductCard(
                                  product: product,
                                  productId: product.id,
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
                                    'assets/images/Group_1000007844.svg',
                                    width: 200,
                                    height: 150,
                                  ),
                                  verticalSpaceSmall,
                                  Text(
                                    'No products added',
                                    style: ktsSubtitleTextAuthentication,
                                  ),
                                ],
                              )));
                        }
                        return SizedBox(
                          height: 74.h,
                          // height: MediaQuery.of(context).size.height * 0.74,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            primary: false,
                            shrinkWrap: true,
                            itemCount: viewModel.data!.length,
                            itemBuilder: (context, index) {
                              var product = viewModel.data![index];
                              return ProductCard(
                                product: product,
                                productId: product.id,
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

class ProductCard extends ViewModelWidget<ProductViewModel> {
  const ProductCard({Key? key, required this.product, required this.productId})
      : super(key: key);

  final Products product;

  final String productId;

  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          viewModel.navigationService.navigateTo(
            Routes.updateProductView,
            arguments: productId,
          );
        },
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
          title: Text(
            product.productName,
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
                      .format(product
                          .price), // The remaining digits without the symbol
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    color: kcTextSubTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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
          //     viewModel.navigationService.navigateTo(
          //       Routes.updateProductView,
          //       arguments: productId,
          //     );
          //   }),
          // ),
        ),
      ),
    );
  }
}
