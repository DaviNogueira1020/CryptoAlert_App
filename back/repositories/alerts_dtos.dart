// alerts_dtos.dart
// DTOs, opções de listagem e classes de paginação do domínio de alertas.

import '../models/alert_model.dart';
import '../models/alert_type.dart';
import '../models/notification_model.dart';

// ─── Alert DTOs ───────────────────────────────────────────────────────────────

class CreateAlertDTO {
  final String symbol;
  final AlertType type;
  final double target;

  const CreateAlertDTO({
    required this.symbol,
    required this.type,
    required this.target,
  });
}

class UpdateAlertDTO {
  final String? symbol;
  final AlertType? type;
  final double? target;
  final bool? active;

  const UpdateAlertDTO({
    this.symbol,
    this.type,
    this.target,
    this.active,
  });
}

class ListAlertsOptions {
  final int page;
  final int limit;

  const ListAlertsOptions({this.page = 1, this.limit = 20})
      : assert(page >= 1),
        assert(limit >= 1 && limit <= 100);
}

class PaginatedAlerts {
  final List<AlertModel> items;
  final int total;
  final int page;
  final int limit;

  const PaginatedAlerts({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });
}

// ─── Notification DTOs ────────────────────────────────────────────────────────

/// Usado internamente pelo worker/job que detecta disparos de alerta.
class CreateNotificationDTO {
  final String userId;
  final String? alertId;
  final String message;

  const CreateNotificationDTO({
    required this.userId,
    this.alertId,
    required this.message,
  });
}

class ListNotificationsOptions {
  final int page;
  final int limit;
  final bool? onlyUnread;

  const ListNotificationsOptions({
    this.page = 1,
    this.limit = 20,
    this.onlyUnread,
  });
}

class PaginatedNotifications {
  final List<NotificationModel> items;
  final int total;
  final int page;
  final int limit;

  const PaginatedNotifications({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });
}
