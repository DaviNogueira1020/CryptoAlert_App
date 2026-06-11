import 'package:flutter/material.dart';
import '../data/models/index.dart';
import '../data/services/index.dart';

// Provider que gerencia o estado das notificações
// Usa o padrão ChangeNotifier do Provider para notificar mudanças na UI
class NotificationProvider extends ChangeNotifier {
  // Lista de todas as notificações
  List<NotificationModel> _notifications = [];
  
  // Lista apenas de notificações não lidas
  List<NotificationModel> _unreadNotifications = [];
  
  // Indica se está carregando dados (para mostrar loading na UI)
  bool _isLoading = false;
  
  // Armazena mensagem de erro caso algo dê errado
  String? _errorMessage;

  // Service para fazer requisições HTTP
  final NotificationService _notificationService = NotificationService();

  // Getters para acessar os dados de fora
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications => _unreadNotifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Retorna a quantidade de notificações não lidas
  int get unreadCount => _unreadNotifications.length;

  // Carrega a lista de TODAS as notificações
  Future<void> loadNotifications() async {
    try {
      // Começa o carregamento
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Faz requisição ao backend para buscar notificações
      _notifications = await _notificationService.listNotifications();
      
      // Termina o carregamento
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Se der erro, armazena a mensagem de erro
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Carrega apenas as notificações NÃO LIDAS
  Future<void> loadUnreadNotifications() async {
    try {
      // Começa o carregamento
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Faz requisição ao backend para buscar notificações não lidas
      _unreadNotifications = await _notificationService.listUnreadNotifications();
      
      // Termina o carregamento
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // Se der erro, armazena a mensagem de erro
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Marca uma notificação como LIDA
  Future<void> markAsRead(String id) async {
    try {
      // Faz requisição ao backend para marcar como lida
      final readNotification = await _notificationService.markAsRead(id);

      // Encontra o índice da notificação na lista
      final index = _notifications.indexWhere((notification) => notification.id == id);
      
      // Se encontrou, substitui a notificação pela atualizada
      if (index != -1) {
        _notifications[index] = readNotification;
      }

      // Remove da lista de não lidas
      _unreadNotifications.removeWhere((notification) => notification.id == id);

      // Notifica os listeners sobre a mudança
      notifyListeners();
    } catch (e) {
      // Se der erro, armazena a mensagem de erro
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Deleta uma notificação
  Future<void> deleteNotification(String id) async {
    try {
      // Faz requisição ao backend para deletar a notificação
      await _notificationService.deleteNotification(id);

      // Remove da lista de todas as notificações
      _notifications.removeWhere((notification) => notification.id == id);
      
      // Remove da lista de não lidas se estava lá
      _unreadNotifications.removeWhere((notification) => notification.id == id);

      // Notifica os listeners sobre a mudança
      notifyListeners();
    } catch (e) {
      // Se der erro, armazena a mensagem de erro
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Limpa a mensagem de erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
