// lib/data/services/user_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/utils/logger.dart';
import '../../domain/models/user_model.dart';

/// Serviço que lida diretamente com as chamadas de API de usuários
class UserApiService {
  final http.Client client;
  final String baseUrl = 'https://projeto-aplicado.onrender.com';

  UserApiService(this.client);

  /// GET /usuarios - Lista todos os usuários
  Future<List<UserModel>> fetchUsers() async {
    final url = Uri.parse('$baseUrl/usuarios');

    appLogger.i('GET Request to: $url');

    final response = await client.get(url);

    appLogger.i('Response Status Code: ${response.statusCode}');
    appLogger.d('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao buscar usuários. Status: ${response.statusCode}');
    }
  }

  /// POST /usuarios - Cadastra um novo usuário
  Future<UserModel> createUser(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/usuarios');
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
      return UserModel.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      final jsonError = jsonDecode(response.body);
      throw Exception(jsonError['erro'] ?? 'Dados inválidos');
    } else {
      throw Exception('Falha ao cadastrar usuário. Status: ${response.statusCode}');
    }
  }

  /// PUT /usuarios/`<id>` - Atualiza um usuário existente
  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/usuarios/$id');
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
      throw Exception('Usuário não encontrado');
    } else {
      final jsonError = jsonDecode(response.body);
      throw Exception(jsonError['erro'] ?? 'Falha ao atualizar usuário');
    }
  }

  /// DELETE /usuarios/`<id>` - Exclui um usuário
  Future<void> deleteUser(int id) async {
    final url = Uri.parse('$baseUrl/usuarios/$id');

    appLogger.i('DELETE Request to: $url');

    final response = await client.delete(url);

    appLogger.i('Response Status Code: ${response.statusCode}');
    appLogger.d('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Usuário não encontrado');
    } else {
      final jsonError = jsonDecode(response.body);
      throw Exception(jsonError['erro'] ?? 'Falha ao excluir usuário');
    }
  }
}
