import 'dart:convert';
import 'package:http/http.dart' as http;

class BinanceClient {
  static const String baseUrl =
  'https://api.binance.com/api/v3/ticker/price';

  Future<double> getPrice(String symbol) async{
    final url = Uri.parse('$baseUrl?symbol=$symbol');

    final response = await http.get(url);
    
    if(response.statusCode != 200){
      throw Exception('Binance API returned status ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final price = double.parse(data['price'] as String);

    return price;
  }
}
