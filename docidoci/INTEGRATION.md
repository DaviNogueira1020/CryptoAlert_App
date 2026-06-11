# Guia de Integração Frontend-API

Neste documento você aprenderá como integrar a API do backend com as páginas do Flutter usando os Services e Providers criados.

---

## 📦 Estrutura de Arquivos

Os serviços foram organizados da seguinte forma:

```
viewer/lib/
├── data/
│   ├── models/
│   │   ├── alert_model.dart           # Modelo de alerta
│   │   ├── notification_model.dart    # Modelo de notificação
│   │   ├── market_data_model.dart     # Modelo de dados de mercado
│   │   └── index.dart                 # Exportação centralizada
│   └── services/
│       ├── alert_service.dart         # Service HTTP de alertas
│       ├── notification_service.dart  # Service HTTP de notificações
│       ├── market_service.dart        # Service HTTP de mercado
│       └── index.dart                 # Exportação centralizada
│
└── presentation/
    └── controllers/
        ├── alert_provider.dart        # Provider de alertas (State Management)
        ├── notification_provider.dart # Provider de notificações
        ├── market_provider.dart       # Provider de mercado
        └── index.dart                 # Exportação centralizada
```

---

## 🔌 Arquitetura de Camadas

### 1️⃣ **Models** (Camada de Dados)

Os models transformam JSON da API em objetos Dart:

```dart
// alert_model.dart
class AlertModel {
  final String id;
  final String symbol;
  final double target;
  final String type;
  final bool active;

  AlertModel.fromJson(Map<String, dynamic> json)
    // Desserializa JSON da API
}
```

### 2️⃣ **Services** (Camada de Integração HTTP)

Os services fazem as requisições HTTP:

```dart
// alert_service.dart
class AlertService {
  Future<AlertModel> createAlert({...}) async {
    // Faz POST para http://localhost:8080/alerts/create
  }
  
  Future<List<AlertModel>> listAlerts() async {
    // Faz GET para http://localhost:8080/alerts/list
  }
}
```

### 3️⃣ **Providers** (Camada de Estado)

Os providers gerenciam o estado e notificam as páginas quando os dados mudam:

```dart
// alert_provider.dart
class AlertProvider extends ChangeNotifier {
  List<AlertModel> _alerts = [];
  
  Future<void> loadAlerts() async {
    _alerts = await _alertService.listAlerts();
    notifyListeners(); // Avisa a UI que mudou
  }
}
```

### 4️⃣ **Pages** (Camada de Apresentação)

As páginas exibem os dados e permitem interações:

```dart
// alerts_integration_example.dart
Consumer<AlertProvider>(
  builder: (context, alertProvider, child) {
    return ListView(
      children: alertProvider.alerts.map((alert) => ...).toList()
    );
  },
)
```

---

## 🎯 Como Usar: Passo a Passo

### Passo 1: Importar os Providers no main.dart

```dart
import 'package:provider/provider.dart';
import 'presentation/controllers/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Cria instâncias dos providers
        ChangeNotifierProvider(create: (_) => AlertProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => MarketProvider()),
      ],
      child: MaterialApp(
        // ... resto da configuração do app
      ),
    );
  }
}
```

### Passo 2: Usar em uma Página

```dart
import 'package:provider/provider.dart';
import 'presentation/controllers/index.dart';

class MyAlertsPage extends StatefulWidget {
  @override
  State<MyAlertsPage> createState() => _MyAlertsPageState();
}

class _MyAlertsPageState extends State<MyAlertsPage> {
  @override
  void initState() {
    super.initState();
    
    // Carrega os alertas quando a página inicia
    Future.microtask(() {
      context.read<AlertProvider>().loadAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AlertProvider>(
        builder: (context, alertProvider, child) {
          // Se está carregando
          if (alertProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // Se teve erro
          if (alertProvider.errorMessage != null) {
            return Center(child: Text(alertProvider.errorMessage!));
          }

          // Mostra a lista de alertas
          return ListView(
            children: alertProvider.alerts.map((alert) {
              return Card(
                child: ListTile(
                  title: Text(alert.symbol),
                  subtitle: Text('Preço: ${alert.target}'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
```

---

## 💡 Exemplos de Uso

### Exemplo 1: Listar Alertas

```dart
// Lê o provider
final alertProvider = context.read<AlertProvider>();

// Carrega os alertas
await alertProvider.loadAlerts();

// Acessa a lista
print(alertProvider.alerts); // List<AlertModel>
```

### Exemplo 2: Criar um Novo Alerta

```dart
final alertProvider = context.read<AlertProvider>();

// Cria um novo alerta
await alertProvider.createAlert(
  symbol: 'BTCUSDT',
  target: 65000,
  type: 'above',
);

// O alerta é adicionado automaticamente à lista
// e os listeners são notificados
```

### Exemplo 3: Deletar um Alerta

```dart
final alertProvider = context.read<AlertProvider>();

// Deleta um alerta pelo ID
await alertProvider.deleteAlert('01aryz6s41tsdbftnzj7ehl42c');

// O alerta é removido da lista automaticamente
```

### Exemplo 4: Buscar Dados de Mercado

```dart
final marketProvider = context.read<MarketProvider>();

// Carrega os dados de mercado
await marketProvider.loadMarketOverview();

// Acessa a lista de ativos
for (var market in marketProvider.marketData) {
  print('${market.symbol}: \$${market.priceUsd}');
}
```

### Exemplo 5: Buscar Preço de Uma Criptomoeda

```dart
final marketProvider = context.read<MarketProvider>();

// Busca o preço de uma criptomoeda específica
final price = await marketProvider.getPriceBySymbol('BTCUSDT');
print('Bitcoin: \$${price}');
```

### Exemplo 6: Gerenciar Notificações

```dart
final notificationProvider = context.read<NotificationProvider>();

// Carrega as notificações
await notificationProvider.loadNotifications();

// Marca como lida
await notificationProvider.markAsRead('notification_id');

// Deleta uma notificação
await notificationProvider.deleteNotification('notification_id');

// Acessa quantidade de não lidas
print('Não lidas: ${notificationProvider.unreadCount}');
```

---

## 🔄 Padrão de Uso com Consumer

O `Consumer` é usado para "ouvir" mudanças no provider e reconstruir a UI:

```dart
Consumer<AlertProvider>(
  builder: (context, alertProvider, child) {
    // Constrói a UI baseado no estado do provider
    // Se o provider mudar (via notifyListeners()), 
    // esta função é chamada novamente
    
    return ListView(
      children: alertProvider.alerts.map((alert) => ...).toList(),
    );
  },
)
```

---

## ⚠️ Tratamento de Erros

Todos os providers armazenam mensagens de erro em `errorMessage`:

```dart
Consumer<AlertProvider>(
  builder: (context, alertProvider, child) {
    if (alertProvider.errorMessage != null) {
      return Column(
        children: [
          Text('Erro: ${alertProvider.errorMessage}'),
          ElevatedButton(
            onPressed: () => alertProvider.clearError(),
            child: Text('Limpar'),
          ),
        ],
      );
    }
    
    return // ... resto da UI
  },
)
```

---

## 📝 Comentários no Código

Todos os serviços e providers possuem comentários em português explicando o que cada função faz:

```dart
// Isso aqui busca a lista de alertas do backend
Future<void> loadAlerts() async {
  try {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Faz requisição ao backend
    _alerts = await _alertService.listAlerts();
    
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _errorMessage = e.toString();
    _isLoading = false;
    notifyListeners();
  }
}
```

---

## 📂 Arquivos de Exemplo

Três arquivos de exemplo foram criados mostrando como integrar:

1. **alerts_integration_example.dart** - Gerenciamento de alertas
2. **market_integration_example.dart** - Visualização de dados de mercado
3. **notifications_integration_example.dart** - Gerenciamento de notificações

Você pode copiar e adaptar esses exemplos para suas próprias páginas.

---

## 🚀 Próximos Passos

1. ✅ Importar os Providers no `main.dart`
2. ✅ Usar os exemplos de páginas como base
3. ✅ Adaptar conforme suas necessidades
4. ✅ Testar se a API está respondendo corretamente
5. ✅ Adicionar mais funcionalidades conforme necessário

---

## 📞 Suporte

Se encontrar problemas:

1. **Verifique se o backend está rodando**: `dart run bin/server.dart` na pasta `mobile/`
2. **Verifique a URL base**: Deve ser `http://localhost:8080`
3. **Veja os logs**: Use `print()` para debugar valores
4. **Consulte a API_DOCS.md**: Para entender os endpoints

---

**Última atualização**: Junho 2026
