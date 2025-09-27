// lib/features/home/presentation/views/settings_view.dart

import 'package:flutter/material.dart';
import 'package:mobile/presentation/theme/app_colors.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.errorRed.withOpacity(
        0.4,
      ), // Um tom de vermelho
      body: Center(
        child: Text(
          'Página de Configurações',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.black, // Texto em preto profundo
          ),
        ),
      ),
    );
  }
}
