import 'package:mobile/services/http_service.dart';
import 'package:mobile/config/api_config.dart';

/// Modelo para Alerta vindo da API
class AlertaAPI {
  final String id;
  final String symbol;
  final double target;
  final String type; // 'above' ou 'below'
  final bool active;

  AlertaAPI({
    required this.id,
    required this.symbol,
    required this.target,
    required this.type,
    required this.active,
  });

  factory AlertaAPI.fromJson(Map<String, dynamic> json) {
    return AlertaAPI(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      target: (json['target'] is num) ? json['target'].toDouble() : 0.0,
      type: json['type'] ?? 'above',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'target': target,
    'type': type,
    'active': active,
  };
}

/// Serviço HTTP para operações de alertas na API
class AlertasServiceHTTP {
  static final AlertasServiceHTTP _instance = AlertasServiceHTTP._internal();
  final HttpService _httpService = HttpService();

  factory AlertasServiceHTTP() {
    return _instance;
  }

  AlertasServiceHTTP._internal();

  /// Obtém lista de alertas da API
  Future<List<AlertaAPI>> listar() async {
    try {
      final response = await _httpService.get(ApiConfig.alertsListEndpoint);
      
      // Resposta pode ser List diretamente ou Map com chave 'alerts'
      List<dynamic> alertsList = [];
      
      if (response is List) {
        alertsList = response;
      } else if (response is Map && response.containsKey('alerts')) {
        alertsList = response['alerts'] as List<dynamic>;
      }
      
      return alertsList
          .map((item) => AlertaAPI.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao listar alertas: $e');
    }
  }

  /// Cria um novo alerta na API
  Future<AlertaAPI> criar({
    required String symbol,
    required double target,
    required String type, // 'above' ou 'below'
  }) async {
    try {
      final response = await _httpService.post(
        ApiConfig.alertsCreateEndpoint,
        body: {
          'symbol': symbol,
          'target': target,
          'type': type,
        },
      );
      
      return AlertaAPI.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao criar alerta: $e');
    }
  }

  /// Deleta um alerta da API
  Future<bool> deletar(String alertaId) async {
    try {
      final endpoint = '${ApiConfig.alertsDeleteEndpoint}/$alertaId';
      await _httpService.delete(endpoint);
      return true;
    } catch (e) {
      throw Exception('Erro ao deletar alerta: $e');
    }
  }

  /// Ativa/desativa um alerta na API
  Future<bool> toggleAtivo(String alertaId, bool novoStatus) async {
    try {
      // Assumindo que existe endpoint para toggle ou update
      // Pode precisar ser adaptado conforme a API real
      final endpoint = '/alerts/toggle/$alertaId';
      await _httpService.post(
        endpoint,
        body: {'active': novoStatus},
      );
      return true;
    } catch (e) {
      throw Exception('Erro ao alternar status do alerta: $e');
    }
  }
}
