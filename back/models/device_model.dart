/// Dispositivo físico vinculado a um usuário, portador do token FCM.
class DeviceModel {
  final String id;
  final String userId;
  final String fcmToken;
  final DateTime createdAt;

  const DeviceModel({
    required this.id,
    required this.userId,
    required this.fcmToken,
    required this.createdAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fcmToken: json['fcm_token'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'fcm_token': fcmToken,
      'created_at': createdAt.toIso8601String(),
    };
  }

  DeviceModel copyWith({
    String? id,
    String? userId,
    String? fcmToken,
    DateTime? createdAt,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeviceModel(id: $id, userId: $userId)';
}