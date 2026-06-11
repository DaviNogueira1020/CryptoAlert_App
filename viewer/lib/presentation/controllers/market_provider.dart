import 'package:flutter/material.dart';
import '../data/models/index.dart';
import '../data/services/index.dart';

// Provider que gerencia o estado dos dados de mercado
// Usa o padrão ChangeNotifier do Provider para notificar mudanças na UI
class MarketProvider extends ChangeNotifier {
  // Lista de todos os ativos de mercado
  List<MarketDataModel> _marketData = [];
  
  // Indica se está carregando dados (para mostrar loading na UI)
  bool _isLoading = false;
  
  // Armazena mensagem de erro caso algo dê errado
  String? _errorMessage;

  // Service para fazer requisições HTTP
  final MarketService _marketService = MarketService();

  // Getters para acessar os dados de fora
  List<MarketDataModel> get marketData => _marketData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Carrega o panorama geral de mercado (todos os ativos)
  Future<void> loadMarketOverview() async {
    try {
      // Começa o carregamento
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Faz requisição ao backend para buscar dados de mercado
      _marketData = await _marketService.getMarketOverview();
      
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

  // Busca o preço de uma criptomoeda específica
  Future<double?> getPriceBySymbol(String symbol) async {
    try {
      // Limpa a mensagem de erro anterior
      _errorMessage = null;
      notifyListeners();

      // Faz requisição ao backend para buscar o preço
      final price = await _marketService.getPriceBySymbol(symbol);
      
      return price;
    } catch (e) {
      // Se der erro, armazena a mensagem de erro
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Força uma atualização imediata dos dados de mercado
  Future<void> refreshMarketData() async {
    try {
      // Começa o carregamento
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Faz requisição ao backend para forçar atualização
      await _marketService.refreshMarketData();
      
      // Carrega novamente os dados atualizados
      _marketData = await _marketService.getMarketOverview();

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

  // Limpa a mensagem de erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
