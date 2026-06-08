import 'package:uuid/uuid.dart';
import 'package:crypto_alert_backend/core/exceptions/validation_exception.dart';
import 'package:crypto_alert_backend/modules/notifications/notification_model.dart';
import 'package:crypto_alert_backend/modules/notifications/notifications_repository.dart';
import 'dart:math';

class NotificationsService {
  final NotificationsRepository _repository = NotificationsRepository();
  
  Future<AppNotification> createNotification({
    required String alertId,
    required String title,
    required String message,
  }) async{
    if (alertId.isEmpty) {
      throw ValidationException('Alert ID is required');
    }

    if (title.isEmpty) {
      throw ValidationException('Title is required');
    }

    if (message.isEmpty) {
      throw ValidationException('Message is required');
    }

    final id = const Uuid().v4();

    final notification = AppNotification(
      id: id,
      alertId: alertId,
      title: title,
      message: message,
    );

    await _repository.create(notification);

    return notification;
  }

  Future<List<AppNotification>> getNotifications() async{
    return await _repository.findAll();
  }

  Future<List<AppNotification>> getUnreadNotifications() async{      
    return await _repository.findUnread();
  }

  Future<AppNotification> markNotificationAsRead(String id) async{
    final markedAsReadNotification = await _repository.markAsRead(id);
  
    return markedAsReadNotification;
  }

  Future<AppNotification> deleteNotification(String id) async{
    final deletedNotification = await _repository.delete(id);

    return deletedNotification;
  }
}