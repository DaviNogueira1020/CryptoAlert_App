---

### `docs/backlogs/backend_development_PT.md`

```markdown
# CryptoAlert Mobile Backend — Log de Desenvolvimento

## Visão Geral

Backend desenvolvido em Dart utilizando Dart Frog para gerenciamento de alertas de criptomoedas integrados à Binance API.

---

# Objetivo

O backend é responsável por:
* Gerenciamento de usuários
* Gerenciamento de alertas
* Monitoramento de criptomoedas
* Processamento de notificações
* Integração com Firebase Cloud Messaging
* Persistência em PostgreSQL

---

# Stack

| Tecnologia               | Finalidade         |
| ------------------------ | ------------------ |
| Dart                     | Linguagem backend  |
| Dart Frog                | Framework HTTP     |
| PostgreSQL               | Banco de dados     |
| Binance API              | Dados de mercado   |
| Firebase Cloud Messaging | Push notifications |

---

# Arquitetura

O projeto segue arquitetura em camadas:
* Routes
* Services
* Repositories
* Clients
* Scheduler
* Middlewares

## Responsabilidades

| Camada     | Responsabilidade       |
| ---------- | ---------------------- |
| Route      | Comunicação HTTP       |
| Service    | Regras de negócio      |
| Repository | Persistência           |
| Client     | APIs externas          |
| Scheduler  | Processos periódicos   |
| Middleware | Tratamento transversal |

---

# Integração Binance

Arquivos:
* clients/binance_client.dart
* modules/crypto/crypto_service.dart
* routes/crypto/price.dart

Funcionalidades:
* Consulta de preços em tempo real
* Integração com Binance Spot API
* Endpoint de consulta individual

---

# Sistema de Alertas

## Estrutura
Campos:
* id
* symbol
* target
* type
* active

## CRUD Completo
Endpoints:

| Método | Endpoint                  |
| ------ | ------------------------- |
| POST   | /alerts/create            |
| GET    | /alerts/list              |
| GET    | /alerts/list_active       |
| PUT    | /alerts/update/:id        |
| PATCH  | /alerts/activate/:id      |
| PATCH  | /alerts/deactivate/:id    |
| DELETE | /alerts/delete/:id        |

## Melhorias Implementadas
* Enum AlertType
* copyWith
* Atualização parcial via COALESCE
* Desativação automática após disparo
* Persistência PostgreSQL
* Separação explícita de ativação/desativação visando idempotência nas requisições.

---

# Sistema de Notificações

## Estrutura
Campos:
* id
* alert_id
* title
* message
* read
* created_at

## Endpoints

| Método | Endpoint                  |
| ------ | ------------------------- |
| GET    | /notifications/list       |
| GET    | /notifications/unread     |
| PATCH  | /notifications/read/:id   |
| DELETE | /notifications/delete/:id |

## Funcionalidades
* Listagem completa
* Listagem de não lidas
* Marcar como lida
* Exclusão
* Persistência PostgreSQL

---

# PostgreSQL

Migração concluída dos módulos:
* Alerts
* Notifications

Removido:
* mock_database.dart
* Persistência em memória

Implementado:
* DatabaseConnection
* Queries parametrizadas
* RETURNING
* Conversão ResultRow → Model

---

# Scheduler

Arquivo:
* alerts_scheduler.dart

Responsabilidades:
* Buscar alertas ativos
* Consultar Binance
* Validar condições
* Criar notificações
* Desativar alertas disparados

---

# Tratamento Global de Erros

Implementado middleware global.

## Exceptions customizadas
* ValidationException
* NotFoundException
* ConflictException

## Mapeamento HTTP

| Exception           | HTTP |
| ------------------- | ---- |
| ValidationException | 400  |
| NotFoundException   | 404  |
| ConflictException   | 409  |
| Outros              | 500  |

---

# Módulo de Dados de Mercado

## Objetivo
Disponibilizar ao aplicativo informações de mercado atualizadas para exibição de preços, métricas e monitoramento dos ativos cadastrados.

## Integrações Implementadas

### Binance API
Responsável por fornecer:
- preço atual
- variação de 24 horas
- volume negociado em 24 horas

Arquivos:
- clients/binance_client.dart
- modules/crypto/crypto_service.dart

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

## Banco de Dados
Tabela `crypto_assets` (Campos adicionados):
- image_url
- coingecko_id

Tabela `market_snapshots` (Campos adicionados):
- change_7d
- change_30d
- market_cap
- circulating_supply
- total_supply

## Endpoints de Mercado

| Método | Endpoint                  |
| ------ | ------------------------- |
| GET    | /market/overview          |
| POST   | /market/refresh           |

## Scheduler de Mercado
Implementado serviço de atualização automática: `MarketDataUpdaterService`
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

## Pendências Principais

### Autenticação
Necessário concluir:
- registro
- login
- JWT
- middleware de autenticação

### Integração Usuário ↔ Alertas
Relacionar:
- usuários
- alertas
- notificações
- preferências

### Firebase Cloud Messaging
Necessário:
- registrar tokens
- enviar push notifications
- integração completa com dispositivos móveis

### Conversor de Moedas
Planejado:
- USD → BRL
- USD → EUR
- Preferência de moeda do usuário

### Preferências do Usuário
Planejado:
- moedas favoritas
- moeda padrão
- personalização de notificações