import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';
import 'package:verzo/services/dashboard_service.dart';

class CardTransactionsViewModel
    extends FutureViewModel<List<CardTransactions>> {
  final navigationService = locator<NavigationService>();
  final dashboardService = locator<DashboardService>();
  List<CardTransactions> cardTransactions = [];

  late final String cardId;

  CardTransactionsViewModel({required this.cardId});

  @override
  Future<List<CardTransactions>> futureToRun() => viewCardTransactions();

  Future<List<CardTransactions>> viewCardTransactions() async {
    // Retrieve existing expense categories
    cardTransactions =
        await dashboardService.viewCardTransactions(cardId: cardId);

    rebuildUi();
    return cardTransactions;
  }

  void navigateBack() => navigationService.back();
}
