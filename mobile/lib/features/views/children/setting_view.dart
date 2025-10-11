// lib/features/home/presentation/views/settings_view.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/presentation/theme/app_colors.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentWhite,
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: AppColors.accentWhite,
        foregroundColor: AppColors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Seção de Administração
          const Text(
            'ADMINISTRAÇÃO',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: AppColors.lightGray,
            child: ListTile(
              leading: const Icon(Icons.people, color: AppColors.primaryGreen),
              title: const Text('Gestão de Usuários'),
              subtitle: const Text('Gerenciar usuários do sistema'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.goNamed('users');
              },
            ),
          ),
          const SizedBox(height: 24),

          // Seção de Conta
          const Text(
            'CONTA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: AppColors.lightGray,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: AppColors.primaryGreen,
                  ),
                  title: const Text('Meu Perfil'),
                  subtitle: const Text('Editar informações pessoais'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Navegar para perfil
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.lock,
                    color: AppColors.primaryGreen,
                  ),
                  title: const Text('Alterar Senha'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Alterar senha
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Seção de Aplicativo
          const Text(
            'APLICATIVO',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: AppColors.lightGray,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: AppColors.primaryGreen,
                  ),
                  title: const Text('Central de Notificações'),
                  subtitle: const Text('Ver todas as notificações'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    context.goNamed('notifications');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.dark_mode,
                    color: AppColors.primaryGreen,
                  ),
                  title: const Text('Tema Escuro'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // TODO: Toggle tema
                    },
                    activeTrackColor: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Seção de Sobre
          const Text(
            'SOBRE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: AppColors.lightGray,
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info, color: AppColors.primaryGreen),
                  title: Text('Versão'),
                  trailing: Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.code,
                    color: AppColors.primaryGreen,
                  ),
                  title: const Text('Desenvolvido por'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Mostrar créditos
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Botão de Logout
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implementar logout
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
                    TextButton(
                      onPressed: () {
                        // TODO: Limpar sessão e voltar para login
                        Navigator.pop(context);
                        context.goNamed('login');
                      },
                      child: const Text(
                        'Sair',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sair da Conta'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
