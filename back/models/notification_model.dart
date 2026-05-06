/// Notificação gerada pelo backend ao disparar um alerta de preço.
///
/// [alertId] pode ser null quando o alerta foi deletado (ON DELETE SET NULL).
class NotificationModel {
  final String id;
  final String userId;
  final String? alertId; // nullable: SET NULL ao deletar o alerta
  final String message;
  final bool read;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    this.alertId,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      alertId: json['alert_id'] as String?,
      message: json['message'] as String,
      read: json['read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'alert_id': alertId,
      'message': message,
      'read': read,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? alertId,
    String? message,
    bool? read,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      alertId: alertId ?? this.alertId,
      message: message ?? this.message,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'NotificationModel(id: $id, userId: $userId, read: $read)';
}