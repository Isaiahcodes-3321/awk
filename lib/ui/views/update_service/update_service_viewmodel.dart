import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';

class UpdateServiceViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final serviceService = locator<ProductsServicesService>();
  final DialogService dialogService = locator<DialogService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> serviceUnitdropdownItems = [];

  late Services service;
  late final String serviceId;

  UpdateServiceViewModel({required this.serviceId});

  Future<List<ServiceUnit>> getServiceUnits() async {
    final serviceUnits = await serviceService.getServiceUnits();
    serviceUnitdropdownItems = serviceUnits.map((serviceUnit) {
      return DropdownMenuItem<String>(
        value: serviceUnit.id.toString(),
        child: Text(serviceUnit.unitName),
      );
    }).toList();
    return serviceUnits;
  }

  Future<Services> getServicesById() async {
    final services = await serviceService.getServiceById(serviceId: serviceId);
    service = services;

    return services;
  }

  Future<bool> archiveService() async {
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
      }

      // Navigate to the service view
      navigationService.replaceWith(Routes.serviceView);

      return isArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> deleteService() async {
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
      }

      // Navigate to the service view
      navigationService.replaceWith(Routes.serviceView);

      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  void setSelectedService() {
    // Set the form field values based on the selected expense properties
    updateserviceNameController.text = service.name;
    updatepriceController.text = service.price.toString();
    updateServiceUnitIdController.text = service.serviceUnitId!;
    rebuildUi();
  }

  TextEditingController updateserviceNameController = TextEditingController();
  TextEditingController updatepriceController = TextEditingController();
  TextEditingController updateServiceUnitIdController = TextEditingController();

  Future<ServiceUpdateResult> runServiceUpdate() async {
    return serviceService.updateServices(
        serviceId: serviceId,
        name: updateserviceNameController.text,
        price: double.parse(updatepriceController.text),
        serviceUnitId: updateServiceUnitIdController.text);
  }

  Future updateServiceData(BuildContext context) async {
    final result = await runBusyFuture(runServiceUpdate());

    if (result.service != null) {
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
