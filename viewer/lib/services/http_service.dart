import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/config/api_config.dart';

/// Serviço HTTP genérico para requisições à API
class HttpService {
  static final HttpService _instance = HttpService._internal();

  factory HttpService() {
    return _instance;
  }

  HttpService._internal();

  /// Faz requisição GET - retorna dynamic (pode ser Map ou List)
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse(ApiConfig.getUrl(endpoint));
      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: ApiConfig.requestTimeout));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao fazer requisição GET: $e');
    }
  }

  /// Faz requisição GET com query parameters - retorna dynamic
  Future<dynamic> getWithParams(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.getUrl(endpoint));
      final urlWithParams = uri.replace(queryParameters: queryParams);
      
      final response = await http
          .get(urlWithParams, headers: headers)
          .timeout(const Duration(seconds: ApiConfig.requestTimeout));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao fazer requisição GET com params: $e');
    }
  }

  /// Faz requisição POST - retorna dynamic
  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.getUrl(endpoint));
      final response = await http
          .post(
            url,
            headers: headers ?? {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: ApiConfig.requestTimeout));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao fazer requisição POST: $e');
    }
  }

  /// Faz requisição DELETE - retorna dynamic
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.getUrl(endpoint));
      final response = await http
          .delete(url, headers: headers)
          .timeout(const Duration(seconds: ApiConfig.requestTimeout));

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body.isEmpty) {
          return {'success': true};
        }
        return jsonDecode(response.body);
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao fazer requisição DELETE: $e');
    }
  }
}
