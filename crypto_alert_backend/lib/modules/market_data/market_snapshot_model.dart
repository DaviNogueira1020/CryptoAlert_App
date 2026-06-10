import 'package:postgres/postgres.dart';
import 'package:crypto_alert_backend/utils/number_parser.dart';

class MarketSnapshot{
  final String symbol;
  final double priceUsd;
  final double? change24h;
  final double? volume24h;
  final DateTime updatedAt;

  MarketSnapshot({
    required this.symbol,
    required this.priceUsd,
    this.change24h,
    this.volume24h,
    required this.updatedAt,
  });

  factory MarketSnapshot.fromRow(ResultRow row){
    return MarketSnapshot(
      symbol: row[0]! as String,
      priceUsd: parseDouble(row[1])!,
      change24h: row[2] != null ?
                parseDouble(row[2]) : null,
      volume24h: row[3] != null ?
                parseDouble(row[3]) : null,
      updatedAt: row[4]! as DateTime,
    );
  }
}