import 'package:crypto_alert_backend/modules/alerts/alerts_repository.dart';
import 'package:crypto_alert_backend/core/database/mock_database.dart';
import 'dart:math';

class AlertsService {
  final AlertsRepository _repository = alertsRepository;
  
  Alert createAlert({
    required String symbol,
    required double target,
    required String type,
  }){
    if(symbol.isEmpty){
      throw Exception('Symbol is required');
    }

    if(type != 'above' && type != 'below'){
      throw Exception('Type must be "above" or "below"');
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

  List<Alert> getActiveAlerts(){      
    return _repository.findActive();
  }

  Alert toggleAlertStatus(String id){
    final toggledAlert = _repository.toggleStatus(id);
  
    return toggledAlert;
  }

  Alert updateAlert(
    String id, {
    String? symbol, 
    double? target, 
    String? type
  }) {
    final updatedAlert = _repository.update(
      id,
      symbol: symbol,
      target: target,
      type: type
    );
    
    return updatedAlert;
  }

  Alert deleteAlert(String id){
    final deletedAlert = _repository.delete(id);

    return deletedAlert;
  }
}