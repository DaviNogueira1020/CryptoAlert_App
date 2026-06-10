// Modelo que representa um alerta criado pelo usuário
class Alerta {
  final String cripto;           // ex: BTC, ETH
  final String tipoAlerta;
  final String porcentual;
  final bool condicaoCima;       // true = alerta de alta, false = alerta de baixa
  final String titulo;
  final String prioridade;
  final String tipoNotificacao;
  final String repeticao;
  final String descricao;
  final String data;
  final String hora;
  bool ativo;                    // mudar status do alearta entre ativo e inativo

  Alerta({
    required this.cripto,
    required this.tipoAlerta,
    required this.porcentual,
    required this.condicaoCima,
    required this.titulo,
    required this.prioridade,
    required this.tipoNotificacao,
    required this.repeticao,
    required this.descricao,
    required this.data,
    required this.hora,
    this.ativo = true,
  });

  // converte o alerta para texto para salvar no ambiente
  Map<String, dynamic> toJson() => {
    'cripto': cripto,
    'tipoAlerta': tipoAlerta,
    'porcentual': porcentual,
    'condicaoCima': condicaoCima,
    'titulo': titulo,
    'prioridade': prioridade,
    'tipoNotificacao': tipoNotificacao,
    'repeticao': repeticao,
    'descricao': descricao,
    'data': data,
    'hora': hora,
    'ativo': ativo,
  };

  // recria um alerta a partir do texto salvo quando reiniciar o app
  factory Alerta.fromJson(Map<String, dynamic> json) => Alerta(
    cripto: json['cripto'] ?? '',
    tipoAlerta: json['tipoAlerta'] ?? '',
    porcentual: json['porcentual'] ?? '',
    condicaoCima: json['condicaoCima'] ?? true,
    titulo: json['titulo'] ?? '',
    prioridade: json['prioridade'] ?? 'Alta',
    tipoNotificacao: json['tipoNotificacao'] ?? 'Sistema',
    repeticao: json['repeticao'] ?? 'Diariamente',
    descricao: json['descricao'] ?? '',
    data: json['data'] ?? '',
    hora: json['hora'] ?? '',
    ativo: json['ativo'] ?? true,
  );
}
