import 'package:crypto_alert_backend/clients/binance_client.dart';

class CryptoService {
  final BinanceClient _client = BinanceClient();

  Future<double> getPrice(String symbol) async{
    final price = await _client.getPrice(symbol);

    return price;
  }

}