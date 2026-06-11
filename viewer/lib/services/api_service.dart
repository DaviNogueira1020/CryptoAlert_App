import 'dart:convert';
import 'package:http/http.dart' as http;

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
