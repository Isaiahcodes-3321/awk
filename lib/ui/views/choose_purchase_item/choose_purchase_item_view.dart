import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'choose_purchase_item_viewmodel.dart';

class ChoosePurchaseItemView extends StatefulWidget {
  const ChoosePurchaseItemView({
    Key? key,
  }) : super(key: key);

  @override
  State<ChoosePurchaseItemView> createState() => _ChoosePurchaseItemViewState();
}

class _ChoosePurchaseItemViewState extends State<ChoosePurchaseItemView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChoosePurchaseItemViewModel>.reactive(
      viewModelBuilder: () => ChoosePurchaseItemViewModel(),
      onViewModelReady: (model) async {
        // await model.getProductByBusiness();
      },
      builder: (context, model, child) => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: kcButtonTextColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ListView(
              children: [
                verticalSpaceSmall,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(model.selectedItems);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: kcFormBorderColor.withOpacity(0.3),
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  fill: 0.9,
                                  color: kcTextSubTitleColor,
                                  size: 16,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(model.selectedItems);
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
                verticalSpaceSmallMid,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select items',
                      style: ktsTitleTextAuthentication,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await model.navigationService
                            .navigateTo(Routes.addPurchaseItemView);

                        if (result == true) {
                          model.reloadItems();
                        }
                      },
                      child: Text(
                        '+  Add item',
                        style: ktsAddNewText,
                      ),
                    ),
                  ],
                ),
                verticalSpaceTiny,
                Text(
                  'Choose products',
                  style: ktsFormHintText,
                ),
                verticalSpaceIntermitent,
                Container(
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: kcButtonTextColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1, color: kcBorderColor),
                  ),
                  child: Builder(builder: (context) {
                    if (model.isBusy) {
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
                    if (model.data!.isEmpty) {
                      return SizedBox(
                          height: 500,
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
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      primary: true,
                      shrinkWrap: true,
                      itemCount: model.data!.length,
                      itemBuilder: (context, index) {
                        return PurchaseItemsCard(
                          products: model.data![index],
                          isSelected:
                              model.selectedItems.contains(model.data![index]),
                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                model.selectedItems.add(model.data![index]);
                              } else {
                                model.selectedItems.remove(model.data![index]);
                              }
                            });
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          thickness: 0.4,
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
              left: 24,
              right: 24,
            ),
            child: SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: () {
                  if (model.selectedItems.isNotEmpty) {
                    Navigator.of(context).pop(model.selectedItems);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: defaultBorderRadius,
                    color: kcPrimaryColor,
                  ),
                  child: Text(
                    "Add selected items",
                    style: ktsButtonText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PurchaseItemsCard extends StatelessWidget {
  const PurchaseItemsCard({
    Key? key,
    required this.products,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  final Products products;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      // tileColor: isSelected ? kcPrimaryColor : kcStrokeColor,
      title: Text(
        products.productName,
        style: ktsBodyText,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      leading: SvgPicture.asset(
        'assets/images/Group 1000007812.svg',
        width: 32,
        height: 32,
      ),

      trailing: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kcFormBorderColor // Stroke color
              ),
          color: isSelected ? Colors.green : null, // Fill color
        ),
      ),
      onTap: () {
        onSelected(!isSelected);
      },
    );
  }
}
