class Alert{
  final String id;
  final String symbol;
  final double target;
  final String type; // 'above' or 'bellow'
  bool active;

  Alert({
    required this.id,
    required this.symbol,
    required this.target,
    required this.type, // 'above' or 'bellow'
    this.active = true,
  });
}

class AlertsRepository {
  final List<Alert> _alerts = [];
  
  void create(Alert alert){
    _alerts.add(alert);
  }

  List<Alert> findAll(){
    return _alerts;
  }

  List<Alert> findActive(){
    return _alerts.where((alert) => alert.active).toList();
  }
}
