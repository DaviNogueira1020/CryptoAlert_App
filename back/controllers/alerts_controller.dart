// alerts_controller.dart
// Camada de controle — agnóstica de framework HTTP.
// Recebe AlertsRequest, delega ao AlertsService, devolve AlertsResponse.

import '../services/alerts_service.dart';
import 'alerts_validator.dart';

// ─── Envelope de requisição ───────────────────────────────────────────────────

class AlertsRequest {
  final String userId;
  final Map<String, dynamic> body;
  final Map<String, String> params;
  final Map<String, String> query;

  const AlertsRequest({
    required this.userId,
    this.body   = const {},
    this.params = const {},
    this.query  = const {},
  });
}

// ─── Envelope de resposta ─────────────────────────────────────────────────────

class AlertsResponse {
  final int statusCode;
  final Map<String, dynamic> payload;

  const AlertsResponse({required this.statusCode, required this.payload});

  factory AlertsResponse.ok(dynamic data) => AlertsResponse(
        statusCode: 200,
        payload:    {'success': true, 'data': data},
      );

  factory AlertsResponse.created(dynamic data) => AlertsResponse(
        statusCode: 201,
        payload:    {'success': true, 'data': data},
      );

  factory AlertsResponse.badRequest(List<String> issues) => AlertsResponse(
        statusCode: 400,
        payload:    {'success': false, 'errors': issues},
      );

  factory AlertsResponse.notFound(String message) => AlertsResponse(
        statusCode: 404,
        payload:    {'success': false, 'error': message},
      );

  factory AlertsResponse.serverError(String message) => AlertsResponse(
        statusCode: 500,
        payload:    {'success': false, 'error': message},
      );
}

// ─── Controller ───────────────────────────────────────────────────────────────

class AlertsController {
  final AlertsService _service;

  AlertsController(this._service);

  // POST /alerts
  Future<AlertsResponse> criar(AlertsRequest req) async {
    try {
      final dto   = validateCreateAlert(req.body);
      final alert = await _service.criarAlerta(req.userId, dto);
      return AlertsResponse.created(alert.toJson());
    } on ValidationError catch (e) {
      return AlertsResponse.badRequest(e.issues);
    } on ArgumentError catch (e) {
      return AlertsResponse.badRequest([e.message.toString()]);
    } catch (e) {
      return AlertsResponse.serverError(e.toString());
    }
  }

  // GET /alerts
  Future<AlertsResponse> listar(AlertsRequest req) async {
    try {
      final options  = validateListAlertsQuery(req.query);
      final paginated = await _service.listarAlertas(req.userId, options);
      return AlertsResponse.ok({
        'items': paginated.items.map((a) => a.toJson()).toList(),
        'total': paginated.total,
        'page':  paginated.page,
        'limit': paginated.limit,
      });
    } on ValidationError catch (e) {
      return AlertsResponse.badRequest(e.issues);
    } catch (e) {
      return AlertsResponse.serverError(e.toString());
    }
  }

  // PUT /alerts/:id
  Future<AlertsResponse> atualizar(AlertsRequest req) async {
    try {
      final id  = validateIdParam(req.params['id']);
      final dto = validateUpdateAlert(req.body);
      final alert = await _service.atualizarAlerta(req.userId, id, dto);
      return AlertsResponse.ok(alert.toJson());
    } on ValidationError catch (e) {
      return AlertsResponse.badRequest(e.issues);
    } on StateError catch (e) {
      return AlertsResponse.notFound(e.message);
    } on ArgumentError catch (e) {
      return AlertsResponse.badRequest([e.message.toString()]);
    } catch (e) {
      return AlertsResponse.serverError(e.toString());
    }
  }

  // DELETE /alerts/:id
  Future<AlertsResponse> remover(AlertsRequest req) async {
    try {
      final id = validateIdParam(req.params['id']);
      await _service.deletarAlerta(req.userId, id);
      return AlertsResponse.ok({'message': 'Alerta removido com sucesso'});
    } on ValidationError catch (e) {
      return AlertsResponse.badRequest(e.issues);
    } on StateError catch (e) {
      return AlertsResponse.notFound(e.message);
    } catch (e) {
      return AlertsResponse.serverError(e.toString());
    }
  }
}
