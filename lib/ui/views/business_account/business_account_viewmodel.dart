import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/business_creation_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/business_account/business_account_view.form.dart';

class BusinessAccountViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();
  final businessCreationService = locator<BusinessCreationService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? pickedDate = DateTime.now();

  Future<void> showDatePickerDialog(BuildContext context) async {
    pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime tempPickedDate = DateTime.now();
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.48,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarViewMode: DatePickerMode.day,
                    currentDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 2),
                    firstDate: DateTime(DateTime.now().year - 2),
                    calendarType: CalendarDatePicker2Type.single,
                    controlsHeight: 50,
                    selectedDayHighlightColor: kcPrimaryColor,

                    // Add more configurations as needed
                  ),
                  onValueChanged: (value) {
                    if (value.isNotEmpty) {
                      // Check if the list is not empty
                      tempPickedDate = value
                          .first!; // Update the temp date with the first item
                    }
                  },
                  value: [],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(tempPickedDate),
                      child: Container(
                        height: 50,
                        // color: kcPrimaryColor,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: kcPrimaryColor,
                        ),
                        child: Text(
                          "Select Date",
                          style: ktsButtonText,
                        ),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
    rebuildUi();
  }

  // void setBusinessDetails() async {
  //   bvnNo = bvnValue ?? '';
  //   rebuildUi();
  // }

  Future<bool> createBusinessAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String identityIdValue = prefs.getString('identityId') ?? '';
    return businessCreationService.createBusinessAccount(
        addressLine1: addressValue ?? '',
        city: cityValue ?? '',
        dob: dateOfBirthValue ?? '',
        postalCode: postalCodeValue ?? '',
        state: stateValue ?? '',
        identityNumber: bvnValue ?? '',
        identityId: identityIdValue,
        otp: otpValue ?? '');
  }

  Future saveBusinessData(BuildContext context) async {
    final result = await runBusyFuture(createBusinessAccount());

    if (result == true) {
      await dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Business account',
        description: 'Business account successfully set up.',
        barrierDismissible: true,
        mainButtonTitle: 'Ok',
      );
      await navigationService.replaceWith(Routes.homeView);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            validationMessage ?? 'An error occurred, Try again.',
            textAlign: TextAlign.start,
            style: ktsSubtitleTileText2,
          ),
          elevation: 2,
          duration: const Duration(seconds: 3), // Adjust as needed
          backgroundColor: kcErrorColor,
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.fixed,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4))),
          padding: const EdgeInsets.all(12),
          // margin: EdgeInsets.only(
          //     bottom: MediaQuery.of(context).size.height * 0.85),
        ),
      );
      await dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Business account',
          description: "Business account wasn't set up.",
          barrierDismissible: true,
          mainButtonTitle: 'Ok');
    }
  }

  void navigateBack() => navigationService.back();

  Future<BusinessOTPResult> sendVerificationOTP() async {
    return businessCreationService.sendVerificationOTP(
        bvnNumber: bvnValue ?? '');
  }

  Future saveBVNData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await runBusyFuture(sendVerificationOTP());

    if (result.OTP != null) {
      final identityId = result.OTP!.id;
      prefs.setString('identityId', identityId);
      navigationService.navigateTo(Routes.businessAccountView);
    } else if (result.error != null) {
      setValidationMessage(result.error?.message);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            validationMessage ?? 'An error occurred, Try again.',
            textAlign: TextAlign.start,
            style: ktsSubtitleTileText2,
          ),
          elevation: 2,
          duration: const Duration(seconds: 3), // Adjust as needed
          backgroundColor: kcErrorColor,
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.fixed,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4))),
          padding: const EdgeInsets.all(12),
          // margin: EdgeInsets.only(
          //     bottom: MediaQuery.of(context).size.height * 0.85),
        ),
      );
    } else {
      // handle other errors
    }
  }

  void navigateBack2() => navigationService.navigateTo(Routes.homeView);
}
