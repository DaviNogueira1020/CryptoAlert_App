import 'dart:convert';

import 'package:crypto_alert_backend/modules/alerts/alert_type.dart';
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
  final type = data['type'] != null ? 
              AlertTypeExtension.fromString(data['type'] as String) 
              : null;

  final service = AlertsService();
  
  final updatedAlert = await service.updateAlert(
    id, symbol: symbol, target: target, type: type);

  return Response.json(
    body: {
      'message': 'Alert updated successfully',
      'id': updatedAlert.id,
      'symbol': updatedAlert.symbol,
      'target': updatedAlert.target,
      'type': updatedAlert.type.value,
      'active': updatedAlert.active,
    },
  );
}