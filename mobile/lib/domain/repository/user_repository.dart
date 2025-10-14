// lib/domain/repository/user_repository.dart

import 'package:mobile/domain/models/user_model.dart';

/// Interface que define as operações de gestão de usuários
/// Seguindo o padrão Repository para desacoplar a lógica de negócio da camada de dados
abstract class UserRepository {
  /// Busca todos os usuários do sistema
  Future<List<UserModel>> fetchUsers();

  /// Cria um novo usuário
  ///
  /// [data] deve conter:
  /// - nome: String
  /// - email: String (único)
  /// - funcao: String
  /// - setor: String
  /// - senha: String
  Future<UserModel> createUser(Map<String, dynamic> data);

  /// Atualiza um usuário existente
  ///
  /// [id] - ID do usuário a ser atualizado
  /// [data] - Campos a serem atualizados
  Future<void> updateUser(int id, Map<String, dynamic> data);

  /// Exclui um usuário do sistema
  ///
  /// [id] - ID do usuário a ser excluído
  Future<void> deleteUser(int id);
}
