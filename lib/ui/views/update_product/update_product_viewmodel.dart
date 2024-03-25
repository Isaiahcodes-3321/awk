import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';

class UpdateProductViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final productService = locator<ProductsServicesService>();
  final DialogService dialogService = locator<DialogService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> productUnitdropdownItems = [];

  late Products product;
  late final String productId;

  UpdateProductViewModel({required this.productId});

  Future<List<ProductUnit>> getProductUnits() async {
    final productUnits = await productService.getProductUnits();
    productUnitdropdownItems = productUnits.map((productUnit) {
      return DropdownMenuItem<String>(
        value: productUnit.id.toString(),
        child: Text(productUnit.unitName),
      );
    }).toList();
    return productUnits;
  }

  Future<Products> getProductsById() async {
    final products = await productService.getProductById(productId: productId);
    product = products;
    rebuildUi();
    return products;
  }

  // Add a property to track reorder level
  bool trackReorderLevel = false;
  num reorderLevel = 0;

  // Add a controller for reorder level
  TextEditingController reorderLevelController = TextEditingController();

  void setTrackReorderLevel(bool value) {
    trackReorderLevel = value;
    // If tracking is disabled, clear the reorder level
    if (!value) {
      reorderLevel = 0;
      reorderLevelController.text = '';
    }
    rebuildUi();
  }

  void setSelectedProduct() {
    // Set the form field values based on the selected expense properties
    updateproductNameController.text = product.productName;
    updatepriceController.text = product.price.toString();
    updateProductUnitIdController.text = product.productUnitId!;
    rebuildUi();
  }

  TextEditingController updateproductNameController = TextEditingController();
  TextEditingController updatepriceController = TextEditingController();
  TextEditingController updateProductUnitIdController = TextEditingController();

  Future<ProductUpdateResult> runProductUpdate() async {
    if (trackReorderLevel && reorderLevelController.text.isNotEmpty) {
      reorderLevel = num.parse(reorderLevelController.text);
    }
    return productService.updateProducts(
        productId: productId,
        reorderLevel: reorderLevel,
        trackReorderLevel: trackReorderLevel,
        productName: updateproductNameController.text,
        price: double.parse(updatepriceController.text),
        productUnitId: updateProductUnitIdController.text);
  }

  Future updateProductData(BuildContext context) async {
    final result = await runBusyFuture(runProductUpdate());

    if (result.product != null) {
      // navigate to success route
      navigationService.replaceWith(Routes.productView);
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

  Future<bool> archiveProduct() async {
    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.archive,
      title: 'Archive Product',
      description:
          "Are you sure you want to archive this product? You can’t undo this action",
      barrierDismissible: true,
      mainButtonTitle: 'Archive',
    );

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      // Proceed with archiving if confirmed
      final bool isArchived =
          await productService.archiveProduct(productId: productId);

      if (isArchived) {
        await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Archived!',
            description: 'Your product has been successfully archived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok');
      }

      // Navigate to the product view
      navigationService.replaceWith(Routes.productView);

      return isArchived;
    } else {
      // User canceled the action
      return false;
    }
  }

  Future<bool> deleteProduct() async {
    // Show a confirmation dialog
    final DialogResponse? response = await dialogService.showCustomDialog(
      variant: DialogType.delete,
      title: 'Delete Product',
      description:
          "Are you sure you want to delete this product? You can’t undo this action",
      barrierDismissible: true,
      mainButtonTitle: 'Delete',
    );

    // Check if the user confirmed the action
    if (response?.confirmed == true) {
      // Proceed with deleting if confirmed
      final bool isDeleted =
          await productService.deleteProduct(productId: productId);

      if (isDeleted) {
        await dialogService.showCustomDialog(
          variant: DialogType.deleteSuccess,
          title: 'Deleted!',
          description: 'Your product has been successfully deleted.',
          barrierDismissible: true,
          mainButtonTitle: 'Ok',
        );
      }

      // Navigate to the product view
      navigationService.replaceWith(Routes.productView);

      return isDeleted;
    } else {
      // User canceled the action
      return false;
    }
  }

  @override
  void setFormStatus() {}

  void navigateBack() => navigationService.back();
}
