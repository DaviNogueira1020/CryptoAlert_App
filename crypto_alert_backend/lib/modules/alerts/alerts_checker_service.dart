import 'package:crypto_alert_backend/modules/alerts/alert_type.dart';
import 'package:crypto_alert_backend/modules/alerts/alerts_service.dart';
import 'package:crypto_alert_backend/modules/crypto/crypto_service.dart';
import 'package:crypto_alert_backend/modules/notifications/notifications_service.dart';


class AlertsCheckerService{
  final AlertsService _alertsService = AlertsService();
  final CryptoService _cryptoService = CryptoService();
  final NotificationsService _notificationsService = NotificationsService();

  Future<void> checkActiveAlerts() async{
    final alerts = await _alertsService.getActiveAlerts();

    for(final alert in alerts){
      final currentPrice = await _cryptoService.getPrice(alert.symbol);

      switch (alert.type){
        case AlertType.above:
          if(currentPrice >= alert.target){
            final notification = await _notificationsService.createNotification(
              alertId: alert.id,
              title: 'Price Alert Triggered',
              message: '${alert.symbol} is above ${alert.target} '
                       '(Current price: ${currentPrice.toStringAsFixed(2)})',
            );
            
            print('[NOTIFICATION CREATED] ${notification.title}:\n'
                  '${notification.message})');
          }
          break;
        case AlertType.below:
          if(currentPrice <= alert.target){
            final notification = await _notificationsService.createNotification(
              alertId: alert.id,
              title: 'Price Alert Triggered',
              message: '${alert.symbol} is below ${alert.target} '
                       '(Current price: ${currentPrice.toStringAsFixed(2)})',
            );
            
            print('[NOTIFICATION CREATED] ${notification.title}:\n'
                  '${notification.message}');
          }
          break;
      }
    } 
  }
}   