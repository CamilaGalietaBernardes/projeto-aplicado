// lib/data/services/order_service_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/utils/logger.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/stock_model.dart';
import '../../domain/models/order_service_model.dart';

class OrderServiceApi {
  final http.Client client;
  final String baseUrl = 'http://localhost:6000';

  OrderServiceApi(this.client);

  Future<List<UserModel>> fetchUsers() async {
    final response = await client.get(Uri.parse('$baseUrl/usuarios'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao buscar usuários');
    }
  }

  Future<List<StockModel>> fetchParts() async {
    final response = await client.get(Uri.parse('$baseUrl/peca'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => StockModel.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao buscar peças');
    }
  }

  Future<List<OrderServiceModel>> fetchOrders() async {
    final response = await client.get(Uri.parse('$baseUrl/ordemservico'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => OrderServiceModel.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao buscar ordens de serviço');
    }
  }

  Future<OrderServiceModel> createOrder(Map<String, dynamic> data) async {
    final response = await client.post(
      Uri.parse('$baseUrl/ordemservico'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    appLogger.i('Resposta da API para /ordemservico');
    appLogger.d('Status da Resposta: ${response.statusCode}');
    appLogger.d('Corpo da Resposta: ${response.body}');

    if (response.statusCode == 201) {
      try {
        final jsonResponse = jsonDecode(response.body);
        return OrderServiceModel.fromJson(jsonResponse);
      } catch (e, st) {
        appLogger.e(
          'Erro de desserialização da resposta JSON:',
          error: e,
          stackTrace: st,
        );
        throw Exception('Erro ao processar dados da Ordem de Serviço');
      }
    } else {
      final jsonError = jsonDecode(response.body);
      throw Exception(jsonError['erro'] ?? 'Falha ao criar ordem de serviço');
    }
  }

  /// PUT /ordemservico/`<id>` - Atualiza uma ordem de serviço
  Future<void> updateOrder(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/ordemservico/$id');
    final body = jsonEncode(data);

    appLogger.i('PUT Request to: $url');
    appLogger.d('Request Body: $body');

    final response = await client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    appLogger.i('Response Status Code: ${response.statusCode}');
    appLogger.d('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Ordem não encontrada');
    } else {
      final jsonError = jsonDecode(response.body);
      throw Exception(jsonError['erro'] ?? 'Falha ao atualizar ordem');
    }
  }

  /// DELETE /ordemservico/`<id>` - Exclui uma ordem de serviço
  Future<void> deleteOrder(int id) async {
    final url = Uri.parse('$baseUrl/ordemservico/$id');

    appLogger.i('DELETE Request to: $url');

    final response = await client.delete(url);

    appLogger.i('Response Status Code: ${response.statusCode}');
    appLogger.d('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Ordem não encontrada');
    } else {
      final jsonError = jsonDecode(response.body);
      throw Exception(jsonError['erro'] ?? 'Falha ao excluir ordem');
    }
  }
}
