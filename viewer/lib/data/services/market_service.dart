import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/market_data_model.dart';

// Service responsável por fazer requisições HTTP de dados de mercado com a API
class MarketService {
  // URL base da API Backend
  static const String _baseUrl = 'http://localhost:8080';

  // Busca todos os ativos monitorados e seus dados de mercado atuais
  Future<List<MarketDataModel>> getMarketOverview() async {
    try {
      // Faz a requisição GET para buscar dados de mercado
      final response = await http.get(
        Uri.parse('$_baseUrl/market/overview'),
      );

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON que vem como uma lista
        final List<dynamic> jsonList = jsonDecode(response.body);
        
        // Converte cada item da lista para um MarketDataModel
        return jsonList.map((json) => MarketDataModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        // Se não foi sucesso, lança uma exceção
        throw Exception('Erro ao buscar dados de mercado: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao buscar dados de mercado: $e');
    }
  }

  // Busca o preço de uma criptomoeda específica passando o símbolo
  Future<double> getPriceBySymbol(String symbol) async {
    try {
      // Monta a URL com parâmetro de query symbol=BTCUSDT
      final uri = Uri.parse('$_baseUrl/crypto/price').replace(
        queryParameters: {'symbol': symbol},
      );

      // Faz a requisição GET para buscar o preço
      final response = await http.get(uri);

      // Se a resposta foi sucesso (status 200)
      if (response.statusCode == 200) {
        // Desserializa o JSON com os dados do preço
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Extrai e retorna o preço como double
        return (jsonData['price'] as num).toDouble();
      } else {
        // Se não foi sucesso, lança uma exceção
        throw Exception('Erro ao buscar preço: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao buscar preço: $e');
    }
  }

  // Força uma atualização imediata dos snapshots de mercado no backend
  Future<void> refreshMarketData() async {
    try {
      // Faz a requisição POST para forçar atualização
      final response = await http.post(
        Uri.parse('$_baseUrl/market/refresh'),
        headers: {'Content-Type': 'application/json'},
      );

      // Se a resposta NÃO foi sucesso (status != 200)
      if (response.statusCode != 200) {
        // Lança uma exceção com o erro
        throw Exception('Erro ao atualizar dados de mercado: ${response.body}');
      }
    } catch (e) {
      // Captura qualquer erro e relança como exceção
      throw Exception('Erro ao atualizar dados de mercado: $e');
    }
  }
}
