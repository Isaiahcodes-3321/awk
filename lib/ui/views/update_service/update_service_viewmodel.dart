import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';

class UpdateServiceViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final serviceService = locator<ProductsServicesService>();
  final DialogService dialogService = locator<DialogService>();
  final authService = locator<AuthenticationService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> serviceUnitdropdownItems = [];

  late Services service;
  late final String serviceId;

  UpdateServiceViewModel({required this.serviceId});

  Future<List<ServiceUnit>> getServiceUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final businessIdValue = prefs.getString('businessId');
    final unfilteredserviceUnits =
        await serviceService.getServiceUnits(businessId: businessIdValue ?? '');
    // Filter out the service unit with the name 'others'
    final serviceUnits = unfilteredserviceUnits
        .where((serviceUnit) => serviceUnit.unitName.toLowerCase() != 'other')
        .toList();
    serviceUnitdropdownItems = serviceUnits.map((serviceUnit) {
      String displayText = serviceUnit.unitName;
      if (serviceUnit.description != null &&
          serviceUnit.description!.isNotEmpty) {
        displayText += ' - ${serviceUnit.description}';
      }
      return DropdownMenuItem<String>(
        value: serviceUnit.id.toString(),
        child: Text(displayText),
      );
    }).toList();
    return serviceUnits;
  }

  Future getServicesById1() async {
    await runBusyFuture(getServicesById());
    await runBusyFuture(getServiceUnits());
  }

  Future<Services> getServicesById() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final services = await serviceService.getServiceById(serviceId: serviceId);
    service = services;

    return services;
  }

  Future<bool> archiveService() async {
    final db = await getServiceDatabase();
    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.archive,
      title: 'Archive Service',
      description:
          "Are you sure you want to archive this service? You can’t undo this action",
      barrierDismissible: true,
      mainButtonTitle: 'Archive',
    );

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
        // Proceed with archiving if confirmed
        final bool isArchived =
            await serviceService.archiveService(serviceId: serviceId);

        if (isArchived) {
          await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Archived!',
            description: 'Your service has been successfully archived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok',
          );
          await db.delete('services');
        }

        // Navigate to the service view
        navigationService.replaceWith(Routes.serviceView);

        return isArchived;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  Future<bool> deleteService() async {
    final db = await getServiceDatabase();
    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.delete,
      title: 'Delete Service',
      description:
          "Are you sure you want to delete this service? You can’t undo this action",
      barrierDismissible: true,
      mainButtonTitle: 'Delete',
    );

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
        // Proceed with deleting if confirmed
        final bool isDeleted =
            await serviceService.deleteService(serviceId: serviceId);

        if (isDeleted) {
          await dialogService.showCustomDialog(
            variant: DialogType.deleteSuccess,
            title: 'Deleted!',
            description: 'Your service has been successfully deleted.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok',
          );
          await db.delete('services');
        }

        // Navigate to the service view
        navigationService.replaceWith(Routes.serviceView);

        return isDeleted;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  void setSelectedService() {
    // Set the form field values based on the selected expense properties
    updateserviceNameController.text = service.name;
    updatepriceController.text = service.price.toStringAsFixed(0);
    updateServiceUnitIdController.text = service.serviceUnitId!;
    rebuildUi();
  }

  TextEditingController updateserviceNameController = TextEditingController();
  TextEditingController updatepriceController = TextEditingController();
  TextEditingController updateServiceUnitIdController = TextEditingController();

  Future<ServiceUpdateResult> runServiceUpdate() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    return serviceService.updateServices(
        serviceId: serviceId,
        name: updateserviceNameController.text,
        price: double.parse(updatepriceController.text),
        serviceUnitId: updateServiceUnitIdController.text);
  }

  Future updateServiceData(BuildContext context) async {
    final db = await getServiceDatabase();
    final result = await runBusyFuture(runServiceUpdate());

    if (result.service != null) {
      await db.delete('services');
      // navigate to success route
      navigationService.replaceWith(Routes.serviceView);
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
