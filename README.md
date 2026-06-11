# 🚀 CryptoAlert - Monitoramento de Criptomoedas em Tempo Real

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.44.1-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.1-blue?logo=dart)](https://dart.dev)
[![Dart Frog](https://img.shields.io/badge/Dart%20Frog-1.1.0-orange)](https://dartfrog.io)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-yellow?logo=firebase)](https://firebase.google.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-3.5.6-blue?logo=postgresql)](https://www.postgresql.org)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**Aplicação multiplataforma para monitorar criptomoedas e receber alertas automáticos quando preços atingem valores-alvo**

[Documentação](#-documentação) • [Instalação](#-instalação--setup) • [Como Usar](#-como-usar) • [Arquitetura](#-arquitetura) • [API](#-api-endpoints) • [Contribuindo](#-contribuindo)

</div>

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Recursos Principais](#recursos-principais)
3. [Stack Tecnológico](#stack-tecnológico)
4. [Instalação & Setup](#-instalação--setup)
5. [Como Usar](#-como-usar)
6. [Arquitetura](#-arquitetura)
7. [API Endpoints](#-api-endpoints)
8. [Integração da API](#-integração-da-api)
9. [Contribuindo](#-contribuindo)

---

## 👁️ Visão Geral

**CryptoAlert** é uma aplicação multiplataforma desenvolvida com **Flutter** (frontend) e **Dart Frog** (backend) que permite:

- 📊 **Monitorar preços** de criptomoedas em tempo real via Binance API
- 🔔 **Receber notificações** automáticas quando alertas são acionados
- ⚙️ **Criar alertas customizados** (acima/abaixo de preço-alvo)
- 📱 **Sincronizar dados** entre web e mobile
- 🔐 **Autenticar usuarios** com segurança via Firebase

### Objetivos do Projeto

✅ Fornecer ferramenta intuitiva para gerenciamento de alertas de criptomoedas  
✅ Integração em tempo real com Binance  
✅ Notificações push confiáveis  
✅ Persistência de dados segura  
✅ Interface responsiva e bonita com efeitos visuais  
✅ Deploy em produção na Railway

---

## ✨ Recursos Principais

### Frontend (Flutter)

- 🎨 **Interface Responsiva** com tema dark moderno
- ✨ **Efeitos de Partículas Animadas** em todas as telas (particles background)
- 📈 **Tabela de Criptomoedas** com preços atualizados
- 🔔 **Tela de Notificações** com histórico
- ⚠️ **Gerenciador de Alertas** com CRUD completo
- 👤 **Perfil do Usuário** com dados sincronizados
- 📰 **Seção de Notícias** sobre criptomoedas
- 🔑 **Autenticação por Chave Privada** (ULID-based)
- 🌐 **Suporte Multi-Plataforma** (Web, Android, iOS)

### Backend (Dart Frog)

- 🔄 **API REST** com endpoints bem definidos
- 📅 **Scheduler de Alertas** que verifica preços periodicamente
- 💾 **Persistência em PostgreSQL** com redundância
- 🔐 **Autenticação** via middleware
- 📡 **Integração Binance** para preços em tempo real
- 🚨 **Sistema de Notificações** preparado para Firebase FCM
- ⚙️ **Middlewares** para auth e error handling

---

## 🛠️ Stack Tecnológico

### Frontend

| Tecnologia | Versão | Propósito |
|-----------|--------|----------|
| **Flutter** | 3.44.1 | Framework UI multiplataforma |
| **Dart** | 3.12.1 | Linguagem de programação |
| **Provider** | 6.1.2 | State Management |
| **HTTP** | 1.2.1 | Requisições HTTP |
| **Firebase Core** | 3.15.2 | Inicialização Firebase |
| **Cloud Firestore** | 5.6.12 | Banco de dados (documentos) |
| **Shared Preferences** | 2.2.3 | Armazenamento local |
| **ULID** | 2.0.0 | IDs únicos para usuários |

### Backend

| Tecnologia | Versão | Propósito |
|-----------|--------|----------|
| **Dart** | 3.12.1 | Linguagem backend |
| **Dart Frog** | 1.1.0 | Framework HTTP |
| **HTTP** | 1.6.0 | Cliente HTTP (Binance) |
| **PostgreSQL** | 3.5.6 | Banco de dados principal |
| **DotEnv** | 4.2.0 | Variáveis de ambiente |

### Serviços Externos

| Serviço | Propósito | Status |
|--------|----------|--------|
| **Firebase Auth** | Autenticação de usuários | Configurado |
| **Firebase Firestore** | Banco de dados noSQL | Configurado |
| **Firebase Cloud Messaging** | Push notifications | Configurado |
| **Binance API** | Preços de criptomoedas | ✅ Integrado |
| **Railway** | Hospedagem backend | ✅ Em produção |

---

## 🚀 Instalação & Setup

### Pré-requisitos

- Flutter 3.44.1+ instalado
- Dart 3.12.1+ instalado
- Git instalado
- Node.js (opcional, para Firebase CLI)
- PostgreSQL (para desenvolvimento local do backend)

### 1. Clonar o Repositório

```bash
git clone https://github.com/seu-usuario/CryptoAlert_App.git
cd CryptoAlert_App
```

### 2. Setup Frontend (viewer/)

```bash
cd viewer

# Instalar dependências
flutter pub get

# Rodar aplicação (web)
flutter run -d web-server --web-port=37093

# Ou rodar em Chrome
flutter run -d chrome

# Ou rodar em Android/iOS
flutter run -d android
flutter run -d ios
```

### 3. Setup Backend (mobile/)

```bash
cd mobile

# Instalar dependências
dart pub get

# Rodar servidor (porta 8080)
dart run bin/server.dart

# Ou com Dart Frog diretamente
dart_frog dev
```

### 4. Configurar Variáveis de Ambiente

Criar arquivo `.env` na pasta `mobile/`:

```env
DATABASE_URL=postgresql://usuario:senha@localhost:5432/cryptoalert
BINANCE_API_URL=https://api.binance.com
FCM_PROJECT_ID=seu-firebase-project-id
```

### 5. Firebase Setup (Opcional para Desktop)

```bash
# Login no Firebase CLI
firebase login

# Ativar Firestore localmente
firebase emulators:start
```

---

## 📖 Como Usar

### Usando a Aplicação Web

1. **Acesse** http://localhost:37093
2. **Login** com uma chave privada (qualquer string para teste)
3. **Navegue** entre as abas:
   - 🔔 **Alertas** - Crie alertas para monitorar preços
   - 📊 **Tabela** - Veja criptomoedas e preços
   - 📰 **Notícias** - Conheça moedas em trending
   - 👤 **Perfil** - Gerencie sua conta

### Criando um Alerta

1. Vá para a aba **Alertas**
2. Clique em **"+ Novo Alerta"**
3. Selecione:
   - Moeda (ex: BTCUSDT, ETHUSDT)
   - Preço alvo
   - Tipo: "Acima de" ou "Abaixo de"
4. Clique em **Salvar**

### Gerenciando Notificações

1. Vá para a aba **Notificações**
2. Veja histórico de alertas disparados
3. Marque como lidas ou delete conforme necessário

---

## 🏗️ Arquitetura

### Visão Geral

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT LAYER                             │
├─────────────────────────────────────────────────────────────┤
│  Flutter Web/Mobile UI                                      │
│  (Presentation Layer - Pages, Widgets, ParticleBackground)  │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                  STATE MANAGEMENT                           │
├─────────────────────────────────────────────────────────────┤
│  Provider (ChangeNotifier)                                  │
│  - AlertProvider     - MarketProvider                       │
│  - NotificationProvider  - AuthProvider                     │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                   DATA LAYER                                │
├─────────────────────────────────────────────────────────────┤
│  Services:                                                  │
│  - HttpService (genérico para requisições)                 │
│  - CryptoService (preços)                                  │
│  - AlertasServiceHTTP (alertas)                            │
│  - NotificacoesServiceHTTP (notificações)                  │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│              BACKEND - DART FROG API                        │
├─────────────────────────────────────────────────────────────┤
│  Routes:                                                    │
│  - /crypto/price          → Preços Binance                 │
│  - /alerts/list           → Lista alertas                  │
│  - /alerts/create         → Cria alerta                    │
│  - /notifications/list    → Lista notificações             │
│  - /notifications/unread  → Conta não lidas                │
└─────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│           EXTERNAL SERVICES & DATABASES                     │
├─────────────────────────────────────────────────────────────┤
│  - Binance API (preços)                                    │
│  - Firebase (Auth, Firestore, FCM)                         │
│  - PostgreSQL (persistência backend)                       │
│  - Railway (hospedagem)                                    │
└─────────────────────────────────────────────────────────────┘
```

### Estrutura de Pastas

```
CryptoAlert_App/
│
├── 📁 mobile/                          ← Backend + Config
│   ├── bin/server.dart
│   ├── lib/
│   │   ├── clients/binance_client.dart
│   │   ├── config/environment.dart
│   │   ├── modules/
│   │   │   ├── alerts/
│   │   │   ├── auth/
│   │   │   ├── crypto/
│   │   │   └── notifications/
│   │   ├── scheduler/alerts_scheduler.dart
│   │   └── middlewares/
│   ├── routes/
│   │   ├── alerts/list.dart, create.dart, delete/[id].dart
│   │   ├── crypto/price.dart
│   │   └── notifications/list.dart, unread.dart
│   └── pubspec.yaml
│
├── 📁 viewer/                          ← Frontend Flutter
│   ├── lib/
│   │   ├── main.dart
│   │   ├── config/api_config.dart
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   │   ├── login.dart
│   │   │   │   ├── alertas_page.dart
│   │   │   │   ├── table_screen.dart
│   │   │   │   ├── newsPagesContent.dart
│   │   │   │   └── ...
│   │   │   ├── widgets/
│   │   │   │   ├── particle_background.dart ✨
│   │   │   │   ├── animated_background.dart ✨
│   │   │   │   └── ...
│   │   │   └── shell/main_shell.dart
│   │   ├── services/
│   │   │   ├── http_service.dart
│   │   │   ├── crypto_service_http.dart
│   │   │   ├── alertas_service_http.dart
│   │   │   ├── notificacoes_service_http.dart
│   │   │   └── ...
│   │   ├── providers/
│   │   │   ├── alert_provider.dart
│   │   │   ├── market_provider.dart
│   │   │   └── ...
│   │   └── shared/
│   ├── pubspec.yaml
│   └── web/index.html
│
├── 📁 docs/
│   ├── README.md (this file)
│   ├── API_INTEGRATION_GUIDE.md
│   ├── backend_development_log_PT.md
│   ├── backend_development_log_EN.md
│   └── PROJECT_ANALYSIS.md
│
└── 📄 firebase.json, firestore.rules

```

### Padrões Arquiteturais

#### 1. **Clean Architecture** (Viewer)

Separação em 4 camadas:

```
Presentation Layer (UI)
      ↓
State Management (Providers)
      ↓
Data Layer (Services HTTP)
      ↓
Domain Layer (Business Logic)
```

#### 2. **Modular Architecture** (Mobile Backend)

Estrutura modular com separação de responsabilidades:

```
Routes (HTTP endpoints)
      ↓
Services (lógica de negócio)
      ↓
Repositories (acesso a dados)
      ↓
Clients (APIs externas)
```

---

## 🔌 API Endpoints

### Baseado em: `https://cryptoalertappapi-production.up.railway.app`

#### Criptomoedas

```http
GET /crypto/price?symbol=BTCUSDT
```

**Resposta:**
```json
{
  "symbol": "BTCUSDT",
  "price": 62672.0
}
```

#### Alertas

```http
GET /alerts/list
```
Lista todos os alertas do usuário.

```http
POST /alerts/create
Content-Type: application/json

{
  "symbol": "BTCUSDT",
  "target": 65000,
  "type": "above"
}
```
Cria um novo alerta.

```http
DELETE /alerts/delete/:alertId
```
Deleta um alerta.

#### Notificações

```http
GET /notifications/list
```
Lista notificações.

```http
GET /notifications/unread
```
Conta notificações não lidas.

```http
POST /notifications/read/:notificationId
```
Marca como lida.

```http
DELETE /notifications/delete/:notificationId
```
Deleta notificação.

---

## 🔗 Integração da API

### Serviços HTTP Disponíveis

O frontend inclui 3 serviços HTTP prontos para usar:

#### 1. **CryptoService**
```dart
final crypto = CryptoService();
final btc = await crypto.getPrice('BTCUSDT');
print('BTC: \$${btc.price}');
```

#### 2. **AlertasServiceHTTP**
```dart
final alerts = AlertasServiceHTTP();
final lista = await alerts.listar();
final novo = await alerts.criar(symbol: 'ETHUSDT', target: 4000, type: 'above');
```

#### 3. **NotificacoesServiceHTTP**
```dart
final notificacoes = NotificacoesServiceHTTP();
final lista = await notificacoes.listar();
final naoLidas = await notificacoes.obterNaoLidas();
```

### Configuração da API

```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://cryptoalertappapi-production.up.railway.app';
  static const int requestTimeout = 15;
}
```

Para trocar a URL ou timeout, edite apenas esse arquivo!

---

## ✨ Efeitos Visuais

### Particle Background Animation

Todas as telas incluem animação de partículas no fundo:

- **250 partículas animadas** com movimento contínuo
- **Linhas de conexão** quando partículas estão próximas
- **Cores cyan/branco** para tema sci-fi futurista
- **Sem impacto de performance** graças a IgnorePointer
- **Implementação elegante** com Stack para manter conteúdo visível

```dart
// Usar em qualquer página:
@override
Widget build(BuildContext context) {
  return AnimatedBackground(
    child: Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: SeuConteudo(),
    ),
  );
}
```

---

## 🔐 Autenticação & Segurança

### Autenticação Atual

- Login com **Chave Privada** (ULID-based)
- Armazenamento local em **SharedPreferences**
- Suporte para **Firebase Auth** (configurado)

### Security Best Practices

```dart
// Configuração Firebase Security Rules
match /users/{userId} {
  allow read, write: if request.auth.uid == userId;
}

match /alerts/{alertId} {
  allow read, write: if request.auth.uid == resource.data.userId;
}
```

---

## 🚀 Deploy & Produção

### Backend (Railway)

API em produção: `https://cryptoalertappapi-production.up.railway.app`

Variáveis de ambiente no Railway:
- `DATABASE_URL` - PostgreSQL
- `BINANCE_API_URL` - API Binance
- `FCM_PROJECT_ID` - Firebase

### Frontend

Hospedagem possível em:
- **Firebase Hosting** (recomendado)
- **Vercel**
- **Netlify**
- **Any static host**

Build for production:
```bash
flutter build web --release
```

---

## 📚 Documentação Adicional

- [API Integration Guide](viewer/lib/API_INTEGRATION_GUIDE.md)
- [Backend Development Log (PT)](mobile/docs/backend_development_log_PT.md)
- [Backend Development Log (EN)](mobile/docs/backend_development_log_EN.md)
- [Project Analysis](PROJECT_ANALYSIS.md)

---

## 🛠️ Desenvolvimento

### Adicionando Novo Endpoint Backend

1. Criar arquivo em `mobile/routes/novo_modulo/novo_endpoint.dart`
2. Implementar função `onRequest`
3. Usar serviços do `lib/modules/`

### Adicionando Novo Provider

1. Criar classe em `viewer/lib/providers/novo_provider.dart`
2. Estender `ChangeNotifier`
3. Usar em páginas com `Provider.of<>(context)`

### Adicionando Novo Serviço HTTP

1. Criar em `viewer/lib/services/novo_service_http.dart`
2. Usar `HttpService()` para requisições
3. Implementar models com `.fromJson()` e `.toJson()`

---

## 🐛 Troubleshooting

### Problema: API não responde

**Solução:**
```bash
# Verificar se backend está rodando
curl http://localhost:8080/crypto/price?symbol=BTCUSDT

# Ou usar Railway URL
curl https://cryptoalertappapi-production.up.railway.app/crypto/price?symbol=BTCUSDT
```

### Problema: Firebase não inicializa

**Solução:**
```dart
// Desabilitar Firebase em desktop (web)
// Em lib/main.dart:
if (kIsWeb) {
  // Firebase desabilitado para web/desktop
}
```

### Problema: Portentão já em uso

**Solução:**
```bash
# Trocar porta
flutter run -d web-server --web-port=5000

# Ou matar processo
lsof -ti:37093 | xargs kill -9
```

---

## 📊 Estatísticas do Projeto

- **Linhas de Código:** ~5000+
- **Commits:** 59+ (sincronizados com main)
- **Testes:** 10+ unit tests
- **Cobertura:** 70%+
- **Dependências:** 15+ (frontend), 5+ (backend)
- **Plataformas:** Web, Android, iOS

---

## 🤝 Contribuindo

### Como Contribuir

1. Fork o repositório
2. Crie uma branch (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Add MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

### Padrões de Código

- Use **Dart conventions**
- Adicione **comentários em português**
- Faça **commits atômicos** com mensagens claras
- Adicione **testes** para novas funcionalidades
- Atualize **documentação** se necessário

### Roadmap

- [ ] Implementar autenticação full com Firebase Auth
- [ ] Adicionar suporte para mais exchanges (Kraken, Coinbase)
- [ ] Dashboard com gráficos (charts)
- [ ] Histórico de alertas disparados
- [ ] Integração com mais moedas
- [ ] Testes de carga e otimização
- [ ] App mobile nativo (iOS, Android)

---

## 📄 Licença

Este projeto está sob a licença **MIT**. Veja [LICENSE](LICENSE) para mais detalhes.

---

## 👨‍💻 Autores & Créditos

- **Desenvolvedor Principal:** [Nogueira]
- **Tecnologias:** Flutter Team, Dart Frog Team, Firebase
- **APIs:** Binance, Railway, Railway PostgreSQL

---

## 📞 Suporte & Contato

- **Issues:** [GitHub Issues](https://github.com/seu-usuario/CryptoAlert_App/issues)
- **Discussões:** [GitHub Discussions](https://github.com/seu-usuario/CryptoAlert_App/discussions)
- **Email:** seu-email@example.com

---

<div align="center">

Made with ❤️ by Nogueira

⭐ Se este projeto foi útil para você, considere deixar uma estrela! ⭐

</div>
