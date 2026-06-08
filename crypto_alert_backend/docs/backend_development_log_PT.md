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
| PATCH  | /alerts/toggle_status/:id |
| DELETE | /alerts/delete/:id        |

## Melhorias Implementadas

* Enum AlertType
* copyWith
* Atualização parcial via COALESCE
* Desativação automática após disparo
* Persistência PostgreSQL

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

# Estado Atual

## Concluído

✅ Arquitetura modular

✅ Integração Binance

✅ CRUD completo de alertas

✅ CRUD completo de notificações

✅ Scheduler funcional

✅ PostgreSQL integrado

✅ Error Middleware

✅ Exceptions customizadas

✅ Repository Pattern

✅ Service Layer

✅ Rotas RESTful

---

# Próximas Entregas

## Market Data

* Cadastro de criptomoedas monitoradas
* Histórico de preços
* Cache local de mercado
* Tickers para dashboard
* Endpoint de mercado

## Firebase

* Integração FCM
* Push notifications reais

## Auth

* Cadastro
* Login
* JWT
* Middleware de autenticação

## Infraestrutura

* Variáveis de ambiente
* Logs estruturados
* Docker
* Deploy

---

# Branch Atual

feature/backend-alerts-notifications

---

# Próxima Branch

feature/market-data
