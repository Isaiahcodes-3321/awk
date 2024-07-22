import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/services/notification_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'notifications_viewmodel.dart';

class NotificationsView extends StackedView<NotificationsViewModel> {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NotificationsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcButtonTextColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          verticalSpaceSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: () {
                viewModel.navigateBack();
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
                              viewModel.navigateBack();
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
              'Notifications',
              style: ktsTitleTextAuthentication,
            ),
          ),
          verticalSpaceTiny,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'View your notifications ',
              style: ktsSubtitleTextAuthentication,
            ),
          ),
          verticalSpaceIntermitent,
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
              if (viewModel.data!.isEmpty) {
                return SizedBox(
                    height: 400,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/Group 2984.svg',
                          width: 200,
                          height: 150,
                        ),
                        verticalSpaceSmall,
                        Text(
                          'No notification available',
                          style: ktsSubtitleTextAuthentication,
                        ),
                      ],
                    )));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(2),
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                primary: true,
                shrinkWrap: true,
                itemCount: viewModel.data!.length,
                itemBuilder: (context, index) {
                  var notification = viewModel.data![index];
                  return Notification(
                    notification: notification,
                    index: index,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    thickness: 0.2,
                  );
                },
              );
            }),
          ),
        ]),
      ),
    );
  }

  @override
  NotificationsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NotificationsViewModel();
}

class Notification extends ViewModelWidget<NotificationsViewModel> {
  const Notification(
      {Key? key, required this.notification, required this.index})
      : super(key: key);

  final Notificationss notification;
  final int index;

  @override
  Widget build(BuildContext context, NotificationsViewModel viewModel) {
    bool isExpanded = viewModel.isExpanded(index);

    return ListTile(
      onTap: () => viewModel.toggleExpandedState(index),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: SvgPicture.asset(
        'assets/images/Group 2984.svg',
        width: 32,
        height: 32,
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontFamily: 'Satoshi',
          color: kcTextTitleColor.withOpacity(0.8),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.message,
            style: const TextStyle(
              fontFamily: 'Satoshi',
              color: kcTextSubTitleColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            maxLines: isExpanded ? null : 1,
          ),
          if (isExpanded) ...[
            verticalSpaceMinute,
            Text(
              viewModel.formatNotificationTime(notification.dateTime),
              style: const TextStyle(
                fontFamily: 'Satoshi',
                color: kcTextSubTitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            color: kcTextSubTitleColor.withOpacity(0.8),
            icon: Icon(isExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down),
            onPressed: () => viewModel.toggleExpandedState(index),
          ),
        ],
      ),
    );
  }
}
