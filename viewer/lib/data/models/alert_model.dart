// Modelo de Alerta para desserializar dados vindo da API
class AlertModel {
  // ID único do alerta
  final String id;
  
  // Símbolo da criptomoeda (ex: BTCUSDT)
  final String symbol;
  
  // Preço-alvo para gatilhar o alerta
  final double target;
  
  // Tipo de alerta: 'above' (acima) ou 'below' (abaixo)
  final String type;
  
  // Se o alerta está ativo ou não
  final bool active;

  AlertModel({
    required this.id,
    required this.symbol,
    required this.target,
    required this.type,
    required this.active,
  });

  // Converte JSON vindo da API para objeto AlertModel
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      target: (json['target'] as num).toDouble(),
      type: json['type'] as String,
      active: json['active'] as bool,
    );
  }

  // Converte AlertModel para JSON para enviar à API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'target': target,
      'type': type,
      'active': active,
    };
  }

  // Cria uma cópia do AlertModel com alguns campos modificados
  AlertModel copyWith({
    String? id,
    String? symbol,
    double? target,
    String? type,
    bool? active,
  }) {
    return AlertModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      target: target ?? this.target,
      type: type ?? this.type,
      active: active ?? this.active,
    );
  }

  @override
  String toString() => 'AlertModel(id: $id, symbol: $symbol, target: $target, type: $type, active: $active)';
}
