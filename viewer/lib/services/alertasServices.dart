// Gerencia todos os alertas do app: salva, carrega, adiciona, remove e ativa/desativa.
// Os dados são salvos no dispositivo, então continuam existindo após fechar o app.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile/models/alerta_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertasService {
  static final List<Alerta> alertas = [];

  // Número que aumenta a cada mudança. As telas que escutam ele se atualizam automaticamente.
  static final ValueNotifier<int> tick = ValueNotifier(0);

  static int _totalCriados = 0;

  // Total histórico de alertas criados (nunca diminui, mesmo ao deletar)
  static int get totalAlertas => _totalCriados;

  // Quantidade de alertas que estão ativos no momento
  static int get alertasAtivos => alertas.where((a) => a.ativo).length;

  // Lê os alertas salvos no dispositivo ao abrir o app
  static Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    _totalCriados = prefs.getInt('alertas_total_criados') ?? 0;
    final raw = prefs.getStringList('alertas_lista') ?? [];
    alertas
      ..clear()
      ..addAll(raw.map((s) => Alerta.fromJson(jsonDecode(s) as Map<String, dynamic>)));
    tick.value++;
  }

  // Salva a lista de alertas no dispositivo (chamado automaticamente após qualquer mudança)
  static Future<void> _salvar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('alertas_total_criados', _totalCriados);
    await prefs.setStringList(
      'alertas_lista',
      alertas.map((a) => jsonEncode(a.toJson())).toList(),
    );
  }

  static void adicionar(Alerta alerta) {
    alertas.add(alerta);
    _totalCriados++;
    tick.value++;
    _salvar();
  }

  static void remover(int index) {
    if (index < 0 || index >= alertas.length) return;
    alertas.removeAt(index);
    tick.value++;
    _salvar();
  }

  // Alterna o alerta entre ativo e inativo
  static void toggleAtivo(int index) {
    if (index < 0 || index >= alertas.length) return;
    alertas[index].ativo = !alertas[index].ativo;
    tick.value++;
    _salvar();
  }
}
