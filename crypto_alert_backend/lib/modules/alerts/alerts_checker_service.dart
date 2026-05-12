import 'package:crypto_alert_backend/modules/alerts/alert_type.dart';
import 'package:crypto_alert_backend/modules/alerts/alerts_service.dart';
import 'package:crypto_alert_backend/modules/crypto/crypto_service.dart';


class AlertsCheckerService{
  final AlertsService _alertsService = AlertsService();
  final CryptoService _cryptoService = CryptoService();

  Future<void> checkActiveAlerts() async{
    final alerts = _alertsService.getActiveAlerts();

    for(final alert in alerts){
      final currentPrice = await _cryptoService.getPrice(alert.symbol);

      switch (alert.type){
        case AlertType.above:
          if(currentPrice >= alert.target){
            print('[ALERT TRIGGERED] ${alert.symbol} above ${alert.target} ' 
                    '(Current price: ${currentPrice.toStringAsFixed(2)})');
          }
          break;
        case AlertType.below:
          if(currentPrice <= alert.target){
            print('[ALERT TRIGGERED] ${alert.symbol} below ${alert.target} ' 
                    '(Current price: ${currentPrice.toStringAsFixed(2)})');
          }
          break;
        default:
          break;
      }
    }
  }
}   