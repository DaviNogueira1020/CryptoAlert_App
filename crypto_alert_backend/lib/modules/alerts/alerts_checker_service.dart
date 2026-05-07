import 'package:crypto_alert_backend/modules/alerts/alerts_service.dart';
import 'package:crypto_alert_backend/modules/crypto/crypto_service.dart';


class AlertsCheckerService{
  final AlertsService _alertsService = AlertsService();
  final CryptoService _cryptoService = CryptoService();

  Future<void> checkAllAlerts() async{
    final alerts = _alertsService.getAlerts();

    for(final alert in alerts){
      if(!alert.active){
        continue;
      }

      final currentPrice = await _cryptoService.getPrice(alert.symbol);

      switch (alert.type){
        case 'above':
          if(currentPrice >= alert.target){
            print('[ALERT TRIGGERED] ${alert.symbol} above ${alert.target}');
          }
          break;
        case 'bellow':
          if(currentPrice <= alert.target){
            print('[ALERT TRIGGERED] ${alert.symbol} below ${alert.target}');
          }
          break;
        default:
          break;
      }
    }
  }
}   