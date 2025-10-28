import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/login_view.dart';
import 'package:mobile/features/views/children/order_view.dart';
import 'package:mobile/features/views/children/homechild2_view.dart';
import 'package:mobile/features/views/children/homechild3_view.dart';
import 'package:mobile/features/views/children/setting_view.dart';
import 'package:mobile/features/views/children/stock_view.dart';
import 'package:mobile/features/views/children/stock_alerts_view.dart';
import 'package:mobile/features/views/children/user_list_view.dart';
import 'package:mobile/features/views/children/notifications_view.dart';
import 'package:mobile/features/views/children/reports_view.dart';
import 'package:mobile/features/views/home_view.dart';
import 'package:mobile/features/views/profile_view.dart';
import 'package:mobile/presentation/shared_widgets/scaffold_home.dart';
import 'package:mobile/routes/router_notifier.dart';

// Chaves globais para os navegadores, úteis para navegação aninhada ou global
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Provider para o GoRouter, para que possa ser acessado em qualquer lugar com Riverpod
final goRouterProvider = Provider<GoRouter>((ref) {
  // Observa o notifier, que contém a lógica de autenticação e avisa o GoRouter
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey, // Navegador raiz
    debugLogDiagnostics: true, // Útil para depuração durante o desenvolvimento
    // Ouve as mudanças do notifier (que escuta o sessionProvider)
    refreshListenable: notifier,

    // Usa a função de redirecionamento do notifier
    redirect: (context, state) => notifier.redirect(state),

    // A rota inicial é o que a tela principal "pensa" que é a rota inicial.
    // O redirect se encarrega de verificar o login antes.
    initialLocation: '/home',

    routes: [
      // Rota de nível superior para Login (não usa a ShellRoute)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),

      // ShellRoute para a navegação principal com IndexedStack
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldHome(navigationShell: navigationShell);
        },
        branches: [
          // A primeira rama do Shell (índice 0): Inicio
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeView(),
                // ¡Aqui é onde adicionamos as rotas aninhadas para os widgets filhos!
                routes: [
                  GoRoute(
                    path: 'childA', // A rota completa será /home/childA
                    name: 'homeChildA',
                    builder: (context, state) => const NewOrderView(),
                  ),
                  GoRoute(
                    path: 'childB', // A rota completa será /home/childB
                    name: 'homeChildB',
                    builder: (context, state) => const HomeChildBView(),
                  ),
                  GoRoute(
                    path: 'childC', // A rota completa será /home/childC
                    name: 'homeChildC',
                    builder: (context, state) => const HomeChildCView(),
                  ),
                ],
              ),
            ],
          ),
          // A segunda rama do Shell (índice 1): Estoque
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/stock',
                name: 'stock',
                builder: (context, state) => const StockView(),
                routes: [
                  GoRoute(
                    path: 'alerts',
                    name: 'stockAlerts',
                    builder: (context, state) => const StockAlertsView(),
                  ),
                ],
              ),
            ],
          ),
          // A terceira rama do Shell (índice 2): Ajustes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => SettingsView(),
                routes: [
                  GoRoute(
                    path: 'users',
                    name: 'users',
                    builder: (context, state) => const UserListView(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    name: 'notifications',
                    builder: (context, state) => const NotificationsView(),
                  ),
                  GoRoute(
                    path: 'reports',
                    name: 'reports',
                    builder: (context, state) => const ReportsView(),
                  ),
                  GoRoute(
                    path: 'profile',
                    name: 'profile',
                    builder: (context, state) => const ProfileView(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
