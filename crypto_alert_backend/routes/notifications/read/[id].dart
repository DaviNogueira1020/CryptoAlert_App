import 'package:crypto_alert_backend/modules/notifications/notifications_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if(context.request.method != HttpMethod.patch){
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed'},
    );
  }

  final service = NotificationsService();
  
  final markedAsReadNotification = await service.markNotificationAsRead(id);

  return Response.json(
    body: {
      'message': 'Notification marked as read successfully',
      'notification': {
        'id': markedAsReadNotification.id,
        'read': markedAsReadNotification.read
      }
    },
  );
}