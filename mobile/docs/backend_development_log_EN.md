# CryptoAlert Mobile Backend — Development Log

## Project Overview

Backend developed in Dart using Dart Frog for cryptocurrency alert management integrated with Binance API.

---

# Objective

The backend is responsible for:

- User authentication
- Alert management
- Cryptocurrency monitoring
- Notification processing
- Firebase Cloud Messaging integration
- PostgreSQL persistence

---

# Stack

| Technology | Purpose |
|---|---|
| Dart | Backend language |
| Dart Frog | HTTP framework |
| Binance API | Crypto price provider |
| PostgreSQL | Database |
| Firebase Cloud Messaging | Push notifications |

---

# Architecture

The backend follows a modular architecture based on:

- Routes
- Services
- Repositories
- Scheduler
- Clients

## Layer responsibilities

| Layer | Responsibility |
|---|---|
| Route | HTTP communication |
| Service | Business rules |
| Repository | Persistence |
| Client | External APIs |

---

# Initial Structure

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

# Binance Integration

## Implemented files

- `clients/binance_client.dart`
- `modules/crypto/crypto_service.dart`
- `routes/crypto/price.dart`

## Features

- Binance API integration
- Real-time cryptocurrency prices
- `/crypto/price` endpoint

---

# Alert System

## Implemented files

- `alerts_repository.dart`
- `alerts_service.dart`
- `alerts_checker_service.dart`

## Alert structure

- id
- symbol
- target
- type
- active

---

# Mock Persistence

Temporary in-memory storage implemented using:

```dart
List<Alert>
```

Purpose:
- accelerate development
- decouple backend from database

---

# CRUD Operations

## Implemented endpoints

| Method | Endpoint |
|---|---|
| POST | `/alerts/create` |
| GET | `/alerts/list` |
| GET | `/alerts/list_active` |
| PUT | `/alerts/update/:id` |
| PATCH | `/alerts/toggle_status/:id` |
| DELETE | `/alerts/delete/:id` |

---

# Architectural Improvements

## copyWith pattern

Implemented immutable update pattern using `copyWith`.

---

## AlertType enum

Replaced magic strings:

```text
'above'
'below'
```

with:

```dart
AlertType.above
AlertType.below
```

---

# Dart Extensions

Implemented serialization and deserialization helpers for `AlertType`.

---

# Scheduler

## File

- `alerts_scheduler.dart`

## Responsibilities

- periodically check active alerts
- fetch Binance prices
- validate conditions
- trigger alert events

---

# Trigger Conditions

Implemented conditions:

- above
- below

---

# Temporary Logging

Current logging format:

```text
[ALERT TRIGGERED] BTCUSDT above 100000 (Current price: 102340.50)
```

---

# RESTful Routes

Dynamic route structure implemented using:

```text
[id].dart
```

---

# Refactors and Fixes

## Naming standardization

Converted:
- methods
- files
- routes

to:
- English
- snake_case

---

# Current Backend Status

## Completed

- Backend infrastructure
- Binance integration
- Full alerts CRUD
- Scheduler
- Enum normalization
- Repository pattern
- Service layer
- Mock persistence
- RESTful routes

---

# Next Steps

1. Notifications module
2. Auth module
3. JWT middleware
4. PostgreSQL integration
5. Firebase Cloud Messaging
6. Structured logging
7. Environment variables
8. Global error handling

---

# Current State

✅ Functional backend  
✅ Running scheduler  
✅ Working endpoints  
✅ Complete CRUD  
✅ Modular architecture consolidated