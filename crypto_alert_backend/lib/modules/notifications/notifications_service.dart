import 'package:crypto_alert_backend/modules/notifications/notification_model.dart';
import 'package:crypto_alert_backend/modules/notifications/notifications_repository.dart';
import 'package:crypto_alert_backend/core/database/mock_database.dart';
import 'dart:math';

class NotificationsService {
  final NotificationsRepository _repository = notificationsRepository;
  
  AppNotification createNotification({
    required String alertId,
    required String title,
    required String message,
  }){
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

    _repository.create(notification);

    return notification;
  }

  List<AppNotification> getNotifications(){
    return _repository.findAll();
  }

  List<AppNotification> getUnreadNotifications(){      
    return _repository.findUnread();
  }

  AppNotification markNotificationAsRead(String id){
    final markedAsReadNotification = _repository.markAsRead(id);
  
    return markedAsReadNotification;
  }

  AppNotification deleteNotification(String id){
    final deletedNotification = _repository.delete(id);

    return deletedNotification;
  }
}