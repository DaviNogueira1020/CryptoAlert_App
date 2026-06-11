// Modelo de Dados de Mercado para desserializar dados vindo da API
class MarketDataModel {
  // Símbolo do ativo (ex: BTCUSDT, ETHUSDT)
  final String symbol;
  
  // Nome da criptomoeda (ex: Bitcoin, Ethereum)
  final String name;
  
  // URL da imagem/logo da criptomoeda
  final String? imageUrl;
  
  // Preço atual em USD
  final double priceUsd;
  
  // Variação percentual nas últimas 24h (ainda em implementação)
  final double? change24h;
  
  // Volume negociado nas últimas 24h (ainda em implementação)
  final double? volume24h;
  
  // Data e hora da última atualização
  final DateTime updatedAt;

  MarketDataModel({
    required this.symbol,
    required this.name,
    this.imageUrl,
    required this.priceUsd,
    this.change24h,
    this.volume24h,
    required this.updatedAt,
  });

  // Converte JSON vindo da API para objeto MarketDataModel
  factory MarketDataModel.fromJson(Map<String, dynamic> json) {
    return MarketDataModel(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      priceUsd: (json['price_usd'] as num).toDouble(),
      change24h: json['change_24h'] != null ? (json['change_24h'] as num).toDouble() : null,
      volume24h: json['volume_24h'] != null ? (json['volume_24h'] as num).toDouble() : null,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Converte MarketDataModel para JSON para enviar à API
  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'image_url': imageUrl,
      'price_usd': priceUsd,
      'change_24h': change24h,
      'volume_24h': volume24h,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Cria uma cópia do MarketDataModel com alguns campos modificados
  MarketDataModel copyWith({
    String? symbol,
    String? name,
    String? imageUrl,
    double? priceUsd,
    double? change24h,
    double? volume24h,
    DateTime? updatedAt,
  }) {
    return MarketDataModel(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      priceUsd: priceUsd ?? this.priceUsd,
      change24h: change24h ?? this.change24h,
      volume24h: volume24h ?? this.volume24h,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'MarketDataModel(symbol: $symbol, name: $name, priceUsd: $priceUsd, updatedAt: $updatedAt)';
}
