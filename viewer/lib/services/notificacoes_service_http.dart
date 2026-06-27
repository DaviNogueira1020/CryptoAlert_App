import 'package:mobile/services/http_service.dart';
import 'package:mobile/config/api_config.dart';

/// Modelo para Notificação vindo da API
class NotificacaoAPI {
  final String id;
  final String title;
  final String message;
  final bool read;
  final DateTime? createdAt;

  NotificacaoAPI({
    required this.id,
    required this.title,
    required this.message,
    required this.read,
    this.createdAt,
  });

  factory NotificacaoAPI.fromJson(Map<String, dynamic> json) {
    return NotificacaoAPI(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      read: json['read'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'read': read,
    'created_at': createdAt?.toIso8601String(),
  };
}

/// Serviço HTTP para operações de notificações na API
class NotificacoesServiceHTTP {
  static final NotificacoesServiceHTTP _instance = NotificacoesServiceHTTP._internal();
  final HttpService _httpService = HttpService();

  factory NotificacoesServiceHTTP() {
    return _instance;
  }

  NotificacoesServiceHTTP._internal();

  /// Obtém lista de notificações da API
  Future<List<NotificacaoAPI>> listar() async {
    try {
      final response = await _httpService.get(ApiConfig.notificationsListEndpoint);
      
      // Resposta pode ser List diretamente ou Map com chave 'notifications'
      List<dynamic> notificationsList = [];
      
      if (response is List) {
        notificationsList = response;
      } else if (response is Map && response.containsKey('notifications')) {
        notificationsList = response['notifications'] as List<dynamic>;
      }
      
      return notificationsList
          .map((item) => NotificacaoAPI.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar notificações: $e');
    }
  }

  /// Obtém contagem de notificações não lidas
  Future<int> obterNaoLidas() async {
    try {
      final response = await _httpService.get(ApiConfig.notificationsUnreadEndpoint);
      
      // Se for um número direto
      if (response is int) return response;
      
      // Se for um map com campo 'count' ou 'unread'
      if (response is Map) {
        if (response.containsKey('count')) return response['count'] as int;
        if (response.containsKey('unread')) return response['unread'] as int;
      }
      
      return 0;
    } catch (e) {
      throw Exception('Erro ao obter notificações não lidas: $e');
    }
  }

  /// Marca uma notificação como lida
  Future<bool> marcarComoLida(String notificacaoId) async {
    try {
      final endpoint = '/notifications/read/$notificacaoId';
      await _httpService.post(
        endpoint,
        body: {},
      );
      return true;
    } catch (e) {
      throw Exception('Erro ao marcar notificação como lida: $e');
    }
  }

  /// Deleta uma notificação
  Future<bool> deletar(String notificacaoId) async {
    try {
      final endpoint = '/notifications/delete/$notificacaoId';
      await _httpService.delete(endpoint);
      return true;
    } catch (e) {
      throw Exception('Erro ao deletar notificação: $e');
    }
  }
}
