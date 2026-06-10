import 'package:crypto_alert_backend/modules/crypto/crypto_service.dart';
import 'package:crypto_alert_backend/clients/coingecko_client.dart';
import 'package:crypto_alert_backend/modules/market_data/coingecko_market_data.dart';
import 'package:crypto_alert_backend/modules/market_data/market_data_service.dart';

class MarketDataUpdaterService{
  final MarketDataService _marketDataService = MarketDataService();
  final CryptoService _cryptoService = CryptoService();
  final CoinGeckoClient _coingeckoClient = CoinGeckoClient();

  Future<void> updateMarketSnapshots() async{
    final assets = await _marketDataService.getActiveAssets();

    print('[MARKET DATA UPDATING] Starting...');

    for(final asset in assets){
      try{
        final ticker = await _cryptoService.getTicker(asset.symbol);

        CoinGeckoMarketData? marketData;

        if(asset.coingeckoId != null){
          print(
            '[COINGECKO REQUEST] '
            '${asset.symbol} -> ${asset.coingeckoId}',
          );

          try{
            marketData = await _coingeckoClient.getCoin(
              asset.coingeckoId!,
            );
          } catch(e){
            print(
              '[COINGECKO ERROR] '
              '${asset.symbol}: $e',
            );

            marketData = null;
          }

          await Future.delayed( //TODO(refactor): This is a gambiarra to keep gecko working, as it hits
            const Duration(seconds: 3),// the requisition limit when there's not a delay
          );
        }

        await _marketDataService.saveSnapshot(
          symbol: asset.symbol,

          priceUsd: ticker.price,

          change24h: ticker.change24h,
          change7d: marketData?.change7d,
          change30d: marketData?.change30d,

          volume24h: ticker.volume24h,

          marketCap: marketData?.marketCap,
          circulatingSupply: marketData?.circulatingSupply,
          totalSupply: marketData?.totalSupply,
        );

        print(
          '[MARKET SNAPSHOT UPDATED] '
          '${ticker.symbol}: \$${ticker.price.toStringAsFixed(2)} '
          '(24h: ${ticker.change24h?.toStringAsFixed(2)}%) '
          '(7d: ${marketData?.change7d?.toStringAsFixed(2) ?? 'N/A'}%)',
        );
      } catch(e, stackTrace){
        print(
          '[MARKET UPDATE ERROR] '
          '${asset.symbol}: $e',
        );

        print(stackTrace);
      }
    }

    print(
      '[MARKET DATA UPDATING] '
      'All market snapshots were updated successfully',
    );
  }
}