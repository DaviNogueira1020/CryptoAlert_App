import 'package:postgres/postgres.dart';

class CryptoAsset{
  final String symbol;
  final String name;
  final bool active;
  final String? imageUrl;

  CryptoAsset({
    required this.symbol,
    required this.name,
    required this.active,
    this.imageUrl,
  });

  factory CryptoAsset.fromRow(ResultRow row) {
    return CryptoAsset(
      symbol: row[0]! as String,
      name: row[1]! as String,
      active: row[2]! as bool,
      imageUrl: row[3] as String?,
    );
  }
}