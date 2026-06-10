import 'dart:convert';
import 'package:crypto_alert_backend/modules/market_data/coingecko_market_data.dart';
import 'package:http/http.dart' as http;

class CoinGeckoClient {
  static const String marketsUrl = 'https://api.coingecko.com/api/v3/coins/markets';

  Future<CoinGeckoMarketData?> getCoin(String coinId) async{
    final url = Uri.parse(
      '$marketsUrl'
      '?vs_currency=usd'
      '&ids=$coinId'
      '&price_change_percentage=7d,30d',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'CoinGecko API returned status ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as List<dynamic>;

    if (data.isEmpty){
      return null;
    }

    return CoinGeckoMarketData.fromJson(
      data.first as Map<String, dynamic>,
    );
  }
}