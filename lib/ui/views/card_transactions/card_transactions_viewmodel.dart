import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/app/app.router.dart';
import 'package:verzo/services/authentication_service.dart';
import 'package:verzo/services/dashboard_service.dart';

class CardTransactionsViewModel
    extends FutureViewModel<List<CardTransactions>> {
  final navigationService = locator<NavigationService>();
  final dashboardService = locator<DashboardService>();
  final authService = locator<AuthenticationService>();
  List<CardTransactions> cardTransactions = [];

  late final String cardId;

  CardTransactionsViewModel({required this.cardId});

  @override
  Future<List<CardTransactions>> futureToRun() => viewCardTransactions();

  Future<List<CardTransactions>> viewCardTransactions() async {
    final result = await authService.refreshToken();
    if (result.error != null) {
      await navigationService.replaceWithLoginView();
    } else if (result.tokens != null) {
      final cardTransactions1 =
          await dashboardService.viewCardTransactions(cardId: cardId);

      // Reverse the list here
      cardTransactions = cardTransactions1.reversed.toList();
    }

    rebuildUi();
    return cardTransactions;
  }

  void navigateBack() => navigationService.back();
}
