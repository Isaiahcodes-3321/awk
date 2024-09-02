import 'package:typesense/typesense.dart';

import 'package:verzo/services/expense_service.dart';
import 'package:verzo/services/products_services_service.dart';
import 'package:verzo/services/purchase_service.dart';
import 'package:verzo/services/sales_service.dart';

// const host = "157.230.122.176";
const host = "analytics.verzo.app";
const protocol = Protocol.https;
final config = Configuration(
  "VdetGahcpA1tjTCOa2HvtyYj1v5tECq8",
  // "kaDjGKmsPSSxFqqgW6Kc9LNmQIV7pDEfQsS68O8yuonfKc07",

  // Your API key
  nodes: {
    Node(
      protocol,
      host,
      port: 8108,
    ),
  },
  numRetries: 3,
  connectionTimeout: const Duration(seconds: 2),
);

final client = Client(config);

Future<List<Expenses>> searchExpenses(
    String search, String businessId, String userId) async {
  final searchRequests = {
    'q': search,
    'query_by': 'reference, description',
    // 'prioritize_token_position': true,
    // 'prioritize_exact_match': true,
    'filter_by': 'businessId:$businessId'
  };

  final searchResponse =
      await client.collection('expense').documents.search(searchRequests);
  // Extract and return the search results from the response
  final searchResults = searchResponse['hits'] as List<dynamic>;

  final List<Expenses> expensesList = searchResults.map((result) {
    final document = result['document'];

    return Expenses(
      id: document['id'],
      description: document['description'],
      amount: document['amount'],
      expenseDate: '',
      reference: document['reference'],
      merchantId: '',
      expenseStatusId: 0,
      merchantName: '',
      expenseItems: [],
      expenseCategoryName: '',
      expenseCategoryId: '',
    );
  }).toList();

  return expensesList;
}

Future<List<Purchases>> searchPurchases(
    String search, String businessId, String userId) async {
  final searchRequests = {
    'q': search,
    'query_by': 'reference, description',
    // 'prioritize_token_position': true,
    // 'prioritize_exact_match': true,
    'filter_by': 'businessId:$businessId'
  };

  final searchResponse =
      await client.collection('purchase').documents.search(searchRequests);
  // Extract and return the search results from the response
  final searchResults = searchResponse['hits'] as List<dynamic>;

  final List<Purchases> purchasesList = searchResults.map((result) {
    final document = result['document'];
    return Purchases(
        id: document['id'],
        description: document['description'],
        transactionDate: '',
        reference: document['reference'],
        merchantId: '',
        merchantName: '',
        merchantEmail: '',
        purchaseItems: [],
        total: document['total'],
        purchaseStatusId: 0,
        paid: false);
  }).toList();

  return purchasesList;
}

Future<List<Sales>> searchSales(
    String search, String businessId, String userId) async {
  final searchRequests = {
    'q': search,
    'query_by': 'reference, description',
    // 'prioritize_token_position': true,
    // 'prioritize_exact_match': true,
    'filter_by': 'businessId:$businessId'
  };

  final searchResponse =
      await client.collection('sale').documents.search(searchRequests);
  // Extract and return the search results from the response
  final searchResults = searchResponse['hits'] as List<dynamic>;

  final List<Sales> salesList = searchResults.map((result) {
    final document = result['document'];
    return Sales(
        paid: false,
        id: document['id'],
        invoiceId: '',
        description: document['description'],
        invoiceDetails: [],
        saleServiceExpenses: [],
        saleExpenses: [],
        dueDate: '',
        transactionDate: '',
        reference: document['reference'],
        customerId: '',
        customerName: '',
        totalAmount: document['saleAmount'],
        VAT: 0,
        subtotal: 0,
        discount: 0,
        saleStatusId: 0,
        currencyName: '',
        currencySymbol: '');
  }).toList();

  return salesList;
}

Future<List<Customers>> searchCustomers(
    String search, String businessId, String userId) async {
  final searchRequests = {
    'q': search,
    'query_by': 'name',
    // 'prioritize_token_position': true,
    'filter_by': 'businessId:$businessId'
  };

  final searchResponse =
      await client.collection('customer').documents.search(searchRequests);
  // Extract and return the search results from the response
  final searchResults = searchResponse['hits'] as List<dynamic>;

  final List<Customers> customersList = searchResults.map((result) {
    final document = result['document'];
    return Customers(
        address: '',
        id: document['id'],
        email: document['email'],
        mobile: '',
        name: document['name']);
  }).toList();

  return customersList;
}

Future<List<Products>> searchProducts(
    String search, String businessId, String userId) async {
  final searchRequests = {
    'q': search,
    'query_by': 'productName',
    // 'prioritize_token_position': true,
    // 'prioritize_exact_match': true,
    'filter_by': 'businessId:$businessId && createdById:$userId'
  };

  final searchResponse =
      await client.collection('product').documents.search(searchRequests);
  // Extract and return the search results from the response
  final searchResults = searchResponse['hits'] as List<dynamic>;

  final List<Products> productsList = searchResults.map((result) {
    final document = result['document'];
    return Products(
      id: document['id'],
      productName: document['productName'],
      price: document['price'],
      quantity: 0,
      // reorderLevel: 0,
      // trackReorderLevel: false,
    );
  }).toList();

  return productsList;
}

Future<List<Services>> searchServices(
    String search, String businessId, String userId) async {
  final searchRequests = {
    'q': search,
    'query_by': 'name',
    // 'prioritize_token_position': true,
    // 'prioritize_exact_match': true,
    'filter_by': 'businessId:$businessId && createdById:$userId'
  };

  final searchResponse =
      await client.collection('service').documents.search(searchRequests);
  // Extract and return the search results from the response
  final searchResults = searchResponse['hits'] as List<dynamic>;

  final List<Services> servicesList = searchResults.map((result) {
    final document = result['document'];
    return Services(
      id: document['id'],
      name: document['name'],
      price: document['price'],
    );
  }).toList();

  return servicesList;
}

Future<List<Items>> searchItems(
    String search, String businessId, String userId) async {
  final searchRequests = {
    'searches': [
      {
        'collection': 'product',
        'q': search,
        'query_by': 'productName',
        'filter_by': 'businessId:$businessId'
      },
      {
        'collection': 'service',
        'q': search,
        'query_by': 'name',
        'filter_by': 'businessId:$businessId'
      }
    ]
  };

  final searchResponse = await client.multiSearch.perform(searchRequests);

  // Extract and return the search results from the response
  final results = searchResponse['results'] as List<dynamic>;

  // Create a list to store the items
  final List<Items> itemsList = [];

  for (var result in results) {
    final hits = result['hits'] as List<dynamic>;
    for (var hit in hits) {
      final document = hit['document'];

      // Check if 'productName' is present, else use 'name'
      String titleField =
          document.containsKey('productName') ? 'productName' : 'name';

      // Check if 'productName' is present, set type to 'P'; otherwise, set type to 'S'
      String type = document.containsKey('productName') ? 'P' : 'S';

      itemsList.add(
        Items(
          id: document['id'],
          price: document['price'],
          type: type,
          title: document[titleField],
          quantity: 0,
        ),
      );
    }
  }

  return itemsList;
}

//        'collection': 'product',
//         'q': search,
//         'query_by': 'productName',
//         'prioritize_token_position': true,
//         'prioritize_exact_match': true,
//         'filter_by': 'businessId:$businessId && createdById:$userId',
//       },
//       {
//         'collection': 'service',
//         'q': search,
//         'query_by': 'name',
//         'prioritize_token_position': true,
//         'filter_by': 'businessId:$businessId',
//       },
//
