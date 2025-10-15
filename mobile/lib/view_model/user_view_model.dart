// lib/view_model/user_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/data/repository_impl/user_repository_impl.dart';
import 'package:mobile/data/services/user_api.dart';
import 'package:mobile/domain/models/user_model.dart';
import 'package:mobile/domain/models/notification_model.dart';
import 'package:mobile/domain/repository/user_repository.dart';
import 'package:mobile/view_model/notification_view_model.dart';
import 'package:mobile/core/utils/logger.dart';

// ==================== PROVIDERS ====================

/// Provider do UserApiService
final userApiServiceProvider = Provider<UserApiService>((ref) {
  final client = http.Client();
  return UserApiService(client);
});

/// Provider do UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = ref.watch(userApiServiceProvider);
  return UserRepositoryImpl(apiService);
});

/// Provider do UserViewModel
final userViewModelProvider = StateNotifierProvider<UserViewModel, AsyncValue<List<UserModel>>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserViewModel(repository, ref);
});

/// Provider para filtro de busca de usuários
final userSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider para filtro de setor
final userSetorFilterProvider = StateProvider<String>((ref) => 'Todos');

// ==================== VIEW MODEL ====================

/// ViewModel para gerenciar o estado da lista de usuários
class UserViewModel extends StateNotifier<AsyncValue<List<UserModel>>> {
  final UserRepository repository;
  final Ref ref;

  UserViewModel(this.repository, this.ref) : super(const AsyncValue.loading()) {
    loadUsers();
  }

  /// Carrega todos os usuários do sistema
  Future<void> loadUsers() async {
    state = const AsyncValue.loading();
    try {
      final users = await repository.fetchUsers();
      state = AsyncValue.data(users);
      appLogger.i('Usuários carregados com sucesso: ${users.length} itens');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      appLogger.e('Erro ao carregar usuários', error: e, stackTrace: st);
    }
  }

  /// Cria um novo usuário
  ///
  /// Retorna true se a operação foi bem-sucedida
  Future<bool> createUser({
    required String nome,
    required String email,
    required String funcao,
    required String setor,
    required String senha,
  }) async {
    try {
      final data = {
        'nome': nome,
        'email': email,
        'funcao': funcao,
        'setor': setor,
        'senha': senha,
      };

      appLogger.i('Criando novo usuário: $data');
      await repository.createUser(data);

      // Recarrega a lista após criar
      await loadUsers();

      // Dispara notificação de sucesso
      await ref.read(notificationViewModelProvider.notifier).addNotification(
            title: 'Usuário Criado',
            message: 'O usuário $nome foi criado com sucesso!',
            type: NotificationType.success,
          );
      ref.invalidate(unreadNotificationCountProvider);

      appLogger.i('Usuário criado com sucesso');
      return true;
    } catch (e, st) {
      // Dispara notificação de erro
      await ref.read(notificationViewModelProvider.notifier).addNotification(
            title: 'Erro ao Criar Usuário',
            message: 'Não foi possível criar o usuário. Tente novamente.',
            type: NotificationType.error,
          );
      ref.invalidate(unreadNotificationCountProvider);

      appLogger.e('Erro ao criar usuário', error: e, stackTrace: st);
      return false;
    }
  }

  /// Atualiza um usuário existente
  ///
  /// Retorna true se a operação foi bem-sucedida
  Future<bool> updateUser({
    required int id,
    String? nome,
    String? email,
    String? funcao,
    String? setor,
    String? senha,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (nome != null) data['nome'] = nome;
      if (email != null) data['email'] = email;
      if (funcao != null) data['funcao'] = funcao;
      if (setor != null) data['setor'] = setor;
      if (senha != null) data['senha'] = senha;

      appLogger.i('Atualizando usuário ID $id: $data');
      await repository.updateUser(id, data);

      // Recarrega a lista após atualizar
      await loadUsers();

      // Dispara notificação de sucesso
      await ref.read(notificationViewModelProvider.notifier).addNotification(
            title: 'Usuário Atualizado',
            message: 'As informações foram atualizadas com sucesso!',
            type: NotificationType.success,
          );
      ref.invalidate(unreadNotificationCountProvider);

      appLogger.i('Usuário atualizado com sucesso');
      return true;
    } catch (e, st) {
      // Dispara notificação de erro
      await ref.read(notificationViewModelProvider.notifier).addNotification(
            title: 'Erro ao Atualizar',
            message: 'Não foi possível atualizar o usuário.',
            type: NotificationType.error,
          );
      ref.invalidate(unreadNotificationCountProvider);

      appLogger.e('Erro ao atualizar usuário', error: e, stackTrace: st);
      return false;
    }
  }

  /// Exclui um usuário
  ///
  /// Retorna true se a operação foi bem-sucedida
  Future<bool> deleteUser(int id) async {
    try {
      appLogger.i('Excluindo usuário ID $id');
      await repository.deleteUser(id);

      // Recarrega a lista após excluir
      await loadUsers();

      // Dispara notificação de sucesso
      await ref.read(notificationViewModelProvider.notifier).addNotification(
            title: 'Usuário Excluído',
            message: 'O usuário foi removido do sistema.',
            type: NotificationType.success,
          );
      ref.invalidate(unreadNotificationCountProvider);

      appLogger.i('Usuário excluído com sucesso');
      return true;
    } catch (e, st) {
      // Dispara notificação de erro
      await ref.read(notificationViewModelProvider.notifier).addNotification(
            title: 'Erro ao Excluir',
            message: 'Não foi possível excluir o usuário.',
            type: NotificationType.error,
          );
      ref.invalidate(unreadNotificationCountProvider);

      appLogger.e('Erro ao excluir usuário', error: e, stackTrace: st);
      return false;
    }
  }

  /// Força o reload da lista
  void refresh() {
    loadUsers();
  }
}
