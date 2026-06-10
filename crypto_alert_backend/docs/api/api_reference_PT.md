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

# Market Data

## GET /market/overview

Retorna os ativos monitorados e seus dados de mercado mais recentes.

### Exemplo de Resposta

```json
[
  {
    "symbol": "BTCUSDT",
    "name": "Bitcoin",
    "image_url": "https://...",
    "price_usd": 61318.05,
    "change_24h": null,
    "volume_24h": null,
    "updated_at": "2026-06-10T03:10:28.501019Z"
  }
]
```

### Observações

* change_24h ainda em implementação.
* volume_24h ainda em implementação.

---

## POST /market/refresh

Força atualização imediata dos snapshots de mercado.

### Resposta

```json
{
  "message": "Market data refreshed successfully"
}
```

---

# Alerts

## GET /alerts/list

Lista todos os alertas cadastrados.

---

## GET /alerts/list_active

Lista apenas alertas ativos.

---

## POST /alerts/create

Cria um novo alerta.

### Request

```json
{
  "symbol": "BTCUSDT",
  "target": 65000,
  "type": "above"
}
```

### Response

```json
{
  "id": "...",
  "symbol": "BTCUSDT",
  "target": 65000,
  "type": "above",
  "active": true
}
```

---

## PUT /alerts/update/:id

Atualiza um alerta existente.

---

## PATCH /alerts/activate/:id

Ativa um alerta.

---

## PATCH /alerts/deactivate/:id

Desativa um alerta.

---

## DELETE /alerts/delete/:id

Remove um alerta.

---

# Notifications

## GET /notifications/list

Lista todas as notificações.

---

## GET /notifications/unread

Lista notificações não lidas.

---

## PATCH /notifications/read/:id

Marca uma notificação como lida.

---

## DELETE /notifications/delete/:id

Remove uma notificação.

---

# Status Atual

## Implementado

* Alerts CRUD
* Notifications CRUD
* Market Overview
* Market Refresh
* Scheduler de Alertas
* Scheduler de Dados de Mercado

## Em Desenvolvimento

* change_24h
* volume_24h
* variação 7d
* variação 30d
* conversão de moedas
* autenticação JWT
* Firebase Cloud Messaging

```
```
