import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/sales_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/common/database_helper.dart';

class ViewSalesViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final _saleService = locator<SalesService>();
  final authService = locator<AuthenticationService>();
  final DialogService dialogService = locator<DialogService>();

  Sales? sale;
  late final String saleId;

  ViewSalesViewModel({required this.saleId});

  num get totalSaleExpensesAmount {
    if (sale?.saleExpenses == null) {
      return 0;
    }
    return sale!.saleExpenses!.fold(0, (sum, item) => sum + item.amount);
  }

  Future<Sales> getSaleById() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    }
    final sales = await _saleService.getSaleById(saleId: saleId);
    sale = sales;

    rebuildUi();
    return sales;
  }

  Future<bool> deleteSale(BuildContext context) async {
    final db = await getSalesDatabase2();
    final db2 = await getSalesDatabaseList();
    final dbWeeklyInvoices = await getWeeklyInvoicesDatabase();
    final dbMonthlyInvoices = await getMonthlyInvoicesDatabase();

    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.delete,
        title: 'Delete invoice',
        description:
            "Are you sure you want to delete this invoice? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Delete'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );

    if (response?.confirmed == true) {
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
        final bool isDeleted = await _saleService.deleteSale(saleId: saleId);
        if (isDeleted) {
          await dialogService.showCustomDialog(
            variant: DialogType.deleteSuccess,
            title: 'Deleted!',
            description: 'Your invoice has been successfully deleted.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok',
          );
          await db.delete('sales');
          await db2.delete('sales');
          await dbWeeklyInvoices.delete('weekly_invoices');
          await dbMonthlyInvoices.delete('monthly_invoices');
        }

        navigationService.back(result: true);
        rebuildUi();

        return isDeleted;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  Future<bool> archiveSale(BuildContext context) async {
    final db = await getSalesDatabase2();
    final db2 = await getSalesDatabaseList();
    final dbWeeklyInvoices = await getWeeklyInvoicesDatabase();
    final dbMonthlyInvoices = await getMonthlyInvoicesDatabase();

    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.archive,
        title: 'Archive invoice',
        description:
            "Are you sure you want to archive this invoice? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Archive'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );

    if (response?.confirmed == true) {
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
        final bool isArchived = await _saleService.archiveSale(saleId: saleId);
        if (isArchived) {
          await dialogService.showCustomDialog(
            variant: DialogType.archiveSuccess,
            title: 'Archived!',
            description: 'Your invoice has been successfully archived.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok',
          );
          await db.delete('sales');
          await db2.delete('sales');
          await dbWeeklyInvoices.delete('weekly_invoices');
          await dbMonthlyInvoices.delete('monthly_invoices');
        }

        navigationService.back(result: true);
        rebuildUi();

        return isArchived;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  Future<bool> sendInvoice(BuildContext context) async {
    final DialogResponse? response = await dialogService.showCustomDialog(
        variant: DialogType.send,
        title: 'Send Invoice',
        description:
            "Are you sure you want to share this invoice with a customer? You can’t undo this action",
        barrierDismissible: true,
        mainButtonTitle: 'Send'
        // cancelTitle: 'Cancel',
        // confirmationTitle: 'Ok',
        );
    if (response?.confirmed == true) {
      final result = await authService.refreshToken();
      if (result.error != null) {
        await navigationService.replaceWithLoginView();
      } else if (result.tokens != null) {
        final bool invoiceSent = await _saleService.sendInvoice(
            invoiceId: sale!.invoiceId, copy: true);
        if (invoiceSent) {
          await dialogService.showCustomDialog(
            variant: DialogType.sendSuccess,
            title: 'Sent!',
            description: 'Your invoice has been successfully sent.',
            barrierDismissible: true,
            mainButtonTitle: 'Ok',
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Access denied: Business has no valid subscription',
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
        }
        return invoiceSent;
      }
    } else {
      // User canceled the action
      return false;
    }
    return false;
  }

  void reloadView() async {
    final sales = await getSaleById();
    sale = sales;
    rebuildUi();
  }

  void navigateBack() => navigationService.back();
}
