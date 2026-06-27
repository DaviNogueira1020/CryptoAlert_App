/// Configuração centralizada da API
class ApiConfig {
  /// URL base da API de produção
  static const String baseUrl = 'https://cryptoalertappapi-production.up.railway.app';

  /// Endpoints disponíveis
  static const String cryptoPriceEndpoint = '/crypto/price';
  static const String alertsListEndpoint = '/alerts/list';
  static const String alertsCreateEndpoint = '/alerts/create';
  static const String alertsDeleteEndpoint = '/alerts/delete';
  static const String notificationsListEndpoint = '/notifications/list';
  static const String notificationsUnreadEndpoint = '/notifications/unread';

  /// Timeout padrão em segundos
  static const int requestTimeout = 15;

  /// Retorna URL completa para um endpoint
  static String getUrl(String endpoint) => '$baseUrl$endpoint';
}
