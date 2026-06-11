# CryptoAlert API - Documentação Completa

## 📌 Informações Gerais

- **Base URL**: `http://localhost:8080`
- **Protocolo**: HTTP REST
- **Content-Type**: `application/json`
- **Autenticação**: Nenhuma (em desenvolvimento)

---

## 📊 Endpoints de Dados de Mercado

### GET /market/overview

Retorna uma lista de todos os ativos monitorados com seus dados de mercado atuais.

**Request:**
```bash
GET http://localhost:8080/market/overview
```

**Response (200):**
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
  },
  {
    "symbol": "ETHUSDT",
    "name": "Ethereum",
    "image_url": "https://...",
    "price_usd": 3215.50,
    "change_24h": null,
    "volume_24h": null,
    "updated_at": "2026-06-10T03:10:28.501019Z"
  }
]
```

**Campos:**
- `symbol` (string): Símbolo da criptomoeda (ex: BTCUSDT)
- `name` (string): Nome da criptomoeda (ex: Bitcoin)
- `image_url` (string|null): URL da imagem/logo
- `price_usd` (number): Preço em USD
- `change_24h` (number|null): Variação em 24h (ainda em implementação)
- `volume_24h` (number|null): Volume em 24h (ainda em implementação)
- `updated_at` (string): Timestamp da última atualização (ISO 8601)

---

### GET /crypto/price

Retorna o preço atual de uma criptomoeda específica.

**Request:**
```bash
GET http://localhost:8080/crypto/price?symbol=BTCUSDT
```

**Query Parameters:**
- `symbol` (string, **obrigatório**): Símbolo da criptomoeda (ex: BTCUSDT)

**Response (200):**
```json
{
  "symbol": "BTCUSDT",
  "price": 61318.05
}
```

**Erros:**
- `400 Bad Request`: Symbol não foi fornecido
- `500 Internal Server Error`: Erro ao buscar preço na Binance

---

### POST /market/refresh

Força uma atualização imediata dos snapshots de mercado no backend.

**Request:**
```bash
POST http://localhost:8080/market/refresh
Content-Type: application/json
```

**Response (200):**
```json
{
  "message": "Market data refreshed successfully"
}
```

---

## 🔔 Endpoints de Alertas

### POST /alerts/create

Cria um novo alerta para uma criptomoeda.

**Request:**
```bash
POST http://localhost:8080/alerts/create
Content-Type: application/json

{
  "symbol": "BTCUSDT",
  "target": 65000,
  "type": "above"
}
```

**Body:**
- `symbol` (string, **obrigatório**): Símbolo da criptomoeda
- `target` (number, **obrigatório**): Preço-alvo
- `type` (string, **obrigatório**): "above" (acima) ou "below" (abaixo)

**Response (200):**
```json
{
  "id": "01aryz6s41tsdbftnzj7ehl42c",
  "symbol": "BTCUSDT",
  "target": 65000,
  "type": "above",
  "active": true
}
```

**Erros:**
- `400 Bad Request`: Campos obrigatórios faltando
- `500 Internal Server Error`: Erro ao criar alerta

---

### GET /alerts/list

Lista TODOS os alertas cadastrados (ativos e inativos).

**Request:**
```bash
GET http://localhost:8080/alerts/list
```

**Response (200):**
```json
[
  {
    "id": "01aryz6s41tsdbftnzj7ehl42c",
    "symbol": "BTCUSDT",
    "target": 65000,
    "type": "above",
    "active": true
  },
  {
    "id": "01aryz6s41tsdbftnzj7ehl42e",
    "symbol": "ETHUSDT",
    "target": 3000,
    "type": "below",
    "active": false
  }
]
```

---

### GET /alerts/list_active

Lista apenas os alertas ATIVOS.

**Request:**
```bash
GET http://localhost:8080/alerts/list_active
```

**Response (200):**
```json
[
  {
    "id": "01aryz6s41tsdbftnzj7ehl42c",
    "symbol": "BTCUSDT",
    "target": 65000,
    "type": "above",
    "active": true
  }
]
```

---

### PUT /alerts/update/:id

Atualiza um alerta existente.

**Request:**
```bash
PUT http://localhost:8080/alerts/update/01aryz6s41tsdbftnzj7ehl42c
Content-Type: application/json

{
  "symbol": "BTCUSDT",
  "target": 70000,
  "type": "above"
}
```

**Path Parameters:**
- `id` (string): ID do alerta a atualizar

**Body:**
- `symbol` (string): Símbolo da criptomoeda
- `target` (number): Novo preço-alvo
- `type` (string): "above" ou "below"

**Response (200):**
```json
{
  "id": "01aryz6s41tsdbftnzj7ehl42c",
  "symbol": "BTCUSDT",
  "target": 70000,
  "type": "above",
  "active": true
}
```

---

### PATCH /alerts/activate/:id

Ativa um alerta (muda `active` para `true`).

**Request:**
```bash
PATCH http://localhost:8080/alerts/activate/01aryz6s41tsdbftnzj7ehl42c
```

**Response (200):**
```json
{
  "id": "01aryz6s41tsdbftnzj7ehl42c",
  "active": true
}
```

---

### PATCH /alerts/deactivate/:id

Desativa um alerta (muda `active` para `false`).

**Request:**
```bash
PATCH http://localhost:8080/alerts/deactivate/01aryz6s41tsdbftnzj7ehl42c
```

**Response (200):**
```json
{
  "id": "01aryz6s41tsdbftnzj7ehl42c",
  "active": false
}
```

---

### DELETE /alerts/delete/:id

Deleta um alerta.

**Request:**
```bash
DELETE http://localhost:8080/alerts/delete/01aryz6s41tsdbftnzj7ehl42c
```

**Response (200):**
```json
{
  "message": "Alert deleted successfully"
}
```

**Erros:**
- `404 Not Found`: Alerta não existe
- `500 Internal Server Error`: Erro ao deletar

---

## 📬 Endpoints de Notificações

### GET /notifications/list

Lista TODAS as notificações.

**Request:**
```bash
GET http://localhost:8080/notifications/list
```

**Response (200):**
```json
[
  {
    "id": "01aryz6s41tsdbftnzj7ehl42d",
    "message": "Bitcoin atingiu o preço alvo: $65000",
    "is_read": false,
    "created_at": "2026-06-10T03:10:28.501019Z"
  }
]
```

---

### GET /notifications/unread

Lista apenas notificações NÃO LIDAS.

**Request:**
```bash
GET http://localhost:8080/notifications/unread
```

**Response (200):**
```json
[
  {
    "id": "01aryz6s41tsdbftnzj7ehl42d",
    "message": "Bitcoin atingiu o preço alvo: $65000",
    "is_read": false,
    "created_at": "2026-06-10T03:10:28.501019Z"
  }
]
```

---

### PATCH /notifications/read/:id

Marca uma notificação como LIDA.

**Request:**
```bash
PATCH http://localhost:8080/notifications/read/01aryz6s41tsdbftnzj7ehl42d
```

**Response (200):**
```json
{
  "id": "01aryz6s41tsdbftnzj7ehl42d",
  "is_read": true
}
```

---

### DELETE /notifications/delete/:id

Deleta uma notificação.

**Request:**
```bash
DELETE http://localhost:8080/notifications/delete/01aryz6s41tsdbftnzj7ehl42d
```

**Response (200):**
```json
{
  "message": "Notification deleted successfully"
}
```

---

## 🧪 Testando os Endpoints

### Com cURL

```bash
# Listar alertas
curl http://localhost:8080/alerts/list

# Criar alerta
curl -X POST http://localhost:8080/alerts/create \
  -H "Content-Type: application/json" \
  -d '{"symbol":"BTCUSDT","target":65000,"type":"above"}'

# Obter preço
curl "http://localhost:8080/crypto/price?symbol=BTCUSDT"
```

### Com Postman

1. Importe a coleção: [Link para Postman Collection](./postman_collection.json)
2. Configure a variável `base_url` como `http://localhost:8080`
3. Execute os requests

### Com o App Flutter

Veja [INTEGRATION.md](INTEGRATION.md) para exemplos de como chamar esses endpoints no Flutter.

---

## ⚠️ Status de Implementação

✅ **Completo:**
- Alerts CRUD
- Notifications CRUD
- Market Overview
- Market Refresh
- Scheduler de Alertas (1 minuto)
- Scheduler de Dados de Mercado

🚧 **Em Desenvolvimento:**
- `change_24h` (variação 24h)
- `volume_24h` (volume 24h)
- Variação 7d/30d
- Conversão de moedas
- Autenticação JWT
- Firebase Cloud Messaging

---

**Última atualização**: Junho 2026
