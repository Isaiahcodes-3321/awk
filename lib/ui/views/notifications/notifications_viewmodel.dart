import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/notification_service.dart';

class NotificationsViewModel extends FutureViewModel<List<Notificationss>> {
  final navigationService = locator<NavigationService>();
  final authService = locator<AuthenticationService>();
  final notoficationService = locator<NotificationService>();

  List<Notificationss> notifications = [];
  Map<int, bool> expandedStates = {};
  @override
  Future<List<Notificationss>> futureToRun() => getBusinessTasks();

  Future<List<Notificationss>> getBusinessTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      // Retrieve existing expense categories
      final defaultNotifications =
          await notoficationService.getMessages(token: userId);
      // Reverse the list of notifications
      notifications = defaultNotifications.reversed.toList();
      expandedStates = {
        for (int i = 0; i < notifications.length; i++) i: false
      };
    }

    rebuildUi();
    return notifications;
  }

  String formatNotificationTime(String dateTime) {
    // Remove the timezone information from the date string
    String cleanedDateTime = dateTime.replaceAll(RegExp(r' \(.+\)'), '');

    // Parse the cleaned date string
    final dateFormat = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z");
    final notificationTime = dateFormat.parse(cleanedDateTime);
    final currentTime = DateTime.now();
    final difference = currentTime.difference(notificationTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      final days = difference.inDays;
      return '$days day${days > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return 'about $months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = difference.inDays ~/ 365;
      return 'about $years year${years > 1 ? 's' : ''} ago';
    }
  }

  void toggleExpandedState(int index) {
    expandedStates[index] = !expandedStates[index]!;
    rebuildUi();
  }

  bool isExpanded(int index) {
    return expandedStates[index] ?? false;
  }

  void navigateBack() => navigationService.back();
}
