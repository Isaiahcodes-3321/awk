import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'archived_purchase_viewmodel.dart';

class ArchivedPurchaseView extends StatefulWidget {
  const ArchivedPurchaseView({Key? key}) : super(key: key);

  @override
  State<ArchivedPurchaseView> createState() => _ArchivedPurchaseViewState();
}

class _ArchivedPurchaseViewState extends State<ArchivedPurchaseView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ArchivedPurchaseViewModel>.reactive(
        // key: UniqueKey(),
        viewModelBuilder: () => ArchivedPurchaseViewModel(),
        onViewModelReady: (viewModel) async {},
        builder: (
          BuildContext context,
          ArchivedPurchaseViewModel viewModel,
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
                        'Archived purchases',
                        style: ktsTitleTextAuthentication,
                      ),
                    ),
                    verticalSpaceTiny,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'View all archived purchases',
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
                      return Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          // physics: const NeverScrollableScrollPhysics(),
                          primary: true,
                          shrinkWrap: true,
                          itemCount: viewModel.data!.length,
                          itemBuilder: (context, index) {
                            var purchase = viewModel.data![index];
                            return ArchivedPurchaseOrderCard(
                              purchase: purchase,
                              purchaseId: purchase.id,
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

class ArchivedPurchaseOrderCard
    extends ViewModelWidget<ArchivedPurchaseViewModel> {
  const ArchivedPurchaseOrderCard({
    Key? key,
    required this.purchase,
    required this.purchaseId,
  }) : super(key: key);

  final Purchases purchase;

  final String purchaseId;

  @override
  Widget build(BuildContext context, ArchivedPurchaseViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      title: Text(
        // '#${purchase.reference}',
        purchase.merchantName,
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
      subtitle: Text(
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: const EdgeInsets.only(top: 2),
            onPressed: () {
              viewModel.unArchivePurchase(purchaseId);
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
              viewModel.deletePurchase(purchaseId);
            }),
          ),
        ],
      ),
    );
  }
}
