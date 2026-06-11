# 🚀 Guia Rápido de Setup

Siga este guia para colocar o CryptoAlert rodando em 10 minutos!

## ⚡ Quick Start (Modo Fácil)

### 1️⃣ Clonar e Entrar no Projeto

```bash
git clone https://github.com/seu-usuario/CryptoAlert_App.git
cd CryptoAlert_App
```

### 2️⃣ Rodar Backend (Terminal 1)

```bash
cd mobile
dart pub get
dart run bin/server.dart
```

✅ Você verá: `Server listening on port 8080`

### 3️⃣ Rodar Frontend (Terminal 2)

```bash
cd viewer
flutter pub get
flutter run -d web-server --web-port=37093
```

✅ Você verá: `Application running on http://localhost:37093`

### 4️⃣ Acessar no Navegador

Abra: **http://localhost:37093**

---

## 🔧 Setup Detalhado

### Pré-requisitos Verificar

```bash
# Verificar Flutter
flutter --version

# Verificar Dart
dart --version

# Verificar Git
git --version
```

Se algum não estiver instalado, [baixe aqui](https://flutter.dev/docs/get-started/install).

### Estrutura após Setup

```
CryptoAlert_App/
├── mobile/          ← Backend em Dart Frog (porta 8080)
├── viewer/          ← Frontend em Flutter (porta 37093)
└── ...
```

### Instalação de Dependências

#### Frontend
```bash
cd viewer
flutter pub get
flutter pub upgrade  # opcional, para atualizar dependências
```

#### Backend
```bash
cd mobile
dart pub get
dart pub upgrade     # opcional
```

---

## 🌐 Acessando a Aplicação

### Web (Recomendado para Desenvolvimento)

```bash
flutter run -d web-server --web-port=37093
```

Acesse: http://localhost:37093

### Chrome

```bash
flutter run -d chrome
```

### Android (Precisa de emulador)

```bash
flutter run -d android
```

### iOS (Precisa de Mac)

```bash
flutter run -d ios
```

### Linux Desktop

```bash
flutter run -d linux
```

---

## 🔌 Testando a API

### Verificar se Backend Está Rodando

```bash
# Teste endpoint de preço
curl http://localhost:8080/crypto/price?symbol=BTCUSDT

# Resposta esperada:
# {"symbol":"BTCUSDT","price":62672.0}
```

### Testar com Production API

```bash
# Sem rodar backend local, usar API em produção:
curl https://cryptoalertappapi-production.up.railway.app/crypto/price?symbol=BTCUSDT
```

---

## 🎯 Primeiro Login

1. Acesse http://localhost:37093
2. Veja formulário de login
3. Digite qualquer string (ex: `usuario123`)
4. Clique **LOGIN**
5. ✅ Você entrará na app!

> **Nota:** Autenticação é por ULID. Para produção, integre Firebase Auth.

---

## 📱 Navegação da Aplicação

| Aba | O que é | Como usar |
|-----|---------|-----------|
| 🔔 **Alertas** | Gerencia alertas de preço | Crie, edite, delete alertas |
| 📊 **Tabela** | Lista de criptomoedas | Veja preços em tempo real |
| 📰 **Notícias** | Moedas em trending | Conheça cryptos populares |
| 👤 **Perfil** | Dados do usuário | Veja informações da conta |

---

## 🛑 Troubleshooting Rápido

### Problema: Porta já está em uso

```bash
# Trocar porta
flutter run -d web-server --web-port=5000

# Ou liberar porta
lsof -ti:37093 | xargs kill -9
```

### Problema: "Failed to load platform channel"

```bash
# Limpar build
flutter clean
flutter pub get
flutter run -d web-server --web-port=37093
```

### Problema: API não responde

```bash
# Verificar se backend está rodando
ps aux | grep "dart run\|bin/server"

# Se não estiver, rodar:
cd mobile
dart run bin/server.dart
```

### Problema: "Cannot find module"

```bash
# Redownload dependências
flutter pub get --offline
flutter pub get
```

---

## 📚 Próximos Passos

- Ler [README.md](README.md) para arquitetura completa
- Explorar [API_INTEGRATION_GUIDE.md](viewer/lib/API_INTEGRATION_GUIDE.md)
- Ler [PROJECT_ANALYSIS.md](PROJECT_ANALYSIS.md) para detalhes técnicos

---

## 🆘 Precisa de Ajuda?

- Abra uma [Issue no GitHub](https://github.com/seu-usuario/CryptoAlert_App/issues)
- Leia [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Verifique [logs em /docs](docs/)

---

**Bom desenvolvimento! 🚀**
