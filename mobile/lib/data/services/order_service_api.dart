// lib/data/order_service_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/domain/models/order_service_model.dart';
import 'package:mobile/domain/models/stock_model.dart';
import 'package:mobile/domain/models/user_model.dart';


class OrderServiceApi {
  final http.Client client;
  final String baseUrl = 'https://projeto-aplicado.onrender.com';

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

  Future<OrderServiceModel> createOrder(Map<String, dynamic> data) async {
    final response = await client.post(
      Uri.parse('$baseUrl/ordemservico'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return OrderServiceModel.fromJson(jsonResponse);
    } else {
      final jsonError = jsonDecode(response.body);
      throw Exception(jsonError['erro'] ?? 'Falha ao criar ordem de serviço');
    }
  }
}
