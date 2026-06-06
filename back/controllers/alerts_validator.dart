// alerts_validator.dart
// Validação de entrada do domínio de alertas.

import '../models/alert_type.dart';
import '../repositories/alerts_dtos.dart';

class ValidationError implements Exception {
  final List<String> issues;
  ValidationError(this.issues);

  @override
  String toString() => 'ValidationError: ${issues.join('; ')}';
}

// ─── Helpers internos ─────────────────────────────────────────────────────────

String? _parseString(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final v = map[key];
    if (v != null && v.toString().trim().isNotEmpty) return v.toString().trim();
  }
  return null;
}

double? _parseDouble(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final v = map[key];
    if (v != null) {
      final n = double.tryParse(v.toString());
      if (n != null) return n;
    }
  }
  return null;
}

bool? _parseBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  final s = v.toString().toLowerCase();
  if (s == 'true') return true;
  if (s == 'false') return false;
  return null;
}

int? _parseInt(dynamic v) {
  if (v == null) return null;
  return int.tryParse(v.toString());
}

// ─── Create ───────────────────────────────────────────────────────────────────

/// Valida o body HTTP e retorna um [CreateAlertDTO].
/// Aceita tanto 'symbol' quanto 'coin' ou 'crypto' como chave do par.
/// Lança [ValidationError] se inválido.
CreateAlertDTO validateCreateAlert(Map<String, dynamic> body) {
  final issues = <String>[];

  // symbol / coin / crypto
  final symbol = _parseString(body, ['symbol', 'coin', 'crypto']);
  if (symbol == null) {
    issues.add('symbol é obrigatório e não pode ser vazio');
  }

  // target / price / targetPrice
  final target = _parseDouble(body, ['target', 'price', 'targetPrice']);
  if (target == null) {
    issues.add('target é obrigatório');
  } else if (target <= 0) {
    issues.add('target deve ser maior que zero');
  }

  // type / direction
  final typeRaw = body['type']?.toString() ?? body['direction']?.toString();
  AlertType? type;
  if (typeRaw == null || typeRaw.isEmpty) {
    issues.add('type é obrigatório ("above" ou "below")');
  } else if (typeRaw != 'above' && typeRaw != 'below') {
    issues.add('type deve ser "above" ou "below"');
  } else {
    type = AlertType.fromString(typeRaw);
  }

  if (issues.isNotEmpty) throw ValidationError(issues);

  return CreateAlertDTO(
    symbol: symbol!.toUpperCase(),
    type:   type!,
    target: target!,
  );
}

// ─── Update (todos os campos opcionais) ──────────────────────────────────────

UpdateAlertDTO validateUpdateAlert(Map<String, dynamic> body) {
  final issues = <String>[];

  final symbolRaw = _parseString(body, ['symbol', 'coin', 'crypto']);

  double? target;
  if (body.containsKey('target') ||
      body.containsKey('price') ||
      body.containsKey('targetPrice')) {
    target = _parseDouble(body, ['target', 'price', 'targetPrice']);
    if (target == null) {
      issues.add('target inválido');
    } else if (target <= 0) {
      issues.add('target deve ser maior que zero');
    }
  }

  AlertType? type;
  final typeRaw =
      body['type']?.toString() ?? body['direction']?.toString();
  if (typeRaw != null) {
    if (typeRaw != 'above' && typeRaw != 'below') {
      issues.add('type deve ser "above" ou "below"');
    } else {
      type = AlertType.fromString(typeRaw);
    }
  }

  bool? active;
  if (body.containsKey('active')) {
    active = _parseBool(body['active']);
    if (active == null) issues.add('active deve ser true ou false');
  }

  if (issues.isNotEmpty) throw ValidationError(issues);

  return UpdateAlertDTO(
    symbol: symbolRaw?.toUpperCase(),
    type:   type,
    target: target,
    active: active,
  );
}

// ─── List query params ────────────────────────────────────────────────────────

ListAlertsOptions validateListAlertsQuery(Map<String, dynamic> query) {
  final issues = <String>[];

  int page  = 1;
  int limit = 20;

  if (query['page'] != null) {
    final p = _parseInt(query['page']);
    if (p == null || p < 1) {
      issues.add('page deve ser inteiro >= 1');
    } else {
      page = p;
    }
  }

  if (query['limit'] != null) {
    final l = _parseInt(query['limit']);
    if (l == null || l < 1 || l > 100) {
      issues.add('limit deve ser inteiro entre 1 e 100');
    } else {
      limit = l;
    }
  }

  if (issues.isNotEmpty) throw ValidationError(issues);

  return ListAlertsOptions(page: page, limit: limit);
}

// ─── ID param ─────────────────────────────────────────────────────────────────

/// Valida um UUID (String) vindo de parâmetro de rota.
String validateIdParam(dynamic raw) {
  if (raw == null || raw.toString().trim().isEmpty) {
    throw ValidationError(['id é obrigatório']);
  }
  // UUID v4 básico — ajuste o regex se usar outro formato
  final id = raw.toString().trim();
  final uuidRegex = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    caseSensitive: false,
  );
  if (!uuidRegex.hasMatch(id)) {
    throw ValidationError(['id deve ser um UUID válido']);
  }
  return id;
}
