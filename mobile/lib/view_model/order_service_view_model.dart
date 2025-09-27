import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/providers/providers.dart';
import 'package:mobile/data/repository_impl/order_service_repository_impl.dart';
import 'package:mobile/domain/models/order_service_model.dart';
import 'package:mobile/domain/models/stock_model.dart';
import 'package:mobile/domain/models/user_model.dart';

// Provedor para gerenciar a lista de usuários
final userListProvider = FutureProvider<List<UserModel>>((ref) {
  final repo = ref.read(orderServiceRepositoryProvider);
  return repo.getUsers();
});

// Provedor para gerenciar a lista de peças/equipamentos
final partListProvider = FutureProvider<List<StockModel>>((ref) {
  final repo = ref.read(orderServiceRepositoryProvider);
  return repo.getParts();
});

// A ViewModel (Notifier) agora aceita a implementação concreta no construtor
class OrderServiceNotifier
    extends StateNotifier<AsyncValue<OrderServiceModel?>> {
  final OrderServiceRepositoryImpl _repo;

  OrderServiceNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createOrder({
    required String tipo,
    required String setor,
    required String detalhes,
    required String status,
    required int solicitanteId,
    required String recorrencia,
    required DateTime data,
    int? equipamentoId,
    int? quantidade, // NOVO: Adicionado o parâmetro 'quantidade'
  }) async {
    state = const AsyncValue.loading();
    try {
      final newOrder = await _repo.createOrder(
        tipo: tipo,
        setor: setor,
        detalhes: detalhes,
        status: status,
        solicitanteId: solicitanteId,
        recorrencia: recorrencia,
        data: data,
        equipamentoId: equipamentoId,
        quantidade: quantidade, // NOVO: Passado o valor para o repositório
      );
      state = AsyncValue.data(newOrder);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final orderServiceNotifierProvider =
    StateNotifierProvider<OrderServiceNotifier, AsyncValue<OrderServiceModel?>>(
      (ref) {
        final concreteRepo =
            ref.watch(orderServiceRepositoryProvider)
                as OrderServiceRepositoryImpl;
        return OrderServiceNotifier(concreteRepo);
      },
    );
