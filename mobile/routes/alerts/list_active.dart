import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/alerts/alerts_service.dart';
import 'package:crypto_alert_backend/modules/alerts/alert_type.dart';

Future<Response> onRequest(RequestContext context) async {
  // Handle CORS preflight
  if (context.request.method == HttpMethod.options) {
    return Response(
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    );
  }

  if(context.request.method != HttpMethod.get){
    return Response.json(
      statusCode: 405,
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
      body: {'error': 'Method not allowed'},
    );
  }

  final service = AlertsService();

  final alerts = await service.getActiveAlerts();

  final response = alerts.map((alert){
    return{
      'id': alert.id,
      'symbol': alert.symbol,
      'target': alert.target,
      'type': alert.type.value,
      'active': alert.active,
    };
  }).toList();

  return Response.json(
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
    body: response,
  );
}