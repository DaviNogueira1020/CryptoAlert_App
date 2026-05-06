import 'alert_type.dart';

/// Alerta de preço configurado pelo usuário.
///
/// [target] é mantido como [double] no cliente. Para cenários que exijam
/// precisão total de 18,8 casas, considere o pacote `decimal`.
class AlertModel {
  final String id;
  final String userId;
  final String symbol;     // ex: 'BTCUSDT'
  final AlertType type;    // AlertType.above | AlertType.below
  final double target;     // NUMERIC(18,8) → double no Dart
  final bool active;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AlertModel({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.type,
    required this.target,
    required this.active,
    required this.createdAt,
    this.updatedAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      symbol: json['symbol'] as String,
      type: AlertType.fromString(json['type'] as String),
      // NUMERIC vem como string do postgres driver para evitar perda de precisão
      target: double.parse(json['target'].toString()),
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'symbol': symbol,
      'type': type.value,
      'target': target,
      'active': active,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  AlertModel copyWith({
    String? id,
    String? userId,
    String? symbol,
    AlertType? type,
    double? target,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AlertModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      type: type ?? this.type,
      target: target ?? this.target,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AlertModel(id: $id, symbol: $symbol, type: ${type.value}, '
      'target: $target, active: $active)';
}