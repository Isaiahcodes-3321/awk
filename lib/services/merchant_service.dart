import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MerchantService {
  ValueNotifier<GraphQLClient> client;

  final MutationOptions _createMerchantMutation;
  final QueryOptions _getMerchantsByBusinessQuery;

  MerchantService()
      : client = ValueNotifier(GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://api.verzo.app/graphql'),
        )),
        _createMerchantMutation = MutationOptions(
          document: gql('''
        mutation CreateMerchant(\$input: CreateMerchant!) {
          createMerchant(input:\$input) {
            id
            name
            businessId
          }
         }
        '''),
        ),
        _getMerchantsByBusinessQuery = QueryOptions(
          document: gql('''
        query GetMerchantsByBusiness(\$input: String!) {
          getMerchantsByBusiness(businessId: \$input) {
            id
            name
            email
            businessId
            }
          }
        '''),
        );

  Future<MerchantCreationResult> createMerchant(
      {required String name,
      required String email,
      required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return MerchantCreationResult.error(
        error: GraphQLMerchantError(
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
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );

    final MutationOptions options = MutationOptions(
      document: _createMerchantMutation.document,
      variables: {
        'input': {
          'name': name,
          'email': email,
          'businessId': businessId,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return MerchantCreationResult.error(
        error: GraphQLMerchantError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    var merchantId = result.data?['createMerchant']['id'];
    var merchantName = result.data?['createMerchant']['name'];

    if (result.data == null || result.data!['createMerchant'] == null) {
      return MerchantCreationResult.error(
        error: GraphQLMerchantError(
          message: "Error parsing response data",
        ),
      );
    }

    var merchant =
        MerchantCreationSuccessResult(id: merchantId, name: merchantName);

    return MerchantCreationResult(merchant: merchant);
  }

  Future<List<Merchants>> getMerchantsByBusiness(
      {required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      throw GraphQLMerchantError(
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
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );
    final QueryOptions options = QueryOptions(
      document: _getMerchantsByBusinessQuery.document,
      variables: {'input': businessId},
    );

    final QueryResult merchantsByBusinessResult =
        await newClient.query(options);

    if (merchantsByBusinessResult.hasException) {
      throw GraphQLMerchantError(
        message: merchantsByBusinessResult
            .exception?.graphqlErrors.first.message
            .toString(),
      );
    }

    final List merchantsData =
        merchantsByBusinessResult.data?['getMerchantsByBusiness'] ?? [];

    final List<Merchants> merchants = merchantsData.map((data) {
      return Merchants(
          id: data['id'],
          name: data['name'],
          businessId: data['businessId'],
          email: data['email']);
    }).toList();

    return merchants;
  }
}

class Merchants {
  final String id;
  final String name;
  final String email;
  final String businessId;

  Merchants(
      {required this.id,
      required this.name,
      required this.email,
      required this.businessId});
}

class MerchantCreationResult {
  late final MerchantCreationSuccessResult? merchant;
  late final GraphQLMerchantError? error;

  MerchantCreationResult({this.merchant}) : error = null;
  MerchantCreationResult.error({this.error}) : merchant = null;

  bool get hasError => error != null;
}

class MerchantCreationSuccessResult {
  final String id;
  final String name;

  MerchantCreationSuccessResult({required this.id, required this.name});
}

class GraphQLMerchantError {
  final String? message;

  GraphQLMerchantError({required this.message});
}
