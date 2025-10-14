// lib/view_model/notification_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/data/repository_impl/notification_repository_impl.dart';
import 'package:mobile/data/services/notification_local_service.dart';
import 'package:mobile/domain/models/notification_model.dart';
import 'package:mobile/domain/repository/notification_repository.dart';
import 'package:mobile/core/utils/logger.dart';

// ==================== PROVIDERS ====================

/// Provider do SharedPreferences
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider do NotificationLocalService
final notificationLocalServiceProvider = Provider<NotificationLocalService>((ref) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  return prefsAsync.when(
    data: (prefs) => NotificationLocalService(prefs),
    loading: () => throw Exception('SharedPreferences ainda não carregado'),
    error: (err, stack) => throw Exception('Erro ao carregar SharedPreferences: $err'),
  );
});

/// Provider do NotificationRepository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final localService = ref.watch(notificationLocalServiceProvider);
  return NotificationRepositoryImpl(localService);
});

/// Provider do NotificationViewModel
final notificationViewModelProvider = StateNotifierProvider<NotificationViewModel, AsyncValue<List<NotificationModel>>>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationViewModel(repository);
});

/// Provider para contar notificações não lidas
final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return await repository.countUnread();
});

// ==================== VIEW MODEL ====================

/// ViewModel para gerenciar o estado das notificações
class NotificationViewModel extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final NotificationRepository repository;

  NotificationViewModel(this.repository) : super(const AsyncValue.loading()) {
    loadNotifications();
  }

  /// Carrega todas as notificações
  Future<void> loadNotifications() async {
    state = const AsyncValue.loading();
    try {
      final notifications = await repository.fetchNotifications();
      state = AsyncValue.data(notifications);
      appLogger.i('Notificações carregadas: ${notifications.length} itens');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      appLogger.e('Erro ao carregar notificações', error: e, stackTrace: st);
    }
  }

  /// Adiciona uma nova notificação
  ///
  /// Esta é a função principal que deve ser chamada de outros ViewModels
  Future<bool> addNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) async {
    try {
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: message,
        type: type,
        timestamp: DateTime.now(),
        isRead: false,
      );

      appLogger.i('Adicionando notificação: $title');
      final success = await repository.addNotification(notification);

      if (success) {
        // Recarrega a lista após adicionar
        await loadNotifications();
        appLogger.i('Notificação adicionada com sucesso');
      }

      return success;
    } catch (e, st) {
      appLogger.e('Erro ao adicionar notificação', error: e, stackTrace: st);
      return false;
    }
  }

  /// Marca uma notificação como lida
  Future<bool> markAsRead(String notificationId) async {
    try {
      appLogger.i('Marcando notificação como lida: $notificationId');
      final success = await repository.markAsRead(notificationId);

      if (success) {
        await loadNotifications();
        appLogger.i('Notificação marcada como lida');
      }

      return success;
    } catch (e, st) {
      appLogger.e('Erro ao marcar como lida', error: e, stackTrace: st);
      return false;
    }
  }

  /// Marca todas as notificações como lidas
  Future<bool> markAllAsRead() async {
    try {
      appLogger.i('Marcando todas as notificações como lidas');
      final success = await repository.markAllAsRead();

      if (success) {
        await loadNotifications();
        appLogger.i('Todas marcadas como lidas');
      }

      return success;
    } catch (e, st) {
      appLogger.e('Erro ao marcar todas como lidas', error: e, stackTrace: st);
      return false;
    }
  }

  /// Exclui uma notificação
  Future<bool> deleteNotification(String notificationId) async {
    try {
      appLogger.i('Excluindo notificação: $notificationId');
      final success = await repository.deleteNotification(notificationId);

      if (success) {
        await loadNotifications();
        appLogger.i('Notificação excluída');
      }

      return success;
    } catch (e, st) {
      appLogger.e('Erro ao excluir notificação', error: e, stackTrace: st);
      return false;
    }
  }

  /// Limpa todas as notificações
  Future<bool> clearAll() async {
    try {
      appLogger.i('Limpando todas as notificações');
      final success = await repository.clearAll();

      if (success) {
        await loadNotifications();
        appLogger.i('Todas as notificações foram limpas');
      }

      return success;
    } catch (e, st) {
      appLogger.e('Erro ao limpar todas', error: e, stackTrace: st);
      return false;
    }
  }

  /// Força o reload da lista
  void refresh() {
    loadNotifications();
  }

  /// Retorna a contagem de não lidas
  Future<int> getUnreadCount() async {
    return await repository.countUnread();
  }
}

// ==================== HELPER FUNCTIONS ====================

/// Função auxiliar para adicionar notificações de qualquer lugar do app
Future<void> addNotification(
  WidgetRef ref, {
  required String title,
  required String message,
  required NotificationType type,
}) async {
  await ref.read(notificationViewModelProvider.notifier).addNotification(
        title: title,
        message: message,
        type: type,
      );

  // Força refresh do contador de não lidas
  ref.invalidate(unreadNotificationCountProvider);
}
