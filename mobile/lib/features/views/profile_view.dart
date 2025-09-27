// lib/features/home/presentation/views/profile_view.dart

import 'package:flutter/material.dart';
import 'package:mobile/presentation/theme/app_colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen.withOpacity(
        0.5,
      ), // Um tom de cinza escuro
      body: Center(
        child: Text(
          'Página de Perfil',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.lightGray, // Texto em branco
          ),
        ),
      ),
    );
  }
}
