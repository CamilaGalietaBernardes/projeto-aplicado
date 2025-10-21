// lib/data/services/stock_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/utils/logger.dart';
import '../../domain/models/stock_model.dart';

/// Serviço que lida diretamente com as chamadas de API de estoque
class StockApiService {
  final http.Client client;
  final String baseUrl = 'http://localhost:5000';

  StockApiService(this.client);

  /// GET /peca - Lista todas as peças do estoque
  Future<List<StockModel>> fetchParts() async {
    final url = Uri.parse('$baseUrl/peca');

    appLogger.i('GET Request to: $url');

    final response = await client.get(url);

    appLogger.i('Response Status Code: ${response.statusCode}');
    appLogger.d('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => StockModel.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao buscar peças. Status: ${response.statusCode}');
    }
  }

  /// POST /peca - Cadastra uma nova peça
  Future<StockModel> createPart(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/peca');
    final body = jsonEncode(data);

    appLogger.i('POST Request to: $url');
    appLogger.d('Request Body: $body');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    appLogger.i('Response Status Code: ${response.statusCode}');
    appLogger.d('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return StockModel.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      final jsonError = jsonDecode(response.body);
      throw Exception(jsonError['erro'] ?? 'Dados inválidos');
    } else {
      throw Exception('Falha ao cadastrar peça. Status: ${response.statusCode}');
    }
  }

  /// PUT /peca/`<id>` - Atualiza uma peça existente
  Future<void> updatePart(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/peca/$id');
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
      throw Exception('Peça não encontrada');
    } else {
      final jsonError = jsonDecode(response.body);
      throw Exception(jsonError['erro'] ?? 'Falha ao atualizar peça');
    }
  }

  /// DELETE /peca/`<id>` - Exclui uma peça
  Future<void> deletePart(int id) async {
    final url = Uri.parse('$baseUrl/peca/$id');

    appLogger.i('DELETE Request to: $url');

    final response = await client.delete(url);

    appLogger.i('Response Status Code: ${response.statusCode}');
    appLogger.d('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Peça não encontrada');
    } else {
      final jsonError = jsonDecode(response.body);
      throw Exception(jsonError['erro'] ?? 'Falha ao excluir peça');
    }
  }

  /// GET /estoque/alertas - Busca peças com estoque baixo
  Future<List<StockModel>> fetchLowStockAlerts() async {
    final url = Uri.parse('$baseUrl/estoque/alertas');

    appLogger.i('GET Request to: $url');

    final response = await client.get(url);

    appLogger.i('Response Status Code: ${response.statusCode}');
    appLogger.d('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => StockModel.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao buscar alertas. Status: ${response.statusCode}');
    }
  }
}
