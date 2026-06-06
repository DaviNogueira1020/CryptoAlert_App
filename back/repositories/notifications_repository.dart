// notifications_repository.dart
// Acesso direto à tabela `notifications` via package:postgres + Database singleton.

import 'package:postgres/postgres.dart';
import '../models/notification_model.dart';
import 'database.dart';
import 'alerts_dtos.dart';

class NotificationsRepository {
  Future<Connection> get _db => Database.instance;

  // ─── Create ────────────────────────────────────────────────────────────────
  // Chamado pelo worker/job quando um alerta de preço é disparado.

  Future<NotificationModel> create(CreateNotificationDTO dto) async {
    final db     = await _db;
    final result = await db.execute(
      Sql.named('''
        INSERT INTO notifications (
          user_id, alert_id, message, read
        ) VALUES (
          @userId, @alertId, @message, FALSE
        )
        RETURNING *
      '''),
      parameters: {
        'userId':  dto.userId,
        'alertId': dto.alertId,
        'message': dto.message,
      },
    );

    return NotificationModel.fromJson(_rowToMap(result.first));
  }

  // ─── Find by user (paginado, com filtro opcional de não-lidas) ─────────────

  Future<PaginatedNotifications> findByUser(
    String userId,
    ListNotificationsOptions options,
  ) async {
    final db   = await _db;
    final skip = (options.page - 1) * options.limit;

    final whereClauses = ['user_id = @userId'];
    final params       = <String, dynamic>{
      'userId': userId,
      'limit':  options.limit,
      'skip':   skip,
    };

    if (options.onlyUnread == true) {
      whereClauses.add('read = FALSE');
    }

    final where = whereClauses.join(' AND ');

    final rows = await db.execute(
      Sql.named('''
        SELECT * FROM notifications
        WHERE $where
        ORDER BY created_at DESC
        LIMIT @limit OFFSET @skip
      '''),
      parameters: params,
    );

    final countResult = await db.execute(
      Sql.named('SELECT COUNT(*) FROM notifications WHERE $where'),
      parameters: {'userId': userId},
    );

    final total = int.parse(countResult.first.first.toString());
    final items =
        rows.map((r) => NotificationModel.fromJson(_rowToMap(r))).toList();

    return PaginatedNotifications(
      items: items,
      total: total,
      page:  options.page,
      limit: options.limit,
    );
  }

  // ─── Find by ID ────────────────────────────────────────────────────────────

  Future<NotificationModel?> findById(String id) async {
    final db     = await _db;
    final result = await db.execute(
      Sql.named('SELECT * FROM notifications WHERE id = @id LIMIT 1'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;
    return NotificationModel.fromJson(_rowToMap(result.first));
  }

  // ─── Marcar como lida ──────────────────────────────────────────────────────

  Future<NotificationModel> markAsRead(String id) async {
    final db     = await _db;
    final result = await db.execute(
      Sql.named('''
        UPDATE notifications
        SET read = TRUE
        WHERE id = @id
        RETURNING *
      '''),
      parameters: {'id': id},
    );

    if (result.isEmpty) throw StateError('Notificação não encontrada');
    return NotificationModel.fromJson(_rowToMap(result.first));
  }

  // ─── Marcar todas do usuário como lidas ────────────────────────────────────

  Future<int> markAllAsRead(String userId) async {
    final db     = await _db;
    final result = await db.execute(
      Sql.named('''
        UPDATE notifications
        SET read = TRUE
        WHERE user_id = @userId AND read = FALSE
      '''),
      parameters: {'userId': userId},
    );

    return result.affectedRows;
  }

  // ─── Contagem de não-lidas ─────────────────────────────────────────────────

  Future<int> countUnread(String userId) async {
    final db     = await _db;
    final result = await db.execute(
      Sql.named('''
        SELECT COUNT(*) FROM notifications
        WHERE user_id = @userId AND read = FALSE
      '''),
      parameters: {'userId': userId},
    );

    return int.parse(result.first.first.toString());
  }

  // ─── Histórico de disparos de um alerta específico ─────────────────────────

  Future<List<NotificationModel>> findByAlert(String alertId) async {
    final db   = await _db;
    final rows = await db.execute(
      Sql.named('''
        SELECT * FROM notifications
        WHERE alert_id = @alertId
        ORDER BY created_at DESC
      '''),
      parameters: {'alertId': alertId},
    );

    return rows.map((r) => NotificationModel.fromJson(_rowToMap(r))).toList();
  }

  // ─── Delete ────────────────────────────────────────────────────────────────

  Future<void> delete(String id) async {
    final db = await _db;
    await db.execute(
      Sql.named('DELETE FROM notifications WHERE id = @id'),
      parameters: {'id': id},
    );
  }

  // ─── Util ──────────────────────────────────────────────────────────────────

  Map<String, dynamic> _rowToMap(ResultRow row) {
    final map = <String, dynamic>{};
    for (final column in row.schema.columns) {
      map[column.columnName ?? ''] = row[column.columnName ?? ''];
    }
    return map;
  }
}
