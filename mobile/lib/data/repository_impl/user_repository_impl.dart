// lib/data/repository_impl/user_repository_impl.dart

import 'package:mobile/data/services/user_api.dart';
import 'package:mobile/domain/models/user_model.dart';
import 'package:mobile/domain/repository/user_repository.dart';

/// Implementação concreta do UserRepository
/// Delega as chamadas para o UserApiService
class UserRepositoryImpl implements UserRepository {
  final UserApiService apiService;

  UserRepositoryImpl(this.apiService);

  @override
  Future<List<UserModel>> fetchUsers() async {
    return await apiService.fetchUsers();
  }

  @override
  Future<UserModel> createUser(Map<String, dynamic> data) async {
    return await apiService.createUser(data);
  }

  @override
  Future<void> updateUser(int id, Map<String, dynamic> data) async {
    await apiService.updateUser(id, data);
  }

  @override
  Future<void> deleteUser(int id) async {
    await apiService.deleteUser(id);
  }
}
