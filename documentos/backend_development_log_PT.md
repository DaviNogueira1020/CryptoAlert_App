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