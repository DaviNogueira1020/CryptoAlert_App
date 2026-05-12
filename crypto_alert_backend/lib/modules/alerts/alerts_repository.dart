class Alert{
  final String id;
  final String symbol;
  final double target;
  final String type; // 'above' or 'below'
  final bool active;

  Alert({
    required this.id,
    required this.symbol,
    required this.target,
    required this.type, // 'above' or 'below'
    this.active = true,
  });

  Alert copyWith({
    String? symbol,
    double? target,
    String? type,
    bool? active,
  }) {
    return Alert(
      id: id,
      symbol: symbol ?? this.symbol,
      target: target ?? this.target,
      type: type ?? this.type,
      active: active ?? this.active,
    );
  }
}

class AlertsRepository {
  final List<Alert> _alerts = [];
  
  void create(Alert alert){
    _alerts.add(alert);
  }

  int _getAlertIndex(String id){
    final index = _alerts.indexWhere((alert) => alert.id == id);

    if(index == -1){
      throw Exception('Alert [ID: $id] not found');
    }

    return index;
  }

  List<Alert> findAll(){
    return List.unmodifiable(_alerts);
  }

  List<Alert> findActive(){
    return _alerts.where((alert) => alert.active).toList();
  }

  Alert toggleStatus(String id){
    final index = _getAlertIndex(id);

    final toggledAlert = _alerts[index].copyWith(active: !_alerts[index].active);

    _alerts[index] = toggledAlert;

    return _alerts[index];
  }

  Alert update(
    String id, {
    String? symbol,
    double? target,
    String? type,
  }) {
    final index = _getAlertIndex(id);
    
    final updatedAlert = _alerts[index].copyWith(
      symbol: symbol, target: target, type: type);
    
    _alerts[index] = updatedAlert;

    return _alerts[index];
  }

  Alert delete(String? id){
    final index = _getAlertIndex(id!);
    
    final deletedAlert = _alerts[index];

    _alerts.removeAt(index);

    return deletedAlert;
  }
}
