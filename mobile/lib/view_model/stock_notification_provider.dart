// lib/view_model/stock_notification_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/domain/models/notification_model.dart';
import 'package:mobile/domain/models/stock_model.dart';
import 'package:mobile/view_model/notification_view_model.dart';
import 'package:mobile/view_model/stock_view_model.dart';
import 'package:mobile/core/utils/logger.dart';

/// Provider que monitora alertas de estoque e dispara notificações
final stockNotificationMonitorProvider = Provider<StockNotificationMonitor>((ref) {
  return StockNotificationMonitor(ref);
});

/// Monitor de notificações de estoque
class StockNotificationMonitor {
  final Ref ref;

  // Cache para evitar notificações duplicadas
  final Set<int> _notifiedParts = {};

  StockNotificationMonitor(this.ref) {
    _startMonitoring();
  }

  /// Inicia o monitoramento de alertas de estoque
  void _startMonitoring() {
    // Observa mudanças nos alertas de estoque
    ref.listen<AsyncValue<List<StockModel>>>(
      lowStockAlertsProvider,
      (previous, next) {
        next.whenData((alerts) {
          _checkAndNotify(alerts);
        });
      },
    );
  }

  /// Verifica alertas e dispara notificações
  Future<void> _checkAndNotify(List<StockModel> alerts) async {
    if (alerts.isEmpty) {
      appLogger.d('Nenhum alerta de estoque');
      return;
    }

    appLogger.i('Verificando ${alerts.length} alertas de estoque');

    for (final part in alerts) {
      // Evita notificar a mesma peça múltiplas vezes
      if (!_notifiedParts.contains(part.id)) {
        await _notifyLowStock(part);
        _notifiedParts.add(part.id);
      }
    }

    // Remove do cache peças que não estão mais em alerta
    final alertIds = alerts.map((p) => p.id).toSet();
    _notifiedParts.removeWhere((id) => !alertIds.contains(id));
  }

  /// Dispara notificação de estoque baixo
  Future<void> _notifyLowStock(StockModel part) async {
    try {
      await ref.read(notificationViewModelProvider.notifier).addNotification(
            title: 'Estoque Baixo: ${part.peca}',
            message:
                'A peça está com ${part.qtd} unidades (mínimo: ${part.qtdMin}). Necessário reabastecer!',
            type: NotificationType.warning,
          );

      // Invalida o contador de não lidas para atualizar o badge
      ref.invalidate(unreadNotificationCountProvider);

      appLogger.i('Notificação de estoque baixo enviada para: ${part.peca}');
    } catch (e, st) {
      appLogger.e('Erro ao enviar notificação de estoque', error: e, stackTrace: st);
    }
  }

  /// Força verificação manual de alertas
  Future<void> checkNow() async {
    final alertsAsync = ref.read(lowStockAlertsProvider);
    alertsAsync.whenData((alerts) => _checkAndNotify(alerts));
  }

  /// Limpa o cache de notificações
  void clearCache() {
    _notifiedParts.clear();
    appLogger.i('Cache de notificações de estoque limpo');
  }
}
