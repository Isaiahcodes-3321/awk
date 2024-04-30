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
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
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

  // Method to set the spending limit
  void setSpendingLimit(num amount, SudoCardSpendingInterval interval) {
    // Create a new SudoCardSpendingLimits object with the provided amount and interval
    final spendingLimitItem = SudoCardSpendingLimits(
      amount: amount,
      // amount: num.parse(amountValue ?? ''),
      interval: interval,
    );
    // Clear previous spending limits if any
    spendingLimit.clear();
    // Add the new spending limit item
    spendingLimit.add(spendingLimitItem);
  }

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

  Future<SudoCardCreationResult?> runSudoCard() async {
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
      final result = await businessService.viewBusinessAccount(
          businessId: businessIdValue);
      if (result == null) {
        await navigationService.replaceWith(Routes.businessAccountView);
      } else {
        return dashboardService.createSudoCard(
          businessId: businessIdValue,
          assignedUserId: userIdValue,
          spendingLimits: spendingLimit.isNotEmpty ? spendingLimit : null,
        );
      }
    }

    // Return null if the user cancels the action
    return null;
  }

  Future createSudoCard(BuildContext context) async {
    final result = await runBusyFuture(runSudoCard());

    if (result?.sudoCard != null) {
      await dialogService.showCustomDialog(
        variant: DialogType.cardSuccess,
        title: 'Created!',
        description: 'Your card has been successfully created.',
        barrierDismissible: true,
        mainButtonTitle: 'Ok',
      );
      await navigationService.replaceWith(Routes.homeView);
    } else if (result?.error != null) {
      setValidationMessage(result?.error?.message);
      await dialogService.showCustomDialog(
          variant: DialogType.cardSuccess,
          title: 'Oops!',
          description: "Your already have a card.",
          barrierDismissible: true,
          mainButtonTitle: 'Ok');
    }

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       validationMessage ?? 'An error occurred, Try again.',
    //       textAlign: TextAlign.start,
    //       style: ktsSubtitleTileText2,
    //     ),
    //     elevation: 2,
    //     duration: const Duration(seconds: 3), // Adjust as needed
    //     backgroundColor: kcErrorColor,
    //     dismissDirection: DismissDirection.up,
    //     behavior: SnackBarBehavior.fixed,
    //     shape: const RoundedRectangleBorder(
    //         borderRadius: BorderRadius.only(
    //             bottomLeft: Radius.circular(4),
    //             bottomRight: Radius.circular(4))),
    //     padding: const EdgeInsets.all(12),
    //     // margin:
    //     //     EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.9),
    //   ),
    // );
  }

  void navigateBack() => navigationService.back();
  // void navigateBack() => navigationService.replaceWith(Routes.homeView);
}
