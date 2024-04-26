import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/business_creation_service.dart';
import 'package:verzo/services/dashboard_service.dart';
import 'package:verzo/ui/views/add_card/add_card_view.form.dart';

class AddCardViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();
  final dashboardService = locator<DashboardService>();
  final businessService = locator<BusinessCreationService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SudoCardSpendingInterval? selectedInterval;
  List<DropdownMenuItem<String>> userdropdownItems = [];
  List<SudoCardSpendingLimits> spendingLimit = [];
  List<SudoCardSpendingInterval> intervalDropdownItems = [
    SudoCardSpendingInterval.daily,
    SudoCardSpendingInterval.weekly,
    SudoCardSpendingInterval.monthly,
    SudoCardSpendingInterval.yearly,
  ];

  void setSelectedInterval(SudoCardSpendingInterval interval) {
    selectedInterval = interval;
    rebuildUi(); // Notify listeners when the value changes
  }

  Future<List<User>> getUsersByBusiness() async {
    final users = await dashboardService.getUsersByBusiness();
    userdropdownItems = users.map((user) {
      return DropdownMenuItem<String>(
        value: user.id.toString(),
        child: Text(user.fullname),
      );
    }).toList();
    return users;
  }

  Future<bool> createSudoCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.card,
        title: 'Create Card',
        description:
            "Are you sure you want to create card? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Create'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );
    if (response?.confirmed == true) {
      await businessService.viewBusinessAccount(businessId: businessIdValue);
      final bool isCreated = await dashboardService.createSudoCard(
          businessId: businessIdValue,
          assignedUserId: userIdValue,
          spendingLimits: spendingLimit);

      if (isCreated == true) {
        await dialogService.showCustomDialog(
          variant: DialogType.cardSuccess,
          title: 'Created!',
          description: 'Your card has been successfully created.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );

        navigationService.replaceWith(Routes.homeView);
      } else {
        await dialogService.showCustomDialog(
            variant: DialogType.cardSuccess,
            title: 'Oops!',
            description: "Your card wasn't created.",
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
      }

      rebuildUi();
      return isCreated;
    } else {
      // User canceled the action
      return false;
    }
  }

  // Future saveSudoCardData(BuildContext context) async {
  //   final result = await runBusyFuture(saveSudoCardData(context));
  //   // if (result == true) {
  //   //   navigationService.replaceWith(Routes.homeView);
  //   // }
  // }

  void navigateBack() => navigationService.back();
}
