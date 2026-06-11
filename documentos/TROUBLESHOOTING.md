# 🐛 Guia de Troubleshooting

Soluções para problemas comuns ao desenvolver CryptoAlert.

---

## 📋 Índice Rápido

- [Problemas de Porta](#problemas-de-porta)
- [Problemas de Dependências](#problemas-de-dependências)
- [Problemas de API](#problemas-de-api)
- [Problemas de Frontend](#problemas-de-frontend)
- [Problemas de Backend](#problemas-de-backend)
- [Problemas de Firebase](#problemas-de-firebase)
- [Perguntas Frequentes](#perguntas-frequentes)

---

## 🔌 Problemas de Porta

### ❌ "Address already in use: 37093"

**Causa:** Outra instância do Flutter já está usando a porta.

**Solução 1:** Trocar de porta
```bash
flutter run -d web-server --web-port=5000
```

**Solução 2:** Matar processo antigo
```bash
# Listar processos na porta
lsof -ti:37093

# Matar processo
lsof -ti:37093 | xargs kill -9
```

**Solução 3:** Reiniciar o sistema

---

### ❌ "Cannot assign requested address"

**Causa:** Endereço IP está incorreto ou não está disponível.

**Solução:**
```bash
# Usar localhost explicitamente
flutter run -d web-server --web-hostname=localhost --web-port=37093
```

---

## 📦 Problemas de Dependências

### ❌ "Pub get" trava ou fica lento

**Solução 1:** Limpar cache
```bash
dart pub cache clean
flutter pub get
```

**Solução 2:** Usar offline mode
```bash
flutter pub get --offline
```

**Solução 3:** Verificar conexão de internet
```bash
ping pub.dev
```

---

### ❌ "Dependency conflict"

**Causa:** Versões incompatíveis de pacotes.

**Solução:**
```bash
# Backend
cd mobile
dart pub upgrade

# Frontend
cd viewer
flutter pub upgrade
```

Se ainda não funcionar, editar `pubspec.yaml` manualmente.

---

### ❌ "Package not found"

**Solução:**
```bash
# Redownload tudo
flutter clean
flutter pub get
```

---

## 🔌 Problemas de API

### ❌ "Failed to connect to localhost:8080"

**Causa:** Backend não está rodando.

**Solução 1:** Verificar se backend está ativo
```bash
curl http://localhost:8080/crypto/price?symbol=BTCUSDT
```

**Solução 2:** Rodar backend manualmente
```bash
cd mobile
dart run bin/server.dart
```

**Solução 3:** Ver logs do backend
```bash
dart run bin/server.dart 2>&1 | tail -50
```

---

### ❌ "HTTP 500 - Internal Server Error"

**Causa:** Erro no código backend.

**Solução:**
```bash
# Rodar backend com verbose
dart run bin/server.dart --verbose

# Ver logs de erro
# Se usar Firebase, verificar console do Firebase
```

---

### ❌ "API returns empty response"

**Causa:** Endpoint não retorna dados esperados.

**Solução:**
```bash
# Testar manualmente
curl -v http://localhost:8080/alerts/list

# Se vazio, verificar banco de dados
# Pode estar sem dados iniciais
```

---

### ❌ "CORS Error"

**Causa:** Backend não permite requisições do frontend.

**Solução:** Adicionar headers CORS no backend

```dart
// mobile/lib/middlewares/cors_middleware.dart
Response addCorsHeaders(Response response) {
  return response.copyWith(
    headers: {
      ...response.headers,
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    },
  );
}
```

---

## 🎨 Problemas de Frontend

### ❌ "Particles not showing"

**Causa:** ParticleBackground não foi adicionado à página.

**Solução:**
```dart
// Ao invés de:
@override
Widget build(BuildContext context) {
  return Scaffold(...);
}

// Use:
@override
Widget build(BuildContext context) {
  return AnimatedBackground(
    child: Scaffold(...),
  );
}
```

---

### ❌ "Content is transparent/invisible"

**Causa:** AnimatedBackground está sobrepondo o conteúdo.

**Solução:** Verificar ordem no Stack

```dart
// ❌ Errado - partículas encobrindo conteúdo
Stack([
  ParticleBackground(),
  Conteudo(), // será transparente
])

// ✅ Certo - AnimatedBackground cuida disso
AnimatedBackground(
  child: Conteudo(), // visível
)
```

---

### ❌ "App lenta / lag nas animações"

**Causa:** Muitas partículas ou redraw frequency alta.

**Solução:**
```dart
// Em particle_background.dart, reduzir quantidade
static const int particleCount = 150; // ao invés de 250
```

---

### ❌ "Icons/Images não aparecem"

**Causa:** Caminho de assets incorreto.

**Solução:**
```dart
// Verificar pubspec.yaml
flutter:
  assets:
    - assets/Icons/
    - assets/Logo/
    - assets/Images/

# Depois:
flutter pub get
```

---

### ❌ "Login não funciona"

**Causa:** SharedPreferences não está armazenando dados.

**Solução:**
```bash
# Limpar dados locais e tentar novamente
flutter clean

# Ou no código, resetar SharedPreferences
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.clear();
```

---

## ⚙️ Problemas de Backend

### ❌ "Dart Frog dev command not found"

**Solução:**
```bash
# Usar dart run diretamente
cd mobile
dart run bin/server.dart

# Ou instalar Dart Frog
dart pub global activate dart_frog_cli
dart_frog dev
```

---

### ❌ "PostgreSQL connection failed"

**Causa:** Banco de dados não está rodando ou credenciais incorretas.

**Solução:**
```bash
# Verificar se PostgreSQL está rodando
sudo systemctl status postgresql

# Se não, iniciar
sudo systemctl start postgresql

# Testar conexão
psql -U postgres -d cryptoalert
```

---

### ❌ "Binance API rate limit exceeded"

**Causa:** Muitas requisições em pouco tempo.

**Solução:**
```dart
// Em mobile/lib/clients/binance_client.dart
// Adicionar delay entre requisições
await Future.delayed(Duration(milliseconds: 200));
```

---

### ❌ "Scheduler não está rodando"

**Causa:** Scheduler não foi iniciado ou tem erro.

**Solução:**
```dart
// Em mobile/bin/server.dart, verificar:
// AlertsScheduler().start();

// Ou debugar manualmente:
final scheduler = AlertsScheduler();
await scheduler.checkAlerts();
```

---

## 🔥 Problemas de Firebase

### ❌ "Firebase initialization failed"

**Causa:** Credenciais do Firebase estão incorretas.

**Solução:**
```dart
// Desabilitar Firebase em web/desktop (temporário)
if (kIsWeb) {
  // Pular inicialização Firebase
} else {
  await Firebase.initializeApp();
}
```

---

### ❌ "Firestore rules denied access"

**Causa:** Security rules estão muito restritivas.

**Solução:** Verificar/atualizar firestore.rules

```
match /users/{userId} {
  allow read, write: if request.auth.uid == userId;
}

match /alerts/{alertId} {
  allow read, write: if request.auth.uid == resource.data.userId;
}
```

---

### ❌ "Firestore connection timeout"

**Causa:** Firestore emulator não está rodando.

**Solução:**
```bash
# Iniciar emulator
firebase emulators:start

# Ou desabilitar Firestore para desenvolvimento
```

---

## ❓ Perguntas Frequentes

### P: Como mudar a URL da API?

R: Edite `viewer/lib/config/api_config.dart`:
```dart
static const String baseUrl = 'nova-url-aqui';
```

---

### P: Como debugar requisições HTTP?

R: Use `http.Client` com logs:
```dart
final client = http.Client();
final response = await client.get(uri);
print('Status: ${response.statusCode}');
print('Body: ${response.body}');
```

---

### P: Como adicionar um novo endpoint?

R: Criar arquivo em `mobile/routes/`:
```dart
// mobile/routes/novo_endpoint/index.dart
Future<Response> onRequest(RequestContext context) async {
  return Response.json(body: {'message': 'Hello'});
}
```

---

### P: Como testar API localmente sem frontend?

R: Use curl ou Postman:
```bash
curl -X GET http://localhost:8080/alerts/list
curl -X POST http://localhost:8080/alerts/create \
  -H "Content-Type: application/json" \
  -d '{"symbol":"BTCUSDT","target":65000,"type":"above"}'
```

---

### P: Como resetar tudo e começar do zero?

R: Execute esses comandos:
```bash
# Limpar Flutter
flutter clean
cd viewer
rm -rf .dart_tool pubspec.lock
flutter pub get

# Limpar Dart
cd ../mobile
dart pub cache clean
dart pub get
```

---

### P: Como contribuir com fixes?

R: Veja [README.md#contribuindo](README.md#-contribuindo)

---

## 🆘 Ainda não funcionou?

1. **Leia os logs completos** - não apenas a última linha
2. **Google o erro** - a maioria tem solução online
3. **Abra uma Issue** - https://github.com/seu-usuario/CryptoAlert_App/issues
4. **Consulte a documentação** - [README.md](README.md), [SETUP.md](SETUP.md)

---

**Boa sorte! 🚀**
