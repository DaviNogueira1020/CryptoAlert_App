import 'package:crypto_alert_backend/modules/alerts/alerts_repository.dart';
import 'dart:math';

class AlertsService {
  final AlertsRepository _repository = AlertsRepository();

  Alert createAlert({
    required String symbol,
    required double target,
    required String type,
  }){
    if(symbol.isEmpty){
      throw Exception('Symbol is required');
    }

    if(type != 'above' && type != 'bellow'){
      throw Exception('Type must be "above" or "bellow"');
    }

    final id = Random().nextInt(100000).toString(); // MOCK

    final alert = Alert(
      id: id,
      symbol: symbol,
      target: target,
      type: type,
    );

    _repository.create(alert);

    return alert;
  }

  List<Alert> getAlerts(){
    return _repository.findAll();
  }
}