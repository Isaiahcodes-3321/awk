import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/typesense.dart';

class ServiceViewModel extends FutureViewModel<List<Services>> {
  final navigationService = locator<NavigationService>();
  final _productservicesService = locator<ProductsServicesService>();
  final DialogService dialogService = locator<DialogService>();
  final TextEditingController searchController = TextEditingController();

  List<Services> services = [];
  List<Services> archivedServices = [];
  List<Services> allServices = [];
  List<Services> searchResults = [];

  bool isSearchActive = false;
  void toggleSearch() {
    isSearchActive = !isSearchActive;
    if (!isSearchActive) {
      // Clear the search controller and reload data if needed
      searchController.clear();
      reload();
    }
    rebuildUi();
  }

  @override
  Future<List<Services>> futureToRun() => getServiceByBusiness();
  Future<List<Services>> getServiceByBusiness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';

    // Retrieve existing products/services
    services = await _productservicesService.getServiceByBusiness(
        businessId: businessIdValue);

    rebuildUi();

    archivedServices = await _productservicesService
        .getArchivedServiceByBusiness(businessId: businessIdValue);

    rebuildUi();

    allServices = [...services, ...archivedServices];

    rebuildUi();

    return allServices;
  }

  Future<void> searchService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String businessIdValue = prefs.getString('businessId') ?? '';
    String userIdValue = prefs.getString('userId') ?? '';
    final searchValue = searchController.text;

    // Ensure the search value is not empty4
    if (searchValue.isNotEmpty) {
      try {
        // Call your searchAllCollections function to search expenses
        searchResults =
            await searchServices(searchValue, businessIdValue, userIdValue);
      } catch (error) {
        print('Error searching expenses: $error');
      }
    } else {
      // searchResults =
      //     expenses; // Reset to original list when the search query is empty
    }
    // print(searchResults);

    services = searchResults;
    archivedServices = searchResults;
    rebuildUi();
    // return searchResults;
  }

  Future<bool> unArchiveService(String serviceId) async {
    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.archive,
      title: 'Unarchive Service',
      description:
          "Are you sure you want to unarchive this service? You can’t undo this action",
      barrierDismissible: true,
      mainButtonTitle: 'Unarchive',
    );

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      // Proceed with archiving if confirmed
      final bool isUnArchived =
          await _productservicesService.unArchiveService(serviceId: serviceId);

      if (isUnArchived) {
        await dialogService.showCustomDialog(
          variant: DialogType.archiveSuccess,
          title: 'Unarchived!',
          description: 'Your service has been successfully unarchived.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
      }

      await reloadServiceData();

      return isUnArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<void> reloadServiceData() async {
    final allServices = await getServiceByBusiness();
    // Update the data with the new list of purchases
    data = allServices;
    rebuildUi();
  }

  Future<List<Services>> reloadService() async {
    allServices = await getServiceByBusiness();
    rebuildUi();
    return allServices;
  }

  Future reload() async {
    runBusyFuture(reloadService());
  }
}
