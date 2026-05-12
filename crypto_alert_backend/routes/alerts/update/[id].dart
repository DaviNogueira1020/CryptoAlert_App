import 'dart:convert';

import 'package:crypto_alert_backend/modules/alerts/alerts_service.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if(context.request.method != HttpMethod.put){
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed'},
    );
  }

  final body = await context.request.body();

  final data = jsonDecode(body) as Map<String, dynamic>;

  final symbol = data['symbol'] as String?;
  final target = (data['target'] as num?)?.toDouble(); // num = int || double
  final type = data['type'] as String?;

  final service = AlertsService();
  
  final updatedAlert = service.updateAlert(
    id, symbol: symbol, target: target, type: type);

  return Response.json(
    body: {
      'update': 'sucessful',
      'id': updatedAlert.id,
      'symbol': updatedAlert.symbol,
      'target': updatedAlert.target,
      'type': updatedAlert.type,
      'active': updatedAlert.active,
    },
  );
}