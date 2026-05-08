import 'dart:async';
import 'package:crypto_alert_backend/modules/alerts/alerts_checker_service.dart';

class AlertsScheduler{
  final AlertsCheckerService _checkerService = AlertsCheckerService();

  void start(){
    print('[SCHEDULER] Starting alerts scheduler...');
  
    Timer.periodic(
      const Duration(minutes: 1),
      (_) async{
        print('[SCHEDULER] Running alerts check...');
        await _checkerService.checkAllAlerts();
      },
    );
  }
}