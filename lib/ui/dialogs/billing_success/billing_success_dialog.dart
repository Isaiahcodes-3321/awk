import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'billing_success_dialog_model.dart';

const double _graphicSize = 60;

class BillingSuccessDialog extends StackedView<BillingSuccessDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const BillingSuccessDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BillingSuccessDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      // shadowColor: kcPrimaryColor,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/images/Frame 2171.svg',
              width: 48,
              height: 48,
            ),
            verticalSpaceSmallMid,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.title ?? '',
                          style: ktsBottomSheetHeaderText),
                      if (request.description != null) ...[
                        verticalSpaceTiny,
                        Text(
                          request.description!,
                          style: ktsFormHintText,
                          maxLines: 3,
                          softWrap: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            verticalSpaceSmallMid,
            GestureDetector(
              onTap: () => completer(DialogResponse(confirmed: true)),
              child: Container(
                height: 40,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kcPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  request.mainButtonTitle!,
                  style: ktsButtonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  BillingSuccessDialogModel viewModelBuilder(BuildContext context) =>
      BillingSuccessDialogModel();
}
