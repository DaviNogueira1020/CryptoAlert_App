// alerts_repository.dart
// Acesso direto ao PostgreSQL via package:postgres + Database singleton.

import 'package:postgres/postgres.dart';
import '../models/alert_model.dart';
import '../models/alert_type.dart';
import 'database.dart';
import 'alerts_dtos.dart';

class AlertsRepository {
  Future<Connection> get _db => Database.instance;

  // ─── Create ────────────────────────────────────────────────────────────────

  Future<AlertModel> create(CreateAlertDTO dto, String userId) async {
    final db = await _db;
    final result = await db.execute(
      Sql.named('''
        INSERT INTO alerts (
          user_id, symbol, type, target, active
        ) VALUES (
          @userId, @symbol, @type, @target, TRUE
        )
        RETURNING *
      '''),
      parameters: {
        'userId': userId,
        'symbol': dto.symbol,
        'type':   dto.type.value,
        'target': dto.target,
      },
    );

    return AlertModel.fromJson(_rowToMap(result.first));
  }

  // ─── Find by user (paginado) ───────────────────────────────────────────────

  Future<PaginatedAlerts> findByUser(
    String userId,
    ListAlertsOptions options,
  ) async {
    final db   = await _db;
    final skip = (options.page - 1) * options.limit;

    final rows = await db.execute(
      Sql.named('''
        SELECT * FROM alerts
        WHERE user_id = @userId
        ORDER BY created_at DESC
        LIMIT @limit OFFSET @skip
      '''),
      parameters: {
        'userId': userId,
        'limit':  options.limit,
        'skip':   skip,
      },
    );

    final countResult = await db.execute(
      Sql.named('SELECT COUNT(*) FROM alerts WHERE user_id = @userId'),
      parameters: {'userId': userId},
    );

    final total = int.parse(countResult.first.first.toString());
    final items = rows.map((r) => AlertModel.fromJson(_rowToMap(r))).toList();

    return PaginatedAlerts(
      items: items,
      total: total,
      page:  options.page,
      limit: options.limit,
    );
  }

  // ─── Find by ID ────────────────────────────────────────────────────────────

  Future<AlertModel?> findById(String id) async {
    final db     = await _db;
    final result = await db.execute(
      Sql.named('SELECT * FROM alerts WHERE id = @id LIMIT 1'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;
    return AlertModel.fromJson(_rowToMap(result.first));
  }

  // ─── Update ────────────────────────────────────────────────────────────────

  Future<AlertModel> update(String id, UpdateAlertDTO dto) async {
    final setClauses = <String>[];
    final params     = <String, dynamic>{'id': id};

    void addField(String col, String param, dynamic value) {
      if (value != null) {
        setClauses.add('$col = @$param');
        params[param] = value;
      }
    }

    addField('symbol', 'symbol', dto.symbol);
    addField('type',   'type',   dto.type?.value);
    addField('target', 'target', dto.target);
    addField('active', 'active', dto.active);

    if (setClauses.isEmpty) {
      final current = await findById(id);
      if (current == null) throw StateError('Alerta não encontrado');
      return current;
    }

    final db  = await _db;
    final sql = '''
      UPDATE alerts
      SET ${setClauses.join(', ')}, updated_at = NOW()
      WHERE id = @id
      RETURNING *
    ''';

    final result = await db.execute(Sql.named(sql), parameters: params);
    return AlertModel.fromJson(_rowToMap(result.first));
  }

  // ─── Delete ────────────────────────────────────────────────────────────────

  Future<void> delete(String id) async {
    final db = await _db;
    await db.execute(
      Sql.named('DELETE FROM alerts WHERE id = @id'),
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
