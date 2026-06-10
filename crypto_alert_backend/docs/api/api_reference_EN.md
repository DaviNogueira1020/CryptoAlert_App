# CryptoAlert Backend API Reference (EN)

## Overview

API responsible for:

* Alert Management
* Notification Management
* Market Data Retrieval
* Cryptocurrency Monitoring
* Binance Integration
* CoinGecko Integration

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

### Response

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

## List Alerts

### GET /alerts/list

### Response

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

## List Active Alerts

### GET /alerts/list_active

---

## Update Alert

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

## Mark as Read

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

### Response

```json
{
  "symbol": "BTCUSDT",
  "price": 61318.05
}
```

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

### Fields

| Field              | Description               |
| ------------------ | ------------------------- |
| symbol             | Binance trading symbol    |
| name               | Asset name                |
| image_url          | Asset image URL           |
| price_usd          | Current USD price         |
| change_24h         | 24-hour percentage change |
| change_7d          | 7-day percentage change   |
| change_30d         | 30-day percentage change  |
| volume_24h         | 24-hour trading volume    |
| market_cap         | Market capitalization     |
| circulating_supply | Circulating supply        |
| total_supply       | Total supply              |
| updated_at         | Last update timestamp     |

---

## Manual Market Refresh

### POST /market/refresh

### Response

```json
{
  "message": "Market data refreshed successfully"
}
```

---

# Data Sources

## Binance

Provides:

* Current price
* 24h price change
* 24h volume

## CoinGecko

Provides:

* Market capitalization
* Circulating supply
* Total supply
* 7-day price change
* 30-day price change
* Asset images

---

# Known Limitations

## CoinGecko Rate Limit

The public CoinGecko API has request limits.

When rate limiting occurs (HTTP 429):

* prices continue updating normally through Binance;
* advanced market metrics may temporarily remain outdated.

The system handles this scenario automatically.

---

# Planned Features

## Market

* USD → BRL conversion
* USD → EUR conversion
* USD → GBP conversion
* User currency preferences

## Users

* Full User → Alerts integration
* Full User → Notifications integration

## Security

* JWT Authentication
* Authentication Middleware
* User-based access control

## Push Notifications

* Firebase Cloud Messaging
* Device Token Registration
* Real-time push delivery

---

# Current Status

## Available for Frontend Consumption

✅ Price lookup

✅ Alert CRUD

✅ Monitoring scheduler

✅ Notification CRUD

✅ Market overview endpoint

✅ Manual market refresh

✅ Market capitalization

✅ Circulating supply

✅ Total supply

✅ 7-day change

✅ 30-day change

✅ Asset images

---

## Under Development

🚧 Complete authentication

🚧 User → Alerts relationship

🚧 User → Notifications relationship

🚧 Firebase Cloud Messaging

🚧 Currency preferences

🚧 Currency conversion

🚧 Production deployment

---

# Version

API Version: v1

Last documentation update: June 2026
