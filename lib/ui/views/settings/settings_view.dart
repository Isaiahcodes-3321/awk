import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/ui_helpers.dart';
import 'package:verzo/ui/views/home/home_view.dart';

import 'settings_viewmodel.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      onViewModelReady: (SettingsViewModel viewModel) async {
        // await viewModel.getUserAndBusinessData();
        viewModel.setUserDetails();
      },
      builder: (
        BuildContext context,
        SettingsViewModel viewModel,
        Widget? child,
      ) {
        return PopScope(
          canPop: false,
          child: Scaffold(
              backgroundColor: kcButtonTextColor,
              key: globalKey,
              drawer: const CustomDrawer(),
              body: Column(
                children: [
                  Container(
                    height: 120,
                    color: Color(0XFF2A5DC8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          verticalSpaceRegular2,
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
                                  )),
                              Text(
                                'Settings',
                                style: ktsButtonText,
                                textAlign: TextAlign.center,
                              ),
                              GestureDetector(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.search,
                                    size: 20,
                                    color: Color(0XFF2A5DC8),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
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
                            Text(
                              'Settings',
                              style: ktsHeaderText,
                            ),
                            verticalSpaceTinyt,
                            Text(
                              'Adjust personal and business settings',
                              style: ktsSubtitleTextAuthentication,
                            ),
                            verticalSpaceSmall,
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
                            Text(
                              'Personal Profile',
                              style: ktsSubtitleTextAuthentication2,
                            ),
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
                                'Name and email address',
                                style: ktsFormHintText,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  viewModel.navigationService
                                      .navigateTo(Routes.profileView);
                                },
                                icon: const Icon(Icons.arrow_forward),
                                iconSize: 24,
                                color: kcTextSubTitleColor,
                              ),
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
                                  viewModel.navigationService
                                      .navigateTo(Routes.passwordView);
                                },
                                icon: const Icon(Icons.arrow_forward),
                                iconSize: 24,
                                color: kcTextSubTitleColor,
                              ),
                            ),
                            // ListTile(
                            //   contentPadding: EdgeInsetsDirectional.zero,
                            //   leading: SvgPicture.asset(
                            //     'assets/images/Frame_43540.svg',
                            //     width: 36,
                            //     height: 36,
                            //   ),
                            //   title: Text(
                            //     'Authentication',
                            //     style: ktsTextAuthentication,
                            //   ),
                            //   subtitle: Text(
                            //     '2FA',
                            //     style: ktsFormHintText,
                            //   ),
                            //   trailing: IconButton(
                            //     onPressed: () {},
                            //     icon: Icon(Icons.arrow_forward_ios),
                            //     iconSize: 20,
                            //   ),
                            // ),
                            ListTile(
                              contentPadding: EdgeInsetsDirectional.zero,
                              leading: SvgPicture.asset(
                                'assets/images/Frame 43540-1.svg',
                                width: 36,
                                height: 36,
                              ),
                              title: Text(
                                'Notifications',
                                style: ktsTextAuthentication,
                              ),
                              subtitle: Text(
                                'See your notifications',
                                style: ktsFormHintText,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  viewModel.navigationService
                                      .navigateTo(Routes.notificationsView);
                                },
                                icon: const Icon(Icons.arrow_forward),
                                iconSize: 24,
                                color: kcTextSubTitleColor,
                              ),
                            ),
                            verticalSpaceIntermitent,
                            Text(
                              'Business Profile',
                              style: ktsSubtitleTextAuthentication2,
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
                                'Name, email address, catego...',
                                style: ktsFormHintText,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  viewModel.navigationService
                                      .navigateTo(Routes.businessProfileView);
                                },
                                icon: const Icon(Icons.arrow_forward),
                                iconSize: 24,
                                color: kcTextSubTitleColor,
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsetsDirectional.zero,
                              leading: SvgPicture.asset(
                                'assets/images/Frame_43540-4.svg',
                                width: 36,
                                height: 36,
                              ),
                              title: Text(
                                'Verzo account',
                                style: ktsTextAuthentication,
                              ),
                              subtitle: Text(
                                'BVN, Account no, Account...',
                                style: ktsFormHintText,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  viewModel.navigationService.navigateTo(
                                      Routes.viewBusinessAccountView);
                                },
                                icon: const Icon(Icons.arrow_forward),
                                iconSize: 24,
                                color: kcTextSubTitleColor,
                              ),
                            ),
                            // ListTile(
                            //   contentPadding: EdgeInsetsDirectional.zero,
                            //   leading: SvgPicture.asset(
                            //     'assets/images/Frame_43540-5.svg',
                            //     width: 36,
                            //     height: 36,
                            //   ),
                            //   title: Text(
                            //     'Expense categories',
                            //     style: ktsTextAuthentication,
                            //   ),
                            //   subtitle: Text(
                            //     'View categories',
                            //     style: ktsFormHintText,
                            //   ),
                            //   trailing: IconButton(
                            //     onPressed: () {
                            //       // viewModel.navigationService
                            //       //     .navigateTo(Routes.expenseCategoriesView);
                            //     },
                            //     icon: const Icon(Icons.arrow_forward),
                            //     iconSize: 20,
                            //     color: kcTextSubTitleColor,
                            //   ),
                            // ),
                            ListTile(
                              contentPadding: EdgeInsetsDirectional.zero,
                              leading: SvgPicture.asset(
                                'assets/images/Frame_43540-6.svg',
                                width: 36,
                                height: 36,
                              ),
                              title: Text(
                                'Report',
                                style: ktsTextAuthentication,
                              ),
                              subtitle: Text(
                                'Coming soon',
                                // 'Manage your transactions',
                                style: ktsFormHintText,
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    // viewModel.navigationService.navigateTo(
                                    //     Routes.reportTransactionsView);
                                  },
                                  icon: const Icon(Icons.arrow_forward),
                                  iconSize: 24,
                                  color: kcTextSubTitleColor),
                            ),
                            verticalSpaceIntermitent,
                            Text(
                              'Plan and billings',
                              style: ktsSubtitleTextAuthentication2,
                            ),
                            ListTile(
                              contentPadding: EdgeInsetsDirectional.zero,
                              leading: SvgPicture.asset(
                                'assets/images/Frame 2171.svg',
                                width: 36,
                                height: 36,
                              ),
                              title: Text(
                                'Pricing',
                                style: ktsTextAuthentication,
                              ),
                              subtitle: Text(
                                'View all verzo plans',
                                style: ktsFormHintText,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  viewModel.navigationService
                                      .navigateTo(Routes.billingView);
                                },
                                icon: const Icon(Icons.arrow_forward),
                                iconSize: 24,
                                color: kcTextSubTitleColor,
                              ),
                            ),
                            verticalSpaceIntermitent,
                            Text(
                              'Others',
                              style: ktsSubtitleTextAuthentication2,
                            ),
                            ListTile(
                              contentPadding: EdgeInsetsDirectional.zero,
                              leading: SvgPicture.asset(
                                'assets/images/Frame_43540-7.svg',
                                width: 32,
                                height: 32,
                              ),
                              title: Text(
                                'Delete account',
                                style: ktsErrorText1,
                              ),
                              subtitle: Text(
                                'This action is not reversible!',
                                style: ktsFormHintText,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  deleteAccount();
                                },
                                icon: const Icon(Icons.arrow_forward),
                                iconSize: 24,
                                color: kcErrorColor.withOpacity(0.7),
                              ),
                            ),
                            verticalSpaceRegular,
                            Center(
                              child: GestureDetector(
                                onTap: logout,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/logout-03.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      horizontalSpaceTiny,
                                      const Text(
                                        'Log out?',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                            letterSpacing: -0.30,
                                            color: kcTextTitleColor),
                                        // style: ktsTextAuthentication,
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
                  ),
                ],
              )),
        );
      },
    );
  }
}
