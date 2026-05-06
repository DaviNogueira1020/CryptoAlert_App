import 'package:dart_frog/dart_frog.dart';
import '../../lib/modules/crypto/crypto_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final symbol = context.request.uri.queryParameters['symbol'];

  final service = CryptoService();
  final price = await service.getPreco(symbol!);

  return Response.json(
    body: {'symbol': symbol, 'price': price},
  );
}