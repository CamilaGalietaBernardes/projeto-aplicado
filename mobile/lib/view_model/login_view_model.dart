// lib/view_model/login_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/providers/providers.dart';
import 'package:mobile/domain/repository/auth_repository.dart';
import '../domain/models/user_model.dart';

/// [LoginViewModel] gerencia o estado de autenticação.
/// O estado (State) será um AsyncValue<UserModel?>:
/// - data(user): Sucesso no login.
/// - data(null): Deslogado.
/// - loading: Em andamento.
/// - error: Erro.
class LoginViewModel extends AutoDisposeAsyncNotifier<UserModel?> {
  late final AuthRepository _authRepository;

  @override
  UserModel? build() {
    // Inicializa o repositório usando o provider definido em core/providers.dart
    _authRepository = ref.read(authRepositoryProvider);
    return null; // Estado inicial: nenhum usuário logado
  }

  Future<void> signIn(String email, String password) async {
    // 1. Define o estado como carregando para atualizar a UI
    state = const AsyncValue.loading();

    try {
      // 2. Chama o método de login do repositório
      final UserModel user = await _authRepository.signIn(
        email: email,
        password: password,
      );

      // NOVO: Use o novo sessionProvider para atualizar e persistir a sessão
      await ref.read(sessionProvider.notifier).updateSessionWithUserModel(user);

      // 4. Define o estado como sucesso com os dados do usuário
      state = AsyncValue.data(user);
    } catch (e, st) {
      // 5. Define o estado como erro para exibir a mensagem na UI
      state = AsyncValue.error(e, st);
    }
  }

  /// Limpa a sessão do usuário.
  Future<void> signOut() async {
    // NOVO: Use o sessionProvider para limpar os dados da sessão
    await ref.read(sessionProvider.notifier).clearSession();
    state = const AsyncValue.data(null);
  }
}
