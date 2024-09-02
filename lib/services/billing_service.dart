import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';

class BillingService {
  final navigationService = locator<NavigationService>();
  ValueNotifier<GraphQLClient> client;

  final MutationOptions _createSubscriptionNewCardAMutation;
  final MutationOptions _createSubscriptionNewCardBMutation;

  final QueryOptions _getPlansQuery;
  final QueryOptions _getCurrentSubscriptionByBusinessQuery;
  final QueryOptions _subscriptionCheckerForFrontendQuery;
  BillingService()
      : client = ValueNotifier(GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://api.verzo.app/graphql'),
        )),
        _createSubscriptionNewCardAMutation = MutationOptions(
          document: gql('''
        mutation CreateSubscriptionNewCardAs(\$input: CreateSubscriptionWithCard!) {
          createSubscriptionNewCardA(input: \$input) {
            status
            paymentReference
            paymentLink
          }
        }
      '''),
        ),
        _createSubscriptionNewCardBMutation = MutationOptions(
          document: gql('''
        mutation CreateSubscriptionNewCardB(\$input: CreateSubscriptionWithCardB!) {
          createSubscriptionNewCardB(input: \$input) {
            id
            currentPlanId
            trialPeriodStart
            trialPeriodEnd
          }
        }
      '''),
        ),
        _getPlansQuery = QueryOptions(
          document: gql('''
        query GetPlans {
          getPlans {
            id
            planName
            currentPrice
            isActive
            }
            }
            '''),
        ),
        _getCurrentSubscriptionByBusinessQuery = QueryOptions(
          document: gql('''
        query getCurrentSubscriptionByBusiness(\$businessId: String!){
          getCurrentSubscriptionByBusiness(businessId: \$businessId) {
            plan{
              planName
              currentPrice
             }
            validTo
            }
            }
            '''),
        ),
        _subscriptionCheckerForFrontendQuery = QueryOptions(
          document: gql('''
        query subscriptionCheckerForFrontend{
          subscriptionCheckerForFrontend
            }
            '''),
        );

  Future<bool> isSubscriptionValid() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLSubscriptionError(
        message: "Access token not found",
      );
    }

    // Use the token to create an authlink
    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    // Create a new GraphQLClient with the authlink
    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api.verzo.app/graphql')),
    );

    final QueryOptions options = QueryOptions(
      document: _subscriptionCheckerForFrontendQuery.document,
    );
    final QueryResult result = await newClient.query(options);
    bool isValid;

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      // throw Exception(result.exception);
      isValid = false;
    }

    isValid = result.data?['subscriptionCheckerForFrontend'] ?? false;

    return isValid;
  }

  Future<Subscriptions> getCurrentSubscriptionByBusiness({
    required String businessId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      GraphQLSubscriptionError(
        message: "Access token not found",
      );
    }

    // Use the token to create an authlink
    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    // Create a new GraphQLClient with the authlink
    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api.verzo.app/graphql')),
    );

    final QueryOptions options = QueryOptions(
        document: _getCurrentSubscriptionByBusinessQuery.document,
        variables: {'businessId': businessId});

    final QueryResult result = await newClient.query(options);

    if (result.hasException) {
      GraphQLSubscriptionError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final subscriptionData = result.data?['getCurrentSubscriptionByBusiness'];
    final planData = subscriptionData['plan'];

    final Subscriptions subscriptions = Subscriptions(
      planName: planData['planName'],
      validTo: subscriptionData['validTo'],
      currentPrice: planData['currentPrice'],
    );

    return subscriptions;
  }

  Future<SubscriptionCreationResult> createSubscriptionNewCardA(
      {required String businessId,
      required String currentPlanId,
      required num tax}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return SubscriptionCreationResult.error(
        error: GraphQLSubscriptionError(
          message: "Access token not found",
        ),
      );
    }

    // Use the token to create an authlink
    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    // Create a new GraphQLClient with the authlink
    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api.verzo.app/graphql')),
    );

    final MutationOptions options = MutationOptions(
      document: _createSubscriptionNewCardAMutation.document,
      variables: {
        'input': {
          'businessId': businessId,
          'currentPlanId': currentPlanId,
          'tax': tax
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return SubscriptionCreationResult.error(
        error: GraphQLSubscriptionError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    var status = result.data?['createSubscriptionNewCardA']['status'];
    var paymentLink = result.data?['createSubscriptionNewCardA']['paymentLink'];
    var paymentReference =
        result.data?['createSubscriptionNewCardA']['paymentReference'];

    var subscription = SubscriptionCreationSuccessResult(
        status: status,
        paymentLink: paymentLink,
        paymentReference: paymentReference);
    return SubscriptionCreationResult(subscription: subscription);
  }

  Future<SubscriptionCreationResultB> createSubscriptionNewCardB(
      {required String businessId,
      required String currentPlanId,
      required String reference,
      required num tax}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return SubscriptionCreationResultB.error(
        error: GraphQLSubscriptionError(
          message: "Access token not found",
        ),
      );
    }

    // Use the token to create an authlink
    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    // Create a new GraphQLClient with the authlink
    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api.verzo.app/graphql')),
    );

    final MutationOptions options = MutationOptions(
      document: _createSubscriptionNewCardBMutation.document,
      variables: {
        'input': {
          'businessId': businessId,
          'currentPlanId': currentPlanId,
          'reference': reference,
          'tax': tax
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return SubscriptionCreationResultB.error(
        error: GraphQLSubscriptionError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    var result_id = result.data?['createSubscriptionNewCardB']['id'];

    var subscription = SubscriptionCreationSuccessResultB(id: result_id);
    return SubscriptionCreationResultB(subscription: subscription);
  }

  Future<List<Plans>> getPlans() async {
    final QueryOptions options = QueryOptions(
      document: _getPlansQuery.document,
    );

    final QueryResult plansResult = await client.value.query(options);

    if (plansResult.hasException) {
      GraphQLSubscriptionError(
        message: plansResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final List plansData = plansResult.data?['getPlans'] ?? [];

    final List<Plans> plans = plansData.map((data) {
      return Plans(
        id: data['id'],
        planName: data['planName'],
        currentPrice: data['currentPrice'],
        isActive: data['isActive'],
      );
    }).toList();

    return plans;
  }
}

class Plans {
  final String id;
  final String planName;
  final num currentPrice;
  final bool isActive;

  Plans(
      {required this.id,
      required this.planName,
      required this.currentPrice,
      required this.isActive});
}

class Subscriptions {
  final String planName;
  final String validTo;
  final num currentPrice;

  Subscriptions({
    required this.planName,
    required this.validTo,
    required this.currentPrice,
  });
}

class SubscriptionCreationResult {
  late final SubscriptionCreationSuccessResult? subscription;
  late final GraphQLSubscriptionError? error;

  SubscriptionCreationResult({this.subscription}) : error = null;
  SubscriptionCreationResult.error({this.error}) : subscription = null;

  bool get hasError => error != null;
}

class SubscriptionCreationSuccessResult {
  SubscriptionCreationSuccessResult(
      {required this.status,
      required this.paymentReference,
      required this.paymentLink});

  late final String status;
  late final String paymentReference;
  late final String paymentLink;
}

class SubscriptionCreationResultB {
  late final SubscriptionCreationSuccessResultB? subscription;
  late final GraphQLSubscriptionError? error;

  SubscriptionCreationResultB({this.subscription}) : error = null;
  SubscriptionCreationResultB.error({this.error}) : subscription = null;

  bool get hasError => error != null;
}

class SubscriptionCreationSuccessResultB {
  SubscriptionCreationSuccessResultB({required this.id});

  late final String id;
}

class GraphQLSubscriptionError {
  final String? message;

  GraphQLSubscriptionError({required this.message});
}
