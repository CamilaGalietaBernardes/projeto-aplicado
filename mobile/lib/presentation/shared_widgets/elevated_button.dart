import 'package:flutter/material.dart';
import 'package:mobile/core/constants/globals.dart';
import 'package:mobile/presentation/theme/app_colors.dart';

class ElevatedButtonBase extends StatelessWidget {
  final double height;
  final double? width;
  final VoidCallback? onPressed;
  final String? text;
  final Color backgroundColor;
  final Color? textColor;
  final Widget? child;
  final double? fontSize;
  final bool isLoading; // NOVO: Adicionado isLoading

  const ElevatedButtonBase({
    super.key,
    required this.height,
    this.width,
    this.onPressed,
    this.text,
    required this.backgroundColor,
    this.textColor,
    this.child,
    this.fontSize,
    this.isLoading = false, // Valor padrão false
  });

  @override
  Widget build(BuildContext context) {
    // Definindo a cor do texto/indicador, padrão para branco se não for fornecida
    final Color effectiveTextColor = textColor ?? AppColors.accentWhite;

    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            backgroundColor: backgroundColor,
            // A cor do foreground define a cor do indicador de progresso
            foregroundColor: effectiveTextColor,
          ),
          // Se estiver carregando, onPressed é null para desabilitar o botão
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? SizedBox(
                  // O tamanho do indicador é baseado no fontSize para ser proporcional
                  width: (fontSize ?? 16) + 4,
                  height: (fontSize ?? 16) + 4,
                  child: CircularProgressIndicator(
                    color: effectiveTextColor, // Cor do indicador
                    strokeWidth: 2.0,
                  ),
                )
              // Se não estiver carregando, mostra o child ou o text
              : child ??
                    Text(
                      text ?? '',
                      style: TextStyle(
                        fontSize: fontSize,
                        color:
                            effectiveTextColor, // Garante que a cor do texto seja aplicada
                      ),
                    ),
        ),
      ),
    );
  }
}
