# CryptoAlert Mobile Backend — Development Log

## Overview

Backend developed in Dart using Dart Frog for cryptocurrency alert management integrated with Binance API.

---

# Objective

The backend is responsible for:

* User management
* Alert management
* Cryptocurrency monitoring
* Notification processing
* Firebase Cloud Messaging integration
* PostgreSQL persistence

---

# Stack

| Technology               | Purpose            |
| ------------------------ | ------------------ |
| Dart                     | Backend language   |
| Dart Frog                | HTTP framework     |
| PostgreSQL               | Database           |
| Binance API              | Market data        |
| Firebase Cloud Messaging | Push notifications |

---

# Architecture

The project follows a layered architecture:

* Routes
* Services
* Repositories
* Clients
* Scheduler
* Middlewares

## Responsibilities

| Layer      | Responsibility         |
| ---------- | ---------------------- |
| Route      | HTTP communication     |
| Service    | Business rules         |
| Repository | Persistence            |
| Client     | External APIs          |
| Scheduler  | Periodic jobs          |
| Middleware | Cross-cutting concerns |

---

# Binance Integration

Files:

* clients/binance_client.dart
* modules/crypto/crypto_service.dart
* routes/crypto/price.dart

Features:

* Real-time prices
* Binance Spot API integration
* Single asset price endpoint

---

# Alert System

## Structure

Fields:

* id
* symbol
* target
* type
* active

## Complete CRUD

| Method | Endpoint                  |
| ------ | ------------------------- |
| POST   | /alerts/create            |
| GET    | /alerts/list              |
| GET    | /alerts/list_active       |
| PUT    | /alerts/update/:id        |
| PATCH  | /alerts/toggle_status/:id |
| DELETE | /alerts/delete/:id        |

## Improvements

* AlertType enum
* copyWith pattern
* Partial updates via COALESCE
* Automatic deactivation after trigger
* PostgreSQL persistence

---

# Notification System

## Structure

Fields:

* id
* alert_id
* title
* message
* read
* created_at

## Endpoints

| Method | Endpoint                  |
| ------ | ------------------------- |
| GET    | /notifications/list       |
| GET    | /notifications/unread     |
| PATCH  | /notifications/read/:id   |
| DELETE | /notifications/delete/:id |

## Features

* List all notifications
* List unread notifications
* Mark as read
* Delete notifications
* PostgreSQL persistence

---

# PostgreSQL

Migration completed for:

* Alerts
* Notifications

Removed:

* mock_database.dart
* In-memory persistence

Implemented:

* DatabaseConnection
* Parameterized queries
* RETURNING clauses
* ResultRow → Model mapping

---

# Scheduler

File:

* alerts_scheduler.dart

Responsibilities:

* Fetch active alerts
* Query Binance prices
* Validate trigger conditions
* Create notifications
* Deactivate triggered alerts

---

# Global Error Handling

Global middleware implemented.

## Custom Exceptions

* ValidationException
* NotFoundException
* ConflictException

## HTTP Mapping

| Exception           | HTTP |
| ------------------- | ---- |
| ValidationException | 400  |
| NotFoundException   | 404  |
| ConflictException   | 409  |
| Others              | 500  |

---

# Current Status

## Completed

✅ Modular architecture

✅ Binance integration

✅ Full alerts CRUD

✅ Full notifications CRUD

✅ Scheduler

✅ PostgreSQL integration

✅ Error middleware

✅ Custom exceptions

✅ Repository pattern

✅ Service layer

✅ RESTful routes

---

# Next Deliveries

## Market Data

* Tracked crypto assets
* Historical prices
* Local market cache
* Dashboard tickers
* Market endpoints

## Firebase

* FCM integration
* Real push notifications

## Authentication

* Register
* Login
* JWT
* Authentication middleware

## Infrastructure

* Environment variables
* Structured logs
* Docker
* Deployment

---

# Current State

✅ Functional backend  
✅ Running scheduler  
✅ Working endpoints  
✅ Complete CRUD  
✅ Modular architecture consolidated

---

# Market Data Module

## Goal

Provide updated market information for asset monitoring and frontend visualization.

---

## Implemented Integrations

### Binance API

Provides:

- current price
- 24h change
- 24h volume

Files:

- clients/binance_client.dart
- modules/crypto/crypto_service.dart

---

### CoinGecko API

Provides:

- asset image
- market cap
- circulating supply
- total supply
- 7d change
- 30d change

Files:

- clients/coingecko_client.dart
- modules/market_data/coingecko_market_data.dart

---

## Database

### crypto_assets

Added fields:

- image_url
- coingecko_id

---

### market_snapshots

Added fields:

- change_7d
- change_30d
- market_cap
- circulating_supply
- total_supply

---

## Market Endpoints

### GET /market/overview

Returns:

- symbol
- name
- image
- price
- volume
- changes
- market cap
- supply
- last update timestamp

---

### POST /market/refresh

Manually refreshes all market snapshots.

Flow:

1. fetch assets
2. query Binance
3. query CoinGecko
4. persist data
5. return success

---

## Market Scheduler

Implemented:

- MarketDataUpdaterService

Responsibilities:

- Binance synchronization
- CoinGecko synchronization
- snapshot persistence

---

# Current Backend Status

## Completed

✅ Alert System

✅ Notification System

✅ PostgreSQL

✅ Binance Integration

✅ CoinGecko Integration

✅ Market Snapshots

✅ /market/overview endpoint

✅ /market/refresh endpoint

✅ Modular architecture consolidated

---

## Main Pending Tasks

### Authentication

Remaining work:

- register
- login
- JWT
- authentication middleware

---

### User Integration

Need to associate:

- users
- alerts
- notifications
- preferences

---

### Firebase Cloud Messaging

Required:

- device token registration
- push notification delivery
- mobile integration

---

### Currency Conversion

Planned:

- USD → BRL
- USD → EUR
- user preferred currency

---

### User Preferences

Planned:

- favorite assets
- default currency
- notification customization