import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:stacked/stacked.dart';
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
                                      'Recent alerts',
                                      style: ktsSubtitleTextAuthentication1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      verticalSpaceSmall,
                      Container(
                        padding:
                            const EdgeInsets.only(left: 0, right: 0, top: 6),
                        height: 76.h,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32)),
                            color: kcButtonTextColor),
                        child: Column(
                          children: [
                            verticalSpaceSmall,
                            // Text('Coming soon...')
                            // Expanded(
                            //   child: Builder(builder: (context) {
                            //     if (viewModel.isBusy) {
                            //       return const SizedBox(
                            //           height: 500,
                            //           child: Center(
                            //               child: Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.center,
                            //             children: [
                            //               CircularProgressIndicator(
                            //                 color: kcPrimaryColor,
                            //               ),
                            //             ],
                            //           )));
                            //     }

                            //     if (
                            //         // viewModel.data == null ||

                            //         viewModel.data!.isEmpty) {
                            //       return SizedBox(
                            //           height: 400,
                            //           child: Center(
                            //               child: Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.center,
                            //             children: [
                            //               SvgPicture.asset(
                            //                 'assets/images/Group 1000007942.svg',
                            //                 width: 200,
                            //                 height: 150,
                            //               ),
                            //               verticalSpaceSmall,
                            //               Text(
                            //                 'No expense available',
                            //                 style:
                            //                     ktsSubtitleTextAuthentication,
                            //               ),
                            //             ],
                            //           )));
                            //     }
                            //     return Material(
                            //       color: Colors.transparent,
                            //       child: ListView.separated(
                            //         padding: const EdgeInsets.all(2),
                            //         scrollDirection: Axis.vertical,
                            //         // physics: const NeverScrollableScrollPhysics(),
                            //         primary: true,
                            //         shrinkWrap: true,
                            //         itemCount: viewModel.data!.length,
                            //         itemBuilder: (context, index) {
                            //           var expense = viewModel.data![index];
                            //           return
                            //               // Container(
                            //               //   clipBehavior: Clip.antiAlias,
                            //               //   padding: EdgeInsets.zero,
                            //               //   width: double.infinity,
                            //               //   decoration: BoxDecoration(
                            //               //     // color: kcButtonTextColor,
                            //               //     borderRadius:
                            //               //         BorderRadius.circular(12),
                            //               //     border: Border.all(
                            //               //         width: 1.3,
                            //               //         color: kcBorderColor),
                            //               //   ),
                            //               //   child:
                            //               ExpenseCard(
                            //             expenses: expense,
                            //             expenseId: expense.id,
                            //             // ),
                            //           );
                            //         },
                            //         separatorBuilder:
                            //             (BuildContext context, int index) {
                            //           return const Divider(
                            //             thickness: 0.2,
                            //           );
                            //         },
                            //       ),
                            //     );
                            //   }),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}
