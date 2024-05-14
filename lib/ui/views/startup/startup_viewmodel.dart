import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/services/authentication_service.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 2));

    if (await _authenticationService.isLoggedIn() == true) {
      final result = await _authenticationService.refreshToken();
      if (result.tokens != null) {
        await _navigationService.replaceWith(Routes.homeView);
      } else if (result.error != null) {
        await _navigationService.replaceWithLoginView();
      }
    } else {
      _navigationService.replaceWithLoginView();
    }

    //   // This is where you can make decisions on where your app should navigate when
    //   // you have custom startup logic
    // }
  }
}
