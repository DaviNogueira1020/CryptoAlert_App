# CryptoAlert Mobile Backend — Log de Desenvolvimento

## Visão Geral do Projeto

Backend desenvolvido em Dart utilizando Dart Frog para gerenciamento de alertas de criptomoedas integrados à Binance API.

---

# Objetivo do Backend

O backend é responsável por:

- Gerenciamento de usuários
- Criação e gerenciamento de alertas
- Monitoramento contínuo de criptomoedas
- Processamento de notificações
- Integração futura com Firebase Cloud Messaging
- Persistência em PostgreSQL

---

# Stack Definida

| Tecnologia | Finalidade |
|---|---|
| Dart | Linguagem backend |
| Dart Frog | Framework HTTP |
| Binance API | Fonte de dados de criptomoedas |
| PostgreSQL | Banco de dados |
| Firebase Cloud Messaging | Push notifications |

---

# Arquitetura

O backend segue uma arquitetura modular baseada em:

- Routes
- Services
- Repositories
- Scheduler
- Clients

---

# Responsabilidade das Camadas

| Camada | Responsabilidade |
|---|---|
| Route | Comunicação HTTP |
| Service | Regras de negócio |
| Repository | Persistência |
| Client | Integrações externas |

---

# Estrutura Inicial

```text
lib/
├── clients/
├── config/
├── core/
├── docs/
├── middlewares/
├── modules/
├── scheduler/
└── utils/
```

---

# Integração com Binance

## Arquivos implementados

- `clients/binance_client.dart`
- `modules/crypto/crypto_service.dart`
- `routes/crypto/price.dart`

---

# Funcionalidades implementadas

- Integração com API da Binance
- Consulta de preços em tempo real
- Endpoint `/crypto/price`

---

# Sistema de Alertas

## Arquivos implementados

- `alerts_repository.dart`
- `alerts_service.dart`
- `alerts_checker_service.dart`

---

# Estrutura do alerta

Campos:
- id
- symbol
- target
- type
- active

---

# Persistência Mock

Implementada persistência temporária em memória utilizando:

```dart
List<Alert>
```

Objetivos:
- acelerar desenvolvimento
- desacoplar backend do banco real

---

# CRUD de Alertas

## Endpoints implementados

| Método | Endpoint |
|---|---|
| POST | `/alerts/create` |
| GET | `/alerts/list` |
| GET | `/alerts/list_active` |
| PUT | `/alerts/update/:id` |
| PATCH | `/alerts/toggle_status/:id` |
| DELETE | `/alerts/delete/:id` |

---

# Melhorias Arquiteturais

## Padrão copyWith

Implementado padrão de atualização imutável utilizando `copyWith`.

---

# Enum AlertType

Substituição de strings mágicas:

```text
'above'
'below'
```

por:

```dart
AlertType.above
AlertType.below
```

---

# Extensions em Dart

Implementadas funções auxiliares para:
- serialização
- desserialização
do enum `AlertType`.

---

# Scheduler

## Arquivo

- `alerts_scheduler.dart`

---

# Responsabilidades

- verificar alertas ativos periodicamente
- consultar preços na Binance
- validar condições de disparo
- registrar eventos de alerta

---

# Condições implementadas

- above
- below

---

# Logging temporário

Formato atual:

```text
[ALERT TRIGGERED] BTCUSDT above 100000 (Current price: 102340.50)
```

---

# Rotas RESTful

Implementadas rotas dinâmicas utilizando:

```text
[id].dart
```

---

# Refatorações e Correções

## Padronização de nomenclatura

Conversão de:
- métodos
- arquivos
- rotas

para:
- inglês
- snake_case

---

# Estado Atual do Backend

## Implementado

- Infraestrutura base
- Integração Binance
- CRUD completo de alertas
- Scheduler
- Normalização via enum
- Repository Pattern
- Service Layer
- Persistência mock
- Rotas RESTful

---

# Próximos Passos

1. Módulo de notificações
2. Módulo de autenticação
3. Middleware JWT
4. Integração PostgreSQL
5. Firebase Cloud Messaging
6. Logging estruturado
7. Variáveis de ambiente
8. Tratamento global de erros

---

# Estado Atual

✅ Backend funcional  
✅ Scheduler em execução  
✅ Endpoints funcionando  
✅ CRUD completo  
✅ Arquitetura modular consolidada

---

# Módulo de Dados de Mercado

## Objetivo

Disponibilizar ao aplicativo informações de mercado atualizadas para exibição de preços, métricas e monitoramento dos ativos cadastrados.

---

## Integrações Implementadas

### Binance API

Responsável por fornecer:

- preço atual
- variação de 24 horas
- volume negociado em 24 horas

Arquivos:

- clients/binance_client.dart
- modules/crypto/crypto_service.dart

---

### CoinGecko API

Responsável por fornecer:

- imagem do ativo
- market cap
- circulating supply
- total supply
- variação de 7 dias
- variação de 30 dias

Arquivos:

- clients/coingecko_client.dart
- modules/market_data/coingecko_market_data.dart

---

## Banco de Dados

Tabela:

### crypto_assets

Campos adicionados:

- image_url
- coingecko_id

---

### market_snapshots

Campos adicionados:

- change_7d
- change_30d
- market_cap
- circulating_supply
- total_supply

---

## Endpoint de Mercado

### GET /market/overview

Retorna:

- símbolo
- nome
- imagem
- preço
- volume
- variações
- market cap
- supply
- timestamp da última atualização

---

### POST /market/refresh

Atualiza manualmente todos os snapshots de mercado.

Fluxo:

1. consulta ativos cadastrados
2. consulta Binance
3. consulta CoinGecko
4. atualiza banco
5. retorna sucesso

---

## Scheduler de Mercado

Implementado serviço de atualização automática:

- MarketDataUpdaterService

Responsável por:

- sincronizar Binance
- sincronizar CoinGecko
- persistir snapshots

---

# Estado Atual do Backend

## Implementado

✅ Sistema de Alertas

✅ Sistema de Notificações

✅ PostgreSQL

✅ Integração Binance

✅ Integração CoinGecko

✅ Snapshot de Mercado

✅ Endpoint /market/overview

✅ Endpoint /market/refresh

✅ Arquitetura modular consolidada

---

## Pendências Principais

### Autenticação

Necessário concluir:

- registro
- login
- JWT
- middleware de autenticação

---

### Integração Usuário ↔ Alertas

Relacionar:

- usuários
- alertas
- notificações
- preferências

---

### Firebase Cloud Messaging

Necessário:

- registrar tokens
- enviar push notifications
- integração completa com dispositivos móveis

---

### Conversor de Moedas

Planejado:

- USD → BRL
- USD → EUR
- Preferência de moeda do usuário

---

### Preferências do Usuário

Planejado:

- moedas favoritas
- moeda padrão
- personalização de notificações