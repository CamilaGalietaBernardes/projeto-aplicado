import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/presentation/theme/app_colors.dart';
import 'package:mobile/view_model/notification_view_model.dart';

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
          IconButton(
            icon: Icon(Icons.person, color: AppColors.primaryGreen, size: 30),
            onPressed: () {},
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
}
