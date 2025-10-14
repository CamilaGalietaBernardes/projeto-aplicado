// lib/data/auth_repository_impl.dart
import 'package:mobile/data/services/auth_api.dart';
import 'package:mobile/domain/repository/auth_repository.dart';
import 'package:mobile/domain/models/user_model.dart';

/// Implementação do AuthRepository, usando o serviço de API.
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<UserModel> signIn({required String email, required String password}) {
    // Delega a chamada para o serviço de API
    return _apiService.postLogin(email: email, password: password);
  }
}
