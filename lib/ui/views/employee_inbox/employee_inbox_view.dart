import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/services/notification_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'employee_inbox_viewmodel.dart';

class EmployeeInboxView extends StatefulWidget {
  const EmployeeInboxView({
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeInboxView> createState() => _EmployeeInboxViewState();
}

class _EmployeeInboxViewState extends State<EmployeeInboxView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EmployeeInboxViewModel>.reactive(
        viewModelBuilder: () => EmployeeInboxViewModel(),
        onViewModelReady: (viewModel) async {},
        builder: (context, viewModel, child) {
          return PopScope(
            canPop: false,
            child: Scaffold(
                backgroundColor: Color(0XFF2A5DC8),
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
                          children: [
                            verticalSpaceRegular,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Inbox',
                                      style: ktsHeaderText1,
                                    ),
                                    verticalSpaceTinyt,
                                    Text(
                                      'View your notifications',
                                      style: ktsSubtitleTextAuthentication1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // verticalSpaceSmall,
                      Container(
                        padding:
                            const EdgeInsets.only(left: 0, right: 0, top: 0),
                        height: 76.h,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32)),
                            color: kcButtonTextColor),
                        child: SingleChildScrollView(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 24,
                              bottom: 50,
                            ),
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
                              if (viewModel.data!.isEmpty) {
                                return SizedBox(
                                    height: 400,
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                physics: const NeverScrollableScrollPhysics(),
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
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    thickness: 0.2,
                                  );
                                },
                              );
                            }),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}

class Notification extends ViewModelWidget<EmployeeInboxViewModel> {
  const Notification(
      {Key? key, required this.notification, required this.index})
      : super(key: key);

  final Notificationss notification;
  final int index;

  @override
  Widget build(BuildContext context, EmployeeInboxViewModel viewModel) {
    bool isExpanded = viewModel.isExpanded(index);

    return ListTile(
      onTap: () => viewModel.toggleExpandedState(index),
      contentPadding: const EdgeInsets.symmetric(horizontal: 28),
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
