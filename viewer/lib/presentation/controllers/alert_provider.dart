import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/index.dart';
import '../data/services/index.dart';

// Provider que gerencia o estado dos alertas
// Usa o padrão ChangeNotifier do Provider para notificar mudanças na UI
class AlertProvider extends ChangeNotifier {
  // Lista de todos os alertas
  List<AlertModel> _alerts = [];
  
  // Lista apenas de alertas ativos
  List<AlertModel> _activeAlerts = [];
  
  // Indica se está carregando dados (para mostrar loading na UI)
  bool _isLoading = false;
  
  // Armazena mensagem de erro caso algo dê errado
  String? _errorMessage;

  // Service para fazer requisições HTTP
  final AlertService _alertService = AlertService();

  // Getters para acessar os dados de fora
  List<AlertModel> get alerts => _alerts;
  List<AlertModel> get activeAlerts => _activeAlerts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Carrega a lista de TODOS os alertas do backend
  Future<void> loadAlerts() async {
    try {
      // Começa o carregamento
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Faz requisição ao backend para buscar alertas
      _alerts = await _alertService.listAlerts();
      
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

  // Carrega apenas os alertas ATIVOS
  Future<void> loadActiveAlerts() async {
    try {
      // Começa o carregamento
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Faz requisição ao backend para buscar alertas ativos
      _activeAlerts = await _alertService.listActiveAlerts();
      
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

  // Cria um novo alerta no backend
  Future<void> createAlert({
    required String symbol,
    required double target,
    required String type,
  }) async {
    try {
      // Começa o carregamento
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Faz requisição ao backend para criar o alerta
      final newAlert = await _alertService.createAlert(
        symbol: symbol,
        target: target,
        type: type,
      );

      // Adiciona o novo alerta à lista
      _alerts.add(newAlert);
      
      // Se o alerta é ativo, adiciona também na lista de ativos
      if (newAlert.active) {
        _activeAlerts.add(newAlert);
      }

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

  // Atualiza um alerta existente
  Future<void> updateAlert({
    required String id,
    required String symbol,
    required double target,
    required String type,
  }) async {
    try {
      // Começa o carregamento
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Faz requisição ao backend para atualizar o alerta
      final updatedAlert = await _alertService.updateAlert(
        id: id,
        symbol: symbol,
        target: target,
        type: type,
      );

      // Encontra o índice do alerta na lista
      final index = _alerts.indexWhere((alert) => alert.id == id);
      
      // Se encontrou, substitui o alerta pelo atualizado
      if (index != -1) {
        _alerts[index] = updatedAlert;
      }

      // Também atualiza na lista de ativos se necessário
      final activeIndex = _activeAlerts.indexWhere((alert) => alert.id == id);
      if (activeIndex != -1 && updatedAlert.active) {
        _activeAlerts[activeIndex] = updatedAlert;
      } else if (activeIndex != -1 && !updatedAlert.active) {
        _activeAlerts.removeAt(activeIndex);
      }

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

  // Ativa um alerta (muda status para true)
  Future<void> activateAlert(String id) async {
    try {
      // Faz requisição ao backend para ativar o alerta
      final activatedAlert = await _alertService.activateAlert(id);

      // Atualiza o alerta na lista
      final index = _alerts.indexWhere((alert) => alert.id == id);
      if (index != -1) {
        _alerts[index] = activatedAlert;
      }

      // Adiciona na lista de ativos
      if (!_activeAlerts.any((alert) => alert.id == id)) {
        _activeAlerts.add(activatedAlert);
      }

      // Notifica os listeners sobre a mudança
      notifyListeners();
    } catch (e) {
      // Se der erro, armazena a mensagem de erro
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Desativa um alerta (muda status para false)
  Future<void> deactivateAlert(String id) async {
    try {
      // Faz requisição ao backend para desativar o alerta
      final deactivatedAlert = await _alertService.deactivateAlert(id);

      // Atualiza o alerta na lista
      final index = _alerts.indexWhere((alert) => alert.id == id);
      if (index != -1) {
        _alerts[index] = deactivatedAlert;
      }

      // Remove da lista de ativos
      _activeAlerts.removeWhere((alert) => alert.id == id);

      // Notifica os listeners sobre a mudança
      notifyListeners();
    } catch (e) {
      // Se der erro, armazena a mensagem de erro
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Deleta um alerta
  Future<void> deleteAlert(String id) async {
    try {
      // Faz requisição ao backend para deletar o alerta
      await _alertService.deleteAlert(id);

      // Remove o alerta da lista
      _alerts.removeWhere((alert) => alert.id == id);
      
      // Remove da lista de ativos se estava lá
      _activeAlerts.removeWhere((alert) => alert.id == id);

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
