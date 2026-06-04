class Alerta {
  final String moeda;
  final double precoAlvo;
  final String titulo;
  final String descricao;

  Alerta({
    required this.moeda,
    required this.precoAlvo,
    this.titulo = '',
    this.descricao = '',
  });
}
