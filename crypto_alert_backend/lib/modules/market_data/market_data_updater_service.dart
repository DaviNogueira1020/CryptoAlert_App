import 'package:crypto_alert_backend/modules/crypto/crypto_service.dart';
import 'package:crypto_alert_backend/modules/market_data/market_data_service.dart';

class MarketDataUpdaterService{
  final MarketDataService _marketDataService = MarketDataService();
  final CryptoService _cryptoService = CryptoService();

  Future<void> updateMarketSnapshots() async{
    final assets = await _marketDataService.getActiveAssets();

    print('[MARKET DATA UPDATING] Starting...');

    for(final asset in assets){
      final ticker = await _cryptoService.getTicker(asset.symbol);

      await _marketDataService.saveSnapshot(
        symbol: ticker.symbol,
        priceUsd: ticker.price,
        change24h: ticker.change24h,
        volume24h: ticker.volume24h
      );

      print('[MARKET SNAPSHOT UPDATED] '
            '${ticker.symbol}: \$${ticker.price.toStringAsFixed(2)} '
            '(24h: ${ticker.change24h?.toStringAsFixed(2)}%)'
      );
    }

    print('[MARKET DATA UPDATING] All market snapshots were updated successfully');
  }
}