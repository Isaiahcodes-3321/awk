import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationService {
  ValueNotifier<GraphQLClient> client;

  final MutationOptions _verificationMutation;
  final MutationOptions _resendVerificationMutation;

  VerificationService()
      : client = ValueNotifier(GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://api.verzo.app/graphql'),
        )),
        _verificationMutation = MutationOptions(
          document: gql('''
        mutation Verification(\$input: Float!) {
          verification(code: \$input) 
        }
      '''),
        ),
        _resendVerificationMutation = MutationOptions(
          document: gql('''
        mutation ResendVerification{
          resendVerification
        }
      '''),
        );

  Future<VerificationResult> verifyOTP({required num code}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return VerificationResult.error(
        error: GraphQLAuthError(
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
      document: _verificationMutation.document,
      variables: {
        'input': code,
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return VerificationResult.error(
        error: GraphQLAuthError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }
    var isSuccessful = result.data?['verification'];

    if (result.data == null || result.data!['verification'] == null) {
      return VerificationResult.error(
        error: GraphQLAuthError(
          message: "Error parsing response data",
        ),
      );
    }

    var verification = VerificationSuccessResult(isSuccessful: isSuccessful);

    return VerificationResult(verificationResponse: verification);
  }

  Future<bool> resendVerification() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLAuthError(
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

    final MutationOptions options = MutationOptions(
      document: _resendVerificationMutation.document,
    );

    final QueryResult result = await newClient.mutate(options);
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      throw Exception(result.exception);
    }

    bool verificationResent = result.data?['resendVerification'];

    return verificationResent;
  }
}

class GraphQLAuthError {
  final String? message;

  GraphQLAuthError({required this.message});
}

class VerificationResult {
  late final VerificationSuccessResult? verificationResponse;
  late final GraphQLAuthError? error;

  VerificationResult({this.verificationResponse}) : error = null;
  VerificationResult.error({this.error}) : verificationResponse = null;

  bool get hasError => error != null && error!.message!.isNotEmpty;
}

class VerificationSuccessResult {
  VerificationSuccessResult({
    required this.isSuccessful,
  });

  late final bool isSuccessful;
}
