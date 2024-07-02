import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';

import 'employee_settings_viewmodel.dart';

class EmployeeSettingsView extends StatefulWidget {
  const EmployeeSettingsView({super.key});

  @override
  State<EmployeeSettingsView> createState() => _EmployeeSettingsViewState();
}

class _EmployeeSettingsViewState extends State<EmployeeSettingsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EmployeeSettingsViewModel>.reactive(
      viewModelBuilder: () => EmployeeSettingsViewModel(),
      onViewModelReady: (EmployeeSettingsViewModel viewModel) async {
        // await viewModel.getUserAndBusinessData();
        viewModel.setUserDetails();
      },
      builder: (
        BuildContext context,
        EmployeeSettingsViewModel viewModel,
        Widget? child,
      ) {
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
                                    'Settings',
                                    style: ktsHeaderText1,
                                  ),
                                  verticalSpaceTinyt,
                                  Text(
                                    'Access more information',
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
                      padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
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
                              top: 24, bottom: 50, left: 28, right: 28),
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(children: [
                                  Icon(
                                    Icons.account_circle_rounded,
                                    size: 80,
                                    color: kcTextSubTitleColor.withOpacity(.4),
                                  ),
                                  Text(
                                    viewModel
                                        .userName, // Use 'userName' from SharedPreferences
                                    style: ktsHeaderText,
                                  ),
                                  Text(
                                    viewModel
                                        .businessName, // Use 'businessName' from SharedPreferences
                                    style: ktsSubtitleTextAuthentication,
                                  ),
                                ]),
                              ),
                              verticalSpaceIntermitent,
                              ListTile(
                                contentPadding: EdgeInsetsDirectional.zero,
                                leading: SvgPicture.asset(
                                  'assets/images/Frame_43540.svg',
                                  width: 36,
                                  height: 36,
                                ),
                                title: Text(
                                  'Personal Information',
                                  style: ktsTextAuthentication,
                                ),
                                subtitle: Text(
                                  '${viewModel.userEmail}, ${viewModel.userName}',
                                  style: ktsFormHintText,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                // trailing: IconButton(
                                //   onPressed: () {
                                //     viewModel.navigationService
                                //         .navigateTo(Routes.profileView);
                                //   },
                                //   icon: const Icon(Icons.arrow_forward),
                                //   iconSize: 20,
                                //   color: kcTextSubTitleColor,
                                // ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsetsDirectional.zero,
                                leading: SvgPicture.asset(
                                  'assets/images/Frame_43540-4.svg',
                                  width: 36,
                                  height: 36,
                                ),
                                title: Text(
                                  'Business information',
                                  style: ktsTextAuthentication,
                                ),
                                subtitle: Text(
                                  '${viewModel.businessEmail}, ${viewModel.businessName}, ${viewModel.businessMobile}',
                                  style: ktsFormHintText,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                // trailing: IconButton(
                                //   onPressed: () {
                                //     viewModel.navigationService
                                //         .navigateTo(Routes.businessProfileView);
                                //   },
                                //   icon: const Icon(Icons.arrow_forward),
                                //   iconSize: 20,
                                //   color: kcTextSubTitleColor,
                                // ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsetsDirectional.zero,
                                leading: SvgPicture.asset(
                                  'assets/images/Frame_43540-2.svg',
                                  width: 36,
                                  height: 36,
                                ),
                                title: Text(
                                  'Security',
                                  style: ktsTextAuthentication,
                                ),
                                subtitle: Text(
                                  'Password',
                                  style: ktsFormHintText,
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    viewModel.navigationService.navigateTo(
                                        Routes.employeePasswordView);
                                  },
                                  icon: const Icon(Icons.arrow_forward),
                                  iconSize: 24,
                                  color: kcTextSubTitleColor,
                                ),
                              ),
                              verticalSpaceRegular,
                              Center(
                                child: GestureDetector(
                                  onTap: logout,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/logout-03.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                        horizontalSpaceTiny,
                                        Text(
                                          'Log out?',
                                          style: ktsTextAuthentication,
                                          // style: TextStyle(
                                          //     fontSize: 16,
                                          //     fontFamily: 'Satoshi',
                                          //     fontWeight: FontWeight.w500,
                                          //     height: 0,
                                          //     letterSpacing: -0.30,
                                          //     color: kcErrorColor),
                                        )
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
