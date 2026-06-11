import 'package:crypto_alert_backend/modules/alerts/alert_type.dart';
import 'package:postgres/postgres.dart';

class Alert{
  final String id;
  final String symbol;
  final double target;
  final AlertType type; // 'above' or 'below'
  final bool active;

  Alert({
    required this.id,
    required this.symbol,
    required this.target,
    required this.type, // 'above' or 'below'
    this.active = true,
  });

  factory Alert.fromRow(ResultRow row) {
    return Alert(
      id: row[0]! as String,
      symbol: row[1]! as String,
      target: (row[2]! as num).toDouble(),
      type: AlertTypeExtension.fromString(
        row[3]! as String,
      ),
      active: row[4]! as bool,
    );
  }

  Alert copyWith({
    String? symbol,
    double? target,
    AlertType? type,
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