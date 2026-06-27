# CryptoAlert - Análise Completa do Projeto

## 📋 Sumário Executivo

**CryptoAlert** é uma aplicação multiplataforma de **monitoramento e gestão de alertas de criptomoedas** em tempo real. Desenvolvida com Flutter (frontend) e Dart Frog (backend), integra a API Binance para obter preços, Firebase para autenticação e notificações, e PostgreSQL para persistência de dados.

---

## 1. 🎯 Propósito e Objetivos

### Objetivo Principal
Permitir que usuários monitorem criptomoedas e recebam notificações automáticas quando os preços atingem valores-alvo especificados.

### Objetivos Específicos
- ✅ Monitorar preços de criptomoedas em tempo real via Binance API
- ✅ Criar alertas customizados (acima/abaixo de preço)
- ✅ Disparar notificações push quando alertas são acionados
- ✅ Gerenciar alertas de forma intuitiva (CRUD)
- ✅ Sincronizar dados entre múltiplas plataformas (web, mobile)
- ✅ Autenticar usuários com segurança

---

## 2. 🏗️ Arquitetura Geral

### Stack Tecnológico

| Componente | Tecnologia | Propósito |
|-----------|-----------|----------|
| **Frontend Web** | Flutter (Web) | Interface de usuário (viewer) |
| **Frontend Mobile** | Flutter (Android/iOS) | App nativo |
| **Backend** | Dart Frog | HTTP server e lógica de negócio |
| **Banco Principal** | Firestore (Firebase) | Documentos, alertas, notificações |
| **Banco Backend** | PostgreSQL | Persistência de alertas (redundância) |
| **Preços** | Binance API | Dados de criptomoedas em tempo real |
| **Notificações** | Firebase Cloud Messaging | Push notifications |
| **Autenticação** | Firebase Auth | Login/Registro de usuários |
| **Deploy** | Railway | Hospedagem backend |

### Estrutura de Diretórios

```
CryptoAlert_App/
│
├── 📁 mobile/                          # Backend + App Mobile
│   ├── bin/
│   │   └── server.dart                 # Entry point do servidor Dart Frog
│   │
│   ├── lib/
│   │   ├── 📁 clients/                 # Integrações externas
│   │   │   └── binance_client.dart    # Cliente HTTP para Binance
│   │   │
│   │   ├── 📁 config/                  # Configurações
│   │   │   ├── api_config.dart        # Config API (vazio, usando env)
│   │   │   └── environment.dart       # Variáveis de ambiente (.env)
│   │   │
│   │   ├── 📁 core/                    # Núcleo da aplicação
│   │   │   └── database/              # Modelos de dados
│   │   │
│   │   ├── 📁 middlewares/             # Middleware HTTP
│   │   │   ├── auth_middleware.dart   # Autenticação
│   │   │   └── error_middleware.dart  # Tratamento de erros
│   │   │
│   │   ├── 📁 modules/                 # Módulos de negócio
│   │   │   ├── alerts/                # Gerenciamento de alertas
│   │   │   ├── auth/                  # Autenticação de usuários
│   │   │   ├── crypto/                # Dados de criptomoedas
│   │   │   └── notifications/         # Notificações
│   │   │
│   │   ├── 📁 scheduler/               # Jobs agendados
│   │   │   └── alerts_scheduler.dart  # Verifica alertas periodicamente
│   │   │
│   │   └── 📁 utils/                   # Utilitários
│   │
│   ├── 📁 routes/                      # Endpoints HTTP (Dart Frog)
│   │   ├── index.dart
│   │   ├── alerts/                    # GET/POST /alerts/...
│   │   ├── auth/                      # GET/POST /auth/...
│   │   ├── crypto/                    # GET /crypto/price
│   │   └── notifications/             # GET/POST /notifications/...
│   │
│   └── pubspec.yaml                    # Dependências Dart Frog
│
├── 📁 viewer/                          # Frontend Flutter (Web)
│   ├── lib/
│   │   ├── main.dart                   # Entry point do app
│   │   │
│   │   ├── 📁 app/                     # Configuração da aplicação
│   │   │   ├── app.dart               # MaterialApp root
│   │   │   ├── routes.dart            # Definição de rotas
│   │   │   └── themes.dart            # Temas (dark/light)
│   │   │
│   │   ├── 📁 config/                  # Configurações
│   │   │   └── api_config.dart        # URL base da API
│   │   │
│   │   ├── 📁 core/                    # Núcleo
│   │   │   ├── constants/
│   │   │   │   ├── app_colors.dart
│   │   │   │   ├── app_strings.dart
│   │   │   │   └── app_sizes.dart
│   │   │   ├── errors/
│   │   │   └── utils/
│   │   │
│   │   ├── 📁 data/                    # Camada de dados (Clean Arch)
│   │   │   ├── models/                # Classes de dados
│   │   │   │   └── crypto_model.dart
│   │   │   ├── repositories/          # Acesso a dados
│   │   │   └── services/              # HTTP/DB services
│   │   │
│   │   ├── 📁 domain/                  # Lógica de negócio pura
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   │
│   │   ├── 📁 presentation/            # Camada de apresentação (UI)
│   │   │   ├── pages/                 # Telas completas
│   │   │   │   ├── home/
│   │   │   │   ├── alerts/
│   │   │   │   ├── profile/
│   │   │   │   └── login/
│   │   │   ├── controllers/           # Lógica de estado
│   │   │   ├── shell/                 # Shell navegável
│   │   │   └── widgets/               # Componentes UI
│   │   │
│   │   ├── 📁 services/                # Serviços HTTP
│   │   │   ├── http_service.dart      # Cliente HTTP genérico
│   │   │   ├── crypto_service_http.dart
│   │   │   ├── alertas_service_http.dart
│   │   │   ├── notificacoes_service_http.dart
│   │   │   ├── alertasServices.dart   # Serviço local (offline)
│   │   │   ├── banco_de_dados.dart    # SharedPreferences
│   │   │   ├── sessao_usuario.dart    # Gerenciamento de sessão
│   │   │   └── firebase_options.dart  # Config Firebase
│   │   │
│   │   ├── 📁 shared/
│   │   │   ├── widgets/               # Widgets reutilizáveis
│   │   │   └── extensions/            # Extensions Dart
│   │   │
│   │   ├── firebase_options.dart      # Configuração Firebase multiplataforma
│   │   ├── API_INTEGRATION_GUIDE.md   # Guia de integração
│   │   └── structurePresentation.md   # Estrutura apresentada
│   │
│   ├── 📁 ios/ / 📁 android/ / 📁 web/  # Assets e configs nativos
│   └── pubspec.yaml                    # Dependências Flutter
│
├── 📁 docs/                            # Documentação
│   ├── backend_development_log_EN.md   # Log de dev (EN)
│   └── backend_development_log_PT.md   # Log de dev (PT)
│
├── firebase.json                       # Configuração Firebase
├── firestore.rules                     # Regras de segurança Firestore
├── firestore.indexes.json              # Índices Firestore
└── skills-lock.json                    # Lock de dependências
```

---

## 3. 📦 Recursos e Funcionalidades

### ✅ Implementadas

#### Gerenciamento de Alertas
- 📍 **Criar alerta**: Especificar criptomoeda, preço-alvo e tipo (acima/abaixo)
- 📋 **Listar alertas**: Ver todos os alertas ativos do usuário
- ✏️ **Atualizar alerta**: Modificar preço-alvo ou tipo
- 🗑️ **Deletar alerta**: Remover alertas
- ⚡ **Ativar/Desativar**: Toggle status do alerta
- 📊 **Verificação contínua**: Scheduler verifica a cada minuto

#### Preços de Criptomoedas
- 🔄 **Preços em tempo real**: Integração com Binance API
- 📈 **Múltiplas moedas**: BTCUSDT, ETHUSDT, e outras suportadas
- ⚙️ **Atualização automática**: Refresh automático de preços

#### Notificações
- 🔔 **Push notifications**: Via Firebase Cloud Messaging
- 📬 **Histórico**: Lista de notificações recebidas
- ✅ **Marcar como lida**: Gerenciar status de notificações
- 🗑️ **Deletar**: Remover notificações antigas

#### Autenticação e Usuários
- 🔐 **Login/Registro**: Firebase Authentication
- 👤 **Sessão de usuário**: Gerenciamento persistente
- 🔒 **Dados segregados**: Cada usuário vê apenas seus dados

#### Sincronização Multiplataforma
- 🌐 **Web + Mobile**: Dados sincronizados em tempo real
- 💾 **Cache local**: SharedPreferences para offline
- 🔄 **Firestore**: Sincronização automática

---

## 4. 🔌 APIs e Integrações

### 1. **Binance API**
```
GET https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT
```
- Fornecedor de preços em tempo real
- Implementação: `mobile/lib/clients/binance_client.dart`
- Suporta qualquer par de trading válido (BTCUSDT, ETHUSDT, etc.)

### 2. **Backend API (Railway)**
Base URL: `https://cryptoalertappapi-production.up.railway.app`

#### Endpoints de Criptomoedas
```
GET  /crypto/price?symbol=BTCUSDT
     Response: {"symbol":"BTCUSDT","price":62672.0}
```

#### Endpoints de Alertas
```
GET    /alerts/list                          # Listar todos os alertas
POST   /alerts/create                        # Criar novo alerta
PATCH  /alerts/update/{id}                   # Atualizar alerta
DELETE /alerts/delete/{id}                   # Deletar alerta
PATCH  /alerts/toggle_status/{id}            # Ativar/desativar
GET    /alerts/list_active                   # Apenas alertas ativos
```

#### Endpoints de Autenticação
```
POST   /auth/register                        # Registrar novo usuário
POST   /auth/login                           # Fazer login
```

#### Endpoints de Notificações
```
GET    /notifications/list                   # Listar notificações
GET    /notifications/unread                 # Contar não lidas
PATCH  /notifications/read/{id}              # Marcar como lida
DELETE /notifications/delete/{id}            # Deletar notificação
```

### 3. **Firebase**

#### Firestore
Estrutura de documentos:
```
usuarios/{userID}
├── created_at: timestamp
├── dados: map
│   ├── nome: string
│   ├── email: string
│   └── ...
└── alertas/ (subcoleção)
    ├── {alertID}
    │   ├── symbol: BTCUSDT
    │   ├── target: 62000
    │   ├── type: above/below
    │   └── active: true
    
└── notificacoes/ (subcoleção)
    ├── {notifID}
    │   ├── title: string
    │   ├── message: string
    │   ├── read: boolean
    │   └── createdAt: timestamp
```

#### Segurança (Firestore Rules)
```firestore
rules_version = '2';
service cloud.firestore {
  match /usuarios/{userID} {
    # Apenas o usuário autenticado pode criar/ler/atualizar seus dados
    allow create: if request.auth.uid == userID && validFields()
    allow read: if request.auth.uid == userID
    allow update: if request.auth.uid == userID && validFields()
    allow delete: if request.auth.uid == userID
    
    # Subcoleções (alertas, notificações)
    match /{subcollection}/{docID} {
      allow read, write: if request.auth.uid == userID
    }
  }
}
```

#### Firebase Cloud Messaging
- Envia notificações push quando alerta é disparado
- Configurado em `ios/firebase_app_id_file.json`
- Setup automático via Firebase CLI

---

## 5. 🏛️ Padrões de Arquitetura

### 5.1. Backend (Dart Frog)

#### Layered Architecture
```
Routes (Comunicação HTTP)
    ↓
Services (Regra de Negócio)
    ↓
Repositories (Persistência)
    ↓
Clients (Integrações Externas)
```

**Exemplo**: Criar um alerta
```dart
// routes/alerts/create.dart (HTTP Layer)
Future<Response> onRequest(RequestContext context) async {
  final body = await context.request.json();
  final alert = await AlertsService().create(body);
  return Response.json(body: alert.toJson());
}

// modules/alerts/alerts_service.dart (Service Layer)
class AlertsService {
  Future<Alert> create(Map data) async {
    // Validações, regras de negócio
    final alert = Alert.fromJson(data);
    return _repository.save(alert);
  }
}

// core/database/alerts_repository.dart (Repository Layer)
class AlertsRepository {
  Future<Alert> save(Alert alert) async {
    // INSERT INTO alerts ...
  }
}
```

#### Middleware Pattern
```dart
// middlewares/auth_middleware.dart
Response Function(RequestContext) authMiddleware(
  Response Function(RequestContext) handler,
) {
  return (context) {
    final token = context.request.headers['Authorization'];
    if (token == null) return Response(statusCode: 401);
    return handler(context);
  };
}

// middlewares/error_middleware.dart
Response Function(RequestContext) errorMiddleware(...) {
  // Captura exceções e retorna respostas HTTP apropriadas
}
```

#### Scheduler Pattern
```dart
// scheduler/alerts_scheduler.dart
class AlertsScheduler {
  void start() {
    Timer.periodic(Duration(minutes: 1), (_) async {
      await _checkAlerts();
    });
  }
  
  Future<void> _checkAlerts() async {
    final alerts = await _repository.getActive();
    for (final alert in alerts) {
      final currentPrice = await BinanceClient().getPrice(alert.symbol);
      if (_isPriceTriggered(alert, currentPrice)) {
        await _sendNotification(alert);
      }
    }
  }
}
```

### 5.2. Frontend (Flutter - Clean Architecture)

#### Layers
```
Presentation (UI Components)
    ↓
Domain (Usecases, Entities)
    ↓
Data (Repositories, Models, Services)
```

**Exemplo**: Listar alertas
```dart
// presentation/pages/alerts/alerts_page.dart (UI Layer)
class AlertsPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AlertasServiceHTTP().listar(),
      builder: (context, snapshot) => _buildList(snapshot.data),
    );
  }
}

// services/alertas_service_http.dart (Data Layer)
class AlertasServiceHTTP {
  Future<List<AlertaAPI>> listar() async {
    final response = await _httpService.get('/alerts/list');
    return (response as List)
        .map((item) => AlertaAPI.fromJson(item))
        .toList();
  }
}

// data/models/alerta_model.dart (Model Layer)
class AlertaAPI {
  final String id;
  final String symbol;
  final double target;
  final String type; // 'above' | 'below'
  final bool active;
  
  factory AlertaAPI.fromJson(Map json) => AlertaAPI(...)
  Map<String, dynamic> toJson() => {...}
}
```

#### Design Patterns

**Singleton Pattern** (Services)
```dart
class CryptoService {
  static final CryptoService _instance = CryptoService._internal();
  
  factory CryptoService() {
    return _instance; // Sempre retorna mesma instância
  }
  
  CryptoService._internal();
}
```

**Repository Pattern** (Data Access)
```dart
abstract class AlertsRepository {
  Future<List<Alert>> getAll();
  Future<Alert> create(Alert alert);
  Future<void> delete(String id);
}

class AlertsRepositoryImpl implements AlertsRepository {
  // Implementação com HTTP ou DB local
}
```

**Provider Pattern** (State Management)
```dart
class MarketProvider extends ChangeNotifier {
  List<CryptoPrice> _prices = [];
  
  Future<void> carregarPrecos() async {
    _prices = await CryptoService().getPrices(['BTCUSDT', 'ETHUSDT']);
    notifyListeners();
  }
}
```

---

## 6. 🔄 Fluxos de Dados Principais

### Fluxo 1: Criar um Alerta

```
┌─────────────┐
│ Usuário     │ Clica em "Novo Alerta"
│ (UI)        │
└──────┬──────┘
       │
       ├─ AlertasPage
       ├─ Insere: symbol, target, type
       │
       ▼
┌─────────────────────┐
│ Frontend Service    │ AlertasServiceHTTP.criar()
│ HTTP                │
└──────┬──────────────┘
       │
       ├─ POST /alerts/create
       ├─ {"symbol":"BTCUSDT","target":62000,"type":"above"}
       │
       ▼
┌─────────────────────┐
│ Backend             │ routes/alerts/create.dart
│ Route               │
└──────┬──────────────┘
       │
       ├─ Recebe JSON
       │
       ▼
┌─────────────────────┐
│ Backend             │ AlertsService.criar()
│ Service             │ - Validações
│                     │ - Regras de negócio
└──────┬──────────────┘
       │
       ├─ Repository.save()
       │
       ▼
┌─────────────────────┐
│ PostgreSQL          │ INSERT INTO alerts ...
│ Database            │
└──────┬──────────────┘
       │
       ├─ Response 200 OK
       │
       ▼
┌─────────────────────┐
│ Frontend            │ AlertaAPI.fromJson()
│ Service             │ UpdateUI
└─────────────────────┘
```

### Fluxo 2: Disparar Alerta (Background)

```
┌──────────────────────┐
│ AlertsScheduler      │ Timer a cada 1 minuto
│ (Backend)            │
└──────┬───────────────┘
       │
       ├─ getActiveAlerts()
       │
       ▼
┌──────────────────────┐
│ Para cada alerta:    │
│                      │ 1. Obter preço atual
│ - BTCUSDT: 62500     │ 2. Comparar com target
│ - ETHUSDT: 3200      │ 3. Verificar disparo
└──────┬───────────────┘
       │
       ├─ BinanceClient.getPrice()
       │ GET https://api.binance.com/api/v3/ticker/price
       │
       ▼
┌──────────────────────┐
│ Comparação:          │
│ target: 62000        │ Se BTCUSDT (62500) > 62000 → DISPARA
│ type: "above"        │
│ current: 62500       │
└──────┬───────────────┘
       │
       ├─ sendNotification()
       │
       ▼
┌──────────────────────┐
│ Firebase Cloud       │ Envia push notification
│ Messaging (FCM)      │
└──────┬───────────────┘
       │
       ├─ Usuário recebe notificação
       │
       ▼
┌──────────────────────┐
│ Firestore            │ Salva notificação
│ (histórico)          │
└──────────────────────┘
```

### Fluxo 3: Sincronização Multiplataforma

```
┌─────────────┐        ┌─────────────┐
│ App Mobile  │        │ App Web     │
│ (viewer)    │        │ (viewer)    │
└──────┬──────┘        └──────┬──────┘
       │                      │
       ├─ Cria alerta         ├─ Cria alerta
       │  POST /alerts/create │  POST /alerts/create
       │                      │
       └──────────┬───────────┘
                  │
                  ▼
         ┌─────────────────┐
         │ Backend API     │
         │ (Railway)       │
         │ routes/alerts   │
         └────────┬────────┘
                  │
                  ├─ Salva PostgreSQL
                  ├─ Sincroniza Firestore
                  │
         ┌────────┴────────┐
         │                 │
         ▼                 ▼
    ┌─────────┐       ┌─────────┐
    │ Mobile  │       │  Web    │
    │ Listener│       │Listener │
    │Firestore│       │Firestore│
    └─────────┘       └─────────┘
         │                 │
         └─────────┬───────┘
                   │
         ┌─────────▼─────────┐
         │ UI Atualizado     │
         │ em ambas apps     │
         └───────────────────┘
```

---

## 7. 🗄️ Modelos de Dados

### Alert (Alerta)
```typescript
{
  id: string (UUID/ULID)
  userId: string (Firebase UID)
  symbol: string (ex: "BTCUSDT")
  target: number (preço-alvo)
  type: "above" | "below"
  active: boolean
  createdAt: timestamp
  updatedAt: timestamp
  lastTriggeredAt: timestamp (opcional)
}
```

### Notification (Notificação)
```typescript
{
  id: string
  userId: string
  alertId: string (referência ao alerta)
  title: string (ex: "Alerta BTCUSDT")
  message: string (ex: "BTC atingiu $62.500")
  read: boolean
  createdAt: timestamp
  triggeredAt: timestamp
}
```

### User (Usuário)
```typescript
{
  uid: string (Firebase UID)
  email: string
  nome: string
  createdAt: timestamp
  preferences: {
    notificationsEnabled: boolean
    emailNotifications: boolean
    language: "pt-BR" | "en-US"
  }
}
```

### CryptoPrice (Preço)
```typescript
{
  symbol: string (ex: "BTCUSDT")
  price: number (ex: 62672.0)
  timestamp: timestamp
}
```

---

## 8. 🚀 Tecnologias Específicas

### Frontend (viewer/pubspec.yaml)
```yaml
dependencies:
  flutter: sdk
  flutter_svg: ^2.0.0              # Renderizar SVGs
  
  cupertino_icons: ^1.0.8          # Ícones iOS
  http: ^1.2.1                     # Cliente HTTP
  provider: ^6.1.2                 # State management
  intl: ^0.19.0                    # Internacionalização
  shared_preferences: ^2.2.3       # Armazenamento local
  flutter_local_notifications: ^17.2.2  # Notificações locais
  firebase_core: ^3.0.0            # Firebase
  cloud_firestore: ^5.0.0          # Firestore
  ulid: ^2.0.0                     # Geração de IDs
```

### Backend (mobile/pubspec.yaml - Dart Frog)
```yaml
dependencies:
  dart_frog: ^1.1.0                # Framework HTTP
  http: ^1.6.0                     # Cliente HTTP
  postgres: ^3.5.6                 # Driver PostgreSQL
  dotenv: ^4.2.0                   # Environment variables
```

### Linguagens
- **Dart**: Backend (Dart Frog) + Frontend (Flutter)
- **Dart**: Scheduler de alertas
- **SQL**: Queries PostgreSQL
- **Firestore Rules**: Segurança Firestore

---

## 9. 📱 Plataformas Suportadas

| Plataforma | Status | Notas |
|-----------|--------|-------|
| **Android** | ✅ Suportado | APK compilável |
| **iOS** | ✅ Suportado | IPA compilável |
| **Web** | ✅ Suportado | Em desenvolvimento |
| **Desktop (Windows)** | ✅ Suportado | Configs presentes |
| **Desktop (macOS)** | ✅ Suportado | Configs presentes |
| **Desktop (Linux)** | ✅ Suportado | Configs presentes |

---

## 10. 🔐 Segurança

### Autenticação
- ✅ Firebase Authentication (OAuth, Email/Password)
- ✅ Session management via SharedPreferences
- ✅ Backend middleware para validação de tokens

### Autorização
- ✅ Firestore rules segregam dados por userID
- ✅ Backend valida autenticação em cada requisição
- ✅ Dados segregados em PostgreSQL

### Validação
- ✅ Estrutura rígida de documentos Firestore
- ✅ Validação de entrada no backend
- ✅ Tipo-segurança com Dart

### Dados em Trânsito
- ✅ HTTPS para todas as requisições (Railway SSL)
- ✅ Firebase Firestore com SSL
- ✅ PostgreSQL em conexão privada

---

## 11. 📊 Configuração e Deploy

### Backend (Dart Frog)

**Local Development**
```bash
cd mobile
dart pub get
dart run bin/server.dart
# Server rodando em http://localhost:8080
```

**Environment Variables** (`.env`)
```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=cryptoalert
DB_USER=postgres
DB_PASSWORD=yourpassword
FIREBASE_PROJECT_ID=criptalert-187b3
```

**Production** (Railway)
```
- Deploy via Git push ou Railway CLI
- Base URL: https://cryptoalertappapi-production.up.railway.app
- Porta: 8080 (exposta automaticamente)
```

### Frontend (Flutter)

**Web Development**
```bash
cd viewer
flutter run -d web
# Ou com port customizado:
flutter run -d web-server --web-port=5000
```

**Mobile Development**
```bash
cd viewer
flutter run -d android  # ou -d ios
```

**Firebase Setup**
```bash
cd viewer
# Configurar Firebase (já feito)
flutterfire configure
```

---

## 12. 📝 Estrutura de Dependências

### Dependências Backend
```
dart_frog (HTTP server)
  ├── http (requisições HTTP)
  ├── postgres (acesso PostgreSQL)
  └── dotenv (configurações)
```

### Dependências Frontend
```
flutter
  ├── http (requisições HTTP)
  ├── provider (state management)
  ├── firebase_core (autenticação)
  ├── cloud_firestore (dados)
  ├── flutter_local_notifications (notificações)
  ├── shared_preferences (cache local)
  └── intl (internacionalização)
```

---

## 13. 📈 Fluxo de Desenvolvimento

### 1. Criar Feature
```
1. Feature branch: git checkout -b feature/alert-reminder
2. Implementar mudanças (backend + frontend)
3. Testar localmente
4. Commit e push
5. PR review
6. Merge para main
```

### 2. Deploy
```
Backend:
  1. Push para `main` em `mobile/`
  2. Railway detecta e faz deploy automático
  3. Novo server ativo em ~2 min

Frontend:
  1. Build APK: flutter build apk --release
  2. Build iOS: flutter build ios --release
  3. Build Web: flutter build web
  4. Deploy conforme plataforma
```

---

## 14. 🧪 Testes

### Backend
```bash
cd mobile
dart test
# Testes usando mocktail para mocks
```

### Frontend
```bash
cd viewer
flutter test
# Widget tests e integration tests
```

### API Manual
```bash
# Testar endpoint de preço
curl "https://cryptoalertappapi-production.up.railway.app/crypto/price?symbol=BTCUSDT"

# Testar endpoint de alertas
curl -X GET "https://cryptoalertappapi-production.up.railway.app/alerts/list"
```

---

## 15. 🗺️ Roadmap

### ✅ Fase 1 (Atual)
- Backend com Dart Frog
- CRUD de alertas
- Integração Binance
- Scheduler de verificação
- Frontend web básico

### 🔄 Fase 2
- UI completa frontend
- Integração backend-frontend
- Testes automatizados
- Otimizações de performance

### ⏳ Fase 3
- App mobile (Android/iOS)
- Modo offline
- Análises e gráficos
- Suporte a múltiplas criptomoedas
- Histórico de alertas

### ⏳ Fase 4
- Alertas por pattern técnico
- Comparação de preços entre exchanges
- Integração com múltiplas exchanges
- API pública para terceiros
- Comunidade e social features

---

## 16. 📚 Documentação Adicional

- [API Integration Guide](viewer/lib/API_INTEGRATION_GUIDE.md)
- [Backend Development Log](mobile/docs/backend_development_log_EN.md)
- [Backend Development Log PT](mobile/docs/backend_development_log_PT.md)
- [Project Structure](viewer/lib/structurePresentation.md)

---

## 17. 🤝 Contribuindo

### Setup Local
```bash
# Clone
git clone https://github.com/seu-usuario/CryptoAlert_App.git
cd CryptoAlert_App

# Backend
cd mobile
dart pub get

# Frontend
cd ../viewer
flutter pub get

# Configure Firebase
flutterfire configure
```

### Padrões de Código
- ✅ Usar tipos explícitos (não `var`)
- ✅ Adicionar documentação em classes públicas
- ✅ Seguir padrão de pastas
- ✅ Testar antes de submeter PR

---

## 18. 📞 Contato e Suporte

**Projeto**: CryptoAlert - Monitoramento de Criptomoedas
**Versão**: 1.0.0
**Status**: Em desenvolvimento
**Desenvolvedor(a)**: [Seu Nome]
**Última Atualização**: 2024

---

## 📋 Checklist de Features

### Backend Completo ✅
- [x] API Binance integrada
- [x] Sistema de alertas (CRUD)
- [x] Scheduler de verificação
- [x] Autenticação middleware
- [x] Tratamento de erros
- [x] Endpoints REST completos

### Frontend Parcial 🔄
- [x] HTTP services criados
- [x] Modelos de dados
- [x] Firebase configurado
- [x] Auth estrutura básica
- [ ] Pages implementadas
- [ ] UI polida
- [ ] Gerenciamento de estado completo

### Integração 🔄
- [x] Backend-Frontend comunica
- [x] API endpoints funcionam
- [ ] Fluxo completo de user
- [ ] Sync multiplataforma completa
- [ ] Cache otimizado

---

*Análise gerada em: 2026-06-11*
