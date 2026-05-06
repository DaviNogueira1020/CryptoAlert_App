/// Enum seguro para o campo CHECK do banco

/// Direção do alerta de preço, espelhando o CHECK constraint do banco.
enum AlertType {
  above('above'),
  below('below');

  final String value;
  const AlertType(this.value);

  /// Deserializa a partir do valor string vindo do banco / API.
  static AlertType fromString(String raw) {
    return AlertType.values.firstWhere(
      (e) => e.value == raw,
      orElse: () => throw ArgumentError('AlertType inválido: "$raw"'),
    );
  }

  @override
  String toString() => value;
}