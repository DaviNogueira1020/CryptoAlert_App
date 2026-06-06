import 'package:crypto_alert_backend/modules/notifications/notification_model.dart';

class NotificationsRepository {
  final List<AppNotification> _notifications = [];
  
  void create(AppNotification notification){
    _notifications.add(notification);
  }

  int _getNotificationIndex(String id){
    final index = _notifications.indexWhere((notification)=> notification.id == id);

    if(index == -1){
      throw Exception('Notification [ID: $id] not found');
    }

    return index;
  }

  List<AppNotification> findAll(){
    return List.unmodifiable(_notifications);
  }

  List<AppNotification> findUnread(){
    return _notifications.where((notification) => !notification.read).toList();
  }

  AppNotification markAsRead(String id){
    final index = _getNotificationIndex(id);

    if(!_notifications[index].read){
      final readNotification = _notifications[index].copyWith(read: true);

      _notifications[index] = readNotification;
    }
    
    return _notifications[index];
  }

  AppNotification delete(String id){
    final index = _getNotificationIndex(id);
    
    final deletedNotification = _notifications[index];

    _notifications.removeAt(index);

    return deletedNotification;
  }
}
