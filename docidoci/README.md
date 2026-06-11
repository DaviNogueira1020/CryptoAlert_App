# CryptoAlert - Guia de Execução do Projeto

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Flutter 3.4.0+** (com Dart 3.4.0+)
- **Node.js 18+** (para o backend opcional)
- **Git**
- **PostgreSQL 12+** (para o backend)

## 🚀 Configuração Rápida

### 1. **Clonar o Repositório**

```bash
git clone https://github.com/DaviNogueira1020/CryptoAlert_App.git
cd CryptoAlert_App
```

### 2. **Configurar o Backend (Dart Frog)**

O backend está na pasta `mobile/` usando Dart Frog:

```bash
cd mobile

# Instalar dependências
dart pub get

# Executar o servidor (roda na porta 8080 por padrão)
dart run bin/server.dart
```

**Url do backend**: `http://localhost:8080`

> **Nota**: O backend necessita de acesso ao PostgreSQL e à Binance API. Verifique o arquivo `.env` para configurar as credenciais.

### 3. **Configurar o Frontend (Flutter)**

O frontend está na pasta `viewer/`:

```bash
cd viewer

# Instalar dependências
flutter pub get

# Executar no modo debug (Web, Android, iOS, Desktop, etc)
flutter run
```

## 📱 Executando em Diferentes Plataformas

### Web (Recomendado para desenvolvimento)

```bash
cd viewer
flutter run -d chrome
```

Acessa: `http://localhost:55000` (porta padrão pode variar)

### Android

```bash
cd viewer
flutter run -d android
```

> **Pré-requisito**: Android Studio + Android SDK configurado

### iOS

```bash
cd viewer
flutter run -d ios
```

> **Pré-requisito**: Xcode instalado em macOS

### Desktop (Windows/Linux/macOS)

```bash
cd viewer
flutter run -d windows  # Windows
flutter run -d linux    # Linux
flutter run -d macos    # macOS
```

## 🔧 Variáveis de Ambiente

### Backend (mobile/.env)

```env
# PostgreSQL
DATABASE_URL=postgresql://user:password@localhost:5432/cryptoalert

# Binance API (opcional)
BINANCE_API_KEY=your_key_here
BINANCE_API_SECRET=your_secret_here
```

### Frontend (viewer)

O frontend se conecta automaticamente em `http://localhost:8080`. Para alterar, edite:

```dart
// viewer/lib/data/services/alert_service.dart
static const String _baseUrl = 'http://localhost:8080';
```

## 📚 Estrutura de Pastas

```
CryptoAlert_App/
├── viewer/                 # Frontend Flutter
│   ├── lib/
│   │   ├── data/          # Models, Services, Repositories
│   │   ├── presentation/  # Pages, Controllers, Widgets
│   │   ├── domain/        # Entities, Usecases
│   │   └── main.dart      # Entry point
│   └── pubspec.yaml
│
├── mobile/                 # Backend Dart Frog
│   ├── lib/
│   │   ├── clients/       # HTTP clients
│   │   ├── config/        # Configurações
│   │   ├── modules/       # Domínios (alerts, crypto, etc)
│   │   └── scheduler/     # Tasks agendadas
│   ├── routes/            # Rotas HTTP (file-based)
│   ├── bin/server.dart    # Entry point
│   └── pubspec.yaml
│
└── docidoci/              # Documentação
    ├── README.md          # Este arquivo
    ├── API_DOCS.md        # Documentação de endpoints
    └── INTEGRATION.md     # Guia de integração
```

## ✅ Checklist de Configuração

- [ ] Flutter instalado e no PATH
- [ ] PostgreSQL rodando localmente
- [ ] Backend executado (`dart run bin/server.dart`)
- [ ] Frontend conectado ao backend
- [ ] Testes de API funcionando

## 🐛 Troubleshooting

### "Port 8080 already in use"

```bash
# Mude a porta no backend
PORT=8081 dart run bin/server.dart
```

### "Connection refused" no frontend

- Verifique se o backend está rodando
- Verifique se a URL base está correta em `alert_service.dart`
- Cheque firewall/antivírus

### "Pubspec dependency error"

```bash
flutter clean
flutter pub get
```

## 📖 Próximas Leituras

- [API_DOCS.md](API_DOCS.md) - Documentação de endpoints
- [INTEGRATION.md](INTEGRATION.md) - Como integrar os services nas suas páginas
- [Mobile Backend Log](../mobile/docs/backend_development_log_PT.md) - Log de desenvolvimento backend

---

**Última atualização**: Junho 2026
