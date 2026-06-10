# CryptoAlert Backend API Reference (PT-BR)

## Visão Geral

API responsável por:

* Gerenciamento de Alertas
* Gerenciamento de Notificações
* Consulta de Dados de Mercado
* Monitoramento de Criptomoedas
* Integração Binance
* Integração CoinGecko

Base URL:

```text
http://localhost:8080
```

---

# Health Check

## GET /

### Resposta

```json
{
  "message": "Welcome to Dart Frog!"
}
```

---

# Alertas

## Criar alerta

### POST /alerts/create

### Body

```json
{
  "symbol": "BTCUSDT",
  "target": 100000,
  "type": "above"
}
```

### Resposta

```json
{
  "id": "uuid",
  "symbol": "BTCUSDT",
  "target": 100000,
  "type": "above",
  "active": true
}
```

---

## Listar alertas

### GET /alerts/list

### Resposta

```json
[
  {
    "id": "uuid",
    "symbol": "BTCUSDT",
    "target": 100000,
    "type": "above",
    "active": true
  }
]
```

---

## Listar alertas ativos

### GET /alerts/list_active

---

## Atualizar alerta

### PUT /alerts/update/:id

### Body

```json
{
  "symbol": "ETHUSDT",
  "target": 5000,
  "type": "above"
}
```

---

## Ativar alerta

### PATCH /alerts/activate/:id

---

## Desativar alerta

### PATCH /alerts/deactivate/:id

---

## Excluir alerta

### DELETE /alerts/delete/:id

---

# Notificações

## Listar notificações

### GET /notifications/list

---

## Listar não lidas

### GET /notifications/unread

---

## Marcar como lida

### PATCH /notifications/read/:id

---

## Excluir notificação

### DELETE /notifications/delete/:id

---

# Autenticação

## Registrar usuário

### POST /auth/register

---

## Login

### POST /auth/login

---

# Crypto

## Consultar preço

### GET /crypto/price?symbol=BTCUSDT

### Resposta

```json
{
  "symbol": "BTCUSDT",
  "price": 61318.05
}
```

---

# Market Data

## Visão geral do mercado

### GET /market/overview

### Resposta

```json
[
  {
    "symbol": "BTCUSDT",
    "name": "Bitcoin",
    "image_url": "https://...",
    "price_usd": 61318.05,
    "change_24h": 2.37,
    "change_7d": 4.12,
    "change_30d": 15.84,
    "volume_24h": 1250000000.0,
    "market_cap": 1200000000000.0,
    "circulating_supply": 19800000,
    "total_supply": 21000000,
    "updated_at": "2026-06-10T03:10:28.501019Z"
  }
]
```

### Campos

| Campo              | Descrição                      |
| ------------------ | ------------------------------ |
| symbol             | Símbolo Binance                |
| name               | Nome da criptomoeda            |
| image_url          | URL da imagem                  |
| price_usd          | Preço atual em USD             |
| change_24h         | Variação percentual em 24h     |
| change_7d          | Variação percentual em 7 dias  |
| change_30d         | Variação percentual em 30 dias |
| volume_24h         | Volume negociado em 24h        |
| market_cap         | Capitalização de mercado       |
| circulating_supply | Oferta circulante              |
| total_supply       | Oferta total                   |
| updated_at         | Última atualização             |

---

## Atualização manual do mercado

### POST /market/refresh

### Resposta

```json
{
  "message": "Market data refreshed successfully"
}
```

---

# Fontes de Dados

## Binance

Responsável por:

* Preço atual
* Variação 24h
* Volume 24h

## CoinGecko

Responsável por:

* Capitalização de mercado
* Oferta circulante
* Oferta total
* Variação 7 dias
* Variação 30 dias
* Imagens dos ativos

---

# Limitações Conhecidas

## CoinGecko Rate Limit

A API pública da CoinGecko possui limitação de requisições.

Em situações de rate limit (HTTP 429):

* os preços continuam sendo atualizados normalmente via Binance;
* métricas avançadas podem permanecer temporariamente desatualizadas.

O sistema trata esse cenário automaticamente.

---

# Funcionalidades Planejadas

## Mercado

* Conversão USD → BRL
* Conversão USD → EUR
* Conversão USD → GBP
* Preferência de moeda por usuário

## Usuários

* Integração completa entre usuários e alertas
* Integração completa entre usuários e notificações

## Segurança

* JWT Authentication
* Middleware de autenticação
* Controle de acesso por usuário

## Push Notifications

* Firebase Cloud Messaging
* Registro de Device Tokens
* Entrega de notificações em tempo real

---

# Status Atual

## Disponível para consumo pelo Frontend

✅ Consulta de preços

✅ CRUD de alertas

✅ Scheduler de monitoramento

✅ CRUD de notificações

✅ Endpoint de mercado

✅ Atualização manual de mercado

✅ Capitalização de mercado

✅ Oferta circulante

✅ Oferta total

✅ Variação 7 dias

✅ Variação 30 dias

✅ Imagens dos ativos

---

## Em desenvolvimento

🚧 Autenticação completa

🚧 Relacionamento User → Alerts

🚧 Relacionamento User → Notifications

🚧 Firebase Cloud Messaging

🚧 Preferências de moeda

🚧 Conversor de moedas

🚧 Deploy de produção

---

# Versão

API Version: v1

Última atualização da documentação: Junho/2026
