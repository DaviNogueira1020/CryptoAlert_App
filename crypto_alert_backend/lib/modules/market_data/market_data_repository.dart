import 'package:crypto_alert_backend/core/database/database_connection.dart';
import 'package:crypto_alert_backend/modules/market_data/market_snapshot_model.dart';
import 'package:crypto_alert_backend/modules/market_data/crypto_asset_model.dart';
import 'package:crypto_alert_backend/modules/market_data/market_overview_model.dart';
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
        image_url,
        coingecko_id
      FROM crypto_assets
      WHERE active = TRUE
      ORDER BY symbol
      '''
    );

    return result.map(CryptoAsset.fromRow).toList();
  }

  Future<List<MarketOverview>> findOverview() async { //TODO: change it to display all info after working on MarketOverview
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      '''
      SELECT
        a.symbol,
        a.name,
        a.image_url,
        s.price_usd,
        s.change_24h,
        s.change_7d,
        s.change_30d,
        s.volume_24h,
        s.market_cap,
        s.circulating_supply,
        s.total_supply,
        s.updated_at
      FROM crypto_assets a
      JOIN market_snapshots s
        ON a.symbol = s.symbol
      WHERE a.active = TRUE
      ORDER BY a.symbol
      '''
    );

    return result.map(MarketOverview.fromRow).toList();
  }

  Future<List<MarketSnapshot>> findAll() async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      '''
      SELECT
        symbol,
        price_usd,
        change_24h,
        change_7d,
        change_30d,
        volume_24h,
        market_cap,
        circulating_supply,
        total_supply,
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
          change_7d,
          change_30d,
          volume_24h,
          market_cap,
          circulating_supply,
          total_supply
        )
        VALUES(
          @symbol,
          @price_usd,
          @change_24h,
          @change_7d,
          @change_30d,
          @volume_24h,
          @market_cap,
          @circulating_supply,
          @total_supply
        )
        ON CONFLICT(symbol)
        DO UPDATE SET
          price_usd = EXCLUDED.price_usd,
          change_24h = EXCLUDED.change_24h,
          change_7d = EXCLUDED.change_7d,
          change_30d = EXCLUDED.change_30d,
          volume_24h = EXCLUDED.volume_24h,
          market_cap = EXCLUDED.market_cap,
          circulating_supply = EXCLUDED.circulating_supply,
          total_supply = EXCLUDED.total_supply,
          updated_at = CURRENT_TIMESTAMP
      '''),
      parameters: {
        'symbol': snapshot.symbol,

        'price_usd': snapshot.priceUsd,
        
        'change_24h': snapshot.change24h,
        'change_7d': snapshot.change7d,
        'change_30d': snapshot.change30d,
        
        'volume_24h': snapshot.volume24h,

        'market_cap': snapshot.marketCap,
        'circulating_supply': snapshot.circulatingSupply,
        'total_supply': snapshot.totalSupply,
      },
    );
  }
}