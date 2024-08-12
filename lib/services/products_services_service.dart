import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsServicesService {
  ValueNotifier<GraphQLClient> client;

//Products
  final MutationOptions _createProductMutation;
  final MutationOptions _createBusinessProductUnitMutation;
  final MutationOptions _updateProductMutation;
  final QueryOptions _getProductByIdQuery;
  final MutationOptions _archiveProductMutation;
  final MutationOptions _unarchiveProductMutation;
  final MutationOptions _deleteProductMutation;
  final QueryOptions _getCombinedProductUnits;

//Services
  final MutationOptions _createServiceMutation;
  final MutationOptions _createBusinessServiceUnitMutation;
  final MutationOptions _updateServiceMutation;
  final QueryOptions _getServiceByIdQuery;
  final MutationOptions _archiveServiceMutation;
  final MutationOptions _unarchiveServiceMutation;
  final MutationOptions _deleteServiceMutation;
  final QueryOptions _getCombinedServiceUnits;

//product/services
  final QueryOptions _getProductOrServiceByBusinessQuery;
  final QueryOptions _getProductsByBusinessQuery;
  final QueryOptions _getArchivedProductByBusinessQuery;
  final QueryOptions _getServiceByBusinessQuery;
  final QueryOptions _getArchivedServicesByBusinessQuery;

  ProductsServicesService()
      : client = ValueNotifier(GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://api2.verzo.app/graphql'),
        )),
        _createProductMutation = MutationOptions(
          document: gql('''
        mutation CreateProduct(\$input: CreateProduct!) {
          createProduct(input: \$input) {
            id
            productName
            price
          }
        }
      '''),
        ),
        _createBusinessProductUnitMutation = MutationOptions(
          document: gql('''
        mutation CreateBusinessProductUnit(\$input: CreateBusinessProductUnit!) {
          createBusinessProductUnit(input: \$input) {
            id
            unitName
          }
        }
      '''),
        ),
        _updateProductMutation = MutationOptions(
          document: gql('''
            mutation UpdateProduct(\$productId: String!, \$input: UpdateProduct) {
              updateProduct(productId: \$productId, input: \$input) {
                id
                
              }
            }
          '''),
        ),
        _getProductByIdQuery = QueryOptions(
          document: gql('''
        query GetProductById(\$productId: String!){
          getProductById(productId: \$productId){
            id
            productName
            price
            trackReorderLevel
            reorderLevel
            productUnitId
            businessProductUnitId
            }
          }
        '''),
        ),
        _archiveProductMutation = MutationOptions(
          document: gql('''
        mutation ArchiveProductByBusiness(\$productId: String!) {
          archiveProductByBusiness(productId: \$productId)
        }
      '''),
        ),
        _unarchiveProductMutation = MutationOptions(
          document: gql('''
        mutation UnArchiveProductByBusiness(\$productId: String!) {
          unarchiveProductByBusiness(productId: \$productId)
        }
      '''),
        ),
        _deleteProductMutation = MutationOptions(
          document: gql('''
        mutation DeleteProduct(\$productId: String!) {
          deleteProduct(productId: \$productId)
        }
      '''),
        ),
        _getCombinedProductUnits = QueryOptions(
          document: gql('''
        query GetCombinedProductUnits(\$businessId: String!){
          getCombinedProductUnits(businessId: \$businessId){
            id
            unitName
            description
            }
          }
        '''),
        ),
        _createServiceMutation = MutationOptions(
          document: gql('''
        mutation CreateService(\$input: CreateService!) {
          createService(input:\$input) {
            id
            name
            price
          }
         }
        '''),
        ),
        _createBusinessServiceUnitMutation = MutationOptions(
          document: gql('''
        mutation CreateBusinessServiceUnit(\$input: CreateBusinessServiceUnit!) {
          createBusinessServiceUnit(input: \$input) {
            id
            unitName
          }
        }
      '''),
        ),
        _updateServiceMutation = MutationOptions(
          document: gql('''
            mutation UpdateService(\$serviceId: String!, \$input: UpdateService) {
              updateService(serviceId: \$serviceId, input: \$input) {
                id
              }
            }
          '''),
        ),
        _getServiceByIdQuery = QueryOptions(
          document: gql('''
        query GetServiceById(\$serviceId: String!){
          getServiceById(serviceId: \$serviceId){
            id
            name
            price
            serviceUnitId
            businessServiceUnitId
            }
          }
        '''),
        ),
        _archiveServiceMutation = MutationOptions(
          document: gql('''
        mutation ArchiveServiceByBusiness(\$serviceId: String!) {
          archiveServiceByBusiness(serviceId: \$serviceId)
        }
      '''),
        ),
        _unarchiveServiceMutation = MutationOptions(
          document: gql('''
        mutation UnArchiveServiceByBusiness(\$serviceId: String!) {
          unarchiveServiceByBusiness(serviceId: \$serviceId)
        }
      '''),
        ),
        _deleteServiceMutation = MutationOptions(
          document: gql('''
        mutation DeleteService(\$serviceId: String!) {
          deleteService(serviceId: \$serviceId)
        }
      '''),
        ),
        _getCombinedServiceUnits = QueryOptions(
          document: gql('''
        query GetCombinedServiceUnits(\$businessId: String!){
          getCombinedServiceUnits(businessId: \$businessId){
            id
            unitName
            description
            }
          }
        '''),
        ),
        _getProductOrServiceByBusinessQuery = QueryOptions(
          document: gql('''
        query GetProductOrServiceByBusiness(\$businessId: String!,\$cursor: String, \$take: Int) {
          getProductOrServiceByBusiness(businessId: \$businessId, cursor: \$cursor, take: \$take) {
            productOrServiceByBusiness{
              id
              title
              type
              price
              businessId
              product{
              productName
              productUnitId
              productUnit{
                id
                unitName
              }
                }
              service{
              name
              serviceUnitId
              serviceUnit{
                id
                unitName
              }
              }
            }
            cursorId
            }
          }
        '''),
        ),
        _getProductsByBusinessQuery = QueryOptions(
          document: gql('''
        query GetProductsByBusiness(\$input: String!) {
          getProductsByBusiness(businessId: \$input) {
            productByBusiness{
              id
              productName
              price
              
            }
            }
          }
        '''),
        ),
        _getArchivedProductByBusinessQuery = QueryOptions(
          document: gql('''
        query GetArchivedProductByBusiness(\$input: String!) {
          getArchivedProductByBusiness(businessId: \$input) {
            productByBusiness{
              id
              productName
              price
            }
            }
          }
        '''),
        ),
        _getServiceByBusinessQuery = QueryOptions(
          document: gql('''
        query GetServiceByBusiness(\$input: String!) {
          getServiceByBusiness(businessId: \$input) {
            serviceByBusiness{
              id
              name
              price
            }
            }
          }
        '''),
        ),
        _getArchivedServicesByBusinessQuery = QueryOptions(
          document: gql('''
        query GetArchivedServicesByBusiness(\$input: String!) {
          getArchivedServicesByBusiness(businessId: \$input) {
            serviceByBusiness{
              id
              name
              price
            }
            }
          }
        '''),
        );

//Product
  Future<ProductCreationResult> createProducts(
      {required String productName,
      required double price,
      required double initialStockLevel,
      // double? quantityInStock,
      required String businessId,
      required String productUnitId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return ProductCreationResult.error(
        error: GraphQLProductError(
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
      document: _createProductMutation.document,
      variables: {
        'input': {
          'productName': productName,
          'price': price * 100,
          'initialStockLevel': initialStockLevel,
          // 'quantityInStock': quantityInStock,
          'businessId': businessId,
          'productUnitId': productUnitId
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return ProductCreationResult.error(
        error: GraphQLProductError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['createProduct'] == null) {
      return ProductCreationResult.error(
        error: GraphQLProductError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultId = result.data?['createProduct']['id'];
    var resultProductName = result.data?['createProduct']['productName'];
    var resultPrice = result.data?['createProduct']['price'];

    var product = ProductCreationSuccessResult(
        result_id: resultId,
        result_productName: resultProductName,
        result_price: resultPrice);

    return ProductCreationResult(product: product);
  }

  Future<ProductUnitCreationResult> createBusinessProductUnit(
      {required String unitName,
      required String businessId,
      String? description}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return ProductUnitCreationResult.error(
        error: GraphQLProductError(
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
      document: _createBusinessProductUnitMutation.document,
      variables: {
        'input': {
          'unitName': unitName,
          'businessId': businessId,
          'description': description
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return ProductUnitCreationResult.error(
        error: GraphQLProductError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    var productUnitId = result.data?['createBusinessProductUnit']['id'];
    var productUnitName = result.data?['createBusinessProductUnit']['unitName'];

    if (result.data == null ||
        result.data!['createBusinessProductUnit'] == null) {
      return ProductUnitCreationResult.error(
        error: GraphQLProductError(
          message: "Error parsing response data",
        ),
      );
    }

    var productUnit = ProductUnitCreationSuccessResult(
        id: productUnitId, unitName: productUnitName);

    return ProductUnitCreationResult(productUnit: productUnit);
  }

  Future<ProductUpdateResult> updateProducts(
      {required String productId,
      String? productName,
      double? price,
      num? reorderLevel,
      bool? trackReorderLevel,
      String? productUnitId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return ProductUpdateResult.error(
        error: GraphQLProductError(
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
      document: _updateProductMutation.document,
      variables: {
        'productId': productId,
        'input': {
          'productName': productName,
          'price': price! * 100,
          'productUnitId': productUnitId,
          // 'quantityInStock': quantityInStock,
          'reorderLevel': reorderLevel,
          'trackReorderLevel': trackReorderLevel
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return ProductUpdateResult.error(
        error: GraphQLProductError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['updateProduct'] == null) {
      return ProductUpdateResult.error(
        error: GraphQLProductError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultexpenseId = result.data?['updateProduct']['id'];

    var product = ProductUpdateSuccessResult(
      result_id: resultexpenseId,
    );

    return ProductUpdateResult(product: product);
  }

  Future<Products> getProductById({required String productId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLProductError(
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
      document: _getProductByIdQuery.document,
      variables: {'productId': productId},
    );

    final QueryResult productByIdResult = await newClient.query(options);

    if (productByIdResult.hasException) {
      throw GraphQLProductError(
        message:
            productByIdResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final productByIdData = productByIdResult.data?['getProductById'] ?? [];

    final Products productById = Products(
      id: productByIdData['id'],
      productName: productByIdData['productName'],
      price: productByIdData['price'] / 100,
      quantity: 1,
      // reorderLevel: productByIdData['reorderLevel'],
      productUnitId: productByIdData['businessProductUnitId'] ??
          productByIdData['productUnitId'],
      // trackReorderLevel: productByIdData['trackReorderLevel']
    );

    return productById;
  }

  Future<bool> archiveProduct({required String productId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLProductError(
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
      document: _archiveProductMutation.document,
      variables: {
        'productId': productId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isArchived = result.data?['archiveProductByBusiness'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isArchived = false;
    }

    return isArchived;
  }

  Future<bool> unArchiveProduct({required String productId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLProductError(
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
      document: _unarchiveProductMutation.document,
      variables: {
        'productId': productId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isUnArchived = result.data?['unarchiveProductByBusiness'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isUnArchived = false;
    }

    return isUnArchived;
  }

  Future<bool> deleteProduct({required String productId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLProductError(
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
      document: _deleteProductMutation.document,
      variables: {
        'productId': productId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isDeleted = result.data?['deleteProduct'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isDeleted = false;
    }

    return isDeleted;
  }

  Future<List<ProductUnit>> getProductUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');
    if (token == null) {
      GraphQLProductError(
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
      document: _getCombinedProductUnits.document,
      variables: {
        'businessId': businessId,
      },
    );

    final QueryResult productUnitsResult = await newClient.query(options);

    if (productUnitsResult.hasException) {
      GraphQLProductError(
        message: productUnitsResult.exception?.graphqlErrors.first.message
            .toString(),
      );
    }

    final List productUnitsData =
        productUnitsResult.data?['getCombinedProductUnits'] ?? [];

    final List<ProductUnit> productUnits = productUnitsData.map((data) {
      return ProductUnit(
          id: data['id'],
          unitName: data['unitName'],
          description: data['description']);
    }).toList();

    return productUnits;
  }

//Service
  Future<ServiceCreationResult> createServices(
      {required String name,
      required double price,
      required String businessId,
      required String serviceUnitId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return ServiceCreationResult.error(
        error: GraphQLServiceError(
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
      document: _createServiceMutation.document,
      variables: {
        'input': {
          'name': name,
          'price': price * 100,
          'businessId': businessId,
          'serviceUnitId': serviceUnitId
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return ServiceCreationResult.error(
        error: GraphQLServiceError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['createService'] == null) {
      return ServiceCreationResult.error(
        error: GraphQLServiceError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultId = result.data?['createService']['id'];
    var resultName = result.data?['createService']['name'];
    var resultPrice = result.data?['createService']['price'];

    var service = ServiceCreationSuccessResult(
        result_id: resultId,
        result_name: resultName,
        result_price: resultPrice);

    return ServiceCreationResult(service: service);
  }

  Future<ServiceUnitCreationResult> createBusinessServiceUnit(
      {required String unitName,
      required String businessId,
      String? description}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');

    if (token == null) {
      return ServiceUnitCreationResult.error(
        error: GraphQLServiceError(
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
      document: _createBusinessServiceUnitMutation.document,
      variables: {
        'input': {
          'unitName': unitName,
          'businessId': businessId,
          'description': description
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return ServiceUnitCreationResult.error(
        error: GraphQLServiceError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    var serviceUnitId = result.data?['createBusinessServiceUnit']['id'];
    var serviceUnitName = result.data?['createBusinessServiceUnit']['unitName'];

    if (result.data == null ||
        result.data!['createBusinessServiceUnit'] == null) {
      return ServiceUnitCreationResult.error(
        error: GraphQLServiceError(
          message: "Error parsing response data",
        ),
      );
    }

    var serviceUnit = ServiceUnitCreationSuccessResult(
        id: serviceUnitId, unitName: serviceUnitName);

    return ServiceUnitCreationResult(serviceUnit: serviceUnit);
  }

  Future<ServiceUpdateResult> updateServices(
      {required String serviceId,
      String? name,
      double? price,
      String? serviceUnitId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      return ServiceUpdateResult.error(
        error: GraphQLServiceError(
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
      document: _updateServiceMutation.document,
      variables: {
        'serviceId': serviceId,
        'input': {
          'name': name,
          'price': price! * 100,
          'serviceUnitId': serviceUnitId,
        },
      },
    );

    final QueryResult result = await newClient.mutate(options);

    if (result.hasException) {
      return ServiceUpdateResult.error(
        error: GraphQLServiceError(
          message: result.exception?.graphqlErrors.first.message.toString(),
        ),
      );
    }

    if (result.data == null || result.data!['updateService'] == null) {
      return ServiceUpdateResult.error(
        error: GraphQLServiceError(
          message: "Error parsing response data",
        ),
      );
    }

    var resultexpenseId = result.data?['updateService']['id'];

    var service = ServiceUpdateSuccessResult(
      result_id: resultexpenseId,
    );

    return ServiceUpdateResult(service: service);
  }

  Future<Services> getServiceById({required String serviceId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLServiceError(
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
      document: _getServiceByIdQuery.document,
      variables: {'serviceId': serviceId},
    );

    final QueryResult serviceByIdResult = await newClient.query(options);

    if (serviceByIdResult.hasException) {
      throw GraphQLServiceError(
        message:
            serviceByIdResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final serviceByIdData = serviceByIdResult.data?['getServiceById'] ?? [];

    final Services serviceById = Services(
      id: serviceByIdData['id'],
      name: serviceByIdData['name'],
      price: serviceByIdData['price'] / 100,
      serviceUnitId: serviceByIdData['businessServiceUnitId'] ??
          serviceByIdData['serviceUnitId'],
    );

    return serviceById;
  }

  Future<bool> archiveService({required String serviceId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLServiceError(
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
      document: _archiveServiceMutation.document,
      variables: {
        'serviceId': serviceId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isArchived = result.data?['archiveServiceByBusiness'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isArchived = false;
    }

    return isArchived;
  }

  Future<bool> unArchiveService({required String serviceId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLServiceError(
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
      document: _unarchiveServiceMutation.document,
      variables: {
        'serviceId': serviceId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isUnArchived = result.data?['unarchiveServiceByBusiness'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isUnArchived = false;
    }

    return isUnArchived;
  }

  Future<bool> deleteService({required String serviceId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      GraphQLServiceError(
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
      document: _deleteServiceMutation.document,
      variables: {
        'serviceId': serviceId,
      },
    );

    final QueryResult result = await newClient.mutate(options);
    bool isDeleted = result.data?['deleteService'] ?? false;
    if (result.hasException) {
      // Handle any errors that may have occurred during the log out process
      isDeleted = false;
    }

    return isDeleted;
  }

  Future<List<ServiceUnit>> getServiceUnits(
      {required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final businessId = prefs.getString('businessId');
    if (token == null) {
      GraphQLProductError(
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
      document: _getCombinedServiceUnits.document,
      variables: {
        'businessId': businessId,
      },
    );

    final QueryResult serviceUnitsResult = await newClient.query(options);

    if (serviceUnitsResult.hasException) {
      GraphQLServiceError(
        message: serviceUnitsResult.exception?.graphqlErrors.first.message
            .toString(),
      );
    }

    final List serviceUnitsData =
        serviceUnitsResult.data?['getCombinedServiceUnits'] ?? [];

    final List<ServiceUnit> serviceUnits = serviceUnitsData.map((data) {
      return ServiceUnit(
          id: data['id'],
          unitName: data['unitName'],
          description: data['description']);
    }).toList();

    return serviceUnits;
  }

  Future<List<Items>> getProductOrServiceByBusiness(
      {required String businessId, num? take, String? cursor}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLProductError(
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
      document: _getProductOrServiceByBusinessQuery.document,
      variables: {'businessId': businessId, 'take': take, 'cursor': cursor},
    );

    final QueryResult productorserviceByBusinessResult =
        await newClient.query(options);

    // if (productorserviceByBusinessResult.hasException) {
    //   throw GraphQLProductError(
    //     message: productorserviceByBusinessResult.exception?.graphqlErrors
    //         .toString(),
    //   );
    // }

    final List productsorservicesData =
        productorserviceByBusinessResult.data?['getProductOrServiceByBusiness']
                ['productOrServiceByBusiness'] ??
            [];

    final List<Items> items = productsorservicesData.map((data) {
      final productData = data['product'];
      final serviceData = data['service'];

      return Items(
        id: data['id'],
        title: data['title'],
        type: data['type'],
        price: data['price'] / 100,
        productUnitId:
            productData != null ? productData['productUnitId'] : null,
        productName: productData != null ? productData['productName'] : null,
        productUnitName:
            productData != null && productData['productUnit'] != null
                ? productData['productUnit']['unitName']
                : null,
        serviceUnitId:
            serviceData != null ? serviceData['serviceUnitId'] : null,
        serviceName: serviceData != null ? serviceData['name'] : null,
        serviceUnitName:
            serviceData != null && serviceData['serviceUnit'] != null
                ? serviceData['serviceUnit']['unitName']
                : null,
        basicUnit: productData != null ? productData['basicUnit'] : null,
        quantity: 1,
      );
    }).toList();

    return items;

//     final List<Items> items = productsorservicesData.map((data) {
//       return Items(
//         id: data['id'],
//         title: data['title'],
//         type: data['type'],
//         price: data['price'],
//         productUnitId:
//             data['product'] != null ? data['product']['productUnitId'] : null,
//         productName:
//             data['product'] != null ? data['product']['productName'] : null,
//         productUnitName: data['product']['productUnit'] != null
//             ? data['product']['productUnit']['unitName']
//             : null,
//         serviceUnitId:
//             data['service'] != null ? data['service']['serviceUnitId'] : null,

//         serviceName: data['service'] != null ? data['service']['name'] : null,
// //  serviceUnitName: data['service']['serviceUnit'] != null
//         //     ? data['service']['serviceUnit']['unitName']
//         //     : null,
//         basicUnit:
//             data['product'] != null ? data['product']['basicUnit'] : null,
//         quantity: 1,
//       );
//     }).toList();

    // return items;
  }

  Future<List<Products>> getProductsByBusiness(
      {required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLProductError(
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
      document: _getProductsByBusinessQuery.document,
      variables: {'input': businessId},
    );

    final QueryResult productsByBusinessResult = await newClient.query(options);

    // if (productsByBusinessResult.hasException) {
    //   throw GraphQLProductError(
    //     message: productsByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List productsData = productsByBusinessResult
            .data?['getProductsByBusiness']['productByBusiness'] ??
        [];

    final List<Products> products = productsData.map((data) {
      return Products(
          id: data['id'],
          productName: data['productName'],
          price: data['price'] / 100,
          quantity: 1
          // reorderLevel: 0,
          // trackReorderLevel: false
          );
    }).toList();

    return products;
  }

  Future<List<Products>> getArchivedProductsByBusiness(
      {required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLProductError(
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
      document: _getArchivedProductByBusinessQuery.document,
      variables: {'input': businessId},
    );

    final QueryResult productsByBusinessResult = await newClient.query(options);

    // if (productsByBusinessResult.hasException) {
    //   throw GraphQLProductError(
    //     message: productsByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List productsData = productsByBusinessResult
            .data?['getArchivedProductByBusiness']['productByBusiness'] ??
        [];

    final List<Products> products = productsData.map((data) {
      return Products(
          id: data['id'],
          productName: data['productName'],
          price: data['price'] / 100,
          quantity: 1
          // reorderLevel: 0,
          // trackReorderLevel: false
          );
    }).toList();

    return products;
  }

  Future<List<Services>> getServiceByBusiness(
      {required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLProductError(
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
      document: _getServiceByBusinessQuery.document,
      variables: {'input': businessId},
    );

    final QueryResult serviceByBusinessResult = await newClient.query(options);

    // if (serviceByBusinessResult.hasException) {
    //   throw GraphQLServiceError(
    //     message: serviceByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List serviceData = serviceByBusinessResult
            .data?['getServiceByBusiness']['serviceByBusiness'] ??
        [];

    final List<Services> services = serviceData.map((data) {
      return Services(
          id: data['id'], name: data['name'], price: data['price'] / 100);
    }).toList();

    return services;
  }

  Future<List<Services>> getArchivedServiceByBusiness(
      {required String businessId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      throw GraphQLProductError(
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
      document: _getArchivedServicesByBusinessQuery.document,
      variables: {'input': businessId},
    );

    final QueryResult serviceByBusinessResult = await newClient.query(options);

    // if (serviceByBusinessResult.hasException) {
    //   throw GraphQLServiceError(
    //     message: serviceByBusinessResult.exception?.graphqlErrors.first.message
    //         .toString(),
    //   );
    // }

    final List serviceData = serviceByBusinessResult
            .data?['getArchivedServicesByBusiness']['serviceByBusiness'] ??
        [];

    final List<Services> services = serviceData.map((data) {
      return Services(
          id: data['id'], name: data['name'], price: data['price'] / 100);
    }).toList();

    return services;
  }
}

class Products {
  final String id;
  final String productName;
  num price;
  int quantity = 1;
  // bool trackReorderLevel;
  // num reorderLevel;
  String? productUnitId;

  Products(
      {required this.id,
      required this.productName,
      // required this.reorderLevel,
      // required this.trackReorderLevel,
      required this.price,
      required this.quantity,
      this.productUnitId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'price': price,
      'productUnitId': productUnitId,
      'quantity': quantity
    };
  }
}

class Services {
  final String id;
  final String name;
  num price;
  String? serviceUnitId;

  Services(
      {required this.id,
      required this.name,
      required this.price,
      this.serviceUnitId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'serviceUnitId': serviceUnitId,
    };
  }
}

class ProductUnit {
  final String id;
  final String unitName;
  String? description;
  ProductUnit({required this.id, required this.unitName, this.description});
}

class ServiceUnit {
  final String id;
  final String unitName;
  String? description;

  ServiceUnit({
    required this.id,
    required this.unitName,
    this.description,
  });
}

class ProductUnitCreationResult {
  late final ProductUnitCreationSuccessResult? productUnit;
  late final GraphQLProductError? error;

  ProductUnitCreationResult({this.productUnit}) : error = null;
  ProductUnitCreationResult.error({this.error}) : productUnit = null;

  bool get hasError => error != null;
}

class ProductUnitCreationSuccessResult {
  final String id;
  final String unitName;

  ProductUnitCreationSuccessResult({required this.id, required this.unitName});
}

class ServiceUnitCreationResult {
  late final ServiceUnitCreationSuccessResult? serviceUnit;
  late final GraphQLServiceError? error;

  ServiceUnitCreationResult({this.serviceUnit}) : error = null;
  ServiceUnitCreationResult.error({this.error}) : serviceUnit = null;

  bool get hasError => error != null;
}

class ServiceUnitCreationSuccessResult {
  final String id;
  final String unitName;

  ServiceUnitCreationSuccessResult({required this.id, required this.unitName});
}

class Items {
  final String id;
  final String title;
  late final String type;
  final String? productUnitId;
  final String? serviceUnitId;
  num price;
  num basePrice;
  num quantity = 1;
  num? basicUnit;
  // num? quantityInStock;
  String? productUnitName;
  String? productName;
  String? serviceName;
  String? serviceUnitName;

  Items(
      {required this.id,
      required this.title,
      required this.type,
      this.productUnitId,
      this.serviceUnitId,
      required this.price,
      this.basePrice = 0,
      required this.quantity,
      this.basicUnit,
      // this.quantityInStock,
      this.productUnitName,
      this.productName,
      this.serviceName,
      this.serviceUnitName});
}

class ProductCreationResult {
  late final ProductCreationSuccessResult? product;
  late final GraphQLProductError? error;

  ProductCreationResult({this.product}) : error = null;
  ProductCreationResult.error({this.error}) : product = null;

  bool get hasError => error != null;
}

class ProductCreationSuccessResult {
  ProductCreationSuccessResult({
    required this.result_id,
    required this.result_productName,
    required this.result_price,
    // this.basicUnit,
    // this.quantityInStock,
    // this.productUnitName
  });

  late final String result_id;
  late final String result_productName;
  late final num result_price;
  // num? basicUnit;
  // num? quantityInStock;
  // String? productUnitName;
}

class ProductUpdateResult {
  late final ProductUpdateSuccessResult? product;
  late final GraphQLProductError? error;

  ProductUpdateResult({this.product}) : error = null;
  ProductUpdateResult.error({this.error}) : product = null;

  bool get hasError => error != null;
}

class ProductUpdateSuccessResult {
  ProductUpdateSuccessResult({
    required this.result_id,
  });

  late final String result_id;
}

class GraphQLProductError {
  final String? message;

  GraphQLProductError({required this.message});
}

class ServiceCreationResult {
  late final ServiceCreationSuccessResult? service;
  late final GraphQLServiceError? error;

  ServiceCreationResult({this.service}) : error = null;
  ServiceCreationResult.error({this.error}) : service = null;

  bool get hasError => error != null;
}

class ServiceCreationSuccessResult {
  ServiceCreationSuccessResult(
      {required this.result_id,
      required this.result_name,
      required this.result_price});

  late final String result_id;
  late final String result_name;
  late final num result_price;
}

class ServiceUpdateResult {
  late final ServiceUpdateSuccessResult? service;
  late final GraphQLServiceError? error;

  ServiceUpdateResult({this.service}) : error = null;
  ServiceUpdateResult.error({this.error}) : service = null;

  bool get hasError => error != null;
}

class ServiceUpdateSuccessResult {
  ServiceUpdateSuccessResult({
    required this.result_id,
  });

  late final String result_id;
}

class GraphQLServiceError {
  final String? message;

  GraphQLServiceError({required this.message});
}
