import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class SalesService {
  ValueNotifier<GraphQLClient> client;

//Sale
  final MutationOptions _createSaleEntryMutation;
  final MutationOptions _updateSaleEntryMutation;
  final QueryOptions _getSaleByIdQuery;
  final MutationOptions _archiveSaleMutation;
  final MutationOptions _unarchiveSaleMutation;
  final MutationOptions _deleteSaleMutation;
  final MutationOptions _effectSaleExpenseMutation;
  final MutationOptions _markSaleAsDeliveredMutation;
  final MutationOptions _makeSalePaymentMutation;
  final QueryOptions _getSaleByBusinessMobileQuery;
  final QueryOptions _getArchivedSalesByBusinessMobileQuery;

  //Invoice

  final MutationOptions _sendInvoiceBMutation;

//Customers
  final MutationOptions _createCustomerMutation;
  final QueryOptions _getCustomerByIdQuery;
  final MutationOptions _updateCustomerMutation;
  final MutationOptions _archiveCustomerMutation;
  final MutationOptions _unarchiveCustomerMutation;
  final MutationOptions _deleteCustomerMutation;
  final QueryOptions _getCustomerByBusinessMobileQuery;
  final QueryOptions _getArchivedCustomerByBusinessMobileQuery;

  SalesService()
      : client = ValueNotifier(GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://api.verzo.app/graphql'),
        )),
        _createSaleEntryMutation = MutationOptions(
          document: gql('''
        mutation CreateSaleEntry(\$input: CreateSaleEntry!) {
          createSaleEntry(input: \$input) {
            id
          }
        }
      '''),
        ),
        _updateSaleEntryMutation = MutationOptions(
          document: gql('''
            mutation UpdateSaleEntry(\$saleId: String!, \$input: UpdateSaleEntry) {
              updateSaleEntry(saleId: \$saleId, input: \$input) {
                id   
              }
            }
          '''),
        ),
        _getSaleByIdQuery = QueryOptions(
          document: gql('''
        query GetSaleById(\$saleId: String!){
          getSaleById(saleId: \$saleId){
            id
            dueDate
            transactionDate
            description
            note
            paid
            reference
            saleAmount
            saleStatusId
            currency{
              id
              currency
              symbol
            }
            saleExpenses{
              id
              index
              amount
              baseAmount
              description
              effected
              }
            saleServiceExpenses{
              id 
              serviceId
              amount
              baseAmount
              description
              index
              effected
              service{
                id
                name
              }
              }
            invoice{
              id
              subtotal
              overdue
              VAT
              customer{
                email
                name
                id
                }
              invoiceDetails{
                id
                index
                type
                productInvoiceDetail{
                  quantity
                  unitPrice
                  baseUnitPrice
                  product{
                    productName
                    id
                    }
                   }
                serviceInvoiceDetail{
                  quantity
                  unitPrice
                  baseUnitPrice
                  service{
                    name
                    id
                      }
                       }
            }
            }
            }
          }
        '''),
        ),
        _getSaleByBusinessMobileQuery = QueryOptions(
          document: gql('''
        query GetSalesByBusinessMobile(\$input: GetSalesByBusinessMobileInput!) {
          getSalesByBusinessMobile (input: \$input) {
            salesByBusiness{
            id
            description
            reference
            saleAmount
            currency{
              id
              currency
              symbol
            }
            paid
            transactionDate
            customer{
              name
            }
            invoice{
              overdue
            }
            }
            cursorId
            }
          }
        '''),
        ),
        _getArchivedSalesByBusinessMobileQuery = QueryOptions(
          document: gql('''
        query GetArchivedSalesByBusinessMobile(\$input: GetSalesByBusinessMobileInput!) {
          getArchivedSalesByBusinessMobile (input: \$input) {
            salesByBusiness{
            id
            description
            reference
            saleAmount
            paid
            transactionDate
            currency{
              id
              currency
              symbol
            }
            customer{
              name
            }
            }
            cursorId
            }
          }
        '''),
        ),
        _unarchiveSaleMutation = MutationOptions(
          document: gql('''
        mutation UnArchiveSale(\$saleId: String!) {
          unarchiveSale(saleId: \$saleId)
        }
      '''),
        ),
        _archiveSaleMutation = MutationOptions(
          document: gql('''
        mutation ArchiveSale(\$saleId: String!) {
          archiveSale(saleId: \$saleId)
        }
      '''),
        ),
        _deleteSaleMutation = MutationOptions(
          document: gql('''
        mutation DeleteSale(\$saleId: String!) {
          deleteSale(saleId: \$saleId)
        }
      '''),
        ),
        _effectSaleExpenseMutation = MutationOptions(
          document: gql('''
            mutation EffectSaleExpense(\$input: EffectSaleExpense!){
              effectSaleExpense(input: \$input){
                effected
                saleStatus
              }
              }
          '''),
        ),
        _markSaleAsDeliveredMutation = MutationOptions(
          document: gql('''
        mutation MarkSaleAsDelivered(\$saleId: String!) {
          markSaleAsDelivered(saleId: \$saleId){
            delivered
            saleStatus
          }
        }
      '''),
        ),
        _makeSalePaymentMutation = MutationOptions(
          document: gql('''
        mutation MakeSalePayment(\$input: MakeSalePayment!) {
          makeSalePayment(input: \$input){
            paid
            saleStatus
          }
        }
      '''),
        ),
        _sendInvoiceBMutation = MutationOptions(
          document: gql('''
          mutation SendInvoiceB(\$invoiceId: String!,\$copy: Boolean) {
            sendInvoiceB(invoiceId: \$invoiceId,  copy: \$copy)
          }
        '''),
        ),
        _createCustomerMutation = MutationOptions(
          document: gql('''
        mutation CreateCustomer(\$input: CreateCustomer!) {
          createCustomer(input:\$input) {
            id
            name
            mobile
            email
            address
            businessId
          }
         }
        '''),
        ),
        _getCustomerByIdQuery = QueryOptions(
          document: gql('''
        query GetCustomerById(\$customerId: String!){
          getCustomerById(customerId: \$customerId){
            id
            name
            email
            mobile
            address
            }
          }
        '''),
        ),
        _getCustomerByBusinessMobileQuery = QueryOptions(
          document: gql('''
        query GetCustomerByBusinessMobile(\$businessId: String!, \$cursor: String, \$take: Int) {
          getCustomerByBusinessMobile(businessId: \$businessId, cursor: \$cursor, take: \$take) {
            customerByBusiness{
            id
            name
            email
            mobile
            address
            businessId
            }
            }
          }
        '''),
        ),
        _getArchivedCustomerByBusinessMobileQuery = QueryOptions(
          document: gql('''
        query GetArchivedCustomerByBusinessMobile(\$businessId: String!, \$cursor: String, \$take: Int) {
          getArchivedCustomerByBusinessMobile(businessId: \$businessId, cursor: \$cursor, take: \$take) {
            customerByBusiness{
            id
            name
            email
            mobile
            address
            businessId
            }
            }
          }
        '''),
        ),
        _updateCustomerMutation = MutationOptions(
          document: gql('''
            mutation UpdateCustomer(\$customerId: String!, \$input: UpdateCustomer) {
              updateCustomer(customerId: \$customerId, input: \$input) {
                id
                name
              }
            }
          '''),
        ),
        _archiveCustomerMutation = MutationOptions(
          document: gql('''
        mutation ArchiveCustomerByBusiness(\$customerId: String!) {
          archiveCustomerByBusiness(customerId: \$customerId)
        }
      '''),
        ),
        _unarchiveCustomerMutation = MutationOptions(
          document: gql('''
        mutation UnArchiveCustomerByBusiness(\$customerId: String!) {
          unarchiveCustomerByBusiness(customerId: \$customerId)
        }
      '''),
        ),
        _deleteCustomerMutation = MutationOptions(
          document: gql('''
        mutation DeleteCustomer(\$customerId: String!) {
          deleteCustomer(customerId: \$customerId)
        }
      '''),
        );

//Invoice

  Future<SaleCreationResult> createSales(
      {required String customerId,
      required String businessId,
      required String currencyId,
      required List<ItemDetail> item,
      List<SaleExpenses>? saleExpense,
      List<SaleServiceExpenseEntry>? saleServiceExpense,
      required double vat,
      // double? discount,
      required String dueDate,
      required String dateOfIssue,
      required String description,
      String? note}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return SaleCreationResult.error(
        error: GraphQLSaleError(
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
      document: _createSaleEntryMutation.document,
      variables: {
        'input': {
          'invoiceInput': {
            'businessId': businessId,
            'customerId': customerId,
            'dateOfIssue': dateOfIssue,
            'dueDate': dueDate,
            'currencyId': currencyId,
            // 'discount': discount,
            'VAT': vat,
            'item': item
                .map((itemDetail) => {
                      'id': itemDetail.id,
                      'type': itemDetail.type,
                      'price': itemDetail.price * 100,
                      'basePrice': itemDetail.basePrice * 100,
                      'quantity': itemDetail.quantity,
                      'index': itemDetail.index,
                    })
                .toList(),
          },
          'description': description,
          'note': note,
          'saleExpense': saleExpense
              ?.map((saleExpenseItem) => {
                    'description': saleExpenseItem.description,
                    'amount': saleExpenseItem.amount * 100,
                    'baseAmount': saleExpenseItem.baseAmount * 100,
                    'index': saleExpenseItem.index
                  })
              .toList(), // Populate this list if applicable
          'saleServiceExpense': saleServiceExpense
              ?.map((saleServiceExpenseEntry) => {
                    'serviceId': saleServiceExpenseEntry.serviceId,
                    'amount': saleServiceExpenseEntry.amount * 100,
                    'baseAmount': saleServiceExpenseEntry.baseAmount * 100,
                    'index': saleServiceExpenseEntry.index,
                    'description': saleServiceExpenseEntry.description,
                  })
              .toList(), // Populate this list if applicable
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return SaleCreationResult.error(
        error: GraphQLSaleError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['createSaleEntry'] == null) {
      return SaleCreationResult.error(
        error: GraphQLSaleError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultId = result.data?['createSaleEntry']['id'];
    // var result_customerId =
    //     result.data?['createCompleteInvoiceB']['customerId'];

    var sale = SaleCreationSuccessResult(
      result_id: resultId,
    );

    return SaleCreationResult(sale: sale);
  }

  Future<SaleUpdateResult> updateSales({
    required String saleId,
    String? description,
    String? customerId,
    String? currencyId,
    String? dueDate,
    String? dateOfIssue,
    String? note,
    // double? discount,
    double? vat,
    List<SaleExpenses>? saleExpense,
    List<SaleServiceExpenseEntry>? saleServiceExpense,
    List<ItemDetail>? item,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return SaleUpdateResult.error(
        error: GraphQLSaleError(
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
      document: _updateSaleEntryMutation.document,
      variables: {
        'saleId': saleId,
        'input': {
          'description': description,
          'note': note,
          'updateInvoiceInput': {
            'dateOfIssue': dateOfIssue,
            'customerId': customerId,
            'currencyId': currencyId,
            'dueDate': dueDate,
            // 'discount': discount,
            'VAT': vat,
            'item': item
                ?.map((itemDetail) => {
                      'id': itemDetail.id,
                      'type': itemDetail.type,
                      'price': itemDetail.price * 100,
                      'basePrice': itemDetail.basePrice * 100,
                      'quantity': itemDetail.quantity,
                      'index': itemDetail.index,
                    })
                .toList(),
          },
          'saleExpense': saleExpense
              ?.map((saleExpenseItem) => {
                    'description': saleExpenseItem.description,
                    'amount': saleExpenseItem.amount * 100,
                    'baseAmount': saleExpenseItem.baseAmount * 100,
                    'index': saleExpenseItem.index
                  })
              .toList(),
          'saleServiceExpense': saleServiceExpense
              ?.map((saleServiceExpenseEntry) => {
                    'serviceId': saleServiceExpenseEntry.serviceId,
                    'amount': saleServiceExpenseEntry.amount * 100,
                    'baseAmount': saleServiceExpenseEntry.baseAmount * 100,
                    'index': saleServiceExpenseEntry.index,
                    'description': saleServiceExpenseEntry.description
                  })
              .toList(),
        }
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return SaleUpdateResult.error(
        error: GraphQLSaleError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['updateSaleEntry'] == null) {
      return SaleUpdateResult.error(
        error: GraphQLSaleError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultpurchaseId = result.data?['updateSaleEntry']['id'];

    var sale = SaleUpdateSuccessResult(
      result_id: resultpurchaseId,
    );

    return SaleUpdateResult(sale: sale);
  }

  Future<Sales> getSaleById({required String saleId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final timeZone = prefs.getString('timeZone') ?? 'UTC';

    if (token == null) {
      throw GraphQLSaleError(
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
      document: _getSaleByIdQuery.document,
      variables: {
        'saleId': saleId,
      },
    );

    final QueryResult saleByIdResult = await newClient.query(options);

    if (saleByIdResult.hasException) {
      throw GraphQLSaleError(
        message:
            saleByIdResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final saleByIdData = saleByIdResult.data?['getSaleById'];

    final location = tz.getLocation(timeZone);
    // Parse the UTC date string to DateTime
    final utcDate = DateTime.parse(saleByIdData['transactionDate']).toUtc();
    // Convert UTC date to local time zone
    final localDate = tz.TZDateTime.from(utcDate, location);
    // Format localDate as a string (adjust the format as needed)
    // final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(localDate);
    final formattedDate = DateFormat('yyyy-MM-dd').format(localDate);

    final List<dynamic> saleServiceExpenseData =
        saleByIdData['saleServiceExpenses'];
    final List<dynamic> saleExpenseData = saleByIdData['saleExpenses'];

    final List<SaleServiceExpenseEntry> saleServiceExpenses =
        saleServiceExpenseData.map((expenseData) {
      return SaleServiceExpenseEntry(
          serviceName: expenseData['service']['name'],
          serviceId: expenseData['service']['id'],
          id: expenseData['id'],
          amount: expenseData['amount'] / 100,
          baseAmount: expenseData['baseAmount'] / 100,
          description: expenseData['description'],
          index: expenseData['index'],
          effected: expenseData['effected']);
    }).toList();

    final List<SaleExpenses> saleExpenses = saleExpenseData.map((expenseData) {
      return SaleExpenses(
          id: expenseData['id'],
          amount: expenseData['amount'] / 100,
          baseAmount: expenseData['baseAmount'] / 100,
          description: expenseData['description'],
          index: expenseData['index'],
          effected: expenseData['effected']);
    }).toList();

    final List<dynamic> invoiceDetailsData =
        saleByIdData['invoice']['invoiceDetails'] ?? [];
    final String invoiceId = saleByIdData['invoice']['id'];

    final List<ItemDetail> invoiceDetails =
        invoiceDetailsData.map((invoiceData) {
      final Map<String, dynamic> detailData =
          invoiceData['productInvoiceDetail'] ??
              invoiceData['serviceInvoiceDetail'] ??
              invoiceData[null];

      return ItemDetail(
        id: detailData['product']?['id'] ?? detailData['service']?['id'],
        index: invoiceData['index'],
        price: detailData['unitPrice'] / 100,
        basePrice: detailData['baseUnitPrice'] / 100,
        quantity: detailData['quantity'],
        name: detailData['product']?['productName'] ??
            detailData['service']?['name'],
        type: invoiceData['type'],
      );
    }).toList();

    // Access customer name and ID from the invoice object
    final Map<String, dynamic> invoiceData = saleByIdData['invoice'];
    final Map<String, dynamic> customerData = invoiceData['customer'];
    final Map<String, dynamic> currencyData = saleByIdData['currency'];

    final Sales saleById = Sales(
      id: saleByIdData['id'],
      invoiceId: invoiceId,
      description: saleByIdData['description'],
      note: saleByIdData['note'],
      paid: saleByIdData['paid'] ?? false,
      // overdue: invoiceData['overdue'],
      invoiceDetails: invoiceDetails,
      saleServiceExpenses: saleServiceExpenses,
      saleExpenses: saleExpenses,
      dueDate: saleByIdData['dueDate'],
      transactionDate: formattedDate,
      reference: saleByIdData['reference'],
      customerId: customerData['id'],
      customerName: customerData['name'],
      customerEmail: customerData['email'],
      currencySymbol: currencyData['symbol'],
      currencyName: currencyData['currency'],
      currencyId: currencyData['id'],
      totalAmount: saleByIdData['saleAmount'] / 100,
      VAT: invoiceData['VAT'],
      subtotal: invoiceData['subtotal'] / 100,
      // discount: invoiceData['discount'],
      saleStatusId: saleByIdData['saleStatusId'],
    );

    return saleById;
  }

  Future<List<Sales>> getSaleByBusiness(
      {required String businessId,
      num? take,
      String? cursor,
      String? currencyId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final timeZone = prefs.getString('timeZone') ?? 'UTC';

    if (token == null) {
      throw GraphQLSaleError(
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
      document: _getSaleByBusinessMobileQuery.document,
      variables: {
        'input': {
          'businessId': businessId,
          'cursor': cursor,
          'take': take,
          'currencyId': currencyId,
        },
      },
    );

    final QueryResult saleByBusinessResult = await newClient.query(options);

    // if (saleByBusinessResult.hasException) {
    //   throw GraphQLSaleError(
    //     message: saleByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List salesData = saleByBusinessResult
            .data?['getSalesByBusinessMobile']['salesByBusiness'] ??
        [];

    // final String cursorId =
    //     saleByBusinessResult.data?['getSaleByBusinessMobile']['cursorId'] ?? '';

    final List<Sales> sales = salesData.map((data) {
      final customerData = data['customer']; // Access customer data
      final currencyData = data['currency']; // Access currency data
      final invoiceData = data['invoice']; // Access invoice data
      final location = tz.getLocation(timeZone);
      // Parse the UTC date string to DateTime
      final utcDate = DateTime.parse(data['transactionDate']).toUtc();
      // Convert UTC date to local time zone
      final localDate = tz.TZDateTime.from(utcDate, location);

      // Format localDate as a string (adjust the format as needed)
      // final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(localDate);
      final formattedDate = DateFormat('yyyy-MM-dd').format(localDate);
      return Sales(
          id: data['id'],
          invoiceId: '',
          description: data['description'],
          invoiceDetails: [],
          saleServiceExpenses: [],
          saleExpenses: [],
          dueDate: '',
          transactionDate: formattedDate,
          reference: data['reference'],
          customerId: '',
          customerName: customerData['name'],
          currencySymbol: currencyData['symbol'],
          currencyName: currencyData['currency'],
          totalAmount: data['saleAmount'] / 100,
          VAT: 0,
          subtotal: 0,
          discount: 0,
          saleStatusId: 0,
          paid: data['paid'] ?? false,
          overdue: invoiceData['overdue'] ?? false);
    }).toList();

    return sales;
  }

  Future<List<Sales>> getArchivedSaleByBusiness(
      {required String businessId,
      num? take,
      String? cursor,
      String? currencyId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final timeZone = prefs.getString('timeZone') ?? 'UTC';

    if (token == null) {
      throw GraphQLSaleError(
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
      document: _getArchivedSalesByBusinessMobileQuery.document,
      variables: {
        'input': {
          'businessId': businessId,
          'cursor': cursor,
          'take': take,
          'currencyId': currencyId,
        },
      },
    );

    final QueryResult saleByBusinessResult = await newClient.query(options);

    // if (saleByBusinessResult.hasException) {
    //   throw GraphQLSaleError(
    //     message: saleByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List salesData = saleByBusinessResult
            .data?['getArchivedSalesByBusinessMobile']['salesByBusiness'] ??
        [];

    // final String cursorId =
    //     saleByBusinessResult.data?['getSaleByBusinessMobile']['cursorId'] ?? '';

    final List<Sales> sales = salesData.map((data) {
      final customerData = data['customer']; // Access merchant data
      final currencyData = data['currency'];
      final location = tz.getLocation(timeZone);
      // Parse the UTC date string to DateTime
      final utcDate = DateTime.parse(data['transactionDate']).toUtc();
      // Convert UTC date to local time zone
      final localDate = tz.TZDateTime.from(utcDate, location);

      // Format localDate as a string (adjust the format as needed)
      // final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(localDate);
      final formattedDate = DateFormat('yyyy-MM-dd').format(localDate);
      return Sales(
          id: data['id'],
          invoiceId: '',
          description: data['description'],
          paid: data['paid'] ?? false,
          invoiceDetails: [],
          saleServiceExpenses: [],
          saleExpenses: [],
          dueDate: '',
          transactionDate: formattedDate,
          reference: data['reference'],
          customerId: '',
          customerName: customerData['name'],
          currencySymbol: currencyData['symbol'],
          currencyName: '',
          totalAmount: data['saleAmount'] / 100,
          VAT: 0,
          subtotal: 0,
          discount: 0,
          saleStatusId: 0);
    }).toList();

    return sales;
  }

  Future<bool> unarchiveSale({required String saleId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLSaleError(
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
      document: _unarchiveSaleMutation.document,
      variables: {
        'saleId': saleId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isUnArchived = result.data?['unarchiveSale'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isUnArchived = false;
    }

    return isUnArchived;
  }

  Future<bool> archiveSale({required String saleId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLSaleError(
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
      document: _archiveSaleMutation.document,
      variables: {
        'saleId': saleId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isArchived = result.data?['archiveSale'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isArchived = false;
    }

    return isArchived;
  }

  Future<bool> deleteSale({required String saleId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLSaleError(
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
      document: _deleteSaleMutation.document,
      variables: {
        'saleId': saleId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isDeleted = result.data?['deleteSale'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isDeleted = false;
    }

    return isDeleted;
  }

  Future<SaleStatusResult> effectSaleExpense(
      {required String expenseId,
      required String transactionDate,
      required String description,
      String? file}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLSaleError(
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
      document: _effectSaleExpenseMutation.document,
      variables: {
        'input': {
          'expenseId': expenseId,
          'description': description,
          'transactionDate': transactionDate,
          'file': file
        }
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      // Handle any errors that may have occurred during the mutation
      GraphQLSaleError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    bool isEffected = result.data?['effectSaleExpense']['effected'] ?? false;
    num saleStatus = result.data?['effectSaleExpense']['saleStatus'];

    return SaleStatusResult(
      isCompleted: isEffected,
      saleStatus: saleStatus,
    );
  }

  Future<SaleStatusResult> makeSalePayment(
      {required String saleId,
      required String transactionDate,
      required String description,
      String? file}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLSaleError(
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
      document: _makeSalePaymentMutation.document,
      variables: {
        'input': {
          'saleId': saleId,
          'transactionDate': transactionDate,
          'description': description,
          'file': file,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      GraphQLSaleError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    bool isPaid = result.data?['makeSalePayment']['paid'] ?? false;
    num saleStatus = result.data?['makeSalePayment']['saleStatus'];

    return SaleStatusResult(isCompleted: isPaid, saleStatus: saleStatus);
  }

  Future<SaleStatusResult> markSaleAsDelivered({required String saleId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLSaleError(
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
      document: _markSaleAsDeliveredMutation.document,
      variables: {
        'saleId': saleId,
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      GraphQLSaleError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }

    bool isDelivered =
        result.data?['markSaleAsDelivered']['delivered'] ?? false;

    num saleStatus = result.data?['markSaleAsDelivered']['saleStatus'];

    return SaleStatusResult(isCompleted: isDelivered, saleStatus: saleStatus);
  }

  // Invoice
  Future<bool> sendInvoice({
    required String invoiceId,
    bool? copy,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    // final businessId = prefs.getString('businessId');

    if (token == null) {
      GraphQLSaleError(
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
      document: _sendInvoiceBMutation.document,
      variables: {
        'invoiceId': invoiceId,
        'copy': copy,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    if (result.hasException) {
      GraphQLSaleError(
        message: result.exception?.graphqlErrors.first.message.toString(),
      );
    }
    bool isSent = result.data?['sendInvoiceB'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isSent = false;
    }

    return isSent;
  }

//CreateCustomer
  Future<CustomerCreationResult> createCustomer(
      {required String name,
      required String mobile,
      required String email,
      String? address,
      required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return CustomerCreationResult.error(
        error: GraphQLSaleError(
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
      document: _createCustomerMutation.document,
      variables: {
        'input': {
          'name': name,
          'mobile': mobile,
          'email': email,
          'address': address,
          'businessId': businessId,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    var customerId = result.data?['createCustomer']['id'];
    var customerName = result.data?['createCustomer']['name'];
    var customerAddress = result.data?['createCustomer']['address'];
    var customerMobile = result.data?['createCustomer']['mobile'];
    var customerEmail = result.data?['createCustomer']['email'];
    var customerBusinessId = result.data?['createCustomer']['businessId'];

    if (result.hasException) {
      return CustomerCreationResult.error(
        error: GraphQLSaleError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['createCustomer'] == null) {
      return CustomerCreationResult.error(
        error: GraphQLSaleError(
          message: "Error parsing response data",
        ),
      );
    }

    var customer = CustomerCreationSuccessResult(
        id: customerId,
        name: customerName,
        address: customerAddress,
        mobile: customerMobile,
        email: customerEmail,
        businessId: customerBusinessId);

    return CustomerCreationResult(customer: customer);
  }

  Future<Customers> getCustomerById({required String customerId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLSaleError(
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
      document: _getCustomerByIdQuery.document,
      variables: {'customerId': customerId},
    );

    final QueryResult customerByIdResult = await newClient.query(options);

    if (customerByIdResult.hasException) {
      throw GraphQLSaleError(
        message: customerByIdResult.exception?.graphqlErrors.first.message
            .toString(),
      );
    }

    final customerByIdData = customerByIdResult.data?['getCustomerById'] ?? [];

    final Customers customerById = Customers(
        id: customerByIdData['id'],
        email: customerByIdData['email'],
        name: customerByIdData['name'],
        mobile: customerByIdData['mobile'],
        address: customerByIdData['address']);

    return customerById;
  }

  Future<CustomerUpdateResult> updateCustomers({
    required String customerId,
    String? name,
    String? address,
    String? mobile,
    String? email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return CustomerUpdateResult.error(
        error: GraphQLSaleError(
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
      document: _updateCustomerMutation.document,
      variables: {
        'customerId': customerId,
        'input': {
          'name': name,
          'email': email,
          'mobile': mobile,
          'address': address,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return CustomerUpdateResult.error(
        error: GraphQLSaleError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['updateCustomer'] == null) {
      return CustomerUpdateResult.error(
        error: GraphQLSaleError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultexpenseId = result.data?['updateCustomer']['id'];
    var resultName = result.data?['updateCustomer']['name'];

    var customer = CustomerUpdateSuccessResult(
        result_id: resultexpenseId, result_name: resultName);

    return CustomerUpdateResult(customer: customer);
  }

  Future<bool> archiveCustomer({required String customerId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLSaleError(
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
      document: _archiveCustomerMutation.document,
      variables: {
        'customerId': customerId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isArchived = result.data?['archiveCustomerByBusiness'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isArchived = false;
    }

    return isArchived;
  }

  Future<bool> unArchiveCustomer({required String customerId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLSaleError(
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
      document: _unarchiveCustomerMutation.document,
      variables: {
        'customerId': customerId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isUnArchived = result.data?['unarchiveCustomerByBusiness'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isUnArchived = false;
    }

    return isUnArchived;
  }

  Future<bool> deleteCustomer({required String customerId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLSaleError(
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
      document: _deleteCustomerMutation.document,
      variables: {
        'customerId': customerId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isDeleted = result.data?['deleteCustomer'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isDeleted = false;
    }

    return isDeleted;
  }

  Future<List<Customers>> getCustomerByBusiness(
      {required String businessId, num? take, String? cursor}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLSaleError(
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
      document: _getCustomerByBusinessMobileQuery.document,
      variables: {'businessId': businessId, 'take': take, 'cursor': cursor},
    );

    final QueryResult customerByBusinessResult = await newClient.query(options);

    // if (customerByBusinessResult.hasException) {
    //   throw GraphQLSaleError(
    //     message: customerByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List customersData = customerByBusinessResult
            .data?['getCustomerByBusinessMobile']['customerByBusiness'] ??
        [];

    // final String cursorId = customerByBusinessResult
    //         .data?['getCustomerByBusinessMobile']['cursorId'] ??
    //     '';

    final List<Customers> customers = customersData.map((data) {
      return Customers(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          mobile: data['mobile'],
          address: data['address']
          // invoiceCreatedAt: data['invoices']['createdAt'] ?? '',
          // invoiceTotalAmount: data['invoices']['totalAmount']);
          );
    }).toList();

    return customers;
  }

  Future<List<Customers>> getArchivedCustomerByBusiness(
      {required String businessId, num? take, String? cursor}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLSaleError(
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
      document: _getArchivedCustomerByBusinessMobileQuery.document,
      variables: {'businessId': businessId, 'take': take, 'cursor': cursor},
    );

    final QueryResult customerByBusinessResult = await newClient.query(options);

    // if (customerByBusinessResult.hasException) {
    //   throw GraphQLSaleError(
    //     message: customerByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List customersData =
        customerByBusinessResult.data?['getArchivedCustomerByBusinessMobile']
                ['customerByBusiness'] ??
            [];

    // final String cursorId = customerByBusinessResult
    //         .data?['getCustomerByBusinessMobile']['cursorId'] ??
    //     '';

    final List<Customers> customers = customersData.map((data) {
      return Customers(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          mobile: data['mobile'],
          address: data['address']
          // invoiceCreatedAt: data['invoices']['createdAt'] ?? '',
          // invoiceTotalAmount: data['invoices']['totalAmount']);
          );
    }).toList();

    return customers;
  }
}

class SaleStatusResult {
  final bool isCompleted;
  final num saleStatus;

  SaleStatusResult({
    required this.isCompleted,
    required this.saleStatus,
  });
}

class CustomerUpdateResult {
  late final CustomerUpdateSuccessResult? customer;
  late final GraphQLSaleError? error;

  CustomerUpdateResult({this.customer}) : error = null;
  CustomerUpdateResult.error({this.error}) : customer = null;

  bool get hasError => error != null;
}

class CustomerUpdateSuccessResult {
  CustomerUpdateSuccessResult({
    required this.result_id,
    required this.result_name,
  });

  late final String result_id;
  late final String result_name;
}

class Customers {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String? address;
  num? invoiceTotalAmount;
  String? invoiceCreatedAt;

  Customers(
      {required this.id,
      required this.name,
      required this.email,
      required this.mobile,
      this.address,
      this.invoiceCreatedAt,
      this.invoiceTotalAmount});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'invoiceTotalAmount': invoiceTotalAmount,
      'invoiceCreatedAt': invoiceCreatedAt,
    };
  }
}

class CustomerCreationResult {
  late final CustomerCreationSuccessResult? customer;
  late final GraphQLSaleError? error;

  CustomerCreationResult({this.customer}) : error = null;
  CustomerCreationResult.error({this.error}) : customer = null;

  bool get hasError => error != null;
}

class CustomerCreationSuccessResult {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String address;
  final String businessId;

  CustomerCreationSuccessResult(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.email,
      required this.address,
      required this.businessId});
}

class SaleCreationResult {
  late final SaleCreationSuccessResult? sale;
  late final GraphQLSaleError? error;

  SaleCreationResult({this.sale}) : error = null;
  SaleCreationResult.error({this.error}) : sale = null;

  bool get hasError => error != null;
}

class SaleCreationSuccessResult {
  SaleCreationSuccessResult({
    required this.result_id,
  });

  late final String result_id;
}

class GraphQLSaleError {
  final String? message;

  GraphQLSaleError({required this.message});
}

class Sales {
  final String id;
  final String description;
  final String? note;
  String reference;
  bool paid;
  final String customerName;
  final String currencyName;
  final String currencySymbol;
  final String? customerEmail;
  final num subtotal;
  final num totalAmount;
  final num? discount;
  final num VAT;
  // final String createdAt;
  final String dueDate;
  final String transactionDate;
  final String customerId;
  final String? currencyId;
  bool? overdue;
  final List<ItemDetail> invoiceDetails;
  List<SaleServiceExpenseEntry>? saleServiceExpenses;
  List<SaleExpenses>? saleExpenses;
  String invoiceId;
  num saleStatusId;

  Sales(
      {required this.id,
      required this.description,
      this.note,
      required this.reference,
      required this.paid,
      this.currencyId,
      required this.currencyName,
      required this.currencySymbol,
      required this.customerName,
      this.customerEmail,
      required this.subtotal,
      required this.totalAmount,
      this.discount,
      required this.VAT,
      // required this.createdAt,
      required this.dueDate,
      required this.transactionDate,
      required this.customerId,
      this.overdue,
      required this.invoiceDetails,
      this.saleServiceExpenses,
      this.saleExpenses,
      required this.invoiceId,
      required this.saleStatusId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'reference': reference,
      'paid': paid == true ? 1 : 0,
      'customerName': customerName,
      'currencySymbol': currencySymbol,
      'subtotal': subtotal,
      'totalAmount': totalAmount,
      'discount': discount,
      'VAT': VAT,
      'dueDate': dueDate,
      'transactionDate': transactionDate,
      'customerId': customerId,
      'overdue': overdue == true ? 1 : 0, // Convert boolean to integer
      'invoiceDetails':
          jsonEncode(invoiceDetails.map((item) => item.toMap()).toList()),
      'saleServiceExpenses': saleServiceExpenses != null
          ? jsonEncode(
              saleServiceExpenses?.map((entry) => entry.toMap()).toList())
          : null,
      'saleExpenses': saleExpenses != null
          ? jsonEncode(saleExpenses?.map((expense) => expense.toMap()).toList())
          : null,
      'invoiceId': invoiceId,
      'saleStatusId': saleStatusId,
    };
  }
}

class SaleExpenses {
  final String id;
  num index;
  String description;
  num amount;
  num baseAmount;
  bool? effected;

  SaleExpenses(
      {required this.id,
      required this.index,
      required this.description,
      this.effected,
      required this.amount,
      required this.baseAmount});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'index': index,
      'description': description,
      'amount': amount,
      'baseAmount': baseAmount,
      'effected': effected
    };
  }

  static SaleExpenses fromMap(Map<String, dynamic> map) {
    return SaleExpenses(
        id: map['id'],
        index: map['index'],
        description: map['description'],
        amount: map['amount'],
        baseAmount: map['baseAmount'],
        effected: map['effected']);
  }
}

class ItemDetail {
  final String id;
  final String type;
  num index;
  String name;
  num price;
  num basePrice;
  num quantity;

  ItemDetail({
    required this.id,
    required this.type,
    required this.name,
    required this.index,
    required this.price,
    required this.basePrice,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'index': index,
      'price': price,
      'basePrice': basePrice,
      'quantity': quantity,
    };
  }

  static ItemDetail fromMap(Map<String, dynamic> map) {
    return ItemDetail(
      id: map['id'],
      type: map['type'],
      name: map['name'],
      index: map['index'],
      price: map['price'],
      basePrice: map['basePrice'],
      quantity: map['quantity'],
    );
  }
}

class SaleServiceExpenseEntry {
  final String id;
  final String? serviceId;
  String? serviceName;
  num index;
  num amount;
  num baseAmount;
  final String description;
  bool? effected;

  SaleServiceExpenseEntry(
      {required this.id,
      this.serviceId,
      this.serviceName,
      required this.index,
      required this.amount,
      required this.baseAmount,
      this.effected,
      required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': serviceId,
      'index': index,
      'amount': amount,
      'baseAmount': baseAmount,
      'effected': effected,
      'description': description
    };
  }

  static SaleServiceExpenseEntry fromMap(Map<String, dynamic> map) {
    return SaleServiceExpenseEntry(
      id: map['id'],
      serviceId: map['serviceId'],
      index: map['index'],
      amount: map['amount'],
      baseAmount: map['baseAmount'],
      effected: map['effected'],
      description: map['description'],
    );
  }
}

class SaleUpdateResult {
  late final SaleUpdateSuccessResult? sale;
  late final GraphQLSaleError? error;

  SaleUpdateResult({this.sale}) : error = null;
  SaleUpdateResult.error({this.error}) : sale = null;

  bool get hasError => error != null;
}

class SaleUpdateSuccessResult {
  SaleUpdateSuccessResult({
    required this.result_id,
  });

  late final String result_id;
}
