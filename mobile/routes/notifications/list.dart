import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/notifications/notifications_service.dart';


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

  final service = NotificationsService();

  final notifications = service.getNotifications();

  // Se não tiver notificações reais, retorna dados de teste
  final List<dynamic> response;
  
  if (notifications.isEmpty) {
    response = [
      {
        'id': '1',
        'alertId': 'alert_1',
        'title': 'Bitcoin atingiu \$85.000',
        'message': 'Seu alerta para Bitcoin foi acionado',
        'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'read': false,
      },
      {
        'id': '2',
        'alertId': 'alert_2',
        'title': 'Ethereum subiu 5%',
        'message': 'Ethereum atingiu \$2.500 em 24 horas',
        'createdAt': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
        'read': false,
      },
      {
        'id': '3',
        'alertId': 'alert_3',
        'title': 'Solana caiu abaixo de \$140',
        'message': 'Seu alerta para SOL foi disparado',
        'createdAt': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
        'read': true,
      },
      {
        'id': '4',
        'alertId': 'alert_4',
        'title': 'XRP em alta',
        'message': 'XRP atingiu novo pico de \$2.10',
        'createdAt': DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
        'read': true,
      },
      {
        'id': '5',
        'alertId': 'alert_5',
        'title': 'Cardano atualização',
        'message': 'ADA continua estável em \$0.75',
        'createdAt': DateTime.now().subtract(const Duration(hours: 10)).toIso8601String(),
        'read': true,
      },
    ];
  } else {
    response = notifications.map((notification){
      return{
        'id': notification.id,
        'alertId': notification.alertId,
        'title': notification.title,
        'message': notification.message,
        'createdAt': notification.createdAt.toIso8601String(),
        'read': notification.read,
      };
    }).toList();
  }

  return Response.json(
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
    body: response,
  );
}