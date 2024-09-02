import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class ExpenseService {
  ValueNotifier<GraphQLClient> client;

//Expense
  final MutationOptions _createExpenseMutation;
  final QueryOptions _getExpenseByIdQuery;
  final MutationOptions _updateExpenseMutation;
  final MutationOptions _archiveExpenseMutation;
  final MutationOptions _unarchiveExpenseMutation;
  final MutationOptions _deleteExpenseMutation;
  final MutationOptions _markExpenseItemAsReceivedMutation;
  final MutationOptions _uploadMerchantInvoiceToExpenseMutation;
  final MutationOptions _makeExpensePaymentMutation;
  final QueryOptions _getExpenseByBusinessMobileQuery;
  final QueryOptions _getArchivedExpenseByBusinessMobileQuery;

//Expensecategory
// final MutationOptions _createExpenseCategoryMutation;
  final QueryOptions _getExpenseCategoryWithSetsQuery;
  final QueryOptions _getCombinedCOAsQuery;
  // final QueryOptions _getBusinessCOAByBusinessQuery;

  ExpenseService()
      : client = ValueNotifier(GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://api.verzo.app/graphql'),
        )),
        _createExpenseMutation = MutationOptions(
          document: gql('''
        mutation CreateExpense(\$input: CreateExpense!) {
          createExpense(input: \$input) {
            id
          }
        }
      '''),
        ),
        _getExpenseByIdQuery = QueryOptions(
          document: gql('''
        query GetExpenseById(\$expenseId: String!){
          getExpenseById(expenseId: \$expenseId){
            id
            amount
            description
            expenseDate
            reference
            expenseItems{
              id
              description
              quantity
              quantityReceived
              unitPrice
              index
              businessChartOfAccount{
                id
              }
              chartOfAccount{
                id
              }
            }
            merchant{
              name
              email
            }
            merchantId
            expenseCategory{
              name
            }
            expenseCategoryId
            expenseStatusId
            }
          }
        '''),
        ),
        _updateExpenseMutation = MutationOptions(
          document: gql('''
            mutation UpdateExpense(\$expenseId: String!, \$input: UpdateExpense) {
              updateExpense(expenseId: \$expenseId, input: \$input) {
                id
              }
            }
          '''),
        ),
        _getExpenseByBusinessMobileQuery = QueryOptions(
          document: gql('''
        query GetExpenseByBusinessMobile(\$businessId: String!,\$cursor: String, \$take: Int ) {
          getExpenseByBusinessMobile(businessId: \$businessId, cursor: \$cursor, take: \$take) {
            expenseByBusiness{
            id
            description
            reference
            amount
            expenseDate
            merchant{
              name
            }
            }
            cursorId
            }
          }
        '''),
        ),
        _getArchivedExpenseByBusinessMobileQuery = QueryOptions(
          document: gql('''
        query GetArchivedExpenseByBusinessMobile(\$businessId: String!,\$cursor: String, \$take: Int ) {
          getArchivedExpenseByBusinessMobile(businessId: \$businessId, cursor: \$cursor, take: \$take) {
            expenseByBusiness{
            id
            description
            reference
            amount
            expenseDate
            merchant{
              name
            }
            }
            cursorId
            }
          }
        '''),
        ),
        _unarchiveExpenseMutation = MutationOptions(
          document: gql('''
        mutation UnArchiveExpense(\$expenseId: String!) {
          unarchiveExpense(expenseId: \$expenseId)
        }
      '''),
        ),
        _archiveExpenseMutation = MutationOptions(
          document: gql('''
        mutation ArchiveExpense(\$expenseId: String!) {
          archiveExpense(expenseId: \$expenseId)
        }
      '''),
        ),
        _deleteExpenseMutation = MutationOptions(
          document: gql('''
        mutation DeleteExpense(\$expenseId: String!) {
          deleteExpense(expenseId: \$expenseId)
        }
      '''),
        ),
        _markExpenseItemAsReceivedMutation = MutationOptions(
          document: gql('''
            mutation MarkExpenseItemAsReceived(\$input: ExpenseItemReceived!) {
              markExpenseItemAsReceived(input: \$input){
                completed
                expenseStatus
              }
              }
          '''),
        ),
        _uploadMerchantInvoiceToExpenseMutation = MutationOptions(
          document: gql('''
        mutation UploadMerchantInvoiceToExpense(\$input: UploadMerchantInvoice!) {
          uploadMerchantInvoiceToExpense(input: \$input){
            uploaded
            expenseStatus
          }
        }
      '''),
        ),
        _makeExpensePaymentMutation = MutationOptions(
          document: gql('''
        mutation MakeExpensePayment(\$input: ExpensePaymentEntry!) {
          makeExpensePayment(input: \$input){
            paid
            expenseStatus
          }
        }
      '''),
        ),
        // _createExpenseCategoryMutation = MutationOptions(
        //   document: gql('''
        // mutation CreateExpenseCategory(\$input: CreateExpenseCategory!) {
        //   createExpenseCategory(input:\$input) {
        //     id
        //     name
        //     businessId
        //   }
        //  }
        // '''),
        // ),
        _getCombinedCOAsQuery = QueryOptions(
          document: gql('''
        query GetCombinedCOAs(\$input: String!){
          getCombinedCOAs(businessId: \$input){
            id
           name
            }
            }
            '''),
        ),
        // _getBusinessCOAByBusinessQuery = QueryOptions(
        //   document: gql('''
        // query GetBusinessCOAByBusiness{
        //   getBusinessesCOAByBusiness {
        //     id
        //    name
        //     }
        //     }
        //     '''),
        // ),
        _getExpenseCategoryWithSetsQuery = QueryOptions(
          document: gql('''
        query GetExpenseCategoryWithSets{
          getExpenseCategoryWithSets{
            expenseCategories{
            id
            name
            }
            }
          }
        '''),
        );

//Expense

  Future<ExpenseCreationResult> createExpenses(
      {required String description,
      required String expenseCategoryId,
      required String businessId,
      required String merchantId,
      bool? reccuring,
      required String expenseDate,
      required List<ExpenseDetail> expenseItem}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return ExpenseCreationResult.error(
        error: GraphQLExpenseError(
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
      document: _createExpenseMutation.document,
      variables: {
        'input': {
          'description': description,
          'expenseCategoryId': expenseCategoryId,
          'businessId': businessId,
          'merchantId': merchantId,
          'expenseDate': expenseDate,
          'recurring': reccuring,
          'expenseItem': expenseItem
              .map((expenseDetail) => {
                    'creditAccountId': expenseDetail.creditAccountId,
                    'description': expenseDetail.description,
                    'unitPrice': expenseDetail.unitPrice * 100,
                    'quantity': expenseDetail.quantity,
                    'index': expenseDetail.index,
                  })
              .toList(),
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return ExpenseCreationResult.error(
        error: GraphQLExpenseError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['createExpense'] == null) {
      return ExpenseCreationResult.error(
        error: GraphQLExpenseError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultexpenseId = result.data?['createExpense']['id'];

    var expense = ExpenseCreationSuccessResult(
      result_id: resultexpenseId,
    );

    return ExpenseCreationResult(expense: expense);
  }

  Future<Expenses> getExpenseById({required String expenseId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final timeZone = prefs.getString('timeZone') ?? 'UTC';

    if (token == null) {
      throw GraphQLExpenseError(
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
      document: _getExpenseByIdQuery.document,
      variables: {'expenseId': expenseId},
    );

    final QueryResult expenseByIdResult = await newClient.query(options);

    if (expenseByIdResult.hasException) {
      throw GraphQLExpenseError(
        message:
            expenseByIdResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final expenseByIdData = expenseByIdResult.data?['getExpenseById'];
    final location = tz.getLocation(timeZone);
    // Parse the UTC date string to DateTime
    final utcDate = DateTime.parse(expenseByIdData['expenseDate']).toUtc();
    // Convert UTC date to local time zone
    final localDate = tz.TZDateTime.from(utcDate, location);
    // Format localDate as a string (adjust the format as needed)
    // final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(localDate);
    final formattedDate = DateFormat('yyyy-MM-dd').format(localDate);

    final List<dynamic> expenseItemsData =
        expenseByIdData['expenseItems'] ?? [];
    final List<ExpenseDetail> expenseItems = expenseItemsData.map((itemData) {
      final dynamic businessChartOfAccount = itemData['businessChartOfAccount'];
      final String creditAccountId = businessChartOfAccount != null
          ? businessChartOfAccount['id']
          : itemData['chartOfAccount']['id'];
      return ExpenseDetail(
        id: itemData['id'],
        description: itemData['description'],
        index: itemData['index'],
        unitPrice: itemData['unitPrice'] / 100,
        quantity: itemData['quantity'],
        quantityRecieved: itemData['quantityReceived'],
        creditAccountId: creditAccountId,
      );
    }).toList();

    final Expenses expenseById = Expenses(
        id: expenseByIdData['id'],
        description: expenseByIdData['description'],
        reference: expenseByIdData['reference'],
        expenseCategoryId: expenseByIdData['expenseCategoryId'],
        expenseCategoryName: expenseByIdData['expenseCategory']['name'],
        expenseDate: formattedDate,
        merchantId: expenseByIdData['merchantId'],
        merchantName: expenseByIdData['merchant']['name'],
        merchantEmail: expenseByIdData['merchant']['email'],
        amount: expenseByIdData['amount'] / 100,
        expenseStatusId: expenseByIdData['expenseStatusId'],
        expenseItems: expenseItems);

    return expenseById;
  }

  Future<ExpenseUpdateResult> updateExpenses(
      {required String expenseId,
      String? description,
      String? expenseCategoryId,
      String? merchantId,
      String? expenseDate,
      bool? reccuring,
      List<ExpenseDetail>? expenseItem}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return ExpenseUpdateResult.error(
        error: GraphQLExpenseError(
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
      document: _updateExpenseMutation.document,
      variables: {
        'expenseId': expenseId,
        'input': {
          'description': description,
          'expenseCategoryId': expenseCategoryId,
          'expenseDate': expenseDate,
          'merchantId': merchantId,
          'expenseItem': expenseItem
              ?.map((expenseDetail) => {
                    'creditAccountId': expenseDetail.creditAccountId,
                    'description': expenseDetail.description,
                    'unitPrice': expenseDetail.unitPrice * 100,
                    'quantity': expenseDetail.quantity,
                    'index': expenseDetail.index,
                  })
              .toList(),
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return ExpenseUpdateResult.error(
        error: GraphQLExpenseError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['updateExpense'] == null) {
      return ExpenseUpdateResult.error(
        error: GraphQLExpenseError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultexpenseId = result.data?['updateExpense']['id'];

    var expense = ExpenseUpdateSuccessResult(
      result_id: resultexpenseId,
    );

    return ExpenseUpdateResult(expense: expense);
  }

  Future<List<Expenses>> getArchivedExpenseByBusiness(
      {required String businessId, num? take, String? cursor}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final timeZone = prefs.getString('timeZone') ?? 'UTC';

    if (token == null) {
      throw GraphQLExpenseError(
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
      document: _getArchivedExpenseByBusinessMobileQuery.document,
      variables: {'businessId': businessId, 'take': take, 'cursor': cursor},
    );

    final QueryResult expenseByBusinessResult = await newClient.query(options);

    // if (expenseByBusinessResult.hasException) {
    //   throw GraphQLExpenseError(
    //     message: expenseByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List expensesData = expenseByBusinessResult
            .data?['getArchivedExpenseByBusinessMobile']['expenseByBusiness'] ??
        [];

    // final String cursorId = expenseByBusinessResult
    //         .data?['getExpenseByBusinessMobile']['cursorId'] ??
    //     '';

    // prefs.setString('cursorId', cursorId);

    final List<Expenses> expenses = expensesData.map((data) {
      final merchantData = data['merchant']; // Access merchant data
      final location = tz.getLocation(timeZone);
      // Parse the UTC date string to DateTime
      final utcDate = DateTime.parse(data['expenseDate']).toUtc();
      // Convert UTC date to local time zone
      final localDate = tz.TZDateTime.from(utcDate, location);

      // Format localDate as a string (adjust the format as needed)
      // final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(localDate);
      final formattedDate = DateFormat('yyyy-MM-dd').format(localDate);
      return Expenses(
        id: data['id'],
        description: data['description'],
        amount: data['amount'] / 100,
        expenseDate: formattedDate,
        reference: data['reference'],
        merchantId: '',
        expenseStatusId: 0,
        merchantName: merchantData['name'],
        expenseItems: [],
        expenseCategoryName: '',
        expenseCategoryId: '',
      );
    }).toList();

    return expenses;
  }

  Future<List<Expenses>> getExpenseByBusiness(
      {required String businessId, num? take, String? cursor}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final timeZone = prefs.getString('timeZone') ?? 'UTC';

    if (token == null) {
      throw GraphQLExpenseError(
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
      document: _getExpenseByBusinessMobileQuery.document,
      variables: {'businessId': businessId, 'take': take, 'cursor': cursor},
    );

    final QueryResult expenseByBusinessResult = await newClient.query(options);

    // if (expenseByBusinessResult.hasException) {
    //   throw GraphQLExpenseError(
    //     message: expenseByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List expensesData = expenseByBusinessResult
            .data?['getExpenseByBusinessMobile']['expenseByBusiness'] ??
        [];

    // final String cursorId = expenseByBusinessResult
    //         .data?['getExpenseByBusinessMobile']['cursorId'] ??
    //     '';

    // prefs.setString('cursorId', cursorId);

    final List<Expenses> expenses = expensesData.map((data) {
      final merchantData = data['merchant']; // Access merchant data
      final location = tz.getLocation(timeZone);
      // Parse the UTC date string to DateTime
      final utcDate = DateTime.parse(data['expenseDate']).toUtc();
      // Convert UTC date to local time zone
      final localDate = tz.TZDateTime.from(utcDate, location);

      // Format localDate as a string (adjust the format as needed)
      // final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(localDate);
      final formattedDate = DateFormat('yyyy-MM-dd').format(localDate);

      return Expenses(
        id: data['id'],
        description: data['description'],
        amount: data['amount'] / 100,
        expenseDate: formattedDate,
        reference: data['reference'],
        merchantId: '',
        expenseStatusId: 0,
        merchantName: merchantData['name'],
        expenseItems: [],
        expenseCategoryName: '',
        expenseCategoryId: '',
      );
    }).toList();

    return expenses;
  }

  Future<bool> unarchiveExpense({required String expenseId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLExpenseError(
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
      document: _unarchiveExpenseMutation.document,
      variables: {
        'expenseId': expenseId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isUnArchived = result.data?['unarchiveExpense'] ?? false;

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isUnArchived = false;
    }

    return isUnArchived;
  }

  Future<bool> archiveExpense({required String expenseId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLExpenseError(
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
      document: _archiveExpenseMutation.document,
      variables: {
        'expenseId': expenseId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isArchived = result.data?['archiveExpense'] ?? false;

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      // throw Exception(result.exception);
      isArchived = false;
    }

    //  bool isArchived = result.data?['archiveExpense'] ?? false;

    // bool isArchived = result.data?['archiveExpense'] ?? false;

    return isArchived;
  }

  Future<bool> deleteExpense({required String expenseId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLExpenseError(
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
      document: _deleteExpenseMutation.document,
      variables: {
        'expenseId': expenseId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isDeleted = result.data?['deleteExpense'] ?? false;

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      // throw Exception(result.exception);
      isDeleted = false;
    }

    return isDeleted;
  }

  Future<ExpenseStatusResult> markExpenseItemAsReceived(
      {required String expenseItemId,
      required String businessId,
      required String transactionDate,
      required num quantityReceived}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLExpenseError(
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
      document: _markExpenseItemAsReceivedMutation.document,
      variables: {
        'input': {
          'expenseItemId': expenseItemId,
          'businessId': businessId,
          'quantity': quantityReceived,
          'transactionDate': transactionDate,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      // Handle any errors that may have occurred during the mutation
      GraphQLExpenseError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    bool isCompleted =
        result.data?['markExpenseItemAsReceived']['completed'] ?? false;
    num expenseStatus =
        result.data?['markExpenseItemAsReceived']['expenseStatus'] ?? 0;

    return ExpenseStatusResult(
      isCompleted: isCompleted,
      expenseStatus: expenseStatus,
    );
  }

  Future<ExpenseStatusResult> uploadMerchantInvoiceToExpense({
    required String expenseId,
    required String businessId,
    required String invoiceDate,
    bool? match,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      GraphQLExpenseError(
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
      document: _uploadMerchantInvoiceToExpenseMutation.document,
      variables: {
        'input': {
          'expenseId': expenseId,
          'businessId': businessId,
          'invoiceDate': invoiceDate,
          'match': match,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      GraphQLExpenseError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    bool isuploaded =
        result.data?['uploadMerchantInvoiceToExpense']['uploaded'] ?? false;
    num expenseStatus =
        result.data?['uploadMerchantInvoiceToExpense']['expenseStatus'];

    return ExpenseStatusResult(
        isCompleted: isuploaded, expenseStatus: expenseStatus);
  }

  Future<ExpenseStatusResult> makeExpensePayment(
      {required String expenseId,
      required String businessId,
      required String transactionDate,
      required String description,
      required num total,
      String? file}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      GraphQLExpenseError(
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
      document: _makeExpensePaymentMutation.document,
      variables: {
        'input': {
          'expenseId': expenseId,
          'businessId': businessId,
          'transactionDate': transactionDate,
          'description': description,
          'total': total,
          'file': file
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      GraphQLExpenseError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    bool isPaid = result.data?['makeExpensePayment']['paid'] ?? false;
    num expenseStatus = result.data?['makeExpensePayment']['expenseStatus'];

    return ExpenseStatusResult(
        isCompleted: isPaid, expenseStatus: expenseStatus);
  }

// ExpenseCategory
//   Future<ExpenseCategoryCreationResult> createExpenseCategory(
//       {required String name, required String businessId}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('access_token');
//     final businessId = prefs.getString('id');

//     if (token == null) {
//       return ExpenseCategoryCreationResult.error(
//         error: GraphQLExpenseError(
//           message: "Access token not found",
//         ),
//       );
//     }

//     // Use the token to create an authlink
//     final authLink = AuthLink(
//       getToken: () => 'Bearer $token',
//     );

//     // Create a new GraphQLClient with the authlink
//     final newClient = GraphQLClient(
//       cache: GraphQLCache(),
//       link: authLink.concat(HttpLink('https://api.verzo.app/graphql')),
//     );

//     final MutationOptions options = MutationOptions(
//       document: _createExpenseCategoryMutation.document,
//       variables: {
//         'input': {
//           'name': name,
//           'businessId': businessId,
//         },
//       },
//     );

//     final QueryResult result = await newClient.mutate(options);

//     var expenseCategory_id = result.data?['createExpenseCategory']['id'];
//     var expenseCategory_name = result.data?['createExpenseCategory']['name'];
//     var expenseCategory_businessId =
//         result.data?['createExpenseCategory']['businessId'];

//     if (result.hasException) {
//       return ExpenseCategoryCreationResult.error(
//         error: GraphQLExpenseError(
//           message: result.exception?.graphqlErrors.first.message.toString(),
//         ),
//       );
//     }

//     if (result.data == null || result.data!['createExpenseCategory'] == null) {
//       return ExpenseCategoryCreationResult.error(
//         error: GraphQLExpenseError(
//           message: "Error parsing response data",
//         ),
//       );
//     }

//     var expenseCategory = ExpenseCategoryCreationSuccessResult(
//         id: expenseCategory_id,
//         name: expenseCategory_name,
//         businessId: expenseCategory_businessId);

//     return ExpenseCategoryCreationResult(expenseCategory: expenseCategory);
//   }

  Future<List<ExpenseCategory>> getExpenseCategoryWithSets() async {
    final QueryOptions options = QueryOptions(
      document: _getExpenseCategoryWithSetsQuery.document,
    );

    final QueryResult expenseCategoryWithSetsResult =
        await client.value.query(options);

    if (expenseCategoryWithSetsResult.hasException) {
      throw GraphQLExpenseError(
        message: expenseCategoryWithSetsResult
            .exception?.graphqlErrors.first.message
            .toString(),
      );
    }

    final List expenseCategoriesData = expenseCategoryWithSetsResult
            .data?['getExpenseCategoryWithSets']['expenseCategories'] ??
        [];

    final List<ExpenseCategory> expenseCategories =
        expenseCategoriesData.map((data) {
      return ExpenseCategory(id: data['id'], name: data['name']);
    }).toList();

    return expenseCategories;
  }

  Future<List<COA>> getCOAs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      throw GraphQLExpenseError(
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
      document: _getCombinedCOAsQuery.document,
      variables: {'input': businessId},
    );

    final QueryResult cOAsResult = await newClient.query(options);

    if (cOAsResult.hasException) {
      throw GraphQLExpenseError(
        message: cOAsResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final List cOAsData = cOAsResult.data?['getCombinedCOAs'] ?? [];

    final List<COA> cOAs = cOAsData.map((data) {
      return COA(id: data['id'], name: data['name']);
    }).toList();

    return cOAs;
  }
}

class ExpenseStatusResult {
  final bool isCompleted;
  final num expenseStatus;

  ExpenseStatusResult({
    required this.isCompleted,
    required this.expenseStatus,
  });
}

class ExpenseCategory {
  final String id;
  final String name;

  ExpenseCategory({required this.id, required this.name});
}

class COA {
  final String id;
  final String name;

  COA({required this.id, required this.name});
}

// class ExpenseCategoryCreationResult {
//   late final ExpenseCategoryCreationSuccessResult? expenseCategory;
//   late final GraphQLExpenseError? error;

//   ExpenseCategoryCreationResult({this.expenseCategory}) : error = null;
//   ExpenseCategoryCreationResult.error({this.error}) : expenseCategory = null;

//   bool get hasError => error != null;
// }

// class ExpenseCategoryCreationSuccessResult {
//   final String id;
//   final String name;
//   final String businessId;

//   ExpenseCategoryCreationSuccessResult(
//       {required this.id, required this.name, required this.businessId});
// }

class ExpenseUpdateResult {
  late final ExpenseUpdateSuccessResult? expense;
  late final GraphQLExpenseError? error;

  ExpenseUpdateResult({this.expense}) : error = null;
  ExpenseUpdateResult.error({this.error}) : expense = null;

  bool get hasError => error != null;
}

class ExpenseUpdateSuccessResult {
  ExpenseUpdateSuccessResult({
    required this.result_id,
  });

  late final String result_id;
}

class ExpenseCreationResult {
  late final ExpenseCreationSuccessResult? expense;
  late final GraphQLExpenseError? error;

  ExpenseCreationResult({this.expense}) : error = null;
  ExpenseCreationResult.error({this.error}) : expense = null;

  bool get hasError => error != null;
}

class ExpenseCreationSuccessResult {
  ExpenseCreationSuccessResult({
    required this.result_id,
  });

  late final String result_id;
}

class GraphQLExpenseError {
  final String? message;

  GraphQLExpenseError({required this.message});
}

class Expenses {
  Expenses(
      {required this.id,
      required this.description,
      required this.reference,
      required this.amount,
      required this.expenseDate,
      required this.expenseCategoryId,
      required this.expenseCategoryName,
      required this.merchantId,
      required this.merchantName,
      this.merchantEmail,
      this.recurring,
      required this.expenseItems,
      required this.expenseStatusId});

  final String id;
  final String description;
  final String reference;
  final num amount;
  final String expenseDate;
  final String expenseCategoryId;
  final String expenseCategoryName;
  final String merchantId;
  final String merchantName;
  String? merchantEmail;
  bool? recurring;
  final List<ExpenseDetail> expenseItems;
  num expenseStatusId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'reference': reference,
      'amount': amount,
      'expenseDate': expenseDate,
      'expenseCategoryId': expenseCategoryId,
      'expenseCategoryName': expenseCategoryName,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'recurring': recurring == true ? 1 : 0,
      'expenseItems':
          jsonEncode(expenseItems.map((item) => item.toMap()).toList()),
      'expenseStatusId': expenseStatusId,
    };
  }

  static Expenses fromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> decodedExpenseItemsList =
        (jsonDecode(map['expenseItems']) as List<dynamic>)
            .cast<Map<String, dynamic>>()
            .toList();

    List<ExpenseDetail> expenseItems = decodedExpenseItemsList
        .map((itemMap) => ExpenseDetail.fromMap(itemMap))
        .toList();
    return Expenses(
      id: map['id'],
      description: map['description'],
      reference: map['reference'],
      amount: map['amount'],
      expenseDate: map['expenseDate'],
      expenseCategoryId: map['expenseCategoryId'],
      expenseCategoryName: map['expenseCategoryName'],
      merchantId: map['merchantId'],
      merchantName: map['merchantName'],
      recurring: map['recurring'] == 1,
      expenseItems: expenseItems,
      expenseStatusId: map['expenseStatusId'],
    );
  }
}

class ExpenseDetail {
  String id;
  final String description;
  final String? creditAccountId;
  num index;
  num unitPrice;
  num quantity;
  num? quantityRecieved;

  ExpenseDetail(
      {required this.id,
      required this.description,
      this.creditAccountId,
      required this.index,
      required this.unitPrice,
      required this.quantity,
      this.quantityRecieved});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'creditAccountId': creditAccountId,
      'index': index,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'quantityRecieved': quantityRecieved,
    };
  }

  static ExpenseDetail fromMap(Map<String, dynamic> map) {
    return ExpenseDetail(
      id: map['id'],
      description: map['description'],
      creditAccountId: map['creditAccountId'],
      index: map['index'],
      unitPrice: map['unitPrice'],
      quantity: map['quantity'],
      quantityRecieved: map['quantityRecieved'],
    );
  }
}
