// lib/data/repository_impl/order_service_repository_impl.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/utils/logger.dart';
import 'package:mobile/data/services/order_service_api.dart';
import 'package:mobile/domain/models/order_service_model.dart';
import 'package:mobile/domain/models/stock_model.dart';
import 'package:mobile/domain/models/user_model.dart';
import 'package:mobile/domain/repository/order_service_repository.dart';

class OrderServiceRepositoryImpl implements OrderServiceRepository {
  final OrderServiceApi _api;

  OrderServiceRepositoryImpl(this._api);

  @override
  Future<List<UserModel>> getUsers() async {
    return _api.fetchUsers();
  }

  @override
  Future<List<StockModel>> getParts() async {
    return _api.fetchParts();
  }

  @override
  Future<List<OrderServiceModel>> getOrders() async {
    return _api.fetchOrders();
  }

  @override
  Future<OrderServiceModel> createOrder({
    required String tipo,
    required String setor,
    required String detalhes,
    required String status,
    required String recorrencia,
    required DateTime data,
    required int solicitanteId,
    int? equipamentoId,
    int? quantidade,
  }) async {
    List<Map<String, dynamic>> pecasUtilizadas = [];
    if (equipamentoId != null && quantidade != null && quantidade > 0) {
      pecasUtilizadas.add({"peca_id": equipamentoId, "quantidade": quantidade});
    }

    final Map<String, dynamic> dataMap = {
      'tipo': tipo,
      'setor': setor,
      'detalhes': detalhes,
      'status': status,
      'solicitante_id': solicitanteId,
      'data': data.toIso8601String(),
      'recorrencia': recorrencia,
      'equipamento_id': equipamentoId,
      'pecas_utilizadas': pecasUtilizadas,
    };

    appLogger.i('Criando Ordem de Serviço...');
    appLogger.d('Payload enviado para a API: ${jsonEncode(dataMap)}');

    return _api.createOrder(dataMap);
  }

  @override
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
  }) async {
    final Map<String, dynamic> dataMap = {};

    if (tipo != null) dataMap['tipo'] = tipo;
    if (setor != null) dataMap['setor'] = setor;
    if (detalhes != null) dataMap['detalhes'] = detalhes;
    if (status != null) dataMap['status'] = status;
    if (solicitanteId != null) dataMap['solicitante_id'] = solicitanteId;
    if (recorrencia != null) dataMap['recorrencia'] = recorrencia;
    if (data != null) dataMap['data'] = data.toIso8601String();
    if (equipamentoId != null) dataMap['equipamento_id'] = equipamentoId;

    appLogger.i('Atualizando Ordem de Serviço ID: $id');
    appLogger.d('Payload enviado para a API: ${jsonEncode(dataMap)}');

    return _api.updateOrder(id, dataMap);
  }

  @override
  Future<void> deleteOrder(int id) async {
    appLogger.i('Excluindo Ordem de Serviço ID: $id');
    return _api.deleteOrder(id);
  }
}
