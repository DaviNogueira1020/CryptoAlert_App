import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/alerts/alerts_service.dart';
import 'dart:convert';

Future<Response> onRequest(RequestContext context) async {
  if(context.request.method != HttpMethod.post){
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed'},
    );
  }

  final body = await context.request.body();

  final data = jsonDecode(body) as Map<String, dynamic>;

  final symbol = data['symbol'] as String;
  final target = (data['target'] as num).toDouble(); // num = int || double
  final type = data['type'] as String;

  final service = AlertsService();
  
  final alert = service.createAlert(
    symbol: symbol,
    target: target,
    type: type,
  );

  return Response.json(
    statusCode: 201,
    body: {
      'id': alert.id,
      'symbol': alert.symbol,
      'target': alert.target,
      'type': alert.type,
      'active': alert.active,
    },
  );
}