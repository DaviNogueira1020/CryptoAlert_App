import 'package:postgres/postgres.dart';
import 'package:crypto_alert_backend/utils/number_parser.dart';

class MarketOverview{
  final String symbol;
  final String name;
  final String? imageUrl;

  final double priceUsd;
  final double? change24h;
  final double? volume24h;

  final DateTime updatedAt;

  MarketOverview({
    required this.symbol,
    required this.name,
    this.imageUrl,
    required this.priceUsd,
    this.change24h,
    this.volume24h,
    required this.updatedAt,
  });

  factory MarketOverview.fromRow(ResultRow row){
    return MarketOverview(
      symbol: row[0]! as String,
      name: row[1]! as String,
      imageUrl: row[2] as String?,
      priceUsd: parseDouble(row[3])!,
      change24h: row[4] != null ?
                parseDouble(row[4]) : null,
      volume24h: row[5] != null ? 
                parseDouble(row[5]) : null,
      updatedAt: row[6]! as DateTime,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'symbol': symbol,
      'name': name,
      'image_url': imageUrl,
      'price_usd': priceUsd,
      'change_24h': change24h,
      'volume_24h': volume24h,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}