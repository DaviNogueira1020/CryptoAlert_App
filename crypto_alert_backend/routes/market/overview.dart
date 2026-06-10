import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/modules/market_data/market_data_service.dart';

final _marketDataService = MarketDataService();

Future<Response> onRequest(RequestContext context) async{
  final overview = await _marketDataService.getMarketOverview();

  return Response.json(
    body: overview.map((item) => item.toJson()).toList(),
  );
}