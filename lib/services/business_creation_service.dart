import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';

class BusinessCreationService {
  final navigationService = locator<NavigationService>();
  ValueNotifier<GraphQLClient> client;

  final MutationOptions _createBusinessMutation;
  final MutationOptions _sendVerificationOTPMutation;
  final MutationOptions _setUpBusinessAccountMutation;
  final MutationOptions _updateBusinessMutation;

  final QueryOptions _getBusinessCategoriesQuery;
  final QueryOptions _getCountriesQuery;
  final QueryOptions _getCurrenciesQuery;
  final QueryOptions _getBusinessTasksQuery;
  final QueryOptions _viewBusinessAccountQuery;
  final QueryOptions _viewBusinessAccountStatementQuery;

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
        _setUpBusinessAccountMutation = MutationOptions(
          document: gql('''
        mutation SetUpBusinessAccount(\$input: CreateSudoAccount!) {
          setUpBusinessAccount(input: \$input) 
        }
      '''),
        ),
        _sendVerificationOTPMutation = MutationOptions(
          document: gql('''
        mutation SendVerificationOTP(\$bvnNumber: String!) {
          sendVerificationOTP(bvnNumber: \$bvnNumber){
            message
            data{
              _id
              otpId
            }
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
        ),
        _getCountriesQuery = QueryOptions(
          document: gql('''
        query GetCountries {
          getCountries {
            id
            countryName
            }
            }
            '''),
        ),
        _getCurrenciesQuery = QueryOptions(
          document: gql('''
        query GetCurrencies {
          getCurrencies {
            id
            currency
            symbol
            }
            }
            '''),
        ),
        _getBusinessTasksQuery = QueryOptions(
          document: gql('''
        query GetBusinessTasksMobile(\$input: GetTaskMobileInput!){
          getBusinessTasksMobile(input: \$input)  {
            tasks{
              taskType{
                taskType
                createdAt
              }
              user{
                id
                email
                fullname
              }
            }
            }
            }
            '''),
        ),
        _viewBusinessAccountQuery = QueryOptions(
          document: gql('''
        query ViewBusinessAccount(\$businessId: String!){
          viewBusinessAccount(businessId: \$businessId) {
            id
            bvn
            accountName
            accountType
            accountNumber
            accountBalance
            customer{
              billingAddressLine1
              billingAddressCity
              billingAddressState
              }
            }
            }
            '''),
        ),
        _viewBusinessAccountStatementQuery = QueryOptions(
          document: gql('''
        query ViewBusinessAccountStatement(\$input: ViewAccountStatement!){
          viewBusinessAccountStatement(input: \$input){
            id
            paymentReference
            amount
            type
            narration
            transactionDate
            }
            }
            '''),
        );

  Future<BusinessAccount?>? viewBusinessAccount({required businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLBusinessError(
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
      document: _viewBusinessAccountQuery.document,
      variables: {'businessId': businessId},
    );

    final QueryResult businessAccountResult = await newClient.query(options);

    if (businessAccountResult.hasException) {
      return null;
    }
    {
      final businessAccountData =
          businessAccountResult.data?['viewBusinessAccount'];

      final customerData = businessAccountData['customer'];

      final BusinessAccount businessAccount = BusinessAccount(
        id: businessAccountData['id'],
        accountName: businessAccountData['accountName'],
        accountNumber: businessAccountData['accountNumber'],
        accountBalance: businessAccountData['accountBalance'],
        accountbillingAddressLine1: customerData['billingAddressLine1'],
        accountbillingAddressCity: customerData['billingAddressCity'],
        accountbillingAddressState: customerData['billingAddressState'],
        accountType: businessAccountData['accountType'],
        bvn: businessAccountData['bvn'],
      );

      return businessAccount;
    }
  }

  Future<BusinessOTPResult> sendVerificationOTP(
      {required String bvnNumber}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return BusinessOTPResult.error(
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
      document: _sendVerificationOTPMutation.document,
      variables: {'bvnNumber': bvnNumber},
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return BusinessOTPResult.error(
        error: GraphQLBusinessError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    var businessOTPData = result.data?['sendVerificationOTP'];

    var message = businessOTPData['message'];
    var id = businessOTPData['data']['_id'];
    var otpId = businessOTPData['data']['otpId'];
    // var otpVerified = businessOTPData['createBusiness']['otpVerified'];

    var OTP = BusinessOTPSuccessResult(id: id, message: message, otpId: otpId);
    return BusinessOTPResult(OTP: OTP);
  }

  Future<BusinessCreationResult> createBusinessProfile({
    required String businessName,
    required String businessEmail,
    required String businessMobile,
    required String businessCategoryId,
    required String countryId,
  }) async {
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
          'countryId': countryId,
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

  Future<bool> createBusinessAccount({
    required String identityNumber,
    required String identityId,
    required String otp,
    required String addressLine1,
    required String city,
    required String dob,
    required String postalCode,
    required String state,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLBusinessError(
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

    final MutationOptions options = MutationOptions(
      document: _setUpBusinessAccountMutation.document,
      variables: {
        'input': {
          'dob': dob,
          'otp': otp,
          'identityNumber': identityNumber,
          'identityId': identityId,
          'addressLine1': addressLine1,
          'city': city,
          'state': state,
          'postalCode': postalCode
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    bool isSetUp = result.data?['setUpBusinessAccount'] ?? false;

    if (result.hasException) {
      // throw Exception(result.exception);
      isSetUp = false;
    }

    return isSetUp;
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

  Future<List<Country>> getCountries() async {
    final QueryOptions options = QueryOptions(
      document: _getCountriesQuery.document,
    );

    final QueryResult countriesResult = await client.value.query(options);

    if (countriesResult.hasException) {
      GraphQLBusinessError(
        message:
            countriesResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final List countriesData = countriesResult.data?['getCountries'] ?? [];

    final List<Country> countries = countriesData.map((data) {
      return Country(
        id: data['id'],
        countryName: data['countryName'],
      );
    }).toList();

    return countries;
  }

  Future<List<Currency>> getCurrencies() async {
    final QueryOptions options = QueryOptions(
      document: _getCurrenciesQuery.document,
    );

    final QueryResult currenciesResult = await client.value.query(options);

    if (currenciesResult.hasException) {
      GraphQLBusinessError(
        message:
            currenciesResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final List currenciesData = currenciesResult.data?['getCurrencies'] ?? [];

    final List<Currency> currencies = currenciesData.map((data) {
      return Currency(
        id: data['id'],
        currency: data['currency'],
        symbol: data['symbol'],
      );
    }).toList();

    return currencies;
  }

  Future<List<BusinessTask>> getBusinessTasks(
      {required String businessId, num? take, String? cursor}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLBusinessError(
        message: "Access token not found",
      );
    }
// Use the token to create an authlink
    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );
    final QueryOptions options = QueryOptions(
      document: _getBusinessTasksQuery.document,
      variables: {
        'input': {'businessId': businessId, 'take': take, 'cursor': cursor}
      },
    );

    final QueryResult businessTasksResult = await newClient.query(options);

    // if (businessTasksResult.hasException) {
    //   GraphQLBusinessError(
    //     message: businessTasksResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List businessTasksData =
        businessTasksResult.data?['getBusinessTasksMobile']['tasks'] ?? [];

    final List<BusinessTask> businessTasks = businessTasksData.map((data) {
      final taskTypeData = data['taskType'];
      final userData = data['user'];
      return BusinessTask(
          createdAt: taskTypeData['createdAt'],
          taskType: taskTypeData['taskType'],
          userId: userData['id'],
          userEmail: userData['email'],
          userFullname: userData['fullname']);
    }).toList();

    return businessTasks;
  }

  Future<List<BusinessAccountStatement>> viewBusinessAccountStatement({
    required String businessId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      throw GraphQLBusinessError(
        message: "Access token not found",
      );
    }
    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    // Create a new GraphQLClient with the authlink
    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );

    final QueryOptions options = QueryOptions(
      document: _viewBusinessAccountStatementQuery.document,
      variables: {
        'input': {
          'businessId': businessId,
        }
      },
    );

    final QueryResult businessStatementResult = await newClient.query(options);

    // if (userAndBusinessResult.hasException) {
    //   return UserAndBusinessResult.error(
    //     error: GraphQLAuthError(
    //       message: userAndBusinessResult.exception?.graphqlErrors.first.message
    //           .toString(),
    //     ),
    //   );
    // }

    final List businessStatementData =
        businessStatementResult.data?['viewBusinessAccountStatement'] ?? [];

    // Process the retrieved business card data
    final List<BusinessAccountStatement> businessStatement =
        businessStatementData.map((data) {
      return BusinessAccountStatement(
        id: data['id'],
        amount: data['amount'],
        type: data['type'],
        paymentReference: data['paymentReference'],
        narration: data['narration'],
        transactionDate: data['transactionDate'],
      );
    }).toList();

    return businessStatement;
  }
}

class BusinessCategory {
  final String id;
  final String categoryName;

  BusinessCategory({required this.id, required this.categoryName});
}

class Country {
  final String id;
  final String countryName;

  Country({required this.id, required this.countryName});
}

class Currency {
  final String id;
  final String currency;
  final String symbol;

  Currency({required this.id, required this.currency, required this.symbol});
}

class BusinessTask {
  final String taskType;
  final String userEmail;
  final String userFullname;
  final String userId;
  final String createdAt;

  BusinessTask(
      {required this.taskType,
      required this.userEmail,
      required this.userId,
      required this.userFullname,
      required this.createdAt});
}

// class BusinessAccountResult {
//   late final BusinessCreationSuccessResult? account;
//   late final GraphQLBusinessError? error;

//   BusinessAccountResult({this.account}) : error = null;
//   BusinessAccountResult.error({this.error}) : account = null;

//   bool get hasError => error != null;
// }

// class BusinessAccountSuccessResult {
//   final String message;
//   final SafeHeavenAccount data;

//   BusinessAccountSuccessResult({required this.message, required this.data});
// }

// class SafeHeavenAccount {
//   final String bvn;
//   final String accountName;
//   final String accountNumber;

//   SafeHeavenAccount(
//       {required this.bvn,
//       required this.accountName,
//       required this.accountNumber});
// }

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

class BusinessOTPResult {
  late final BusinessOTPSuccessResult? OTP;
  late final GraphQLBusinessError? error;

  BusinessOTPResult({this.OTP}) : error = null;
  BusinessOTPResult.error({this.error}) : OTP = null;

  bool get hasError => error != null;
}

class BusinessOTPSuccessResult {
  BusinessOTPSuccessResult({
    required this.id,
    required this.message,
    required this.otpId,
  });

  late final String id;
  late final String message;

  late final String otpId;
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

class BusinessAccount {
  late final String id;
  late final String accountName;
  late final num accountBalance;
  late final String accountbillingAddressLine1;
  late final String accountbillingAddressState;
  late final String accountbillingAddressCity;

  late final String accountNumber;
  late final String accountType;
  late final String bvn;

  BusinessAccount(
      {required this.accountName,
      required this.id,
      required this.accountNumber,
      required this.accountBalance,
      required this.accountbillingAddressLine1,
      required this.accountbillingAddressState,
      required this.accountbillingAddressCity,
      required this.accountType,
      required this.bvn});
}

class BusinessAccountStatement {
  late final String id;
  late final String paymentReference;
  late final num amount;

  late final String type;
  late final String narration;
  late final String transactionDate;

  BusinessAccountStatement(
      {required this.paymentReference,
      required this.id,
      required this.amount,
      required this.type,
      required this.narration,
      required this.transactionDate});
}

class OTPresponse {
  late final String id;
  late final String message;

  late final String otpId;
  late final bool otpVerified;

  OTPresponse(
      {required this.message,
      required this.id,
      required this.otpId,
      required this.otpVerified});
}
