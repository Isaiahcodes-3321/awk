import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'archived_product_viewmodel.dart';

class ArchivedProductView extends StatefulWidget {
  const ArchivedProductView({Key? key}) : super(key: key);

  @override
  State<ArchivedProductView> createState() => _ArchivedProductViewState();
}

class _ArchivedProductViewState extends State<ArchivedProductView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ArchivedProductViewModel>.reactive(
        // key: UniqueKey(),
        viewModelBuilder: () => ArchivedProductViewModel(),
        onViewModelReady: (viewModel) async {},
        builder: (
          BuildContext context,
          ArchivedProductViewModel viewModel,
          Widget? child,
        ) {
          return Scaffold(
              backgroundColor: kcButtonTextColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // padding: EdgeInsets.zero,
                  children: [
                    verticalSpaceRegular,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () {
                          viewModel.navigateBack(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      kcFormBorderColor.withOpacity(0.3),
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.arrow_back_ios_rounded,
                                        fill: 0.9,
                                        color: kcTextSubTitleColor,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        viewModel.navigateBack(context);
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
                        'Archived products',
                        style: ktsTitleTextAuthentication,
                      ),
                    ),
                    verticalSpaceTiny,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'View all archived products',
                        style: ktsFormHintText,
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
                                  'assets/images/Group_1000007844.svg',
                                  width: 200,
                                  height: 150,
                                ),
                                verticalSpaceSmall,
                                Text(
                                  'No product available',
                                  style: ktsSubtitleTextAuthentication,
                                ),
                              ],
                            )));
                      }
                      return Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          // physics: AlwaysScrollableScrollPhysics(),
                          primary: true,
                          shrinkWrap: true,
                          itemCount: viewModel.data!.length,
                          itemBuilder: (context, index) {
                            var product = viewModel.data![index];
                            return ArchivedProductCard(
                              product: product,
                              productId: product.id,
                              // ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              thickness: 0.2,
                            );
                            // return verticalSpaceTiny1;
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ));
        });
  }
}

class ArchivedProductCard extends ViewModelWidget<ArchivedProductViewModel> {
  const ArchivedProductCard({
    Key? key,
    required this.product,
    required this.productId,
  }) : super(key: key);

  final Products product;

  final String productId;

  @override
  Widget build(BuildContext context, ArchivedProductViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      title: Text(
        // '#${purchase.reference}',
        product.productName,
        // '${purchase.description[0].toUpperCase()}${purchase.description.substring(1)}',
        style: TextStyle(
          fontFamily: 'Satoshi',
          color: kcTextTitleColor.withOpacity(0.9),
          fontSize: 16,
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
              text: NumberFormat.currency(locale: 'en_NGN', symbol: '').format(
                  product.price), // The remaining digits without the symbol
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: const EdgeInsets.only(top: 2),
            onPressed: () {
              viewModel.unArchiveProduct(productId);
            },
            icon: SvgPicture.asset(
              'assets/images/unarchive2.svg',
              // width: 20,
              // height: 20,
              color: kcPrimaryColor,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              'assets/images/trash-04.svg',
              width: 18,
              height: 18,
              color: kcErrorColor,
            ),
            onPressed: (() {
              viewModel.deleteProduct(productId);
            }),
          ),
        ],
      ),
    );
  }
}
