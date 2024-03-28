import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';

class UpdateCustomerViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _saleService = locator<SalesService>();
  final DialogService dialogService = locator<DialogService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Customers customer;
  late final String customerId;

  UpdateCustomerViewModel({required this.customerId});

  Future getCustomerById1() async {
    await runBusyFuture(getCustomerById());
  }

  Future<Customers> getCustomerById() async {
    final customers =
        await _saleService.getCustomerById(customerId: customerId);
    customer = customers;

    return customers;
  }

  Future<bool> archiveCustomer() async {
    final db = await getCustomerDatabase();

    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.archive,
        title: 'Archive Customer',
        description:
            "Are you sure you want to archive this customer? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Archive'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      // Proceed with archiving if confirmed
      final bool isArchived =
          await _saleService.archiveCustomer(customerId: customerId);

      if (isArchived) {
        await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Archived!',
            description: 'Your customer has been successfully archived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
        await db.delete('customers');
      }

      // Navigate to the customer view
      navigationService.replaceWith(Routes.customerView);

      return isArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> deleteCustomer() async {
    final db = await getCustomerDatabase();

    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.delete,
        title: 'Delete Customer',
        description:
            "Are you sure you want to delete this customer? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Delete');

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      // Proceed with deleting if confirmed
      final bool isDeleted =
          await _saleService.deleteCustomer(customerId: customerId);

      if (isDeleted) {
        await dialogService.showCustomDialog(
            variant: DialogType.deleteSuccess,
            title: 'Deleted!',
            description: 'Your customer has been successfully deleted.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
        await db.delete('customers');
      }

      // Navigate to the customer view
      navigationService.replaceWith(Routes.customerView);

      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  void setSelectedCustomer() {
    // Set the form field values based on the selected expense properties
    updateCustomerNameController.text = customer.name;
    updateCustomerEmailController.text = customer.email;
    updateCustomerMobileController.text = customer.mobile;
    updateCustomerAddressController.text = customer.address;
    rebuildUi();
  }

  TextEditingController updateCustomerNameController = TextEditingController();
  TextEditingController updateCustomerEmailController = TextEditingController();
  TextEditingController updateCustomerMobileController =
      TextEditingController();
  TextEditingController updateCustomerAddressController =
      TextEditingController();

  Future<CustomerUpdateResult> runCustomerUpdate() async {
    return _saleService.updateCustomers(
        customerId: customerId,
        name: updateCustomerNameController.text,
        mobile: updateCustomerMobileController.text,
        address: updateCustomerAddressController.text,
        email: updateCustomerEmailController.text);
  }

  Future updateCustomerData(BuildContext context) async {
    final db = await getCustomerDatabase();
    final result = await runBusyFuture(runCustomerUpdate());

    if (result.customer != null) {
      await db.delete('customers');
      // navigate to success route
      navigationService.replaceWith(Routes.customerView);
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
          // margin:
          //     EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.9),
        ),
      );
    } else {
      // handle other errors
    }
  }

  @override
  void setFormStatus() {}

  void navigateBack() => navigationService.back();
}
