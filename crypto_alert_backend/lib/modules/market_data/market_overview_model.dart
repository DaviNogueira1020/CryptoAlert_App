import 'package:postgres/postgres.dart';
import 'package:crypto_alert_backend/utils/number_parser.dart';

class MarketOverview{
  final String symbol;
  final String name;
  final String? imageUrl;

  final double priceUsd;
  
  final double? change24h;
  final double? change7d;
  final double? change30d;

  final double? volume24h;

  final double? marketCap;
  final double? circulatingSupply;
  final double? totalSupply;

  final DateTime updatedAt;

  MarketOverview({
    required this.symbol,
    required this.name,
    this.imageUrl,
    
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

  factory MarketOverview.fromRow(ResultRow row){
    return MarketOverview(
      symbol: row[0]! as String,
      name: row[1]! as String,
      imageUrl: row[2] as String?,
      
      priceUsd: parseDouble(row[3])!,
      
      change24h: row[4] != null ?
                parseDouble(row[4]) : null,
      change7d: row[5] != null ?
                parseDouble(row[5]) : null,
      change30d: row[6] != null ?
                parseDouble(row[6]) : null,
      
      volume24h: row[7] != null ? 
                parseDouble(row[7]) : null,

      marketCap: row[8] != null ?
                parseDouble(row[8]) : null,
      circulatingSupply: row[9] != null ?
                parseDouble(row[9]) : null,
      totalSupply: row[10] != null ?
                parseDouble(row[10]) : null,
      
      updatedAt: row[11]! as DateTime,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'symbol': symbol,
      'name': name,
      'image_url': imageUrl,
      
      'price_usd': priceUsd,
      
      'change_24h': change24h,
      'change_7d': change7d,
      'change_30d': change30d,
      
      'volume_24h': volume24h,

      'market_cap': marketCap,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}