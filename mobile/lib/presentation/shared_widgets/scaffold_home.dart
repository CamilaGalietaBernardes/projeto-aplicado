import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/presentation/theme/app_colors.dart';
import 'package:mobile/view_model/notification_view_model.dart';
import 'package:mobile/core/providers/providers.dart';

class ScaffoldHome extends ConsumerWidget {
  const ScaffoldHome({required this.navigationShell, Key? key})
    : super(key: key);
  final StatefulNavigationShell navigationShell;

  // Função auxiliar para criar SvgPicture com controle de cor
  // Esta função é a forma recomendada de gerenciar os SVGs e suas cores.
  Widget _buildSvgIcon(String assetPath, {Color? color}) {
    return SvgPicture.asset(
      assetPath,
      // O colorFilter é a propriedade que permite mudar a cor do SVG.
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      width: 24.0, // Ajuste o tamanho conforme necessário para seus ícones
      height: 24.0,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color selectedColor = AppColors.primaryGreen;
    final Color unselectedColor = AppColors.lightGray;

    // Observa o contador de notificações não lidas
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png', // Caminho para seu asset
          height: 50, // Ajuste o tamanho conforme necessário
        ),
        actions: [
          // Badge de notificações
          IconButton(
            icon: Badge(
              label: unreadCountAsync.when(
                data: (count) => count > 0 ? Text('$count') : null,
                loading: () => null,
                error: (_, __) => null,
              ),
              isLabelVisible: unreadCountAsync.maybeWhen(
                data: (count) => count > 0,
                orElse: () => false,
              ),
              child: const Icon(Icons.notifications),
            ),
            color: AppColors.primaryGreen,
            iconSize: 30,
            onPressed: () {
              context.pushNamed('notifications');
            },
          ),
          // Ícone do usuário com menu popup
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.primaryGreen, size: 30),
            onPressed: () {
              _showUserMenu(context, ref);
            },
          ),
        ],
        centerTitle: false,
        backgroundColor: AppColors.accentWhite, // Cor do AppBar
      ),
      body: navigationShell,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 4,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          backgroundColor: AppColors.black,
          selectedItemColor: selectedColor, // Usa a cor definida
          unselectedItemColor: unselectedColor, // Usa a cor definida
          selectedLabelStyle: const TextStyle(color: Colors.white),
          unselectedLabelStyle: const TextStyle(color: Colors.white),
          type: BottomNavigationBarType.fixed,
          items: [
            // Exemplo para o item "Inicio"
            BottomNavigationBarItem(
              // Ícone para quando NÃO ESTÁ selecionado
              icon: _buildSvgIcon(
                'assets/icons/home.svg', // Caminho para o SVG do ícone não selecionado
                color: unselectedColor, // Aplica a cor de não selecionado
              ),
              // Ícone para quando ESTÁ selecionado
              activeIcon: _buildSvgIcon(
                'assets/icons/home.svg', // Caminho para o SVG do ícone selecionado/preenchido
                color: selectedColor, // Aplica a cor de selecionado
              ),
              label: 'Home',
            ),

            // Exemplo para o item "Perfil"
            BottomNavigationBarItem(
              icon: _buildSvgIcon(
                'assets/icons/estoque.svg',
                color: unselectedColor,
              ),
              activeIcon: _buildSvgIcon(
                'assets/icons/estoque.svg',
                color: selectedColor,
              ),
              label: 'Estoque',
            ),

            // Exemplo para o item "Ajustes"
            BottomNavigationBarItem(
              icon: _buildSvgIcon(
                'assets/icons/rela.svg',
                color: unselectedColor,
              ),
              activeIcon: _buildSvgIcon(
                'assets/icons/rela.svg',
                color: selectedColor,
              ),
              label: 'Gestão',
            ),
          ],
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context, WidgetRef ref) {
    final userSession = ref.read(sessionProvider);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 50, // x
        kToolbarHeight + 10, // y (abaixo do AppBar)
        10, // right
        0, // bottom
      ),
      items: <PopupMenuEntry<String>>[
        // Header com informações do usuário
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryGreen,
                    radius: 20,
                    child: Text(
                      _getInitials(userSession?.nome ?? 'U'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userSession?.nome ?? 'Usuário',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          userSession?.email ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
            ],
          ),
        ),

        // Meu Perfil
        PopupMenuItem<String>(
          value: 'profile',
          child: const Row(
            children: [
              Icon(Icons.person_outline, color: AppColors.primaryGreen),
              SizedBox(width: 12),
              Text('Meu Perfil'),
            ],
          ),
        ),

        // Configurações
        PopupMenuItem<String>(
          value: 'settings',
          child: const Row(
            children: [
              Icon(Icons.settings_outlined, color: AppColors.primaryGreen),
              SizedBox(width: 12),
              Text('Configurações'),
            ],
          ),
        ),

        const PopupMenuDivider(),

        // Sair
        PopupMenuItem<String>(
          value: 'logout',
          child: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 12),
              Text(
                'Sair',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ).then((value) {
      if (value != null) {
        _handleMenuAction(context, ref, value);
      }
    });
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'profile':
        context.goNamed('profile');
        break;

      case 'settings':
        context.goNamed('settings');
        break;

      case 'logout':
        _showLogoutConfirmation(context, ref);
        break;
    }
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair do aplicativo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Limpa a sessão
              await ref.read(loginViewModelProvider.notifier).signOut();

              // Redireciona para login
              if (context.mounted) {
                context.goNamed('login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
