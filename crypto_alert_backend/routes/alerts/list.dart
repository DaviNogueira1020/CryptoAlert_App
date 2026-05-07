import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/alerts/alerts_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if(context.request.method != HttpMethod.get){
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed'},
    );
  }

  final service = AlertsService();

  final alerts = service.getAlerts();

  final response = alerts.map((alert){
    return{
      'id': alert.id,
      'symbol': alert.symbol,
      'target': alert.target,
      'type': alert.type,
      'active': alert.active,
    };
  }).toList();

  return Response.json(body: response);
}