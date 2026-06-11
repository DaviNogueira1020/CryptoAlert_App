import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/notifications/notifications_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if(context.request.method != HttpMethod.delete){
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed'},
    );
  }

  final service = NotificationsService();
  
  final deletedNotification = await service.deleteNotification(id);

  return Response.json(
    body: {
      'message': 'Notification deleted successfully',
      'notification': {'id': deletedNotification.id},
    },
  );
}