import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stacked_services/stacked_services.dart';
// import 'package:verzo/app/app.locator.dart';

class DashboardService {
  ValueNotifier<GraphQLClient> client;

  final MutationOptions _updateUserMutation;
  final MutationOptions _resetPasswordMutation;
  final MutationOptions _createSudoCardMutation;
  final MutationOptions _userRequestCardMutation;
  final MutationOptions _generateCardTokenMutation;

  final QueryOptions _getCardsByBusinessQuery;
  final QueryOptions _getUserCardsByBusinessQuery;
  final QueryOptions _viewCardTransactionsQuery;
  final QueryOptions _getCardByIdQuery;
  final QueryOptions _getBusinessesByUserIdQuery;
  final QueryOptions _getUserByIdQuery;
  final QueryOptions _getUsersByBusinessQuery;
  final QueryOptions _getExpensesForWeekQuery;
  final QueryOptions _getPurchasesForWeekQuery;
  final QueryOptions _getExpensesForMonthQuery;
  final QueryOptions _getExpensesForQuarterQuery;
  final QueryOptions _getExpensesForYearQuery;
  final QueryOptions _getPurchasesForMonthQuery;
  final QueryOptions _getPurchasesForQuarterQuery;
  final QueryOptions _getPurchasesForYearQuery;
  final QueryOptions _totalWeeklyInvoicesAmountQuery;
  final QueryOptions _totalMonthlyInvoicesAmountQuery;
  final QueryOptions _totalQuarterlyInvoicesAmountQuery;
  final QueryOptions _totalYearlyInvoicesAmountQuery;

  DashboardService()
      : client = ValueNotifier(GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://api2.verzo.app/graphql'),
        )),
        _getBusinessesByUserIdQuery = QueryOptions(
          document: gql('''
        query GetBusinessesByUserId{
          getBusinessesByUserId {
            user {
              id
              email
              fullname
                }
            businesses{
              id
              businessName
              businessEmail
              businessMobile
              businessCategoryId
            }
            }
            }
            '''),
        ),
        _getUserByIdQuery = QueryOptions(
          document: gql('''
        query GetUserById{
          getUserById {
            id
            role{
              roleName
            }
            }
            }
            '''),
        ),
        _getUsersByBusinessQuery = QueryOptions(
          document: gql('''
        query GetUsersByBusiness(\$businessId: String!){
          getUsersByBusiness(businessId: \$businessId) {
            id
            fullname
            email
            }
            }
            '''),
        ),
        _updateUserMutation = MutationOptions(
          document: gql('''
        mutation UpdateUser(\$input: UpdateUser){
          updateUser (input: \$input){
            id
            }
            }
            '''),
        ),
        _resetPasswordMutation = MutationOptions(
          document: gql('''
        mutation ResetPassword(\$input: ResetPassword!){
          resetPassword (input: \$input)
            }
            '''),
        ),
        _createSudoCardMutation = MutationOptions(
          document: gql('''
        mutation CreateSudoCard(\$input: CreateSudoCard!){
          createSudoCard(input: \$input){
            id
          }
        }
     '''),
        ),
        _userRequestCardMutation = MutationOptions(
          document: gql('''
        mutation UserRequestCard(\$businessId: String!){
          userRequestCard (businessId: \$businessId)
            }
            '''),
        ),
        _generateCardTokenMutation = MutationOptions(
          document: gql('''
        mutation GenerateCardToken(\$input: GetCardToken!){
          generateCardToken (input: \$input)
            }
            '''),
        ),
        _getCardsByBusinessQuery = QueryOptions(
          document: gql('''
        query GetCardsByBusiness (\$businessId: String!){
          getCardsByBusiness (businessId: \$businessId){
            id
            expiryDate
            currency
            maskedPan
           
            }
            }
            '''),
        ),
        _getUserCardsByBusinessQuery = QueryOptions(
          document: gql('''
        query GetUserCardsByBusiness (\$businessId: String!){
          getUserCardsByBusiness (businessId: \$businessId){
            id
            expiryDate
            currency
            maskedPan 
            }
            }
            '''),
        ),
        _viewCardTransactionsQuery = QueryOptions(
          document: gql('''
        query ViewCardTransactions(\$input:ViewCardAuthorizations!){
          viewCardTransactions(input:\$input){
            id
            amount
            currency
            type 
            createdAt
            }
            }
            '''),
        ),
        _getCardByIdQuery = QueryOptions(
          document: gql('''
        query getCardById(\$cardId: String!){
          getCardById(cardId: \$businessId){
            id
            amount
            currency
            maskedPan
            }
            }
            '''),
        ),
        _getExpensesForWeekQuery = QueryOptions(
          document: gql('''
        query GetExpensesForWeek (\$businessId: String!,\$weekly: Boolean){
          getExpensesForWeek (businessId: \$businessId, weekly: \$weekly){
            totalExpenseAmountThisWeek
            percentageIncreaseInExpenseThisWeek
            }
            }
            '''),
        ),
        _getPurchasesForWeekQuery = QueryOptions(
          document: gql('''
        query GetPurchasesForWeek (\$businessId: String!,\$weekly: Boolean){
          getPurchasesForWeek (businessId: \$businessId, weekly: \$weekly){
            totalPurchaseAmountThisWeek
            percentageIncreaseInPurchaseThisWeek
            totalPendingPurchaseAmountThisWeek
            }
            }
            '''),
        ),
        _getExpensesForMonthQuery = QueryOptions(
          document: gql('''
        query GetExpensesForMonth(\$businessId: String!,\$monthly: Boolean) {
          getExpensesForMonth (businessId: \$businessId, monthly: \$monthly){
            totalExpenseAmountThisMonth
            percentageIncreaseInExpenseThisMonth
            }
            }
            '''),
        ),
        _getExpensesForQuarterQuery = QueryOptions(
          document: gql('''
        query GetExpensesForQuarter(\$businessId: String!,\$quarterly: Boolean) {
          getExpensesForQuarter (businessId: \$businessId, quarterly: \$quarterly){
            totalExpenseAmountThisQuarter
            percentageIncreaseInExpenseThisQuarter
            }
            }
            '''),
        ),
        _getExpensesForYearQuery = QueryOptions(
          document: gql('''
        query GetExpensesForYear(\$businessId: String!,\$yearly: Boolean) {
          getExpensesForYear (businessId: \$businessId, yearly: \$monthly){
            totalExpenseAmountThisYear
            percentageIncreaseInExpenseThisYear
            }
            }
            '''),
        ),
        _getPurchasesForMonthQuery = QueryOptions(
          document: gql('''
        query GetPurchaseForMonth(\$businessId: String!,\$monthly: Boolean) {
          getPurchaseForMonth (businessId: \$businessId, monthly: \$monthly){
            totalPurchaseAmountThisMonth
            percentageIncreaseInPurchaseThisMonth
            totalPendingPurchaseAmountThisMonth
            }
            }
            '''),
        ),
        _getPurchasesForQuarterQuery = QueryOptions(
          document: gql('''
        query GetPurchaseForQuarter(\$businessId: String!,\$quarterly: Boolean) {
          getPurchaseForQuarter (businessId: \$businessId, quarterly: \$quarterly){
            totalPurchaseAmountThisQuarter
            percentageIncreaseInPurchaseThisQuarter
            }
            }
            '''),
        ),
        _getPurchasesForYearQuery = QueryOptions(
          document: gql('''
        query GetPurchaseForYear(\$businessId: String!,\$yearly: Boolean) {
          getPurchaseForYear (businessId: \$businessId, yearly: \$yearly){
            totalPurchaseAmountThisYear
            percentageIncreaseInPurchaseThisYear
            }
            }
            '''),
        ),
        _totalWeeklyInvoicesAmountQuery = QueryOptions(
          document: gql('''
        query TotalWeeklyInvoicesAmount(\$businessId: String!,\$weekly: Boolean){
          totalWeeklyInvoicesAmount (businessId: \$businessId, weekly: \$weekly){
            totalInvoiceAmountForWeek
            percentageOfIncreaseInInvoicesThisWeek
            totalPendingInvoiceAmountThisWeek
            percentageIncreaseInPendingInvoiceThisWeek
            totalOverdueInvoiceAmountThisWeek
            percentageIncreaseInOverdueInvoicesThisWeek
            }
            }
            '''),
        ),
        _totalMonthlyInvoicesAmountQuery = QueryOptions(
          document: gql('''
        query TotalMonthlyInvoicesAmount (\$businessId: String!,\$monthly: Boolean) {
          totalMonthlyInvoicesAmount (businessId: \$businessId, monthly: \$monthly) {
            totalInvoiceAmountForMonth
            percentageIncreaseInInvoicesThisMonth
            totalPendingInvoiceAmountThisMonth
            percentageIncreaseInPendingInvoiceThisMonth
            totalOverdueInvoiceAmountThisMonth
            percentageIncreaseInOverdueInvoicesThisMonth
            }
            }
            '''),
        ),
        _totalQuarterlyInvoicesAmountQuery = QueryOptions(
          document: gql('''
        query TotalQuarterlyInvoicesAmount (\$businessId: String!,\$quarterly: Boolean) {
          totalQuarterlyInvoicesAmount (businessId: \$businessId, quarterly: \$quarterly) {
            totalInvoiceAmountForQuarter
            percentageIncreaseInInvoicesThisQuarter
            totalPendingInvoiceAmountThisQuarter
            percentageIncreaseInPendingInvoiceThisQuarter
            totalOverdueInvoiceAmountThisQuarter
            percentageIncreaseInOverdueInvoiceThisQuarter
            }
            }
            '''),
        ),
        _totalYearlyInvoicesAmountQuery = QueryOptions(
          document: gql('''
        query TotalYearlyInvoicesAmount (\$businessId: String!,\$yearly: Boolean) {
          totalYearlyInvoicesAmount (businessId: \$businessId,yearly: \$yearly) {
            totalInvoiceAmountForYear
            percentageIncreaseInInvoiceThisYear
            totalPendingInvoiceAmountThisYear
            percentageIncreaseInPendingInvoiceThisYear
            totalOverdueInvoiceAmountThisYear
            percentageIncreaseInOverdueInvoicesThisYear
            }
            }
            '''),
        );

  Future<List<User>> getUsersByBusiness() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      throw GraphQLAuthError(
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
      document: _getUsersByBusinessQuery.document,
      variables: {
        'businessId': businessId,
      },
    );

    final QueryResult usersResult = await newClient.query(options);

    if (usersResult.hasException) {
      GraphQLAuthError(
        message: usersResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final List usersData = usersResult.data?['getUsersByBusiness'] ?? [];

    final List<User> users = usersData.map((data) {
      return User(
        id: data['id'],
        email: data['email'],
        fullname: data['fullname'],
      );
    }).toList();

    return users;
  }

  Future<String> generateCardToken(
      {required String cardId, required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      GraphQLCardError(
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
      document: _generateCardTokenMutation.document,
      variables: {
        'input': {'businessId': businessId, 'cardId': cardId},
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {}

    String cardToken = result.data?['generateCardToken'];

    return cardToken;
  }

  Future<List<BusinessCard>> getCardsByBusiness({
    required String businessId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLAuthError(
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
      document: _getCardsByBusinessQuery.document,
      variables: {
        'businessId': businessId,
      },
    );

    final QueryResult businessCardsResult = await newClient.query(options);

    // if (userAndBusinessResult.hasException) {
    //   return UserAndBusinessResult.error(
    //     error: GraphQLAuthError(
    //       message: userAndBusinessResult.exception?.graphqlErrors.first.message
    //           .toString(),
    //     ),
    //   );
    // }

    final List businessCardsData =
        businessCardsResult.data?['getCardsByBusiness'] ?? [];

    // Process the retrieved business card data
    final List<BusinessCard> businessCards = businessCardsData.map((data) {
      // final accountData = data['account'];
      // final customerData = accountData['customer'];
      return BusinessCard(
        id: data['id'],
        expiryDate: data['expiryDate'],
        maskedPan: data['maskedPan'],
        currency: data['currency'],
        // postalCode: customerData['billingAddressPostalCode'],
        // city: customerData['billingAddressCity'],
        // state: customerData['billingAddressState'],
        // line1: customerData['billingAddressLine1']
      );
    }).toList();

    return businessCards;
  }

  Future<BusinessCard> getCardsById({
    required String cardId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLAuthError(
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
      document: _getCardByIdQuery.document,
      variables: {
        'cardId': cardId,
      },
    );

    final QueryResult businessCardByIdResult = await newClient.query(options);

    if (businessCardByIdResult.hasException) {
      throw GraphQLAuthError(
        message: businessCardByIdResult.exception?.graphqlErrors.first.message
            .toString(),
      );
    }

    final businessCardByIdData = businessCardByIdResult.data?['getCardById'];

    final BusinessCard businessCardById = BusinessCard(
        expiryDate: businessCardByIdData['expiryDate'],
        id: businessCardByIdData['id'],
        maskedPan: businessCardByIdData['maskedPan'],
        currency: businessCardByIdData['currency']);

    return businessCardById;
  }

  Future<List<BusinessCard>> getUserCardsByBusiness({
    required String businessId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLAuthError(
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
      document: _getUserCardsByBusinessQuery.document,
      variables: {
        'businessId': businessId,
      },
    );

    final QueryResult businessCardsResult = await newClient.query(options);

    // if (userAndBusinessResult.hasException) {
    //   return UserAndBusinessResult.error(
    //     error: GraphQLAuthError(
    //       message: userAndBusinessResult.exception?.graphqlErrors.first.message
    //           .toString(),
    //     ),
    //   );
    // }

    final List businessCardsData =
        businessCardsResult.data?['getUserCardsByBusiness'] ?? [];

    // Process the retrieved business card data
    final List<BusinessCard> businessCards = businessCardsData.map((data) {
      // final accountData = data['account'];
      // final customerData = accountData['customer'];
      return BusinessCard(
        id: data['id'],
        expiryDate: data['expiryDate'],
        maskedPan: data['maskedPan'],
        currency: data['currency'],
        // postalCode: customerData['billingAddressPostalCode'],
        // city: customerData['billingAddressCity'],
        // state: customerData['billingAddressState'],
        // line1: customerData['billingAddressLine1']
      );
    }).toList();

    return businessCards;
  }

  Future<List<CardTransactions>> viewCardTransactions({
    required String cardId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLAuthError(
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
      document: _viewCardTransactionsQuery.document,
      variables: {
        'input': {
          'cardId': cardId,
        }
      },
    );

    final QueryResult cardTransactionResult = await newClient.query(options);

    // if (userAndBusinessResult.hasException) {
    //   return UserAndBusinessResult.error(
    //     error: GraphQLAuthError(
    //       message: userAndBusinessResult.exception?.graphqlErrors.first.message
    //           .toString(),
    //     ),
    //   );
    // }

    final List cardTransactionData =
        cardTransactionResult.data?['viewCardTransactions'] ?? [];

    // Process the retrieved business card data
    final List<CardTransactions> cardTransactions =
        cardTransactionData.map((data) {
      return CardTransactions(
          id: data['id'],
          amount: data['amount'],
          type: data['type'],
          currency: data['currency'],
          createdAt: data['createdAt']);
    }).toList();

    return cardTransactions;
  }

  Future<UserAndBusinessResult> getUserAndBusinessData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return UserAndBusinessResult.error(
        error: GraphQLAuthError(
          message: "Access token not found",
        ),
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

    final QueryResult userAndBusinessResult =
        await newClient.query(_getBusinessesByUserIdQuery);

    if (userAndBusinessResult.hasException) {
      return UserAndBusinessResult.error(
        error: GraphQLAuthError(
          message: userAndBusinessResult.exception?.graphqlErrors.first.message
              .toString(),
        ),
      );
    }

    final userData =
        userAndBusinessResult.data?['getBusinessesByUserId']['user'] ?? '';
    final List businessData =
        userAndBusinessResult.data?['getBusinessesByUserId']['businesses'] ??
            [];

    // Handle the retrieved user and business data and store it as needed

    User user = User(
      // Set the user fields based on the retrieved data
      id: userData['id'],
      email: userData['email'],
      fullname: userData['fullname'],
      // Add other user fields as needed
    );

    List<Business> businesses = businessData
        .map((business) => Business(
              // Set the business fields based on the retrieved data
              id: business['id'] ?? '',
              businessName: business['businessName'] ?? '',
              businessEmail: business['businessEmail'] ?? '',
              businessMobile: business['businessMobile'] ?? '',
              businessCategoryId: business['businessCategoryId'] ?? '',
              // Add other business fields as needed
            ))
        .toList();

    prefs.setString('userId', user.id);
    prefs.setString('userName', user.fullname);
    prefs.setString('userEmail', user.email);

    if (businesses.isNotEmpty || businesses == []) {
      prefs.setString('businessId', businesses[0].id);
      prefs.setString('businessName', businesses[0].businessName);
      prefs.setString('businessEmail', businesses[0].businessEmail);
      prefs.setString('businessMobile', businesses[0].businessMobile);
      prefs.setString('businessCategoryId', businesses[0].businessCategoryId);
    }
    // else {
    //   navigationService.replaceWith(Routes.businessProfileCreationRoute);
    //   // Handle the case when the 'businesses' list is empty, e.g., set default values or show an error message.
    // }

    return UserAndBusinessResult(user: user, businesses: businesses);
  }

  Future<UserAndRoleResult> getUserAndRoleData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return UserAndRoleResult.error(
        error: GraphQLAuthError(
          message: "Access token not found",
        ),
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

    final QueryResult userAndRoleResult =
        await newClient.query(_getUserByIdQuery);

    if (userAndRoleResult.hasException) {
      return UserAndRoleResult.error(
        error: GraphQLAuthError(
          message: userAndRoleResult.exception?.graphqlErrors.first.message
              .toString(),
        ),
      );
    }

    final String id = userAndRoleResult.data?['getUserById']['id'] ?? '';
    final roleData = userAndRoleResult.data?['getUserById']['role'] ?? [];

    final String roleName = roleData['roleName'] ?? '';

    return UserAndRoleResult(id: id, roleName: roleName);
  }

  Future<UserUpdateResult> updateUser({
    String? fullname,
    String? email,
    // String? password,
    // Add any other user fields you want to update here
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return UserUpdateResult.error(
        error: GraphQLAuthError(
          message: "Access token  not found",
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
      document: _updateUserMutation.document,
      variables: {
        'input': {
          'email': email,
          'fullname': fullname,
          // 'password': password,
          // Add any other user fields you want to update here
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return UserUpdateResult.error(
        error: GraphQLAuthError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['updateUser'] == null) {
      return UserUpdateResult.error(
        error: GraphQLAuthError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultuserId = result.data?['updateUser']['id'];

    var user = UserUpdateSuccessResult(
      resultUser_id: resultuserId,
    );

    // User update was successful
    return UserUpdateResult(user: user);
  }

  Future<bool> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
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
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );

    final MutationOptions options = MutationOptions(
      document: _resetPasswordMutation.document,
      variables: {
        'input': {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isReset = result.data?['resetPassword'] ?? false;

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isReset = false;
    }

    // if (result.data == null || result.data!['updateUser'] == null) {
    //   return UserUpdateResult.error(
    //     error: GraphQLAuthError(
    //       message: "Error parsing response data",
    //     ),
    //   );
    // }

    // Password update was successful
    return isReset;
  }

  Future<SudoCardCreationResult> createSudoCard({
    required String businessId,
    String? assignedUserId,
    List<SudoCardSpendingLimits>? spendingLimits,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return SudoCardCreationResult.error(
        error: GraphQLCardError(
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
      document: _createSudoCardMutation.document,
      variables: {
        'input': {
          'businessId': businessId,
          'assignedUserId': assignedUserId,
          'spendingLimits': spendingLimits
              ?.map((limit) => {
                    'amount': limit.amount,
                    'interval': limit.interval
                        .toString()
                        .split('.')
                        .last // Convert enum to string
                  })
              .toList()
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return SudoCardCreationResult.error(
        error: GraphQLCardError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['createSudoCard'] == null) {
      return SudoCardCreationResult.error(
        error: GraphQLCardError(
          message: "Error parsing response data",
        ),
      );
    }

    var result_Id = result.data?['createSudoCard']['id'];

    var sudoCard = SudoCardCreationSuccessResult(
      result_id: result_Id,
    );

    return SudoCardCreationResult(sudoCard: sudoCard);
  }

  Future<bool> userRequestCard({required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      GraphQLAuthError(
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
      document: _userRequestCardMutation.document,
      variables: {
        'businessId': businessId,
      },
    );

    final QueryResult result = await newClient.mutate(options);

    bool isRequested = result.data?['userRequestCard'] ?? false;

    if (result.hasException) {
      // throw Exception(result.exception);
      isRequested = false;
    }

    return isRequested;
  }

  Future<ExpensesForWeek> getExpensesForWeek(
      {required String businessId, bool? weekly = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      throw GraphQLAuthError(
        message: "Access token not found",
      );
    }

    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );

    final QueryOptions options = QueryOptions(
      document: _getExpensesForWeekQuery.document,
      variables: {'businessId': businessId, 'weekly': weekly},
    );

    final QueryResult expensesResult = await newClient.query(options);

    if (expensesResult.hasException) {
      throw GraphQLAuthError(
        message:
            expensesResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final totalExpenseAmountThisWeek = expensesResult
        .data?['getExpensesForWeek']['totalExpenseAmountThisWeek'];
    // final percentageOfExpenseToInvoiceThisWeek = expensesResult
    //     .data?['getExpensesForWeek']['percentageOfExpenseToInvoiceThisWeek'];
    final percentageIncreaseInExpenseThisWeek = expensesResult
        .data?['getExpensesForWeek']['percentageIncreaseInExpenseThisWeek'];

    var expensesForTheWeek = ExpensesForWeek(
      totalExpenseAmountThisWeek: totalExpenseAmountThisWeek / 100,
      // percentageOfExpenseToInvoiceThisWeek:
      //     percentageOfExpenseToInvoiceThisWeek,
      percentageIncreaseInExpenseThisWeek: percentageIncreaseInExpenseThisWeek,
    );

    return expensesForTheWeek;
  }

  Future<PurchasesForWeek> getPurchasesForWeek(
      {required String businessId, bool? weekly = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      throw GraphQLAuthError(
        message: "Access token not found",
      );
    }

    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );

    final QueryOptions options = QueryOptions(
      document: _getPurchasesForWeekQuery.document,
      variables: {'businessId': businessId, 'weekly': weekly},
    );

    final QueryResult purchasesResult = await newClient.query(options);

    if (purchasesResult.hasException) {
      throw GraphQLAuthError(
        message:
            purchasesResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final totalPurchaseAmountThisWeek = purchasesResult
        .data?['getPurchasesForWeek']['totalPurchaseAmountThisWeek'];
    final percentageIncreaseInPurchaseThisWeek = purchasesResult
        .data?['getPurchasesForWeek']['percentageIncreaseInPurchaseThisWeek'];
    final totalPendingPurchaseAmountThisWeek = purchasesResult
        .data?['getPurchasesForWeek']['totalPendingPurchaseAmountThisWeek'];

    var purchasesForTheWeek = PurchasesForWeek(
      percentageIncreaseInPurchaseThisWeek:
          percentageIncreaseInPurchaseThisWeek,
      totalPurchaseAmountThisWeek: totalPurchaseAmountThisWeek / 100,
      totalPendingPurchaseAmountThisWeek:
          totalPendingPurchaseAmountThisWeek / 100,
    );

    return purchasesForTheWeek;
  }

  Future<ExpensesForMonth> getExpensesForMonth(
      {required String businessId, bool? monthly = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      throw GraphQLAuthError(
        message: "Access token not found",
      );
    }

    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );

    final QueryOptions options = QueryOptions(
      document: _getExpensesForMonthQuery.document,
      variables: {'businessId': businessId, 'monthly': monthly},
    );

    final QueryResult expensesResult = await newClient.query(options);

    if (expensesResult.hasException) {
      throw GraphQLAuthError(
        message:
            expensesResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final totalExpenseAmountThisMonth = expensesResult
        .data?['getExpensesForMonth']['totalExpenseAmountThisMonth'];
    // final percentageOfExpenseToInvoiceThisMonth = expensesResult
    //     .data?['getExpensesForMonth']['percentageOfExpenseToInvoiceThisMonth'];
    final percentageIncreaseInExpenseThisMonth = expensesResult
        .data?['getExpensesForMonth']['percentageIncreaseInExpenseThisMonth'];

    var expensesForTheMonth = ExpensesForMonth(
      totalExpenseAmountThisMonth: totalExpenseAmountThisMonth / 100,
      // percentageOfExpenseToInvoiceThisMonth:
      //     percentageOfExpenseToInvoiceThisMonth,
      percentageIncreaseInExpenseThisMonth:
          percentageIncreaseInExpenseThisMonth,
    );

    return expensesForTheMonth;
  }

  Future<PurchasesForMonth> getPurchasesForMonth(
      {required String businessId, bool? monthly = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      throw GraphQLAuthError(
        message: "Access token not found",
      );
    }

    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );

    final QueryOptions options = QueryOptions(
      document: _getPurchasesForMonthQuery.document,
      variables: {'businessId': businessId, 'monthly': monthly},
    );

    final QueryResult purchasesResult = await newClient.query(options);

    if (purchasesResult.hasException) {
      throw GraphQLAuthError(
        message:
            purchasesResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final totalPurchaseAmountThisMonth = purchasesResult
        .data?['getPurchaseForMonth']['totalPurchaseAmountThisMonth'];
    final percentageIncreaseInPurchaseThisMonth = purchasesResult
        .data?['getPurchaseForMonth']['percentageIncreaseInPurchaseThisMonth'];
    final totalPendingPurchaseAmountThisMonth = purchasesResult
        .data?['getPurchaseForMonth']['totalPendingPurchaseAmountThisMonth'];

    var purchasesForTheMonth = PurchasesForMonth(
      percentageIncreaseInPurchaseThisMonth:
          percentageIncreaseInPurchaseThisMonth,
      totalPurchaseAmountThisMonth: totalPurchaseAmountThisMonth / 100,
      totalPendingPurchaseAmountThisMonth:
          totalPendingPurchaseAmountThisMonth / 100,
    );

    return purchasesForTheMonth;
  }

  Future<WeeklyInvoices> totalWeeklyInvoicesAmount(
      {required String businessId, bool? weekly = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      throw GraphQLAuthError(
        message: "Access token not found",
      );
    }

    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );

    final QueryOptions options = QueryOptions(
      document: _totalWeeklyInvoicesAmountQuery.document,
      variables: {'businessId': businessId, 'weekly': weekly},
    );

    final QueryResult expensesResult = await newClient.query(options);

    if (expensesResult.hasException) {
      throw GraphQLAuthError(
        message:
            expensesResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final totalInvoiceAmountForWeek = expensesResult
        .data?['totalWeeklyInvoicesAmount']['totalInvoiceAmountForWeek'];
    final percentageOfIncreaseInInvoicesThisWeek =
        expensesResult.data?['totalWeeklyInvoicesAmount']
            ['percentageOfIncreaseInInvoicesThisWeek'];
    // final percentageOfPaidInvoices = expensesResult
    //     .data?['totalWeeklyInvoicesAmount']['percentageOfPaidInvoices'];
    final totalPendingInvoiceAmountThisWeek =
        expensesResult.data?['totalWeeklyInvoicesAmount']
            ['totalPendingInvoiceAmountThisWeek'];
    final percentageIncreaseInPendingInvoiceThisWeek =
        expensesResult.data?['totalWeeklyInvoicesAmount']
            ['percentageIncreaseInPendingInvoiceThisWeek'];
    final totalOverDueInvoiceAmountThisWeek =
        expensesResult.data?['totalWeeklyInvoicesAmount']
            ['totalOverdueInvoiceAmountThisWeek'];
    final percentageIncreaseInOverdueInvoicesThisWeek =
        expensesResult.data?['totalWeeklyInvoicesAmount']
            ['percentageIncreaseInOverdueInvoicesThisWeek'];

    var weeklyInvoices = WeeklyInvoices(
      totalInvoiceAmountForWeek: totalInvoiceAmountForWeek / 100,
      percentageOfIncreaseInInvoicesThisWeek:
          percentageOfIncreaseInInvoicesThisWeek,
      // percentageOfPaidInvoices: percentageOfPaidInvoices,
      totalPendingInvoiceAmountThisWeek:
          totalPendingInvoiceAmountThisWeek / 100,
      percentageIncreaseInPendingInvoiceThisWeek:
          percentageIncreaseInPendingInvoiceThisWeek,
      totalOverDueInvoiceAmountThisWeek:
          totalOverDueInvoiceAmountThisWeek / 100,
      percentageIncreaseInOverdueInvoicesThisWeek:
          percentageIncreaseInOverdueInvoicesThisWeek,
    );

    return weeklyInvoices;
  }

  Future<MonthlyInvoices> totalMonthlyInvoicesAmount(
      {required String businessId, bool? monthly = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      throw GraphQLAuthError(
        message: "Access token not found",
      );
    }

    final authLink = AuthLink(
      getToken: () => 'Bearer $token',
    );

    final newClient = GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(HttpLink('https://api2.verzo.app/graphql')),
    );

    final QueryOptions options = QueryOptions(
      document: _totalMonthlyInvoicesAmountQuery.document,
      variables: {'businessId': businessId, 'monthly': monthly},
    );

    final QueryResult expensesResult = await newClient.query(options);

    if (expensesResult.hasException) {
      throw GraphQLAuthError(
        message:
            expensesResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final totalInvoiceAmountForMonth = expensesResult
        .data?['totalMonthlyInvoicesAmount']['totalInvoiceAmountForMonth'];
    final percentageIncreaseInInvoicesThisMonth =
        expensesResult.data?['totalMonthlyInvoicesAmount']
            ['percentageIncreaseInInvoicesThisMonth'];
    // final percentageOfPaidInvoicesForMonth =
    //     expensesResult.data?['totalMonthlyInvoicesAmount']
    //         ['percentageOfPaidInvoicesForMonth'];
    final totalPendingInvoiceAmountThisMonth =
        expensesResult.data?['totalMonthlyInvoicesAmount']
            ['totalPendingInvoiceAmountThisMonth'];
    final percentageIncreaseInPendingInvoiceThisMonth =
        expensesResult.data?['totalMonthlyInvoicesAmount']
            ['percentageIncreaseInPendingInvoiceThisMonth'];
    final totalOverDueInvoiceAmountThisMonth =
        expensesResult.data?['totalMonthlyInvoicesAmount']
            ['totalOverdueInvoiceAmountThisMonth'];
    final percentageIncreaseInOverdueInvoicesThisMonth =
        expensesResult.data?['totalMonthlyInvoicesAmount']
            ['percentageIncreaseInOverdueInvoicesThisMonth'];

    var monthlyInvoices = MonthlyInvoices(
      totalInvoiceAmountForMonth: totalInvoiceAmountForMonth / 100,
      percentageIncreaseInInvoicesThisMonth:
          percentageIncreaseInInvoicesThisMonth,
      // percentageOfPaidInvoicesForMonth: percentageOfPaidInvoicesForMonth,
      totalPendingInvoiceAmountThisMonth:
          totalPendingInvoiceAmountThisMonth / 100,
      percentageIncreaseInPendingInvoiceThisMonth:
          percentageIncreaseInPendingInvoiceThisMonth,
      totalOverDueInvoiceAmountThisMonth:
          totalOverDueInvoiceAmountThisMonth / 100,
      percentageIncreaseInOverdueInvoicesThisMonth:
          percentageIncreaseInOverdueInvoicesThisMonth,
    );

    return monthlyInvoices;
  }
}

class WeeklyInvoices {
  WeeklyInvoices({
    required this.totalInvoiceAmountForWeek,
    required this.percentageOfIncreaseInInvoicesThisWeek,
    this.percentageOfPaidInvoices,
    required this.totalPendingInvoiceAmountThisWeek,
    required this.percentageIncreaseInPendingInvoiceThisWeek,
    required this.totalOverDueInvoiceAmountThisWeek,
    required this.percentageIncreaseInOverdueInvoicesThisWeek,
  });

  final num totalInvoiceAmountForWeek;
  final num percentageOfIncreaseInInvoicesThisWeek;
  final num? percentageOfPaidInvoices;
  final num totalPendingInvoiceAmountThisWeek;
  final num percentageIncreaseInPendingInvoiceThisWeek;
  final num totalOverDueInvoiceAmountThisWeek;
  final num percentageIncreaseInOverdueInvoicesThisWeek;

  Map<String, dynamic> toMap() {
    return {
      'totalInvoiceAmountForWeek': totalInvoiceAmountForWeek,
      'percentageOfIncreaseInInvoicesThisWeek':
          percentageOfIncreaseInInvoicesThisWeek,
      'percentageOfPaidInvoices': percentageOfPaidInvoices,
      'totalPendingInvoiceAmountThisWeek': totalPendingInvoiceAmountThisWeek,
      'percentageIncreaseInPendingInvoiceThisWeek':
          percentageIncreaseInPendingInvoiceThisWeek,
      'totalOverDueInvoiceAmountThisWeek': totalOverDueInvoiceAmountThisWeek,
      'percentageIncreaseInOverdueInvoicesThisWeek':
          percentageIncreaseInOverdueInvoicesThisWeek,
    };
  }
}

class MonthlyInvoices {
  MonthlyInvoices({
    required this.totalInvoiceAmountForMonth,
    required this.percentageIncreaseInInvoicesThisMonth,
    this.percentageOfPaidInvoicesForMonth,
    required this.totalPendingInvoiceAmountThisMonth,
    required this.percentageIncreaseInPendingInvoiceThisMonth,
    required this.totalOverDueInvoiceAmountThisMonth,
    required this.percentageIncreaseInOverdueInvoicesThisMonth,
  });

  final num totalInvoiceAmountForMonth;
  final num percentageIncreaseInInvoicesThisMonth;
  final num? percentageOfPaidInvoicesForMonth;
  final num totalPendingInvoiceAmountThisMonth;
  final num percentageIncreaseInPendingInvoiceThisMonth;
  final num totalOverDueInvoiceAmountThisMonth;
  final num percentageIncreaseInOverdueInvoicesThisMonth;

  Map<String, dynamic> toMap() {
    return {
      'totalInvoiceAmountForMonth': totalInvoiceAmountForMonth,
      'percentageIncreaseInInvoicesThisMonth':
          percentageIncreaseInInvoicesThisMonth,
      'percentageOfPaidInvoicesForMonth': percentageOfPaidInvoicesForMonth,
      'totalPendingInvoiceAmountThisMonth': totalPendingInvoiceAmountThisMonth,
      'percentageIncreaseInPendingInvoiceThisMonth':
          percentageIncreaseInPendingInvoiceThisMonth,
      'totalOverDueInvoiceAmountThisMonth': totalOverDueInvoiceAmountThisMonth,
      'percentageIncreaseInOverdueInvoicesThisMonth':
          percentageIncreaseInOverdueInvoicesThisMonth,
    };
  }
}

class ExpensesForMonth {
  ExpensesForMonth({
    required this.totalExpenseAmountThisMonth,
    this.percentageOfExpenseToInvoiceThisMonth,
    required this.percentageIncreaseInExpenseThisMonth,
  });

  final num totalExpenseAmountThisMonth;
  final num? percentageOfExpenseToInvoiceThisMonth;
  final num percentageIncreaseInExpenseThisMonth;

  Map<String, dynamic> toMap() {
    return {
      'totalExpenseAmountThisMonth': totalExpenseAmountThisMonth,
      'percentageOfExpenseToInvoiceThisMonth':
          percentageOfExpenseToInvoiceThisMonth,
      'percentageIncreaseInExpenseThisMonth':
          percentageIncreaseInExpenseThisMonth,
    };
  }
}

class ExpensesForWeek {
  final num totalExpenseAmountThisWeek;
  final num? percentageOfExpenseToInvoiceThisWeek;
  final num percentageIncreaseInExpenseThisWeek;

  ExpensesForWeek(
      {required this.totalExpenseAmountThisWeek,
      this.percentageOfExpenseToInvoiceThisWeek,
      required this.percentageIncreaseInExpenseThisWeek});

  Map<String, dynamic> toMap() {
    return {
      'totalExpenseAmountThisWeek': totalExpenseAmountThisWeek,
      'percentageOfExpenseToInvoiceThisWeek':
          percentageOfExpenseToInvoiceThisWeek,
      'percentageIncreaseInExpenseThisWeek':
          percentageIncreaseInExpenseThisWeek,
    };
  }
}

class PurchasesForWeek {
  final num totalPurchaseAmountThisWeek;
  final num totalPendingPurchaseAmountThisWeek;
  final num percentageIncreaseInPurchaseThisWeek;

  PurchasesForWeek(
      {required this.totalPurchaseAmountThisWeek,
      required this.totalPendingPurchaseAmountThisWeek,
      required this.percentageIncreaseInPurchaseThisWeek});

  Map<String, dynamic> toMap() {
    return {
      'totalPurchaseAmountThisWeek': totalPurchaseAmountThisWeek,
      'percentageIncreaseInPurchaseThisWeek':
          percentageIncreaseInPurchaseThisWeek,
      'totalPendingPurchaseAmountThisWeek': totalPendingPurchaseAmountThisWeek,
    };
  }
}

class PurchasesForMonth {
  final num totalPurchaseAmountThisMonth;
  final num totalPendingPurchaseAmountThisMonth;
  final num percentageIncreaseInPurchaseThisMonth;

  PurchasesForMonth(
      {required this.totalPurchaseAmountThisMonth,
      required this.totalPendingPurchaseAmountThisMonth,
      required this.percentageIncreaseInPurchaseThisMonth});

  Map<String, dynamic> toMap() {
    return {
      'totalPurchaseAmountThisMonth': totalPurchaseAmountThisMonth,
      'percentageIncreaseInPurchaseThisMonth':
          percentageIncreaseInPurchaseThisMonth,
      'totalPendingPurchaseAmountThisMonth':
          totalPendingPurchaseAmountThisMonth,
    };
  }
}

// class UserAndBusinessResult {
//   late final User? user;
//   late final List<Business>? businesses;
//   late final GraphQLAuthError? error;

//   UserAndBusinessResult({this.user, this.businesses}) : error = null;
//   UserAndBusinessResult.error({this.error})
//       : user = null,
//         businesses = null;

//   bool get hasError => error != null;
// }

class UserAndBusinessResult {
  late final User user;
  late final List<Business> businesses;
  late final GraphQLAuthError? error;

  UserAndBusinessResult({
    required this.user,
    required this.businesses,
  }) : error = null;

  UserAndBusinessResult.error({this.error})
      : user = User(
          id: '', // Provide default values as needed
          email: '',
          fullname: '',
        ),
        businesses = [];

  bool get hasError => error != null;
}

class User {
  late final String id;
  late final String email;
  late final String fullname;
  // Add other user fields as needed

  User({required this.id, required this.email, required this.fullname});
}

class Business {
  late final String id;
  late final String businessName;
  late final String businessEmail;
  late final String businessMobile;
  late final String businessCategoryId;

  Business(
      {required this.id,
      required this.businessName,
      required this.businessEmail,
      required this.businessMobile,
      required this.businessCategoryId});
}

class BusinessCard {
  late final String expiryDate;
  late final String id;
  late final String maskedPan;
  late final String currency;
  // late final String postalCode;
  // late final String city;
  // late final String state;
  // late final String line1;

  BusinessCard({
    required this.expiryDate,
    required this.id,
    required this.maskedPan,
    required this.currency,
    // required this.postalCode,
    // required this.city,
    // required this.state,
    // required this.line1
  });
}

class CardTransactions {
  late final num amount;
  late final String id;
  late final String type;
  late final String currency;
  late final String createdAt;

  CardTransactions({
    required this.amount,
    required this.id,
    required this.type,
    required this.currency,
    required this.createdAt,
  });
}

class SudoCardSpendingLimits {
  late final num amount;
  final SudoCardSpendingInterval interval;

  SudoCardSpendingLimits({
    required this.amount,
    required this.interval,
  });
}

enum SudoCardSpendingInterval { daily, weekly, monthly, yearly }

class GraphQLAuthError {
  final String? message;

  GraphQLAuthError({required this.message});
}

class GraphQLCardError {
  final String? message;

  GraphQLCardError({required this.message});
}

class UserAndRoleResult {
  late final String id;
  late final String roleName;
  late final GraphQLAuthError? error;

  UserAndRoleResult({
    required this.id,
    required this.roleName,
  }) : error = null;

  UserAndRoleResult.error({this.error})
      : id = '',
        roleName = '';

  bool get hasError => error != null;
}

class UserUpdateResult {
  late final UserUpdateSuccessResult? user;
  late final GraphQLAuthError? error;

  UserUpdateResult({this.user}) : error = null;
  UserUpdateResult.error({this.error}) : user = null;

  bool get hasError => error != null;
}

class UserUpdateSuccessResult {
  UserUpdateSuccessResult({
    required this.resultUser_id,
  });

  late final String resultUser_id;
}

class SudoCardCreationResult {
  late final SudoCardCreationSuccessResult? sudoCard;
  late final GraphQLCardError? error;

  SudoCardCreationResult({this.sudoCard}) : error = null;
  SudoCardCreationResult.error({this.error}) : sudoCard = null;

  bool get hasError => error != null;
}

class SudoCardCreationSuccessResult {
  SudoCardCreationSuccessResult({
    required this.result_id,
  });

  late final String result_id;
}
