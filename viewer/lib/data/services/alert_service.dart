import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alert_model.dart';

// Service responsável por fazer requisições HTTP de alertas com a API
class AlertService {
  // URL base da API Backend
  static const String _baseUrl = 'http://localhost:8080';

  // Cria um novo alerta fazendo requisição POST à API
  Future<AlertModel> createAlert({
    required String symbol,
    required double target,
    required String type,
  }) async {
    try {
      // Monta o corpo da requisição com os dados do novo alerta
      final body = {
        'symbol': symbol,
        'target': target,
        'type': type,
      };

      // Faz a requisição POST para criar o alerta
      final response = await http.post(
        Uri.parse('$_baseUrl/alerts/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON e retorna um AlertModel
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return AlertModel.fromJson(jsonData);
      } else {
        // Se não foi sucesso, lança uma exceção com a mensagem de erro
        throw Exception('Erro ao criar alerta: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao criar alerta: $e');
    }
  }

  // Busca a lista de TODOS os alertas cadastrados
  Future<List<AlertModel>> listAlerts() async {
    try {
      // Faz a requisição GET para buscar todos os alertas
      final response = await http.get(
        Uri.parse('$_baseUrl/alerts/list'),
      );

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON que vem como uma lista
        final List<dynamic> jsonList = jsonDecode(response.body);
        
        // Converte cada item da lista para um AlertModel
        return jsonList.map((json) => AlertModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        // Se não foi sucesso, lança uma exceção
        throw Exception('Erro ao buscar alertas: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao buscar alertas: $e');
    }
  }

  // Busca apenas os alertas ATIVOS (status = true)
  Future<List<AlertModel>> listActiveAlerts() async {
    try {
      // Faz a requisição GET para buscar apenas alertas ativos
      final response = await http.get(
        Uri.parse('$_baseUrl/alerts/list_active'),
      );

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON que vem como uma lista
        final List<dynamic> jsonList = jsonDecode(response.body);
        
        // Converte cada item para um AlertModel
        return jsonList.map((json) => AlertModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        // Se não foi sucesso, lança uma exceção
        throw Exception('Erro ao buscar alertas ativos: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao buscar alertas ativos: $e');
    }
  }

  // Atualiza um alerta existente
  Future<AlertModel> updateAlert({
    required String id,
    required String symbol,
    required double target,
    required String type,
  }) async {
    try {
      // Monta o corpo da requisição com os dados atualizados
      final body = {
        'symbol': symbol,
        'target': target,
        'type': type,
      };

      // Faz a requisição PUT para atualizar o alerta
      final response = await http.put(
        Uri.parse('$_baseUrl/alerts/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON e retorna um AlertModel
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return AlertModel.fromJson(jsonData);
      } else {
        // Se não foi sucesso, lança uma exceção
        throw Exception('Erro ao atualizar alerta: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao atualizar alerta: $e');
    }
  }

  // Ativa um alerta (muda status para true)
  Future<AlertModel> activateAlert(String id) async {
    try {
      // Faz a requisição PATCH para ativar o alerta
      final response = await http.patch(
        Uri.parse('$_baseUrl/alerts/activate/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON e retorna um AlertModel
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return AlertModel.fromJson(jsonData);
      } else {
        // Se não foi sucesso, lança uma exceção
        throw Exception('Erro ao ativar alerta: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao ativar alerta: $e');
    }
  }

  // Desativa um alerta (muda status para false)
  Future<AlertModel> deactivateAlert(String id) async {
    try {
      // Faz a requisição PATCH para desativar o alerta
      final response = await http.patch(
        Uri.parse('$_baseUrl/alerts/deactivate/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON e retorna um AlertModel
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return AlertModel.fromJson(jsonData);
      } else {
        // Se não foi sucesso, lança uma exceção
        throw Exception('Erro ao desativar alerta: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao desativar alerta: $e');
    }
  }

  // Deleta um alerta
  Future<void> deleteAlert(String id) async {
    try {
      // Faz a requisição DELETE para remover o alerta
      final response = await http.delete(
        Uri.parse('$_baseUrl/alerts/delete/$id'),
      );

      // Se a resposta NÃO foi sucesso (status != 200)
      if (response.statusCode != 200) {
        // Lança uma exceção com o erro
        throw Exception('Erro ao deletar alerta: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao deletar alerta: $e');
    }
  }
}
