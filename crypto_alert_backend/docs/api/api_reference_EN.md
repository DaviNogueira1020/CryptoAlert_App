# CryptoAlert Backend API Reference (EN)

## Overview

Backend API responsible for:

* Alert Management
* Notification Management
* Market Data
* Cryptocurrency Monitoring

Base URL:

```text
http://localhost:8080
```

---

# Health Check

## GET /

### Response

```json
{
  "message": "Welcome to Dart Frog!"
}
```

---

# Alerts

## Create Alert

### POST /alerts/create

### Body

```json
{
  "symbol": "BTCUSDT",
  "target": 100000,
  "type": "above"
}
```

---

## List Alerts

### GET /alerts/list

---

## List Active Alerts

### GET /alerts/list_active

---

## Update Alert

### PUT /alerts/update/:id

---

## Activate Alert

### PATCH /alerts/activate/:id

---

## Deactivate Alert

### PATCH /alerts/deactivate/:id

---

## Delete Alert

### DELETE /alerts/delete/:id

---

# Notifications

## List Notifications

### GET /notifications/list

---

## List Unread Notifications

### GET /notifications/unread

---

## Mark As Read

### PATCH /notifications/read/:id

---

## Delete Notification

### DELETE /notifications/delete/:id

---

# Authentication

## Register User

### POST /auth/register

---

## Login

### POST /auth/login

---

# Crypto

## Get Price

### GET /crypto/price?symbol=BTCUSDT

---

# Market Data

## Market Overview

### GET /market/overview

### Response

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

### Fields

| Field      | Description           |
| ---------- | --------------------- |
| symbol     | Binance symbol        |
| name       | Asset name            |
| image_url  | Asset image           |
| price_usd  | Current USD price     |
| change_24h | 24h percentage change |
| volume_24h | 24h traded volume     |
| updated_at | Last update timestamp |

---

## Manual Refresh

### POST /market/refresh

### Response

```json
{
  "message": "Market data refreshed successfully"
}
```

---

# Planned Fields

Not implemented yet:

* change_7d
* change_30d
* market_cap
* circulating_supply
* total_supply
* USD → BRL conversion
* USD → EUR conversion
* User currency preference

---

# Current Status

## Available for Frontend Integration

* Alerts
* Notifications
* Authentication
* Market Overview
* Manual Market Refresh

## Under Development

* Advanced market metrics
* Firebase Cloud Messaging
* User integration
* User preferences
* Currency conversion

```
```