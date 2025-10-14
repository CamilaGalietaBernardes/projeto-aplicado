// lib/core/providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/core/providers/session_provider.dart';
import 'package:mobile/data/repository_impl/auth_repository_impl.dart';
import 'package:mobile/data/repository_impl/order_service_repository_impl.dart';
import 'package:mobile/data/services/auth_api.dart';
import 'package:mobile/data/services/order_service_api.dart';
import 'package:mobile/domain/repository/auth_repository.dart';
import 'package:mobile/domain/models/user_model.dart';
import 'package:mobile/domain/repository/order_service_repository.dart';
import 'package:mobile/view_model/login_view_model.dart';


// 1. Provider para a ferramenta HTTP (usado para isolar a dependência)
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// 2. Provider da Camada Data (Serviço de API)
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final client = ref.watch(httpClientProvider);
  return AuthApiService(client);
});

// 3. Provider da Camada Domain (Repositório)
// É usado para injetar a implementação concreta na ViewModel
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(authApiServiceProvider);
  return AuthRepositoryImpl(apiService);
});

// 4. Provider da Camada ViewModel
final loginViewModelProvider =
    AutoDisposeAsyncNotifierProvider<LoginViewModel, UserModel?>(
      LoginViewModel.new,
    );




final sessionProvider = StateNotifierProvider<SessionNotifier, UserModel?>((
  ref,
) {
  return SessionNotifier();
});


// NOVO: Provedores da Camada de Ordem de Serviço
final orderServiceApiProvider = Provider<OrderServiceApi>((ref) {
  final client = ref.watch(httpClientProvider);
  return OrderServiceApi(client);
});

final orderServiceRepositoryProvider = Provider<OrderServiceRepository>((ref) {
  final api = ref.watch(orderServiceApiProvider);
  return OrderServiceRepositoryImpl(api);
});
