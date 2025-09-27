// lib/data/auth_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/core/utils/logger.dart';
import 'package:mobile/domain/models/user_model.dart';


/// Serviço que lida diretamente com as chamadas de API de autenticação.
class AuthApiService {
  final http.Client client;
  // A URL base confirmada do Render
  final String baseUrl = 'https://projeto-aplicado.onrender.com';

  AuthApiService(this.client);

  /// Envia as credenciais para o endpoint /login.
  Future<UserModel> postLogin({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({'usuario': email, 'senha': password});

    // Logging: Dados enviados para a API
    appLogger.i('POST Request to: $url');
    appLogger.d('Request Body: $body');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      // O backend Flask espera 'email' e 'senha' no corpo da requisição
      body: body,
    );

    // Logging: Resposta da API
    appLogger.i('Response Status Code: ${response.statusCode}');
    appLogger.d('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Sucesso: Retorna o UserModel
      final jsonResponse = jsonDecode(response.body);
      return UserModel.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      // Erro de credenciais (ou outro erro de autenticação)
      final jsonError = jsonDecode(response.body);
      // Extrai a mensagem de erro da resposta do Flask (ex: {"erro": "Usuário não encontrado"})
      throw Exception(jsonError['erro'] ?? 'Credenciais inválidas.');
    } else {
      // Outros erros de servidor
      throw Exception('Falha no login. Status: ${response.statusCode}');
    }
  }
}
