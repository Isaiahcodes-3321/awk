import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:verzo/app/app.bottomsheets.dart';
import 'package:verzo/app/app.dialogs.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/firebase_api.dart';
import 'package:verzo/firebase_options.dart';
import 'package:verzo/ui/common/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupLocator();
  await FirebaseApi().initNotifications();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          color: kcButtonTextColor,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [
            StackedService.routeObserver,
          ],
        );
      },
    );

    //  MaterialApp(
    //     color: kcButtonTextColor,
    //     debugShowCheckedModeBanner: false,
    //     initialRoute: Routes.startupView,
    //     onGenerateRoute: StackedRouter().onGenerateRoute,
    //     navigatorKey: StackedService.navigatorKey,
    //     navigatorObservers: [
    //       StackedService.routeObserver,
    //     ],
    //   );
  }
}

class VgsShowService {
  static const platform = MethodChannel('com.verzo.vgsShow');

  Future<void> revealData(String path, Map<String, dynamic> payload) async {
    try {
      final result = await platform.invokeMethod('revealData', {
        'path': path,
        'payload': payload,
      });
      print('Reveal data response: $result');
    } on PlatformException catch (e) {
      print("Failed to reveal data: '${e.message}'.");
    }
  }
}

class _LoggingObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    print(
        'route.name: ${route.settings.name}, previousRoute.name: ${previousRoute?.settings.name}');
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    print(
        'route.name: ${route.settings.name}, previousRoute.name: ${previousRoute?.settings.name}');
    super.didRemove(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    print(
        'route.name: ${route.settings.name}, previousRoute.name: ${previousRoute?.settings.name}');
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print(
        'newRoute.name: ${newRoute?.settings.name}, oldRoute.name: ${oldRoute?.settings.name}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
