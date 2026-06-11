import 'package:postgres/postgres.dart';
import 'package:crypto_alert_backend/utils/number_parser.dart';

class MarketSnapshot{
  final String symbol;
  
  final double priceUsd;

  final double? change24h;
  final double? change7d;
  final double? change30d;

  final double? volume24h;
  
  final double? marketCap;
  final double? circulatingSupply;
  final double? totalSupply;

  final DateTime updatedAt;

  MarketSnapshot({
    required this.symbol,
    required this.priceUsd,
    this.change24h,
    this.change7d,
    this.change30d,
    this.volume24h,
    this.marketCap,
    this.circulatingSupply,
    this.totalSupply,
    required this.updatedAt,
  });

  factory MarketSnapshot.fromRow(ResultRow row){
    return MarketSnapshot(
      symbol: row[0]! as String,
      
      priceUsd: parseDouble(row[1])!,
      
      change24h: row[2] != null ?
                parseDouble(row[2]) : null,
      change7d: row[3] != null ?
                parseDouble(row[3]) : null,
      change30d: row[4] != null ?
                parseDouble(row[4]) : null,
      
      volume24h: row[5] != null ?
                parseDouble(row[5]) : null,
      
      marketCap: row[6] != null ?
                parseDouble(row[6]) : null,
      circulatingSupply: row[7] != null ?
                parseDouble(row[7]) : null,          
      totalSupply: row[8] != null ?
                parseDouble(row[8]) : null,

      updatedAt: row[9]! as DateTime,
       
    );
  }
}