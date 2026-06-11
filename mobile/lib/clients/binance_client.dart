import 'dart:convert';
import 'package:crypto_alert_backend/modules/crypto/crypto_ticker.dart';
import 'package:http/http.dart' as http;

class BinanceClient {
  static const String tickerPriceUrl = 'https://api.binance.com/api/v3/ticker/price';

  static const String ticker24hUrl = 'https://api.binance.com/api/v3/ticker/24hr';

  Future<double> getPrice(String symbol) async{
    final url = Uri.parse('$tickerPriceUrl?symbol=$symbol');

    final response = await http.get(url);
    
    if(response.statusCode != 200){
      throw Exception('Binance API returned status ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final price = double.parse(data['price'] as String);

    return price;
  }

  Future<CryptoTicker> getTicker(String symbol) async{
    final url = Uri.parse('$ticker24hUrl?symbol=$symbol');

    final response = await http.get(url);

    if (response.statusCode != 200){
      throw Exception(
        'Binance API returned status ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return CryptoTicker(
      symbol: data['symbol'] as String,
      price: double.parse(data['lastPrice'] as String),
      change24h: double.parse(data['priceChangePercent'] as String),
      volume24h: double.parse(data['volume'] as String)
    );
  }
}
