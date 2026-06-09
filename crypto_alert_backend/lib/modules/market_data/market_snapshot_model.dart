import 'package:postgres/postgres.dart';

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
      priceUsd: (row[1]! as num).toDouble(),
      change24h: row[2] != null ?
      (row[2]! as num).toDouble() : null,
      volume24h: row[3] != null ?
      (row[3]! as num).toDouble() : null,
      updatedAt: row[4]! as DateTime,
    );
  }
}