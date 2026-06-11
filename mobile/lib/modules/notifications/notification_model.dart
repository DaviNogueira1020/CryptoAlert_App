  import 'package:postgres/postgres.dart';

class AppNotification{
  final String id;
  final String alertId;
  final String title;
  final String message;
  final bool read;
  final DateTime? createdAt;  //PostgreSQL creates the datestamp

  AppNotification({
    required this.id,
    required this.alertId,
    required this.title,
    required this.message,
    this.createdAt,         
    this.read = false,
  });

  factory AppNotification.fromRow(ResultRow row){
    return AppNotification(
      id: row[0]! as String,
      alertId: row[1]! as String,
      title: row[2]! as String,
      message: row[3]! as String,
      read: row[4]! as bool,      
      createdAt: row[5]! as DateTime
    );
  }
  
  AppNotification copyWith({
    String? title,
    String? message,
    bool? read,
  }){
    return AppNotification(
      id: id,
      alertId: alertId,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
      createdAt: createdAt
    );
  }
}