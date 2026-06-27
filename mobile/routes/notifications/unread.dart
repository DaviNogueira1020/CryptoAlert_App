import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/notifications/notifications_service.dart';


Future<Response> onRequest(RequestContext context) async {
  if(context.request.method != HttpMethod.get){
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed'},
    );
  }

  final service = NotificationsService();

  final notifications = await service.getUnreadNotifications(); //Change this later,
                                                    //too little of a difference
  final response = notifications.map((notification){
    return{
      'id': notification.id,
      'alertId': notification.alertId,
      'title': notification.title,
      'message': notification.message,
      'createdAt': notification.createdAt?.toIso8601String(),
      'read': notification.read,
    };
  }).toList();

  return Response.json(body: response);
}