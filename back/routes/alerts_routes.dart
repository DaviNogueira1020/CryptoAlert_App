// alerts_routes.dart
// Registro de rotas usando package:shelf + shelf_router.
//
// Dependências necessárias no pubspec.yaml:
//   shelf: ^1.4.0
//   shelf_router: ^1.1.0

import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/alerts_controller.dart';

// ─── Auth middleware ──────────────────────────────────────────────────────────

/// Extrai userId do header Authorization.
/// Substitua pela sua lógica real de JWT/sessão.
Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'] ?? '';

      // Exemplo: "Bearer <userId>" — troque por validação JWT real
      final parts = authHeader.split(' ');
      if (parts.length != 2 || parts[0].toLowerCase() != 'bearer') {
        return Response(
          401,
          body: jsonEncode({'success': false, 'error': 'Não autorizado'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final userId = parts[1].trim();
      if (userId.isEmpty) {
        return Response(
          401,
          body: jsonEncode({'success': false, 'error': 'Token inválido'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return innerHandler(request.change(context: {'userId': userId}));
    };
  };
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _userId(Request req) => req.context['userId'] as String;

Future<Map<String, dynamic>> _parseBody(Request req) async {
  final body = await req.readAsString();
  if (body.isEmpty) return {};
  return (jsonDecode(body) as Map<String, dynamic>?) ?? {};
}

Response _fromResponse(AlertsResponse r) => Response(
      r.statusCode,
      body:    jsonEncode(r.payload),
      headers: {'content-type': 'application/json'},
    );

// ─── Router factory ───────────────────────────────────────────────────────────

/// Cria e retorna um [Router] do Shelf com todas as rotas de alertas.
///
/// Uso no server.dart:
/// ```dart
/// final app = const Pipeline()
///     .addMiddleware(logRequests())
///     .addHandler(
///       Router()
///         ..mount('/alerts', alertsRouter(controller).call)
///         .call,
///     );
/// ```
Router alertsRouter(AlertsController controller) {
  final router = Router();
  final auth   = authMiddleware();

  // POST /
  router.post('/', (Request req) async {
    return auth((req) async {
      final body = await _parseBody(req);
      final res  = await controller.criar(
        AlertsRequest(userId: _userId(req), body: body),
      );
      return _fromResponse(res);
    })(req);
  });

  // GET /
  router.get('/', (Request req) async {
    return auth((req) async {
      final res = await controller.listar(
        AlertsRequest(
          userId: _userId(req),
          query:  req.url.queryParameters,
        ),
      );
      return _fromResponse(res);
    })(req);
  });

  // PUT /<id>
  router.put('/<id>', (Request req, String id) async {
    return auth((req) async {
      final body = await _parseBody(req);
      final res  = await controller.atualizar(
        AlertsRequest(
          userId:  _userId(req),
          params:  {'id': id},
          body:    body,
        ),
      );
      return _fromResponse(res);
    })(req);
  });

  // DELETE /<id>
  router.delete('/<id>', (Request req, String id) async {
    return auth((req) async {
      final res = await controller.remover(
        AlertsRequest(
          userId:  _userId(req),
          params:  {'id': id},
        ),
      );
      return _fromResponse(res);
    })(req);
  });

  return router;
}
