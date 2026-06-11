// Modelo de Notificação para desserializar dados vindo da API
class NotificationModel {
  // ID único da notificação
  final String id;
  
  // Mensagem de texto da notificação
  final String message;
  
  // Se a notificação foi lida ou não
  final bool isRead;
  
  // Data e hora em que a notificação foi criada
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  // Converte JSON vindo da API para objeto NotificationModel
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      message: json['message'] as String,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Converte NotificationModel para JSON para enviar à API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Cria uma cópia da NotificationModel com alguns campos modificados
  NotificationModel copyWith({
    String? id,
    String? message,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'NotificationModel(id: $id, message: $message, isRead: $isRead, createdAt: $createdAt)';
}
