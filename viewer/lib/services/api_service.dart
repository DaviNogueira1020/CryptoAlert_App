import 'dart:convert';
import 'package:http/http.dart' as http;

// Esse arquivo é o único lugar que fala com o backend.
// Toda tela que precisar de dados chama os métodos daqui,
// sem precisar saber nada de URL ou JSON.
class ApiService {
  // URL base do backend. Quando for pro Railway, muda só aqui.
  static const String _baseUrl = 'http://localhost:8080';

  // Busca a lista de criptos com preço, variação 24h e imagem.
  // Não precisa de autenticação, qualquer um pode ver o mercado.
  static Future<List<Map<String, dynamic>>> getMarketOverview() async {
    final res = await http.get(Uri.parse('$_baseUrl/market/overview'));
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    }
    throw Exception('Erro ao buscar mercado: ${res.statusCode}');
  }

  // Busca todos os alertas do usuário autenticado.
  // O backend identifica o usuário pelo header X-User-Key.
  static Future<List<Map<String, dynamic>>> getAlerts(String userKey) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/alerts/list'),
      headers: {'X-User-Key': userKey},
    );
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    }
    throw Exception('Erro ao listar alertas: ${res.statusCode}');
  }

  // Cria um novo alerta. type pode ser "above" (acima) ou "below" (abaixo).
  // Exemplo: "me avisa quando BTC passar de 65000"
  static Future<Map<String, dynamic>> createAlert(
    String userKey, {
    required String symbol,
    required double target,
    required String type,
  }) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/alerts/create'),
      headers: {
        'Content-Type': 'application/json',
        'X-User-Key': userKey,
      },
      body: jsonEncode({'symbol': symbol, 'target': target, 'type': type}),
    );
    if (res.statusCode == 201) {
      return Map<String, dynamic>.from(jsonDecode(res.body));
    }
    throw Exception('Erro ao criar alerta: ${res.statusCode}');
  }

  // Remove um alerta pelo id.
  static Future<void> deleteAlert(String userKey, String id) async {
    final res = await http.delete(
      Uri.parse('$_baseUrl/alerts/delete/$id'),
      headers: {'X-User-Key': userKey},
    );
    if (res.statusCode != 200) {
      throw Exception('Erro ao deletar alerta: ${res.statusCode}');
    }
  }

  // Ativa ou desativa um alerta existente.
  // Passa activate: true pra ligar, false pra desligar.
  static Future<void> toggleAlert(
      String userKey, String id, bool activate) async {
    final action = activate ? 'activate' : 'deactivate';
    final res = await http.patch(
      Uri.parse('$_baseUrl/alerts/$action/$id'),
      headers: {'X-User-Key': userKey},
    );
    if (res.statusCode != 200) {
      throw Exception('Erro ao alterar alerta: ${res.statusCode}');
    }
  }

  // Busca todas as notificações do usuário.
  static Future<List<Map<String, dynamic>>> getNotifications(
      String userKey) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/notifications/list'),
      headers: {'X-User-Key': userKey},
    );
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    }
    throw Exception('Erro ao listar notificações: ${res.statusCode}');
  }

  // Marca uma notificação como lida.
  static Future<void> markNotificationRead(
      String userKey, String id) async {
    final res = await http.patch(
      Uri.parse('$_baseUrl/notifications/read/$id'),
      headers: {'X-User-Key': userKey},
    );
    if (res.statusCode != 200) {
      throw Exception('Erro ao marcar notificação: ${res.statusCode}');
    }
class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  // Buscar preço de uma criptomoeda
  static Future<double?> getPrice(String symbol) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/crypto/price?symbol=$symbol'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return double.tryParse(data['price'].toString());
      }
    } catch (e) {
      print('Erro ao buscar preço de $symbol: $e');
    }
    return null;
  }

  // Listar todos os alertas ativos
  static Future<List<dynamic>?> getActiveAlerts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alerts/list_active'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
    } catch (e) {
      print('Erro ao buscar alertas: $e');
    }
    return null;
  }

  // Listar notificações
  static Future<List<dynamic>?> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/list'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
    } catch (e) {
      print('Erro ao buscar notificações: $e');
    }
    return null;
  }
}
