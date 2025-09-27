// lib/presentation/theme/app_colors.dart

import 'package:flutter/material.dart';

/// Paleta de cores principal para o app de gestão de peças e manutenção.
///
/// Inspirada na imagem de referência, usando tons de verde,
/// branco, amarelo vibrante, cinza metálico e dourado.
class AppColors {
  // Cores primárias
  static const Color primaryGreen = Color(0xFF2E7D32); // Verde de fundo
  static const Color accentWhite = Color(0xFFFFFFFF); // Branco puro
  static const Color accentYellow = Color(
    0xFFFBC02D,
  ); // Amarelo das ferramentas
  static const Color metallicGray = Color(0xFF9E9E9E); // Cinza metálico
  static const Color sawGold = Color(0xFFB8860B); // Dourado/bronzado da serra

  // Tonos adicionais
  static const Color darkGreen = Color(
    0xFF1B5E20,
  ); // Verde mais escuro para contraste
  static const Color lightGray = Color(
    0xFFEEEEEE,
  ); // Cinza claro para fundo de cards
  static const Color black = Color(0xFF212121); // Preto para texto escuro

  // Estados
  static const Color errorRed = Color(0xFFD32F2F); // Erro
  static const Color successGreen = Color(0xFF4CAF50); // Sucesso
}
