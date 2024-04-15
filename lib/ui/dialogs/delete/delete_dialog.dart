import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'delete_dialog_model.dart';

const double _graphicSize = 60;

class DeleteDialog extends StackedView<DeleteDialogModel> {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const DeleteDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DeleteDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      // shadowColor: kcErrorColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/Frame_43540-7.svg',
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
                    child: Text('Cancel', style: ktsFormTitleText2),
                  ),
                ),
                GestureDetector(
                  onTap: () => completer(DialogResponse(confirmed: true)),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kcErrorColor,
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
  DeleteDialogModel viewModelBuilder(BuildContext context) =>
      DeleteDialogModel();
}
