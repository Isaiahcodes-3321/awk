import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class PurchaseService {
  ValueNotifier<GraphQLClient> client;

//Expense
  final MutationOptions _createPurchaseEntryMutation;
  final QueryOptions _getPurchaseByIdQuery;
  final MutationOptions _updatePurchaseEntryMutation;
  final MutationOptions _archivePurchaseMutation;
  final MutationOptions _unarchivePurchaseMutation;
  final MutationOptions _deletePurchaseMutation;
  final MutationOptions _markPurchaseItemAsReceivedMutation;
  final MutationOptions _makePurchasePaymentMutation;
  final MutationOptions _uploadMerchantInvoiceToPurchaseMutation;
  final MutationOptions _sendPurchaseMutation;
  final QueryOptions _getPurchaseByBusinessQuery;
  final QueryOptions _getArchivedPurchaseByBusinessQuery;

  // final QueryOptions _getProductByBusinessQuery;

//Expensecategory
// final MutationOptions _createExpenseCategoryMutation;
  // final QueryOptions _getExpenseCategoryWithSetsQuery;

  PurchaseService()
      : client = ValueNotifier(GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://api.verzo.app/graphql'),
        )),
        _createPurchaseEntryMutation = MutationOptions(
          document: gql('''
        mutation CreatePurchaseEntry(\$input: CreatePurchase!) {
          createPurchaseEntry(input: \$input) {
            id
           
          }
        }
      '''),
        ),
        _getPurchaseByIdQuery = QueryOptions(
          document: gql('''
        query GetPurchaseById(\$purchaseId: String!){
          getPurchaseById(purchaseId: \$purchaseId){
            id
            transactionDate
            description
            reference
            total
            purchaseStatusId
            paid
            merchantId
            merchant{
              name
              email
              }
            purchaseItems{
              id
              index
              description
              quantity
              unitPrice 
              quantityReceived
              product{
                id
              }
            }
          }
          }
        '''),
        ),
        _updatePurchaseEntryMutation = MutationOptions(
          document: gql('''
            mutation UpdatePurchaseEntry(\$purchaseId: String!, \$input: UpdatePurchase!) {
              updatePurchaseEntry(purchaseId: \$purchaseId, input: \$input) {
                id
                description    
              }
            }
          '''),
        ),
        _markPurchaseItemAsReceivedMutation = MutationOptions(
          document: gql('''
            mutation MarkPurchaseItemAsReceived( \$input: PurchaseItemReceived!) {
              markPurchaseItemAsReceived(input: \$input){
                completed
                purchaseStatus
              }
              }
          '''),
        ),
        _makePurchasePaymentMutation = MutationOptions(
          document: gql('''
        mutation MakePurchasePayment(\$input: PurchasePaymentEntry!) {
          makePurchasePayment(input: \$input){
                paid
                purchaseStatus
              }
        }
      '''),
        ),
        _uploadMerchantInvoiceToPurchaseMutation = MutationOptions(
          document: gql('''
        mutation UploadMerchantInvoiceToPurchase(\$input: UploadMerchantInvoiceToPurchase!) {
          uploadMerchantInvoiceToPurchase(input: \$input){
                uploaded
                purchaseStatus
              }
        }
      '''),
        ),
        _sendPurchaseMutation = MutationOptions(
          document: gql('''
        mutation SendPurchase(\$purchaseId: String!, \$copy: Boolean) {
          sendPurchase(purchaseId: \$purchaseId, copy: \$copy)
        }
      '''),
        ),
        _getArchivedPurchaseByBusinessQuery = QueryOptions(
          document: gql('''
        query GetArchivedPurchaseByBusinessMobile(\$businessId: String!, \$take: Int) {
          getArchivedPurchaseByBusinessMobile(businessId: \$businessId, take: \$take) {
            purchaseByBusiness{
              id
              reference 
              total
              transactionDate
              description
              paid
              merchant{
              name
              }
            }
          }
          }
        '''),
        ),
        _getPurchaseByBusinessQuery = QueryOptions(
          document: gql('''
        query GetPurchaseByBusinessMobile(\$businessId: String!, \$take: Int) {
          getPurchaseByBusinessMobile(businessId: \$businessId, take: \$take) {
            purchaseByBusiness{
              id
              reference 
              total
              transactionDate
              description
              paid
              merchant{
              name
              }
            }
          }
          }
        '''),
        ),
        _unarchivePurchaseMutation = MutationOptions(
          document: gql('''
        mutation UnArchivePurchase(\$purchaseId: String!) {
          unarchivePurchase(purchaseId: \$purchaseId)
        }
      '''),
        ),
        _archivePurchaseMutation = MutationOptions(
          document: gql('''
        mutation ArchivePurchase(\$purchaseId: String!) {
          archivePurchase(purchaseId: \$purchaseId)
        }
      '''),
        ),
        _deletePurchaseMutation = MutationOptions(
          document: gql('''
        mutation DeletePurchase(\$purchaseId: String!) {
          deletePurchase(purchaseId: \$purchaseId)
        }
      '''),
        );

  Future<PurchaseCreationResult> createPurchaseEntry(
      {required List<PurchaseItemDetail> purchaseItem,
      required String description,
      required String businessId,
      required String merchantId,
      // bool? reccuring,
      required String transactionDate}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return PurchaseCreationResult.error(
        error: GraphQLPurchaseError(
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
      document: _createPurchaseEntryMutation.document,
      variables: {
        'input': {
          'description': description,
          'businessId': businessId,
          'merchantId': merchantId,
          'transactionDate': transactionDate,
          'purchaseItem': purchaseItem
              .map((purchaseItemDetail) => {
                    'productId': purchaseItemDetail.productId,
                    'itemDescription': purchaseItemDetail.itemDescription,
                    'unitPrice': purchaseItemDetail.unitPrice * 100,
                    'quantity': purchaseItemDetail.quantity,
                    'index': purchaseItemDetail.index,
                  })
              .toList(),
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return PurchaseCreationResult.error(
        error: GraphQLPurchaseError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['createPurchaseEntry'] == null) {
      return PurchaseCreationResult.error(
        error: GraphQLPurchaseError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultpurchaseId = result.data?['createPurchaseEntry']['id'];

    var purchase = PurchaseCreationSuccessResult(
      result_id: resultpurchaseId,
    );

    return PurchaseCreationResult(purchase: purchase);
  }

  Future<Purchases> getPurchaseById({required String purchaseId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final timeZone = prefs.getString('timeZone') ?? 'UTC';

    if (token == null) {
      throw GraphQLPurchaseError(
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
      document: _getPurchaseByIdQuery.document,
      variables: {'purchaseId': purchaseId},
    );

    final QueryResult purchaseByIdResult = await newClient.query(options);

    if (purchaseByIdResult.hasException) {
      throw GraphQLPurchaseError(
        message: purchaseByIdResult.exception?.graphqlErrors.first.message
            .toString(),
      );
    }

    final purchaseByIdData = purchaseByIdResult.data?['getPurchaseById'];

    final location = tz.getLocation(timeZone);
    // Parse the UTC date string to DateTime
    final utcDate = DateTime.parse(purchaseByIdData['transactionDate']).toUtc();
    // Convert UTC date to local time zone
    final localDate = tz.TZDateTime.from(utcDate, location);
    // Format localDate as a string (adjust the format as needed)
    // final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(localDate);
    final formattedDate = DateFormat('yyyy-MM-dd').format(localDate);

    final List<dynamic> purchaseItemsData =
        purchaseByIdData['purchaseItems'] ?? [];
    final List<PurchaseItemDetail> purchaseItems =
        purchaseItemsData.map((itemData) {
      return PurchaseItemDetail(
        id: itemData['id'],
        productId: itemData['product']['id'],
        itemDescription: itemData['description'],
        index: itemData['index'],
        unitPrice: itemData['unitPrice'] / 100,
        quantity: itemData['quantity'],
        quantityRecieved: itemData['quantityReceived'],
      );
    }).toList();

    final Purchases purchaseById = Purchases(
        paid: purchaseByIdData['paid'] ?? false,
        id: purchaseByIdData['id'],
        description: purchaseByIdData['description'],
        transactionDate: formattedDate,
        merchantId: purchaseByIdData['merchantId'],
        merchantName: purchaseByIdData['merchant']['name'],
        merchantEmail: purchaseByIdData['merchant']['email'],
        total: purchaseByIdData['total'] / 100,
        purchaseStatusId: purchaseByIdData['purchaseStatusId'],
        purchaseItems: purchaseItems,
        reference: purchaseByIdData['reference']);

    return purchaseById;
  }

  Future<bool> unArchivePurchase({required String purchaseId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLPurchaseError(
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
      document: _unarchivePurchaseMutation.document,
      variables: {
        'purchaseId': purchaseId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isUnArchived = result.data?['unarchivePurchase'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isUnArchived = false;
    }

    return isUnArchived;
  }

  Future<bool> archivePurchase({required String purchaseId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLPurchaseError(
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
      document: _archivePurchaseMutation.document,
      variables: {
        'purchaseId': purchaseId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isArchived = result.data?['archivePurchase'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isArchived = false;
    }

    return isArchived;
  }

  Future<bool> deletePurchase({required String purchaseId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLPurchaseError(
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
      document: _deletePurchaseMutation.document,
      variables: {
        'purchaseId': purchaseId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isDeleted = result.data?['deletePurchase'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isDeleted = false;
    }

    return isDeleted;
  }

  Future<PurchaseStatusResult> makePurchasePayment(
      {required String purchaseId,
      required String businessId,
      required String transactionDate,
      required String description,
      required num total,
      String? file}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      GraphQLPurchaseError(
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
      document: _makePurchasePaymentMutation.document,
      variables: {
        'input': {
          'purchaseId': purchaseId,
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
      GraphQLPurchaseError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    bool isPaid = result.data?['makePurchasePayment']['paid'] ?? false;
    num purchaseStatus = result.data?['makePurchasePayment']['purchaseStatus'];

    return PurchaseStatusResult(
        isCompleted: isPaid, purchaseStatus: purchaseStatus);
  }

  Future<PurchaseStatusResult> uploadMerchantInvoiceToPurchase({
    required String purchaseId,
    required String businessId,
    required String invoiceDate,
    required bool match,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      GraphQLPurchaseError(
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
      document: _uploadMerchantInvoiceToPurchaseMutation.document,
      variables: {
        'input': {
          'purchaseId': purchaseId,
          'businessId': businessId,
          'invoiceDate': invoiceDate,
          'match': match,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      GraphQLPurchaseError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    bool isuploaded =
        result.data?['uploadMerchantInvoiceToPurchase']['uploaded'] ?? false;
    num purchaseStatus =
        result.data?['uploadMerchantInvoiceToPurchase']['purchaseStatus'];

    return PurchaseStatusResult(
        isCompleted: isuploaded, purchaseStatus: purchaseStatus);
  }

  Future<PurchaseStatusResult> markPurchaseItemAsReceived(
      {required String purchaseItemId,
      required String businessId,
      required String transactionDate,
      required int quantityRecieved}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLPurchaseError(
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
      document: _markPurchaseItemAsReceivedMutation.document,
      variables: {
        'input': {
          'purchaseItemId': purchaseItemId,
          'businessId': businessId,
          'quantity': quantityRecieved,
          'transactionDate': transactionDate,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      GraphQLPurchaseError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    bool isCompleted =
        result.data?['markPurchaseItemAsReceived']['completed'] ?? false;

    num purchaseStatus =
        result.data?['markPurchaseItemAsReceived']['purchaseStatus'];

    return PurchaseStatusResult(
        isCompleted: isCompleted, purchaseStatus: purchaseStatus);
  }

  Future<bool> sendPurchase({
    required String purchaseId,
    bool? copy,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    // final businessId = prefs.getString('businessId');

    if (token == null) {
      GraphQLPurchaseError(
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
      document: _sendPurchaseMutation.document,
      variables: {
        'purchaseId': purchaseId,
        'copy': copy,
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      GraphQLPurchaseError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    bool isSent = result.data?['sendPurchase'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isSent = false;
    }

    return isSent;
  }

  Future<PurchaseUpdateResult> updatePurchases({
    required String purchaseId,
    String? description,
    String? merchantId,
    String? transactionDate,
    List<PurchaseItemDetail>? purchaseItem,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return PurchaseUpdateResult.error(
        error: GraphQLPurchaseError(
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
      document: _updatePurchaseEntryMutation.document,
      variables: {
        'purchaseId': purchaseId,
        'input': {
          'description': description,
          'transactionDate': transactionDate,
          'merchantId': merchantId,
          'purchaseItem': purchaseItem
              ?.map((purchaseItemDetail) => {
                    'productId': purchaseItemDetail.productId,
                    'itemDescription': purchaseItemDetail.itemDescription,
                    'unitPrice': purchaseItemDetail.unitPrice * 100,
                    'quantity': purchaseItemDetail.quantity,
                    'index': purchaseItemDetail.index,
                  })
              .toList(),
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return PurchaseUpdateResult.error(
        error: GraphQLPurchaseError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['updatePurchaseEntry'] == null) {
      return PurchaseUpdateResult.error(
        error: GraphQLPurchaseError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultpurchaseId = result.data?['updatePurchaseEntry']['id'];
    var resultDescription = result.data?['updatePurchaseEntry']['description'];

    var purchase = PurchaseUpdateSuccessResult(
      result_id: resultpurchaseId,
      result_description: resultDescription,
    );

    return PurchaseUpdateResult(purchase: purchase);
  }

  Future<List<Purchases>> getPurchaseByBusiness(
      {required String businessId, num? take}) async {
    final prefs = await SharedPreferences.getInstance();
    final timeZone = prefs.getString('timeZone') ?? 'UTC';
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLPurchaseError(
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
      document: _getPurchaseByBusinessQuery.document,
      variables: {'businessId': businessId, 'take': take},
    );

    final QueryResult purchaseByBusinessResult = await newClient.query(options);

    // if (purchaseByBusinessResult.hasException) {
    //   throw GraphQLPurchaseError(
    //     message: purchaseByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List purchaseData = purchaseByBusinessResult
            .data?['getPurchaseByBusinessMobile']['purchaseByBusiness'] ??
        [];

    final List<Purchases> purchases = purchaseData.map((data) {
      final merchantData = data['merchant']; // Access merchant data

      final location = tz.getLocation(timeZone);
      // Parse the UTC date string to DateTime
      final utcDate = DateTime.parse(data['transactionDate']).toUtc();
      // Convert UTC date to local time zone
      final localDate = tz.TZDateTime.from(utcDate, location);
      // Format localDate as a string (adjust the format as needed)
      // final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(localDate);
      final formattedDate = DateFormat('yyyy-MM-dd').format(localDate);
      return Purchases(
          id: data['id'],
          description: data['description'],
          transactionDate: formattedDate,
          reference: data['reference'],
          merchantId: '',
          merchantName: merchantData['name'],
          merchantEmail: '',
          purchaseItems: [],
          total: data['total'] / 100,
          purchaseStatusId: 0,
          paid: data['paid'] ?? false);
    }).toList();

    return purchases;
  }

  Future<List<Purchases>> getArchivedPurchaseByBusiness(
      {required String businessId, num? take}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final timeZone = prefs.getString('timeZone') ?? 'UTC';

    if (token == null) {
      throw GraphQLPurchaseError(
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
      document: _getArchivedPurchaseByBusinessQuery.document,
      variables: {'businessId': businessId, 'take': take},
    );

    final QueryResult purchaseByBusinessResult = await newClient.query(options);

    // if (purchaseByBusinessResult.hasException) {
    //   throw GraphQLPurchaseError(
    //     message: purchaseByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List purchaseData =
        purchaseByBusinessResult.data?['getArchivedPurchaseByBusinessMobile']
                ['purchaseByBusiness'] ??
            [];

    final List<Purchases> purchases = purchaseData.map((data) {
      final merchantData = data['merchant']; // Access merchant data

      final location = tz.getLocation(timeZone);
      // Parse the UTC date string to DateTime
      final utcDate = DateTime.parse(data['transactionDate']).toUtc();
      // Convert UTC date to local time zone
      final localDate = tz.TZDateTime.from(utcDate, location);
      // Format localDate as a string (adjust the format as needed)
      // final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(localDate);
      final formattedDate = DateFormat('yyyy-MM-dd').format(localDate);
      return Purchases(
          id: data['id'],
          description: data['description'],
          transactionDate: formattedDate,
          reference: data['reference'],
          merchantId: '',
          merchantName: merchantData['name'],
          merchantEmail: '',
          purchaseItems: [],
          total: data['total'] / 100,
          purchaseStatusId: 0,
          paid: data['paid'] ?? false);
    }).toList();

    return purchases;
  }
}

class PurchaseStatusResult {
  final bool isCompleted;
  final num purchaseStatus;

  PurchaseStatusResult(
      {required this.isCompleted, required this.purchaseStatus});
}

class Purchases {
  final String id;
  String transactionDate;
  final String description;
  final String reference;
  final String merchantId;
  final String merchantName;
  final String merchantEmail;
  bool paid;
  final num total;
  final List<PurchaseItemDetail> purchaseItems;
  num purchaseStatusId;

  Purchases(
      {required this.id,
      required this.description,
      required this.transactionDate,
      required this.reference,
      required this.merchantId,
      required this.merchantName,
      required this.merchantEmail,
      required this.paid,
      required this.total,
      required this.purchaseItems,
      required this.purchaseStatusId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionDate': transactionDate,
      'description': description,
      'reference': reference,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'merchantEmail': merchantEmail,
      'paid': paid == true ? 1 : 0,
      'total': total,
      'purchaseItems':
          jsonEncode(purchaseItems.map((item) => item.toMap()).toList()),
      'purchaseStatusId': purchaseStatusId,
    };
  }
}

class PurchaseUpdateResult {
  late final PurchaseUpdateSuccessResult? purchase;
  late final GraphQLPurchaseError? error;

  PurchaseUpdateResult({this.purchase}) : error = null;
  PurchaseUpdateResult.error({this.error}) : purchase = null;

  bool get hasError => error != null;
}

class PurchaseUpdateSuccessResult {
  PurchaseUpdateSuccessResult({
    required this.result_id,
    required this.result_description,
  });

  late final String result_id;
  late final String result_description;
}

class PurchaseCreationResult {
  late final PurchaseCreationSuccessResult? purchase;
  late final GraphQLPurchaseError? error;

  PurchaseCreationResult({this.purchase}) : error = null;
  PurchaseCreationResult.error({this.error}) : purchase = null;

  bool get hasError => error != null;
}

class PurchaseCreationSuccessResult {
  PurchaseCreationSuccessResult({
    required this.result_id,
    // required this.result_transactionDate,
    // required this.result_description,
  });

  late final String result_id;
  // late final String result_transactionDate;
  // late final String result_description;
}

class GraphQLPurchaseError {
  final String? message;

  GraphQLPurchaseError({required this.message});
}

class PurchaseItemDetail {
  String id;
  final String productId;
  final String itemDescription;
  num index;
  num unitPrice;
  int quantity;
  int? quantityRecieved;

  PurchaseItemDetail(
      {required this.id,
      required this.productId,
      required this.itemDescription,
      required this.index,
      required this.unitPrice,
      required this.quantity,
      this.quantityRecieved});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'itemDescription': itemDescription,
      'index': index,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'quantityRecieved': quantityRecieved,
    };
  }

  static PurchaseItemDetail fromMap(Map<String, dynamic> map) {
    return PurchaseItemDetail(
      id: map['id'],
      productId: map['productId'],
      itemDescription: map['itemDescription'],
      index: map['index'],
      unitPrice: map['unitPrice'],
      quantity: map['quantity'],
      quantityRecieved: map['quantityRecieved'],
    );
  }
}
