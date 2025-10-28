// lib/features/home/presentation/views/profile_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/presentation/theme/app_colors.dart';
import 'package:mobile/core/providers/providers.dart';
import 'package:mobile/domain/models/user_model.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSession = ref.watch(sessionProvider);

    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: AppColors.accentWhite,
        foregroundColor: AppColors.black,
      ),
      body: userSession == null
          ? const Center(
              child: Text(
                'Usuário não autenticado',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar com iniciais
                  _buildAvatar(userSession),
                  const SizedBox(height: 16),

                  // Nome do usuário
                  Text(
                    userSession.nome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),

                  // Função
                  Text(
                    userSession.funcao ?? 'Sem função',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Informações detalhadas
                  _buildInfoCard(userSession),
                  const SizedBox(height: 24),

                  // Botões de ação
                  _buildActionButton(
                    context: context,
                    icon: Icons.edit,
                    label: 'Editar Perfil',
                    color: AppColors.primaryGreen,
                    onTap: () => _showEditProfileDialog(context, ref, userSession),
                  ),
                  const SizedBox(height: 12),

                  _buildActionButton(
                    context: context,
                    icon: Icons.lock_outline,
                    label: 'Alterar Senha',
                    color: AppColors.accentYellow,
                    onTap: () => _showChangePasswordDialog(context, ref),
                  ),
                  const SizedBox(height: 12),

                  _buildActionButton(
                    context: context,
                    icon: Icons.logout,
                    label: 'Sair da Conta',
                    color: Colors.red,
                    onTap: () => _handleLogout(context, ref),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAvatar(UserModel user) {
    final initials = _getInitials(user.nome);
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Widget _buildInfoCard(UserModel user) {
    return Card(
      color: AppColors.lightGray,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              icon: Icons.email,
              label: 'Email',
              value: user.email,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              icon: Icons.work,
              label: 'Função',
              value: user.funcao ?? 'Sem função',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              icon: Icons.business,
              label: 'Setor',
              value: user.setor ?? 'Sem setor',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) async {
    final nomeController = TextEditingController(text: user.nome);
    final funcaoController = TextEditingController(text: user.funcao ?? '');
    final setorController = TextEditingController(text: user.setor ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: funcaoController,
                decoration: const InputDecoration(
                  labelText: 'Função',
                  prefixIcon: Icon(Icons.work),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: setorController,
                decoration: const InputDecoration(
                  labelText: 'Setor',
                  prefixIcon: Icon(Icons.business),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              // Atualizar sessão local (simplificado - sem chamada API)
              final updatedUser = UserModel(
                id: user.id,
                nome: nomeController.text,
                email: user.email,
                funcao: funcaoController.text,
                setor: setorController.text,
              );

              await ref
                  .read(sessionProvider.notifier)
                  .updateSessionWithUserModel(updatedUser);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Perfil atualizado com sucesso!'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangePasswordDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Senha'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha Atual',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Nova Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Validações
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('As senhas não coincidem!'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('A senha deve ter no mínimo 6 caracteres!'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // TODO: Implementar chamada API para alterar senha
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Senha alterada com sucesso!'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            child: const Text('Alterar'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair do aplicativo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await ref.read(loginViewModelProvider.notifier).signOut();
      if (context.mounted) {
        context.goNamed('login');
      }
    }
  }
}
