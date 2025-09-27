

import 'package:mobile/domain/models/user_model.dart';

/// Contrato (interface) para o Repositório de Autenticação.
/// Define o que a camada de domínio espera da camada de dados.
abstract class AuthRepository {
  Future<UserModel> signIn({required String email, required String password});
}
