import 'package:crypto_alert_backend/core/exceptions/validation_exception.dart';
import 'package:crypto_alert_backend/modules/market_data/crypto_asset_model.dart';
import 'package:crypto_alert_backend/modules/market_data/market_data_repository.dart';
import 'package:crypto_alert_backend/modules/market_data/market_snapshot_model.dart';

class MarketDataService{
  final MarketDataRepository _repository = MarketDataRepository();

  Future<List<CryptoAsset>> getActiveAssets() async {
    return await _repository.findActiveAssets();
  }
  
  Future<List<MarketSnapshot>> getMarketSnapshots() async{
    return _repository.findAll();
  }

  Future<MarketSnapshot> saveSnapshot({
    required String symbol,
    required double priceUsd,
    double? change24h,
    double? volume24h,
  }) async{
    if(symbol.isEmpty){
      throw ValidationException('Symbol is required');
    }

    if(priceUsd <= 0){
      throw ValidationException('Price must be greater than zero');
    }

    final snapshot = MarketSnapshot(
      symbol: symbol,
      priceUsd: priceUsd,
      change24h: change24h,
      volume24h: volume24h,
      updatedAt: DateTime.now() //Temporary
    );

    await _repository.upsertSnapshot(snapshot);

    return snapshot;
  }
}