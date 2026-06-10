# CryptoAlert Backend API Reference (PT-BR)

## Visão Geral

API responsável por:

* Gerenciamento de Alertas
* Gerenciamento de Notificações
* Consulta de Dados de Mercado
* Monitoramento de Criptomoedas

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
    "volume_24h": 1250000000.0,
    "updated_at": "2026-06-10T03:10:28.501019Z"
  }
]
```

### Campos

| Campo      | Descrição                  |
| ---------- | -------------------------- |
| symbol     | Símbolo Binance            |
| name       | Nome da criptomoeda        |
| image_url  | URL da imagem              |
| price_usd  | Preço atual em USD         |
| change_24h | Variação percentual em 24h |
| volume_24h | Volume negociado em 24h    |
| updated_at | Última atualização         |

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

# Campos Planejados

Ainda não implementados:

* change_7d
* change_30d
* market_cap
* circulating_supply
* total_supply
* Conversão USD → BRL
* Conversão USD → EUR
* Preferência de moeda do usuário

---

# Status Atual

## Disponível para consumo pelo Frontend

* Alertas
* Notificações
* Autenticação
* Market Overview
* Refresh manual de mercado

## Em desenvolvimento

* Métricas avançadas de mercado
* Firebase Cloud Messaging
* Integração completa de usuários
* Preferências personalizadas
* Conversor de moedas

```
```