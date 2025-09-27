// lib/features/home/presentation/views/children/home_child_c_view.dart

import 'package:flutter/material.dart';
import 'package:mobile/presentation/theme/app_colors.dart';

class HomeChildCView extends StatelessWidget {
  const HomeChildCView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.errorRed.withOpacity(0.4), // Um vermelho suave
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Widget Filho C',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.lightGray,
              ),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
