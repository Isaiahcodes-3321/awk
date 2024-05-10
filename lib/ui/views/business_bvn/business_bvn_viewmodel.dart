import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/business_creation_service.dart';
import 'package:verzo/ui/common/app_colors.dart';
import 'package:verzo/ui/common/app_styles.dart';
import 'package:verzo/ui/views/business_account/business_account_view.form.dart';

class BusinessBvnViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();
  final businessCreationService = locator<BusinessCreationService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
}
