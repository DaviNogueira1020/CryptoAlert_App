import 'package:crypto_alert_backend/modules/alerts/alert_type.dart';
import 'package:crypto_alert_backend/core/database/database_connection.dart';
import 'package:postgres/postgres.dart';

class Alert{
  final String id;
  final String symbol;
  final double target;
  final AlertType type; // 'above' or 'below'
  final bool active;

  Alert({
    required this.id,
    required this.symbol,
    required this.target,
    required this.type, // 'above' or 'below'
    this.active = true,
  });

  factory Alert.fromDatabase(Map<String, dynamic> row){
    return Alert(
      id: row['id'] as String,
      symbol: row['symbol'] as String,
      target: (row['target'] as num).toDouble(),
      type: AlertTypeExtension.fromString(
        row['type'] as String
      ),
      active: row['active'] as bool,
    );
  }

  factory Alert.fromRow(ResultRow row) {
    return Alert(
      id: row[0]! as String,
      symbol: row[1]! as String,
      target: (row[2]! as num).toDouble(),
      type: AlertTypeExtension.fromString(
        row[3]! as String,
      ),
      active: row[4]! as bool,
    );
  }

  Alert copyWith({
    String? symbol,
    double? target,
    AlertType? type,
    bool? active,
  }) {
    return Alert(
      id: id,
      symbol: symbol ?? this.symbol,
      target: target ?? this.target,
      type: type ?? this.type,
      active: active ?? this.active,
    );
  }
}

class AlertsRepository {
  Future<void> create(Alert alert) async {
    final connection = await DatabaseConnection.getConnection();

    await connection.execute(
      Sql.named('''
        INSERT INTO alerts(
          id,
          symbol,
          target,
          type,
          active
        )
        VALUES(
          @id,
          @symbol,
          @target,
          @type,
          @active
        )
      '''),
      parameters: {
        'id': alert.id,
        'symbol': alert.symbol,
        'target': alert.target,
        'type': alert.type.value,
        'active': alert.active,
      },
    );
  }

  /* Future<Alert> findById(String id) async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        SELECT
          id,
          symbol,
          target,
          type,
          active
        FROM alerts
        WHERE id = @id
      '''),
      parameters: {
        'id': id,
      },
    );

    if(result.isEmpty){
      throw Exception ('Alert [ID: $id] not found');
    }

    return Alert.fromRow(result.first);
  } */

  Future<List<Alert>> findAll() async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      '''
        SELECT
          id,
          symbol,
          target,
          type,
          active
        FROM alerts
      ''',
    );
    
    return result.map(Alert.fromRow).toList();
  }

  Future<List<Alert>> findActive() async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      '''
        SELECT
          id,
          symbol,
          target,
          type,
          active
        FROM alerts
        WHERE active = TRUE      
      ''',
    );
    
    return result.map(Alert.fromRow).toList();
  }

  Future<Alert> toggleStatus(String id) async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        UPDATE alerts
        SET active = NOT active
        WHERE id = @id
        RETURNING
          id,
          symbol,
          target,
          type,
          active
      '''),
      parameters: {
        'id': id,
      },
    );

    if(result.isEmpty){
      throw Exception('Alert [ID: $id] not found');
    }

    return Alert.fromRow(result.first);
  }

  Future<Alert> update(
    String id, {
    String? symbol,
    double? target,
    AlertType? type,
  }) async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        UPDATE alerts
        SET
          symbol = COALESCE(@symbol, symbol),
          target = COALESCE(@target, target),
          type = COALESCE(@type, type)
        WHERE id = @id
        RETURNING
          id,
          symbol,
          target,
          type,
          active
      '''),
      parameters: {
        'id': id,
        'symbol': symbol,
        'target': target,
        'type': type?.value
      },
    );

    if(result.isEmpty){
      throw Exception('Alert [ID: $id] not found');
    }

    return Alert.fromRow(result.first);
  }

  Future<Alert> delete(String id) async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        DELETE FROM alerts
        WHERE id = @id
        RETURNING
          id,
          symbol,
          target,
          type,
          active
      '''),
      parameters: {
        'id': id,
      },
    );

    if(result.isEmpty){
      throw Exception('Alert [ID: $id] not found');
    }

    return Alert.fromRow(result.first);
  }
}
