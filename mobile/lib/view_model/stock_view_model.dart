// lib/view_model/stock_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/data/repository_impl/stock_repository_impl.dart';
import 'package:mobile/data/services/stock_api.dart';
import 'package:mobile/domain/models/stock_model.dart';
import 'package:mobile/domain/repository/stock_repository.dart';
import 'package:mobile/core/utils/logger.dart';

// ==================== PROVIDERS ====================

/// Provider do HTTP Client
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Provider do StockApiService
final stockApiServiceProvider = Provider<StockApiService>((ref) {
  final client = ref.watch(httpClientProvider);
  return StockApiService(client);
});

/// Provider do StockRepository
final stockRepositoryProvider = Provider<StockRepository>((ref) {
  final apiService = ref.watch(stockApiServiceProvider);
  return StockRepositoryImpl(apiService);
});

/// Provider do StockViewModel
final stockViewModelProvider = StateNotifierProvider<StockViewModel, AsyncValue<List<StockModel>>>((ref) {
  final repository = ref.watch(stockRepositoryProvider);
  return StockViewModel(repository);
});

/// Provider para lista de alertas de estoque baixo
final lowStockAlertsProvider = StateNotifierProvider<LowStockAlertsNotifier, AsyncValue<List<StockModel>>>((ref) {
  final repository = ref.watch(stockRepositoryProvider);
  return LowStockAlertsNotifier(repository);
});

/// Provider para filtro de busca de peças
final stockSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider para filtro de categoria
final stockCategoryFilterProvider = StateProvider<String>((ref) => 'Todas');

// ==================== VIEW MODEL ====================

/// ViewModel para gerenciar o estado da lista de peças
class StockViewModel extends StateNotifier<AsyncValue<List<StockModel>>> {
  final StockRepository repository;

  StockViewModel(this.repository) : super(const AsyncValue.loading()) {
    loadParts();
  }

  /// Carrega todas as peças do estoque
  Future<void> loadParts() async {
    state = const AsyncValue.loading();
    try {
      final parts = await repository.fetchParts();
      state = AsyncValue.data(parts);
      appLogger.i('Peças carregadas com sucesso: ${parts.length} itens');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      appLogger.e('Erro ao carregar peças', error: e, stackTrace: st);
    }
  }

  /// Cria uma nova peça
  ///
  /// Retorna true se a operação foi bem-sucedida
  Future<bool> createPart({
    required String nome,
    required String categoria,
    required int qtd,
    required int qtdMin,
  }) async {
    try {
      final data = {
        'nome': nome,
        'categoria': categoria,
        'qtd': qtd,
        'qtd_min': qtdMin,
      };

      appLogger.i('Criando nova peça: $data');
      await repository.createPart(data);

      // Recarrega a lista após criar
      await loadParts();

      appLogger.i('Peça criada com sucesso');
      return true;
    } catch (e, st) {
      appLogger.e('Erro ao criar peça', error: e, stackTrace: st);
      return false;
    }
  }

  /// Atualiza uma peça existente
  ///
  /// Retorna true se a operação foi bem-sucedida
  Future<bool> updatePart({
    required int id,
    String? nome,
    String? categoria,
    int? qtd,
    int? qtdMin,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (nome != null) data['nome'] = nome;
      if (categoria != null) data['categoria'] = categoria;
      if (qtd != null) data['qtd'] = qtd;
      if (qtdMin != null) data['qtd_min'] = qtdMin;

      appLogger.i('Atualizando peça ID $id: $data');
      await repository.updatePart(id, data);

      // Recarrega a lista após atualizar
      await loadParts();

      appLogger.i('Peça atualizada com sucesso');
      return true;
    } catch (e, st) {
      appLogger.e('Erro ao atualizar peça', error: e, stackTrace: st);
      return false;
    }
  }

  /// Exclui uma peça
  ///
  /// Retorna true se a operação foi bem-sucedida
  Future<bool> deletePart(int id) async {
    try {
      appLogger.i('Excluindo peça ID $id');
      await repository.deletePart(id);

      // Recarrega a lista após excluir
      await loadParts();

      appLogger.i('Peça excluída com sucesso');
      return true;
    } catch (e, st) {
      appLogger.e('Erro ao excluir peça', error: e, stackTrace: st);
      return false;
    }
  }

  /// Força o reload da lista
  void refresh() {
    loadParts();
  }
}

// ==================== ALERTAS DE ESTOQUE BAIXO ====================

/// Notifier para gerenciar alertas de estoque baixo
class LowStockAlertsNotifier extends StateNotifier<AsyncValue<List<StockModel>>> {
  final StockRepository repository;

  LowStockAlertsNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadAlerts();
  }

  /// Carrega peças com estoque abaixo do mínimo
  Future<void> loadAlerts() async {
    state = const AsyncValue.loading();
    try {
      final alerts = await repository.fetchLowStockAlerts();
      state = AsyncValue.data(alerts);
      appLogger.i('Alertas carregados: ${alerts.length} peças com estoque baixo');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      appLogger.e('Erro ao carregar alertas', error: e, stackTrace: st);
    }
  }

  /// Força o reload dos alertas
  void refresh() {
    loadAlerts();
  }
}
