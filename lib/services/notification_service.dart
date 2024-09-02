import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:verzo/app/app.locator.dart';

class NotificationService {
  final navigationService = locator<NavigationService>();
  ValueNotifier<GraphQLClient> client;

  final QueryOptions _getMessagesQuery;
  NotificationService()
      : client = ValueNotifier(GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink('https://queue.api.verzo.app/graphql'),
        )),
        _getMessagesQuery = QueryOptions(
          document: gql('''
        query GetMessages (\$topic: String!){
          getMessages (topic: \$topic){
            id
            title
            message
            key
            type
            dateTime
            }
            }
            '''),
        );

  Future<List<Notificationss>> getMessages({required String token}) async {
    final prefs = await SharedPreferences.getInstance();
    final topic = prefs.getString('userId');
    final QueryOptions options = QueryOptions(
        document: _getMessagesQuery.document, variables: {'topic': topic});

    final QueryResult messagesResult = await client.value.query(options);

    if (messagesResult.hasException) {
      GraphQLNotificationError(
        message:
            messagesResult.exception?.graphqlErrors.first.message.toString(),
      );
    }

    final List notificaitonsData = messagesResult.data?['getMessages'] ?? [];

    final List<Notificationss> notifications = notificaitonsData.map((data) {
      return Notificationss(
        id: data['id'],
        title: data['title'],
        message: data['message'],
        key: data['key'],
        type: data['type'],
        dateTime: data['dateTime'],
      );
    }).toList();

    return notifications;
  }
}

class Notificationss {
  final String id;
  final String title;
  final String message;
  final String key;
  final String type;
  final String dateTime;

  Notificationss(
      {required this.id,
      required this.title,
      required this.message,
      required this.key,
      required this.type,
      required this.dateTime});
}

class GraphQLNotificationError {
  final String? message;

  GraphQLNotificationError({required this.message});
}
