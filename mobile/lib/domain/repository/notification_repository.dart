// lib/domain/repository/notification_repository.dart

import 'package:mobile/domain/models/notification_model.dart';

/// Interface que define as operações de notificações
abstract class NotificationRepository {
  /// Busca todas as notificações
  Future<List<NotificationModel>> fetchNotifications();

  /// Adiciona uma nova notificação
  Future<bool> addNotification(NotificationModel notification);

  /// Marca uma notificação como lida
  Future<bool> markAsRead(String notificationId);

  /// Marca todas as notificações como lidas
  Future<bool> markAllAsRead();

  /// Exclui uma notificação específica
  Future<bool> deleteNotification(String notificationId);

  /// Limpa todas as notificações
  Future<bool> clearAll();

  /// Conta quantas notificações não lidas existem
  Future<int> countUnread();
}
