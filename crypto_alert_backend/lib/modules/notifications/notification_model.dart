class AppNotification {
  final String id;
  final String alertId;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool read;

  AppNotification({
    required this.id,
    required this.alertId,
    required this.title,
    required this.message,
    this.read = false,
  }) : createdAt = DateTime.now();

  AppNotification copyWith({
    String? title,
    String? message,
    bool? read,
  }) {
    return AppNotification(
      id: id,
      alertId: alertId,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
    );
  }
}