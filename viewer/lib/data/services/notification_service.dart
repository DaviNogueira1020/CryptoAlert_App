import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';

// Service responsável por fazer requisições HTTP de notificações com a API
class NotificationService {
  // URL base da API Backend
  static const String _baseUrl = 'http://localhost:8080';

  // Busca a lista de TODAS as notificações do usuário
  Future<List<NotificationModel>> listNotifications() async {
    try {
      // Faz a requisição GET para buscar todas as notificações
      final response = await http.get(
        Uri.parse('$_baseUrl/notifications/list'),
      );

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON que vem como uma lista
        final List<dynamic> jsonList = jsonDecode(response.body);
        
        // Converte cada item da lista para um NotificationModel
        return jsonList.map((json) => NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        // Se não foi sucesso, lança uma exceção
        throw Exception('Erro ao buscar notificações: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao buscar notificações: $e');
    }
  }

  // Busca apenas as notificações NÃO LIDAS (isRead = false)
  Future<List<NotificationModel>> listUnreadNotifications() async {
    try {
      // Faz a requisição GET para buscar notificações não lidas
      final response = await http.get(
        Uri.parse('$_baseUrl/notifications/unread'),
      );

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON que vem como uma lista
        final List<dynamic> jsonList = jsonDecode(response.body);
        
        // Converte cada item para um NotificationModel
        return jsonList.map((json) => NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        // Se não foi sucesso, lança uma exceção
        throw Exception('Erro ao buscar notificações não lidas: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao buscar notificações não lidas: $e');
    }
  }

  // Marca uma notificação como LIDA
  Future<NotificationModel> markAsRead(String id) async {
    try {
      // Faz a requisição PATCH para marcar como lida
      final response = await http.patch(
        Uri.parse('$_baseUrl/notifications/read/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON e retorna um NotificationModel
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return NotificationModel.fromJson(jsonData);
      } else {
        // Se não foi sucesso, lança uma exceção
        throw Exception('Erro ao marcar notificação como lida: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao marcar notificação como lida: $e');
    }
  }

  // Deleta uma notificação
  Future<void> deleteNotification(String id) async {
    try {
      // Faz a requisição DELETE para remover a notificação
      final response = await http.delete(
        Uri.parse('$_baseUrl/notifications/delete/$id'),
      );

      // Se a resposta NÃO foi sucesso (status != 200)
      if (response.statusCode != 200) {
        // Lança uma exceção com o erro
        throw Exception('Erro ao deletar notificação: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao deletar notificação: $e');
    }
  }
}
