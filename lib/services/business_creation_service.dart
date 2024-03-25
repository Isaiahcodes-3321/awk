import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessCreationService {
  ValueNotifier<GraphQLClient> client;

  final MutationOptions _createBusinessMutation;
  final MutationOptions _updateBusinessMutation;

  final QueryOptions _getBusinessCategoriesQuery;

  BusinessCreationService()
      : client = ValueNotifier(GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://api2.verzo.app/graphql'),
        )),
        _createBusinessMutation = MutationOptions(
          document: gql('''
        mutation CreateBusiness(\$input: CreateBusiness!) {
          createBusiness(input: \$input) {
            id
            businessName
            businessEmail
            businessMobile
          }
        }
      '''),
        ),
        _updateBusinessMutation = MutationOptions(
          document: gql('''
        mutation UpdateBusiness(\$businessId: String!,\$input: UpdateBusiness) {
          updateBusiness(businessId: \$businessId, input: \$input) {
            id
          }
        }
      '''),
        ),
        _getBusinessCategoriesQuery = QueryOptions(
          document: gql('''
        query GetBusinessCategories {
          getBusinessCategories {
            id
            categoryName
            }
            }
            '''),
        );

  Future<BusinessCreationResult> createBusinessProfile(
      {required String businessName,
      required String businessEmail,
      required String businessMobile,
      required String businessCategoryId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return BusinessCreationResult.error(
        error: GraphQLBusinessError(
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
      document: _createBusinessMutation.document,
      variables: {
        'input': {
          'businessName': businessName,
          'businessEmail': businessEmail,
          'businessMobile': businessMobile,
          'businessCategoryId': businessCategoryId,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return BusinessCreationResult.error(
        error: GraphQLBusinessError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    var resultbusinessId = result.data?['createBusiness']['id'];
    var resultBusinessName = result.data?['createBusiness']['businessName'];
    var resultBusinessEmail = result.data?['createBusiness']['businessEmail'];
    var resultBusinessMobile = result.data?['createBusiness']['businessMobile'];

    var business = BusinessCreationSuccessResult(
        resultbusiness_id: resultbusinessId,
        result_businessName: resultBusinessName,
        result_businessEmail: resultBusinessEmail,
        result_businessMobile: resultBusinessMobile);
    return BusinessCreationResult(business: business);
  }

  Future<BusinessUpdateResult> updateBusiness(
      {String? businessName,
      String? businessEmail,
      String? businessMobile,
      String? businessCategoryId,
      String? logo,
      required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return BusinessUpdateResult.error(
        error: GraphQLBusinessError(
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
      document: _updateBusinessMutation.document,
      variables: {
        'businessId': businessId,
        'input': {
          'businessName': businessName,
          'businessEmail': businessEmail,
          'businessMobile': businessMobile,
          'businessCategoryId': businessCategoryId,
          'logo': logo
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return BusinessUpdateResult.error(
        error: GraphQLBusinessError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['updateBusiness'] == null) {
      return BusinessUpdateResult.error(
        error: GraphQLBusinessError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultbusinessId = result.data?['updateBusiness']['id'];

    var business = BusinessUpdateSuccessResult(
      resultbusiness_id: resultbusinessId,
    );
    return BusinessUpdateResult(business: business);
  }

  Future<List<BusinessCategory>> getBusinessCategories() async {
    final QueryOptions options = QueryOptions(
      document: _getBusinessCategoriesQuery.document,
    );

    final QueryResult businessCategoriesResult =
        await client.value.query(options);

    if (businessCategoriesResult.hasException) {
      GraphQLBusinessError(
        message: businessCategoriesResult.exception?.graphqlErrors.first.message
            .toString(),
      );
    }

    final List businessCategoriesData =
        businessCategoriesResult.data?['getBusinessCategories'] ?? [];

    final List<BusinessCategory> businessCategories =
        businessCategoriesData.map((data) {
      return BusinessCategory(
        id: data['id'],
        categoryName: data['categoryName'],
      );
    }).toList();

    return businessCategories;
  }
}

class BusinessCategory {
  final String id;
  final String categoryName;

  BusinessCategory({required this.id, required this.categoryName});
}

class BusinessCreationResult {
  late final BusinessCreationSuccessResult? business;
  late final GraphQLBusinessError? error;

  BusinessCreationResult({this.business}) : error = null;
  BusinessCreationResult.error({this.error}) : business = null;

  bool get hasError => error != null;
}

class BusinessCreationSuccessResult {
  BusinessCreationSuccessResult({
    required this.resultbusiness_id,
    required this.result_businessName,
    required this.result_businessEmail,
    required this.result_businessMobile,
  });

  late final String resultbusiness_id;
  late final String result_businessName;
  late final String result_businessEmail;
  late final String result_businessMobile;
}

class BusinessUpdateResult {
  late final BusinessUpdateSuccessResult? business;
  late final GraphQLBusinessError? error;

  BusinessUpdateResult({this.business}) : error = null;
  BusinessUpdateResult.error({this.error}) : business = null;

  bool get hasError => error != null;
}

class BusinessUpdateSuccessResult {
  BusinessUpdateSuccessResult({
    required this.resultbusiness_id,
  });

  late final String resultbusiness_id;
}

class GraphQLBusinessError {
  final String? message;

  GraphQLBusinessError({required this.message});
}
