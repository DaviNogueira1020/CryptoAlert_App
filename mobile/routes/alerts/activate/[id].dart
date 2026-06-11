import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/alerts/alerts_service.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async{
  if (context.request.method != HttpMethod.patch){
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed'},
    );
  }

  final service = AlertsService();

  final alert = await service.activateAlert(id);

  return Response.json(
    body: {
      'message': 'Alert activated successfully',
      'alert': {
        'id': alert.id,
        'active': alert.active,
      },
    },
  );
}