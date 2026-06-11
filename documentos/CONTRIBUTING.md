# 🤝 Guia de Contribuição

Obrigado por considerar contribuir para o CryptoAlert! Este documento fornece diretrizes e instruções para fazer contribuições ao projeto.

---

## 📋 Índice

- [Código de Conduta](#código-de-conduta)
- [Como Contribuir](#como-contribuir)
- [Padrões de Código](#padrões-de-código)
- [Processo de Pull Request](#processo-de-pull-request)
- [Reportando Bugs](#reportando-bugs)
- [Sugerindo Melhorias](#sugerindo-melhorias)
- [Roadmap](#roadmap)

---

## 📜 Código de Conduta

### Nossa Promessa

Nos comprometemos a fornecer um ambiente acolhedor para todos, independentemente de:
- Idade
- Tamanho do corpo
- Deficiência
- Etnia
- Identidade de gênero
- Nível de experiência
- Nacionalidade
- Aparência pessoal
- Raça
- Religião
- Identidade e orientação sexual

### Nossos Padrões

Exemplos de comportamento que contribuem para criar um ambiente positivo:
- ✅ Usar linguagem acolhedora e inclusiva
- ✅ Ser respeitoso com pontos de vista divergentes
- ✅ Aceitar críticas construtivas com graça
- ✅ Focar no que é melhor para a comunidade
- ✅ Mostrar empatia com membros da comunidade

Exemplos de comportamento inaceitável:
- ❌ Linguagem ou imagens sexualizadas
- ❌ Trolling, comentários insultuosos, ataques pessoais
- ❌ Assédio público ou privado
- ❌ Publicar informações privadas de outros
- ❌ Condutas que possam ser consideradas inapropriadas

---

## 💡 Como Contribuir

### Formas de Contribuição

#### 1. **Reportar Bugs**
- Encontrou um erro? [Abra uma Issue](https://github.com/seu-usuario/CryptoAlert_App/issues/new)

#### 2. **Sugerir Melhorias**
- Ideia para nova feature? [Crie uma Discussion](https://github.com/seu-usuario/CryptoAlert_App/discussions)

#### 3. **Enviar Pull Request**
- Quer desenvolver? Siga o [Processo de PR](#processo-de-pull-request)

#### 4. **Melhorar Documentação**
- Docs podem melhorar? Envie um PR!

#### 5. **Otimizar Código**
- Encontrou código que pode melhorar? Refatore com PR

---

## 👨‍💻 Padrões de Código

### Dart/Flutter

#### Formatting

```bash
# Formatar código
dart format lib/
flutter format lib/

# Analisar
dart analyze
flutter analyze
```

#### Nomenclatura

```dart
// Classes: PascalCase
class UserModel { }

// Funções/variáveis: camelCase
void getUserData() { }
int userData = 0;

// Constantes: camelCase
const int maxRetries = 3;

// Privadas: com underscore
class _PrivateClass { }
void _privateFunction() { }
```

#### Comentários

```dart
// ✅ Bom - comentários descritivos em português
/// Obtém preço da criptomoeda da Binance API
/// 
/// Parâmetros:
/// - symbol: símbolo da moeda (ex: BTCUSDT)
/// 
/// Retorna:
/// CryptoPrice com os dados
Future<CryptoPrice> getPrice(String symbol) async { ... }

// ❌ Ruim - comentários vagos
void getPrice() { ... } // gets price
```

#### Tipagem

```dart
// ✅ Bom - tipos explícitos
final List<String> symbols = ['BTC', 'ETH'];
Future<List<Alerta>> getAlerts() async { ... }

// ❌ Ruim - tipos implícitos
var symbols = ['BTC', 'ETH'];
getAlerts() async { ... }
```

#### Error Handling

```dart
// ✅ Bom - tratamento específico
try {
  final price = await getPrice(symbol);
  return price;
} on SocketException {
  throw Exception('Falha de conexão');
} on FormatException {
  throw Exception('Formato de resposta inválido');
} catch (e) {
  throw Exception('Erro desconhecido: $e');
}

// ❌ Ruim - ignora erros
final price = await getPrice(symbol);
```

### Backend (Dart Frog)

#### Rotas

```dart
// ✅ Bom - função bem documentada e tipada
/// GET /alerts/list
/// Retorna lista de alertas do usuário
Future<Response> onRequest(RequestContext context) async {
  try {
    final alerts = await AlertsService().getAlerts();
    return Response.json(body: alerts);
  } catch (e) {
    return Response.json(
      statusCode: 500,
      body: {'error': 'Erro ao listar alertas'},
    );
  }
}

// ❌ Ruim - sem tratamento de erro
Future<Response> onRequest(RequestContext context) async {
  final alerts = await AlertsService().getAlerts();
  return Response.json(body: alerts);
}
```

---

## 🔄 Processo de Pull Request

### 1. Fork e Clone

```bash
# Fork no GitHub (botão "Fork")

# Clone seu fork
git clone https://github.com/seu-usuario/CryptoAlert_App.git
cd CryptoAlert_App

# Adicionar upstream
git remote add upstream https://github.com/usuario-original/CryptoAlert_App.git
```

### 2. Criar Branch

```bash
# Sincronizar com main
git fetch upstream
git checkout main
git merge upstream/main

# Criar branch com nome descritivo
git checkout -b feature/adicionar-dark-mode
git checkout -b fix/alertas-nao-salvam
git checkout -b docs/adicionar-guia-api
```

### Convenção de Nomes

- `feature/` - nova funcionalidade
- `fix/` - correção de bug
- `docs/` - mudança de documentação
- `refactor/` - refatoração sem mudança de funcionalidade
- `chore/` - tarefas de manutenção
- `test/` - adição de testes

### 3. Fazer Mudanças

```bash
# Editar arquivos

# Testar localmente
flutter test
dart analyze

# Formatar código
dart format lib/
```

### 4. Commit

```bash
# ✅ Commits atômicos e descritivos
git add lib/services/novo_service.dart
git commit -m "feat: adicionar novo serviço de crypto"

git add lib/models/novo_model.dart
git commit -m "feat: criar modelo de dados"

# ❌ Evitar
git commit -m "mudanças varias"
git commit -m "wip" # work in progress
```

### Convenção de Commits

Usar [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

Tipos:
- `feat:` - nova funcionalidade
- `fix:` - correção de bug
- `docs:` - mudança de documentação
- `style:` - formatação (não altera lógica)
- `refactor:` - refatoração
- `perf:` - melhorias de performance
- `test:` - adição/mudança de testes
- `chore:` - tarefas de manutenção

Exemplos:

```bash
git commit -m "feat(alerts): permitir criar alertas por preço-alvo"
git commit -m "fix(notifications): notificações não disparam corretamente"
git commit -m "docs(readme): atualizar instruções de instalação"
git commit -m "refactor(services): simplificar lógica de HTTP client"
git commit -m "perf(particles): otimizar renderização de partículas"
```

### 5. Push e PR

```bash
# Push para seu fork
git push origin feature/adicionar-dark-mode

# Abrir PR no GitHub
# - Descrição clara do que foi feito
# - Referência a issues (#123)
# - Screenshots se for UI
# - Checklist de testes
```

### PR Template

```markdown
## Descrição
Breve descrição do que foi feito.

## Tipo de Mudança
- [ ] Nova funcionalidade
- [ ] Correção de bug
- [ ] Breaking change
- [ ] Mudança de documentação

## Como foi testado?
Descrever como você testou esta mudança.

## Checklist
- [ ] Código segue style guide
- [ ] Comentários adicionados
- [ ] Documentação atualizada
- [ ] Testes passam
- [ ] Sem warnings de análise

## Screenshots (se aplicável)
Cole screenshots de UI changes.

## Issues Relacionadas
Fixes #123
```

---

## 🐛 Reportando Bugs

### Antes de Reportar

1. **Procure por issues existentes** - seu bug já pode estar reportado
2. **Verifique documentação** - pode ser uso incorreto
3. **Teste com versão latest** - bug pode já estar corrigido

### Como Reportar

Use o [Bug Report Template](https://github.com/seu-usuario/CryptoAlert_App/issues/new?template=bug_report.md):

```markdown
## Descrição do Bug
Descrição clara do que é o bug.

## Passos para Reproduzir
1. Fazer X
2. Fazer Y
3. Observar Z

## Comportamento Esperado
O que deveria acontecer.

## Comportamento Atual
O que realmente acontece.

## Ambiente
- OS: Linux/Windows/macOS
- Flutter: 3.44.1
- Dart: 3.12.1
- Dispositivo: Web/Android/iOS

## Logs/Erros
```
Cole logs/stack traces aqui
```

## Screenshots
Cole screenshots se relevante.
```

---

## 💡 Sugerindo Melhorias

Use o [Feature Request Template](https://github.com/seu-usuario/CryptoAlert_App/issues/new?template=feature_request.md):

```markdown
## Descrição da Melhoria
Descrição clara da sua sugestão.

## Motivação
Por que isso seria útil?

## Possível Implementação
Como você sugere implementar isso?

## Exemplos Adicionais
Outros exemplos ou casos de uso.
```

---

## 🗺️ Roadmap

### v1.1 (Q3 2026)

- [ ] Dark mode completo
- [ ] Suporte para mais exchanges
- [ ] Gráficos de preço
- [ ] Histórico de alertas
- [ ] Exportar dados

### v2.0 (Q4 2026)

- [ ] App mobile nativo completo
- [ ] Autenticação full Firebase
- [ ] Push notifications via FCM
- [ ] Algoritmos de IA para recomendações
- [ ] API pública para integradores

### v3.0 (2027)

- [ ] Microserviços
- [ ] Machine Learning predictions
- [ ] Community features
- [ ] Marketplace de strategies

---

## 📚 Recursos Úteis

- [Flutter Docs](https://flutter.dev/docs)
- [Dart Guide](https://dart.dev/guides)
- [Dart Frog Docs](https://dartfrog.io)
- [Firebase Docs](https://firebase.google.com/docs)
- [Binance API](https://binance-docs.github.io/apidocs/)

---

## 🙏 Obrigado!

Sua contribuição é valiosa! Qualquer melhoria, por menor que seja, ajuda a tornar CryptoAlert melhor para todos.

Se tiver dúvidas:
1. Abra uma [Discussion](https://github.com/seu-usuario/CryptoAlert_App/discussions)
2. Me envie um email
3. Procure por threads similares

**Bem-vindo à comunidade! 🚀**
