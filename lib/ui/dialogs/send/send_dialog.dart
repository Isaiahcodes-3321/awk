import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'send_dialog_model.dart';

const double _graphicSize = 60;

class SendDialog extends StackedView<SendDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const SendDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SendDialogModel viewModel,
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
              'assets/images/Frame_43540-9.svg',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => completer(DialogResponse(confirmed: false)),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: kcFormBorderColor)),
                    child: Text('Cancel', style: ktsFormTitleText),
                  ),
                ),
                GestureDetector(
                  onTap: () => completer(DialogResponse(confirmed: true)),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.28,
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
          ],
        ),
      ),
    );
  }

  @override
  SendDialogModel viewModelBuilder(BuildContext context) => SendDialogModel();
}
