import 'package:crypto_alert_backend/clients/binance_client.dart';
import 'package:crypto_alert_backend/modules/crypto/crypto_ticker.dart';

class CryptoService {
  final BinanceClient _client = BinanceClient();

  Future<double> getPrice(String symbol) async{
    final price = await _client.getPrice(symbol);

    return price;
  }

  Future<CryptoTicker> getTicker(String symbol) async{
    final ticker = await _client.getTicker(symbol);

    return ticker;
  }
}