// lib/data/services/notification_local_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/domain/models/notification_model.dart';
import 'package:mobile/core/utils/logger.dart';

/// Serviço para gerenciar notificações localmente usando SharedPreferences
class NotificationLocalService {
  static const String _notificationsKey = 'app_notifications';
  static const int _maxNotifications = 50; // Limitar a 50 notificações

  final SharedPreferences prefs;

  NotificationLocalService(this.prefs);

  /// Carrega todas as notificações armazenadas
  Future<List<NotificationModel>> loadNotifications() async {
    try {
      final jsonString = prefs.getString(_notificationsKey);

      if (jsonString == null || jsonString.isEmpty) {
        appLogger.d('Nenhuma notificação armazenada');
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final notifications = jsonList
          .map((json) => NotificationModel.fromJson(json))
          .toList();

      // Ordenar por timestamp (mais recente primeiro)
      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      appLogger.i('${notifications.length} notificações carregadas');
      return notifications;
    } catch (e, st) {
      appLogger.e('Erro ao carregar notificações', error: e, stackTrace: st);
      return [];
    }
  }

  /// Salva uma nova notificação
  Future<bool> saveNotification(NotificationModel notification) async {
    try {
      final notifications = await loadNotifications();

      // Adicionar no início da lista
      notifications.insert(0, notification);

      // Limitar ao máximo de notificações
      if (notifications.length > _maxNotifications) {
        notifications.removeRange(_maxNotifications, notifications.length);
        appLogger.d('Notificações antigas removidas (limite: $_maxNotifications)');
      }

      await _saveAll(notifications);
      appLogger.i('Notificação salva: ${notification.title}');
      return true;
    } catch (e, st) {
      appLogger.e('Erro ao salvar notificação', error: e, stackTrace: st);
      return false;
    }
  }

  /// Marca uma notificação como lida
  Future<bool> markAsRead(String notificationId) async {
    try {
      final notifications = await loadNotifications();
      final index = notifications.indexWhere((n) => n.id == notificationId);

      if (index == -1) {
        appLogger.w('Notificação não encontrada: $notificationId');
        return false;
      }

      notifications[index] = notifications[index].copyWith(isRead: true);
      await _saveAll(notifications);

      appLogger.i('Notificação marcada como lida: $notificationId');
      return true;
    } catch (e, st) {
      appLogger.e('Erro ao marcar notificação como lida', error: e, stackTrace: st);
      return false;
    }
  }

  /// Marca todas as notificações como lidas
  Future<bool> markAllAsRead() async {
    try {
      final notifications = await loadNotifications();
      final updatedNotifications = notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();

      await _saveAll(updatedNotifications);
      appLogger.i('Todas as notificações marcadas como lidas');
      return true;
    } catch (e, st) {
      appLogger.e('Erro ao marcar todas como lidas', error: e, stackTrace: st);
      return false;
    }
  }

  /// Exclui uma notificação específica
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final notifications = await loadNotifications();
      notifications.removeWhere((n) => n.id == notificationId);

      await _saveAll(notifications);
      appLogger.i('Notificação excluída: $notificationId');
      return true;
    } catch (e, st) {
      appLogger.e('Erro ao excluir notificação', error: e, stackTrace: st);
      return false;
    }
  }

  /// Limpa todas as notificações
  Future<bool> clearAll() async {
    try {
      await prefs.remove(_notificationsKey);
      appLogger.i('Todas as notificações foram limpas');
      return true;
    } catch (e, st) {
      appLogger.e('Erro ao limpar notificações', error: e, stackTrace: st);
      return false;
    }
  }

  /// Conta quantas notificações não lidas existem
  Future<int> countUnread() async {
    try {
      final notifications = await loadNotifications();
      return notifications.where((n) => !n.isRead).length;
    } catch (e) {
      appLogger.e('Erro ao contar não lidas', error: e);
      return 0;
    }
  }

  /// Salva todas as notificações
  Future<void> _saveAll(List<NotificationModel> notifications) async {
    final jsonList = notifications.map((n) => n.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_notificationsKey, jsonString);
  }
}
