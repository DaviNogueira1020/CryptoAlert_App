# CryptoAlert Backend — Backlog

## High Priority (Post Deployment)

### 1. Authentication System

Goals:

* User registration
* Login
* JWT authentication
* Authorization middleware

Features:

* POST /auth/register
* POST /auth/login
* JWT Middleware
* Password hashing

Status:
Pending

---

### 2. User ↔ Alerts Integration

Goals:

Associate alerts with users.

Planned changes:

Users table

Alerts table

Add:

* user_id
* foreign keys
* user-based filtering

Status:
Pending

---

### 3. Firebase Cloud Messaging (FCM)

Goals:

Send real push notifications.

Features:

* Device token registration
* Push notification delivery
* Scheduler integration

Status:
Pending

---

## Medium Priority

### 4. Currency Conversion

Support:

* USD
* BRL
* EUR

Requirements:

* Exchange rate service
* Cache layer
* Conversion service

Status:
Pending

---

### 5. User Preferences

Settings:

* preferred currency
* language
* notification preferences

Status:
Pending

---

### 6. Automatic Market Scheduler

Goals:

Refresh market data automatically.

Status:
Planned

---

## Low Priority

### 7. External API Caching

Targets:

* CoinGecko
* Binance

Goal:

Reduce rate limits.

Status:
Planned

---

### 8. Observability

* Structured logging
* Metrics
* Monitoring

Status:
Planned
