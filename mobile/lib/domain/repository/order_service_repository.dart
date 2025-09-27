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
    int? equipamentoId, // Este já existia
    int? quantidade, // NOVO: Adicionado 'quantidade'
  });

  Future<List<UserModel>> getUsers();
  Future<List<StockModel>> getParts();
  // NOVO: Adicionamos o método ao contrato
  Future<List<OrderServiceModel>> getOrders(); 
}
