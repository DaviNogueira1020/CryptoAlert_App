# Guia de Integração da API de Produção

## Visão Geral

O app agora possui serviços HTTP para integração com a API de produção em:
```
https://cryptoalertappapi-production.up.railway.app/
```

## Serviços Disponíveis

### 1. **CryptoService** (`lib/services/crypto_service_http.dart`)
Obtém preços de criptomoedas.

```dart
import 'package:mobile/services/crypto_service_http.dart';

final cryptoService = CryptoService();

// Obter preço de uma moeda
final price = await cryptoService.getPrice('BTCUSDT');
print('BTC: ${price.price}');

// Obter preços de múltiplas moedas
final prices = await cryptoService.getPrices(['BTCUSDT', 'ETHUSDT']);
```

### 2. **AlertasServiceHTTP** (`lib/services/alertas_service_http.dart`)
Gerencia alertas na API.

```dart
import 'package:mobile/services/alertas_service_http.dart';

final alertasService = AlertasServiceHTTP();

// Listar alertas
final alertas = await alertasService.listar();

// Criar alerta
final novoAlerta = await alertasService.criar(
  symbol: 'BTCUSDT',
  target: 65000,
  type: 'above', // ou 'below'
);

// Deletar alerta
await alertasService.deletar(alertaId);

// Ativar/desativar
await alertasService.toggleAtivo(alertaId, true);
```

### 3. **NotificacoesServiceHTTP** (`lib/services/notificacoes_service_http.dart`)
Gerencia notificações.

```dart
import 'package:mobile/services/notificacoes_service_http.dart';

final notificacoesService = NotificacoesServiceHTTP();

// Listar notificações
final notificacoes = await notificacoesService.listar();

// Obter contagem de não lidas
final naoLidas = await notificacoesService.obterNaoLidas();

// Marcar como lida
await notificacoesService.marcarComoLida(notificacaoId);

// Deletar
await notificacoesService.deletar(notificacaoId);
```

## Configuração

A URL base da API está centralizada em:
```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://cryptoalertappapi-production.up.railway.app';
  static const int requestTimeout = 15; // segundos
}
```

Para mudar a URL ou timeouts, edite apenas este arquivo.

## Integração com Providers

Para integrar esses serviços com o estado do app, use com `ChangeNotifier`:

```dart
// Exemplo em um Provider
class MarketProvider extends ChangeNotifier {
  CryptoService _cryptoService = CryptoService();
  
  Future<void> carregarPrecos() async {
    try {
      final precos = await _cryptoService.getPrices(['BTCUSDT', 'ETHUSDT']);
      // Atualizar estado
      notifyListeners();
    } catch (e) {
      print('Erro: $e');
    }
  }
}
```

## Endpoints Testados da API

✅ **GET /crypto/price?symbol=BTCUSDT**
```json
{
  "symbol": "BTCUSDT",
  "price": 62672.0
}
```

✅ **GET /alerts/list**
```json
[
  {
    "id": "a4efb242-dbc4-46c0-80bb-06f168c191c7",
    "symbol": "BTCUSDT",
    "target": 75000.0,
    "type": "above",
    "active": true
  }
]
```

✅ **GET /notifications/list**
```json
[]
```

## Próximos Passos

1. **Integrar Providers**: Atualize os Providers para usar os serviços HTTP
2. **Substituir Mock Data**: Remova dados hardcoded e use as APIs
3. **Error Handling**: Adicione tratamento de erros nas telas
4. **Cache Local**: Considere implementar cache para melhor UX
5. **Autenticação**: Quando a API requerer auth, adicione headers nos serviços
