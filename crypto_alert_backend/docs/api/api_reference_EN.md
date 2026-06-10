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

# Market Data

## GET /market/overview

Returns tracked assets and their latest market data.

### Response Example

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

### Notes

* change_24h is under development.
* volume_24h is under development.

---

## POST /market/refresh

Forces immediate market snapshot update.

### Response

```json
{
  "message": "Market data refreshed successfully"
}
```

---

# Alerts

## GET /alerts/list

Returns all alerts.

---

## GET /alerts/list_active

Returns only active alerts.

---

## POST /alerts/create

Creates a new alert.

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

Updates an existing alert.

---

## PATCH /alerts/activate/:id

Activates an alert.

---

## PATCH /alerts/deactivate/:id

Deactivates an alert.

---

## DELETE /alerts/delete/:id

Deletes an alert.

---

# Notifications

## GET /notifications/list

Returns all notifications.

---

## GET /notifications/unread

Returns unread notifications.

---

## PATCH /notifications/read/:id

Marks a notification as read.

---

## DELETE /notifications/delete/:id

Deletes a notification.

---

# Current Status

## Implemented

* Alerts CRUD
* Notifications CRUD
* Market Overview
* Market Refresh
* Alerts Scheduler
* Market Data Scheduler

## In Progress

* change_24h
* volume_24h
* 7d variation
* 30d variation
* currency conversion
* JWT authentication
* Firebase Cloud Messaging

```
```
