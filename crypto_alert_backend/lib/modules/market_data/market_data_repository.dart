import 'package:crypto_alert_backend/core/database/database_connection.dart';
import 'package:crypto_alert_backend/modules/market_data/market_snapshot_model.dart';
import 'package:crypto_alert_backend/modules/market_data/crypto_asset_model.dart';
import 'package:postgres/postgres.dart';

class MarketDataRepository{
    Future<List<CryptoAsset>> findActiveAssets() async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      '''
      SELECT
        symbol,
        name,
        active,
        image_url
      FROM crypto_assets
      WHERE active = TRUE
      ORDER BY symbol
      '''
    );

    return result.map(CryptoAsset.fromRow).toList();
  }

  Future<List<MarketSnapshot>> findAll() async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      '''
      SELECT
        symbol,
        price_usd,
        change_24h,
        volume_24h,
        updated_at
      FROM market_snapshots
      ORDER BY symbol
      '''
    );

    return result.map(MarketSnapshot.fromRow).toList();
  }

  Future<void> upsertSnapshot(MarketSnapshot snapshot) async{
    final connection = await DatabaseConnection.getConnection();

    await connection.execute(
      Sql.named('''
        INSERT INTO market_snapshots(
          symbol,
          price_usd,
          change_24h,
          volume_24h
        )
        VALUES(
          @symbol,
          @price_usd,
          @change_24h,
          @volume_24h
        )
        ON CONFLICT(symbol)
        DO UPDATE SET
          price_usd = EXCLUDED.price_usd,
          change_24h = EXCLUDED.change_24h,
          volume_24h = EXCLUDED.volume_24h,
          updated_at = CURRENT_TIMESTAMP
      '''),
      parameters: {
        'symbol': snapshot.symbol,
        'price_usd': snapshot.priceUsd,
        'change_24h': snapshot.change24h,
        'volume_24h': snapshot.volume24h,
      },
    );
  }
}