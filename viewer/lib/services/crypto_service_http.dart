import 'package:mobile/services/http_service.dart';
import 'package:mobile/config/api_config.dart';

/// Modelo para preço de criptomoeda
class CryptoPrice {
  final String symbol;
  final double price;

  CryptoPrice({
    required this.symbol,
    required this.price,
  });

  factory CryptoPrice.fromJson(Map<String, dynamic> json) {
    return CryptoPrice(
      symbol: json['symbol'] ?? '',
      price: (json['price'] is num) ? json['price'].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'price': price,
  };
}

/// Serviço para dados de criptomoedas
class CryptoService {
  static final CryptoService _instance = CryptoService._internal();
  final HttpService _httpService = HttpService();

  factory CryptoService() {
    return _instance;
  }

  CryptoService._internal();

  /// Obtém preço de uma criptomoeda da API
  Future<CryptoPrice> getPrice(String symbol) async {
    try {
      final response = await _httpService.getWithParams(
        ApiConfig.cryptoPriceEndpoint,
        queryParams: {'symbol': symbol},
      );
      
      return CryptoPrice.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao obter preço de $symbol: $e');
    }
  }

  /// Obtém preços de múltiplas criptomoedas
  Future<List<CryptoPrice>> getPrices(List<String> symbols) async {
    try {
      final prices = <CryptoPrice>[];
      
      for (final symbol in symbols) {
        try {
          final price = await getPrice(symbol);
          prices.add(price);
        } catch (e) {
          print('Erro ao obter preço de $symbol: $e');
          // Continua com próximo símbolo
        }
      }
      
      return prices;
    } catch (e) {
      throw Exception('Erro ao obter múltiplos preços: $e');
    }
  }
}
