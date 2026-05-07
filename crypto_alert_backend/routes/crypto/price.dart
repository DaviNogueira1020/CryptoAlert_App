import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/crypto/crypto_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final symbol = context.request.uri.queryParameters['symbol'];

  if (symbol == null) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Symbol is required'},
    );
  }

  try {
    final service = CryptoService();
    final price = await service.getPrice(symbol);

    return Response.json(
      body: {
        'symbol': symbol,
        'price': price,
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': e.toString()},
    );
  }
}