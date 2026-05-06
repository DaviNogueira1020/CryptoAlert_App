/// Modelo VOLÁTIL (não persistido)
/// Snapshot de preço em tempo real vindo diretamente da API Binance.
///
/// NÃO é persistido no banco. Vive apenas em memória / estado reativo.
/// Estrutura compatível com o endpoint GET /api/v3/ticker/price da Binance.
class CryptoPriceModel {
  final String symbol;
  final double price;
  final DateTime fetchedAt;

  const CryptoPriceModel({
    required this.symbol,
    required this.price,
    required this.fetchedAt,
  });

  factory CryptoPriceModel.fromJson(Map<String, dynamic> json) {
    return CryptoPriceModel(
      symbol: json['symbol'] as String,
      price: double.parse(json['price'] as String), // Binance retorna string
      fetchedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'price': price.toString(),
      'fetched_at': fetchedAt.toIso8601String(),
    };
  }

  CryptoPriceModel copyWith({
    String? symbol,
    double? price,
    DateTime? fetchedAt,
  }) {
    return CryptoPriceModel(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  String toString() => 'CryptoPriceModel(symbol: $symbol, price: $price)';
}