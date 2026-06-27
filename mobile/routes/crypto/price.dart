import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/crypto/crypto_service.dart';

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

  final symbol = context.request.uri.queryParameters['symbol'];

  if (symbol == null) {
    return Response.json(
      statusCode: 400,
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
      body: {'error': 'Symbol is required'},
    );
  }

  try {
    final service = CryptoService();
    final price = await service.getPrice(symbol);

    return Response.json(
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
      body: {
        'symbol': symbol,
        'price': price,
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      headers: {
        'Access-Control-Allow-Origin': '*',
      },
      body: {'error': e.toString()},
    );
  }
}