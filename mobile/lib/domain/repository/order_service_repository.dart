import 'package:mobile/domain/models/order_service_model.dart';
import 'package:mobile/domain/models/stock_model.dart';
import 'package:mobile/domain/models/user_model.dart';

abstract class OrderServiceRepository {
  Future<OrderServiceModel> createOrder({
    required String tipo,
    required String setor,
    required String detalhes,
    required String status,
    required int solicitanteId,
    required String recorrencia,
    required DateTime data,
    int? equipamentoId,
    int? quantidade,
  });

  Future<void> updateOrder({
    required int id,
    String? tipo,
    String? setor,
    String? detalhes,
    String? status,
    int? solicitanteId,
    String? recorrencia,
    DateTime? data,
    int? equipamentoId,
  });

  Future<void> deleteOrder(int id);

  Future<List<UserModel>> getUsers();
  Future<List<StockModel>> getParts();
  Future<List<OrderServiceModel>> getOrders();
}
