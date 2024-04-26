// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/archive/archive_dialog.dart';
import '../ui/dialogs/archive_success/archive_success_dialog.dart';
import '../ui/dialogs/card/card_dialog.dart';
import '../ui/dialogs/card_success/card_success_dialog.dart';
import '../ui/dialogs/delete/delete_dialog.dart';
import '../ui/dialogs/delete_success/delete_success_dialog.dart';
import '../ui/dialogs/info/info_dialog.dart';
import '../ui/dialogs/info_alert/info_alert_dialog.dart';
import '../ui/dialogs/logout/logout_dialog.dart';
import '../ui/dialogs/send/send_dialog.dart';
import '../ui/dialogs/send_success/send_success_dialog.dart';

enum DialogType {
  infoAlert,
  archive,
  delete,
  deleteSuccess,
  archiveSuccess,
  send,
  sendSuccess,
  info,
  logout,
  card,
  cardSuccess,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.infoAlert: (context, request, completer) =>
        InfoAlertDialog(request: request, completer: completer),
    DialogType.archive: (context, request, completer) =>
        ArchiveDialog(request: request, completer: completer),
    DialogType.delete: (context, request, completer) =>
        DeleteDialog(request: request, completer: completer),
    DialogType.deleteSuccess: (context, request, completer) =>
        DeleteSuccessDialog(request: request, completer: completer),
    DialogType.archiveSuccess: (context, request, completer) =>
        ArchiveSuccessDialog(request: request, completer: completer),
    DialogType.send: (context, request, completer) =>
        SendDialog(request: request, completer: completer),
    DialogType.sendSuccess: (context, request, completer) =>
        SendSuccessDialog(request: request, completer: completer),
    DialogType.info: (context, request, completer) =>
        InfoDialog(request: request, completer: completer),
    DialogType.logout: (context, request, completer) =>
        LogoutDialog(request: request, completer: completer),
    DialogType.card: (context, request, completer) =>
        CardDialog(request: request, completer: completer),
    DialogType.cardSuccess: (context, request, completer) =>
        CardSuccessDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
