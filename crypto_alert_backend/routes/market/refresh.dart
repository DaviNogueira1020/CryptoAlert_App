import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/market_data/market_data_updater_service.dart';

Future<Response> onRequest(RequestContext context) async{
  final updater = MarketDataUpdaterService();

  await updater.updateMarketSnapshots();

  return Response.json(
    body: {'message': 'Market data refreshed successfully'}
  );
}