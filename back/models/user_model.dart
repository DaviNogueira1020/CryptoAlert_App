/// Representa um usuário da plataforma.
///
/// Nota: [passwordHash] nunca deve ser enviado ao client após o login.
/// O campo está aqui apenas para serialização server-side se necessário.
class UserModel {
  final String id;
  final String email;
  final String? passwordHash; // opcional: omitido nas respostas de API
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    this.passwordHash,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      passwordHash: json['password_hash'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? passwordHash,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserModel(id: $id, email: $email)';
}