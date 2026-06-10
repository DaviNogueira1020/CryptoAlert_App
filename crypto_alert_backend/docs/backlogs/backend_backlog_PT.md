# CryptoAlert Backend — Backlog

## Prioridade Alta (Pós Deploy)

### 1. Sistema de Autenticação

Objetivo:

* Cadastro de usuários
* Login
* JWT Authentication
* Middleware de autorização

Funcionalidades:

* POST /auth/register
* POST /auth/login
* JWT Middleware
* Password Hashing

Status:
Pendente

---

### 2. Integração Usuário ↔ Alertas

Objetivo:

Associar alertas aos usuários.

Alterações previstas:

Tabela users

Tabela alerts

Adicionar:

* user_id
* foreign keys
* filtros por usuário

Status:
Pendente

---

### 3. Firebase Cloud Messaging (FCM)

Objetivo:

Enviar notificações push reais.

Funcionalidades:

* Registro de device tokens
* Envio automático de notificações
* Integração com AlertsScheduler

Status:
Pendente

---

## Prioridade Média

### 4. Conversão de Moedas

Objetivo:

Permitir exibição de preços em:

* USD
* BRL
* EUR

Necessário:

* Serviço de câmbio
* Cache de taxas
* Conversor centralizado

Status:
Pendente

---

### 5. Preferências do Usuário

Objetivo:

Permitir personalização.

Configurações:

* moeda padrão
* idioma
* notificações habilitadas

Status:
Pendente

---

### 6. Scheduler Automático de Mercado

Objetivo:

Atualizar market snapshots automaticamente.

Status:
Planejado

---

## Prioridade Baixa

### 7. Cache de APIs Externas

* CoinGecko
* Binance

Objetivo:

Reduzir rate limits.

Status:
Planejado

---

### 8. Observabilidade

* Logging estruturado
* Métricas
* Monitoramento

Status:
Planejado
