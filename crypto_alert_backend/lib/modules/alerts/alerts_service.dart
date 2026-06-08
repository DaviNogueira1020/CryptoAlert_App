import 'package:crypto_alert_backend/modules/alerts/alert_type.dart';
import 'package:crypto_alert_backend/modules/alerts/alerts_repository.dart';
import 'dart:math';

class AlertsService {
  final AlertsRepository _repository = AlertsRepository();
  
  Future<Alert> createAlert({
    required String symbol,
    required double target,
    required AlertType type,
  }) async{
    if(symbol.isEmpty){
      throw Exception('Symbol is required');
    }

    final id = Random().nextInt(100000).toString(); // MOCK

    final alert = Alert(
      id: id,
      symbol: symbol,
      target: target,
      type: type,
    );

    await _repository.create(alert);

    return alert;
  }

  Future<List<Alert>> getAlerts() async{
    return await _repository.findAll();
  }

  Future<List<Alert>> getActiveAlerts() async{      
    return await _repository.findActive();
  }

  Future<Alert> toggleAlertStatus(String id) async{
    final toggledAlert = await _repository.toggleStatus(id);
  
    return toggledAlert;
  }

  Future<Alert> updateAlert(
    String id, {
    String? symbol, 
    double? target, 
    AlertType? type
  }) async{
    final updatedAlert = await _repository.update(
      id,
      symbol: symbol,
      target: target,
      type: type
    );
    
    return updatedAlert;
  }

  Future<Alert> deleteAlert(String id) async{
    final deletedAlert = await _repository.delete(id);

    return deletedAlert;
  }
}