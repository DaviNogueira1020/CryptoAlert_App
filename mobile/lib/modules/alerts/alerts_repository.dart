import 'package:crypto_alert_backend/modules/alerts/alert_model.dart';
import 'package:crypto_alert_backend/modules/alerts/alert_type.dart';
import 'package:crypto_alert_backend/core/exceptions/not_found_exception.dart';
import 'package:crypto_alert_backend/core/database/database_connection.dart';
import 'package:postgres/postgres.dart';

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
      throw NotFoundException ('Alert [ID: $id] not found');
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

  Future<Alert> activate(String id) async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        UPDATE alerts
        SET active = TRUE
        WHERE id = @id
        RETURNING
          id,
          symbol,
          target,
          type,
          active
      '''),
      parameters:{
        'id': id,
      },
    );

    if(result.isEmpty){
      throw NotFoundException('Alert [ID: $id] not found');
    }

    return Alert.fromRow(result.first);
  }

  Future<Alert> deactivate(String id) async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        UPDATE alerts
        SET active = FALSE
        WHERE id = @id
        RETURNING
          id,
          symbol,
          target,
          type,
          active
      '''),
      parameters:{
        'id': id,
      },
    );

    if(result.isEmpty){
      throw NotFoundException('Alert [ID: $id] not found');
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
      throw NotFoundException('Alert [ID: $id] not found');
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
      throw NotFoundException('Alert [ID: $id] not found');
    }

    return Alert.fromRow(result.first);
  }
}
