import 'package:postgres/postgres.dart';

// TODO(refactor):
// Move parseNullableDouble to utils/parsers.dart
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  return double.parse(value.toString());
}

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
      priceUsd: _parseDouble(row[1])!,
      change24h: row[2] != null ?
                _parseDouble(row[2]) : null,
      volume24h: row[3] != null ?
                _parseDouble(row[3]) : null,
      updatedAt: row[4]! as DateTime,
    );
  }
}