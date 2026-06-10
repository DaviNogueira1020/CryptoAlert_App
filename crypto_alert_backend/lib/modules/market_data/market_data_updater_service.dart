import 'package:crypto_alert_backend/modules/crypto/crypto_service.dart';
import 'package:crypto_alert_backend/modules/market_data/market_data_service.dart';

class MarketDataUpdaterService{
  final MarketDataService _marketDataService = MarketDataService();
  final CryptoService _cryptoService = CryptoService();

  Future<void> updateMarketSnapshots() async{
    final assets = await _marketDataService.getActiveAssets();

    for(final asset in assets){
      final price = await _cryptoService.getPrice(asset.symbol);

      await _marketDataService.saveSnapshot(
        symbol: asset.symbol,
        priceUsd: price,
      );

      print('[MARKET SNAPSHOT UPDATED] '
            '${asset.symbol}: \$${price.toStringAsFixed(2)}');
    }
  }
}