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
      throw Exception('Alert ID is required');
    }

    if (title.isEmpty) {
      throw Exception('Title is required');
    }

    if (message.isEmpty) {
      throw Exception('Message is required');
    }

    final id = Random().nextInt(100000).toString(); // MOCK

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