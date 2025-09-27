// lib/features/home/presentation/views/children/home_child_b_view.dart

import 'package:flutter/material.dart';
import 'package:mobile/presentation/theme/app_colors.dart';

class HomeChildBView extends StatelessWidget {
  const HomeChildBView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.successGreen.withOpacity(
        0.4,
      ), // Um verde suave
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Widget Filho B',
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
                backgroundColor: AppColors.metallicGray,
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
