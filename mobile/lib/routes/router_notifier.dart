import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// O caminho abaixo deve estar correto no seu projeto
import 'package:mobile/core/providers/providers.dart';

/// Gerencia a lógica de redirecionamento e notifica o GoRouter quando
/// o estado de autenticação muda (evitando o loop infinito).
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Escuta o provedor de sessão e notifica o GoRouter (via notifyListeners())
    // quando o estado de login muda (usuário logou ou deslogou).
    _ref.listen<Object?>(sessionProvider, (_, __) => notifyListeners());
  }

  /// Função de redirecionamento. É chamada sempre que o GoRouter precisa verificar
  /// o estado de autenticação ou quando o estado muda (via notifyListeners).
  String? redirect(GoRouterState state) {
    // Acessa o estado de sessão atual sem recriar o provedor do GoRouter
    final userSession = _ref.read(sessionProvider);
    final loggedIn = userSession != null;
    final loggingIn = state.uri.toString() == '/login';

    // Se NÃO estiver logado e NÃO estiver na tela de login, vá para o login.
    if (!loggedIn && !loggingIn) {
      return '/login';
    }

    // Se ESTIVER logado e ESTIVER tentando acessar a tela de login, vá para a home.
    if (loggedIn && loggingIn) {
      return '/home';
    }

    // Nenhuma alteração.
    return null;
  }
}

// Provedor que disponibiliza o RouterNotifier
final routerNotifierProvider = ChangeNotifierProvider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});
