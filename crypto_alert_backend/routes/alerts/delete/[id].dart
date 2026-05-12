import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/alerts/alerts_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if(context.request.method != HttpMethod.delete){
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed'},
    );
  }

  final service = AlertsService();
  
  final deletedAlert = service.deleteAlert(id);

  return Response.json(
    body: {
      'deletion': 'sucessful',
      'id': deletedAlert.id,
    },
  );
}