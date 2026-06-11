# CryptoAlert Mobile Backend — Development Log

## Overview

Backend developed in Dart using Dart Frog for cryptocurrency alert management integrated with the Binance API.

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
| Dart Frog                | HTTP Framework     |
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

| Layer      | Responsibility       |
| ---------- | -------------------- |
| Route      | HTTP Communication   |
| Service    | Business rules       |
| Repository | Persistence          |
| Client     | External APIs        |
| Scheduler  | Periodic processes   |
| Middleware | Cross-cutting logic  |

---

# Binance Integration

Files:
* clients/binance_client.dart
* modules/crypto/crypto_service.dart
* routes/crypto/price.dart

Features:
* Real-time price fetching
* Binance Spot API integration
* Individual crypto query endpoint

---

# Alerts System

## Structure
Fields:
* id
* symbol
* target
* type
* active

## Full CRUD
Endpoints:

| Method | Endpoint                  |
| ------ | ------------------------- |
| POST   | /alerts/create            |
| GET    | /alerts/list              |
| GET    | /alerts/list_active       |
| PUT    | /alerts/update/:id        |
| PATCH  | /alerts/activate/:id      |
| PATCH  | /alerts/deactivate/:id    |
| DELETE | /alerts/delete/:id        |

## Implemented Improvements
* AlertType Enum
* copyWith method
* Partial update via COALESCE
* Automatic deactivation after triggering
* PostgreSQL persistence
* Explicit separation of activation/deactivation to ensure request idempotency.

---

# Notifications System

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
* Full listing
* Unread listing
* Mark as read
* Deletion
* PostgreSQL persistence

---

# PostgreSQL

Migration completed for modules:
* Alerts
* Notifications

Removed:
* mock_database.dart
* In-memory persistence

Implemented:
* DatabaseConnection
* Parameterized queries
* RETURNING clauses
* ResultRow → Model conversion

---

# Scheduler

File:
* alerts_scheduler.dart

Responsibilities:
* Fetch active alerts
* Query Binance
* Validate conditions
* Create notifications
* Deactivate triggered alerts

---

# Global Error Handling

Implemented global middleware.

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

# Market Data Module

## Objective
Provide the mobile application with up-to-date market information to display prices, metrics, and monitor registered assets.

## Implemented Integrations

### Binance API
Responsible for providing:
- current price
- 24-hour change
- 24-hour trading volume

Files:
- clients/binance_client.dart
- modules/crypto/crypto_service.dart

### CoinGecko API
Responsible for providing:
- asset image
- market cap
- circulating supply
- total supply
- 7-day change
- 30-day change

Files:
- clients/coingecko_client.dart
- modules/market_data/coingecko_market_data.dart

## Database
`crypto_assets` Table (Added fields):
- image_url
- coingecko_id

`market_snapshots` Table (Added fields):
- change_7d
- change_30d
- market_cap
- circulating_supply
- total_supply

## Market Endpoints

| Method | Endpoint                  |
| ------ | ------------------------- |
| GET    | /market/overview          |
| POST   | /market/refresh           |

## Market Scheduler
Implemented automatic update service: `MarketDataUpdaterService`
Responsible for:
- synchronizing with Binance
- synchronizing with CoinGecko
- persisting snapshots

---

# Current Backend Status

## Implemented
✅ Alerts System
✅ Notifications System
✅ PostgreSQL
✅ Binance Integration
✅ CoinGecko Integration
✅ Market Snapshot
✅ /market/overview endpoint
✅ /market/refresh endpoint
✅ Consolidated modular architecture

## Main Pending Tasks

### Authentication
Needs completion:
- registration
- login
- JWT
- authentication middleware

### User ↔ Alerts Integration
Relate:
- users
- alerts
- notifications
- preferences

### Firebase Cloud Messaging
Requirements:
- register device tokens
- send push notifications
- full integration with mobile devices

### Currency Converter
Planned:
- USD → BRL
- USD → EUR
- User currency preference

### User Preferences
Planned:
- favorite coins
- default currency
- notification customization