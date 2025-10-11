// lib/data/repository_impl/notification_repository_impl.dart

import 'package:mobile/data/services/notification_local_service.dart';
import 'package:mobile/domain/models/notification_model.dart';
import 'package:mobile/domain/repository/notification_repository.dart';

/// Implementação concreta do NotificationRepository
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalService localService;

  NotificationRepositoryImpl(this.localService);

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    return await localService.loadNotifications();
  }

  @override
  Future<bool> addNotification(NotificationModel notification) async {
    return await localService.saveNotification(notification);
  }

  @override
  Future<bool> markAsRead(String notificationId) async {
    return await localService.markAsRead(notificationId);
  }

  @override
  Future<bool> markAllAsRead() async {
    return await localService.markAllAsRead();
  }

  @override
  Future<bool> deleteNotification(String notificationId) async {
    return await localService.deleteNotification(notificationId);
  }

  @override
  Future<bool> clearAll() async {
    return await localService.clearAll();
  }

  @override
  Future<int> countUnread() async {
    return await localService.countUnread();
  }
}
