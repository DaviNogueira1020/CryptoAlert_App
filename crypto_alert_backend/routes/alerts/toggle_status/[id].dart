import 'package:crypto_alert_backend/modules/alerts/alerts_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if(context.request.method != HttpMethod.patch){
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed'},
    );
  }

  final service = AlertsService();
  
  final toggledAlert = service.toggleAlertStatus(id);

  return Response.json(
    body: {
      'message': 'Alert status toggled successfully',
      'alert': {
        'id': toggledAlert.id,
        'active': toggledAlert.active
      }
    },
  );
}