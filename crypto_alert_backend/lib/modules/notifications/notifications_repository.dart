import 'package:crypto_alert_backend/core/exceptions/not_found_exception.dart';
import 'package:crypto_alert_backend/modules/notifications/notification_model.dart';
import 'package:crypto_alert_backend/core/database/database_connection.dart';
import 'package:postgres/postgres.dart';

class NotificationsRepository{
  Future<void> create(AppNotification notification) async{
    final connection = await DatabaseConnection.getConnection();

    await connection.execute( //PostgreSQL creates DateTime automatically
      // ignore: leading_newlines_in_multiline_strings
      Sql.named(''' 
        INSERT INTO notifications(
          id,
          alert_id,
          title,
          message,
          read
        )
        VALUES(
          @id,
          @alert_id,
          @title,
          @message,
          @read
        ) 
      '''),
      parameters: {
        'id': notification.id,
        'alert_id': notification.alertId,
        'title': notification.title,
        'message': notification.message,
        'read': notification.read
      },
    );
  }

  /* Future<AppNotification?> findById(String id) async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        SELECT
          id,
          alert_id,
          title,
          message,
          read,
          created_at
        FROM notifications
        WHERE id = @id
      '''),
      parameters: {
        'id': id,
      },
    );

    if(result.isEmpty){
      return null;
    }

    return AppNotification.fromRow(result.first);
  } */


  Future<List<AppNotification>> findAll() async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      '''
        SELECT
          id,
          alert_id,
          title,
          message,
          read,
          created_at
        FROM notifications
      ''',
    );
    
    return result.map(AppNotification.fromRow).toList();
  }

  Future<List<AppNotification>> findUnread() async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      '''
        SELECT
          id,
          alert_id,
          title,
          message,
          read,
          created_at
        FROM notifications
        WHERE read = FALSE
      ''',
    );
    
    return result.map(AppNotification.fromRow).toList();
  }

  Future<AppNotification> markAsRead(String id) async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        UPDATE notifications
        SET read = TRUE
        WHERE id = @id
        RETURNING
          id,
          alert_id,
          title,
          message,
          read,
          created_at
      '''),
      parameters: {
        'id': id,
      },
    ); 

    if(result.isEmpty){
      throw NotFoundException('Notification [ID: $id] not found');
    }

    return AppNotification.fromRow(result.first);
  }

  Future<AppNotification> delete(String id) async{
    final connection = await DatabaseConnection.getConnection();

    final result = await connection.execute(
      Sql.named('''
        DELETE FROM notifications
        WHERE id = @id
        RETURNING
          id,
          alert_id,
          title,
          message,
          read,
          created_at
      '''),
      parameters: {
        'id': id,
      },
    );
    
    if(result.isEmpty){
      throw NotFoundException ('Notification [ID: $id] not found');
    }

    return AppNotification.fromRow(result.first);
  }
}
