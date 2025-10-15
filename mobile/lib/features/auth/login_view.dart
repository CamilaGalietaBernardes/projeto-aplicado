import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/constants/globals.dart';
import 'package:mobile/core/providers/providers.dart';
import 'package:mobile/domain/models/user_model.dart';
import 'package:mobile/presentation/shared_widgets/elevated_button.dart';
import 'package:mobile/presentation/shared_widgets/text_form.dart'; // Mantido como text_form
import 'package:mobile/presentation/theme/app_colors.dart' show AppColors;

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

// O estado agora estende ConsumerState
class _LoginViewState extends ConsumerState<LoginView> {
  bool showUserCard = false;
  bool _passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variável para exibir mensagens de erro da API/VM
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    // 1. OUVINDO O ESTADO (Para navegação e exibição de erros)
    ref.listen<AsyncValue<UserModel?>>(loginViewModelProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (e, st) {
          // Exibe a mensagem de erro
          setState(() {
            // Tenta limpar o prefixo de Exception se existir
            _errorMessage = e.toString().contains('Exception:')
                ? e.toString().replaceAll('Exception: ', '')
                : 'Erro de conexão ou credenciais inválidas.';
          });
        },
        data: (user) {
          if (user != null) {
            // Sucesso no login: Navega para a próxima tela
            // Mude '/home' para a rota principal do seu app
            context.go('/home');
            // Opcional: Fechar o card após sucesso
            setState(() => showUserCard = false);
          }
        },
      );
    });

    // 2. OBSERVANDO O ESTADO (Para o indicador de loading)
    final loginState = ref.watch(loginViewModelProvider);
    final isLoading = loginState.isLoading;

    final backgroundImage = 'assets/images/fundo.png';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(backgroundImage, fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black87,
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100.h,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: double.infinity,
                  height: 0.23.sh,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Sistema Manutenção',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: AppColors.accentWhite,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Centralização, Controle e Automação dos seus Processos Operacionais para uma gestão mais eficiente e inteligente. ",
                            style: TextStyle(
                              color: AppColors.accentWhite,
                              fontSize: 14.sp,
                              shadows: const [
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 3.0,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.11.sh,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    ElevatedButtonBase(
                      textColor: AppColors.accentWhite,
                      height: 50.h,
                      width: 0.75.sw,
                      fontSize: 16.sp,
                      isLoading: isLoading, // Desabilita se estiver carregando
                      onPressed: () {
                        if (!isLoading) {
                          setState(() {
                            showUserCard = true;
                            _errorMessage = null; // Limpa erro ao abrir o card
                          });
                        }
                      },
                      text: 'Entrar',
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  ],
                ),
              ),

              // --- Efeito de Backdrop e Card de Login ---
              if (showUserCard)
                // 1. Full-screen GestureDetector para fechar ao tocar fora
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      if (!isLoading) {
                        // Impede o fechamento durante o loading
                        setState(() {
                          showUserCard = false;
                          _errorMessage = null; // Limpa erro ao fechar
                        });
                      }
                    },
                    child: Container(
                      // Fundo escurecido
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: AnimatedPadding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,

                        // 2. GestureDetector interno para consumir toques no card
                        child: GestureDetector(
                          onTap:
                              () {}, // Consome o toque e impede que feche o modal
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 15.0,
                                sigmaY: 15.0,
                              ),
                              child: Container(
                                // A decoração do container que dá a cor e o gradiente
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color.fromARGB(
                                        255,
                                        125,
                                        124,
                                        124,
                                      ).withOpacity(0.5),
                                      AppColors.primaryGreen.withOpacity(0.5),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                // Conteúdo do Card
                                child: SizedBox(
                                  height: 0.45
                                      .sh, // Aumentado para acomodar a mensagem de erro
                                  width: 0.88.sw,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(
                                          'Bem-vindo!',
                                          style: TextStyle(
                                            color: AppColors.accentWhite,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          'Acesse sua conta para continuar',
                                          style: TextStyle(
                                            color: AppColors.lightGray,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      // Mensagem de Erro (Condicional)
                                      if (_errorMessage != null)
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8.h),
                                          child: Text(
                                            _errorMessage!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.errorRed,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 2.h,
                                        ),
                                        child: TextFormBase(
                                          colorform: AppColors.metallicGray
                                              .withAlpha(100),
                                          controller: _emailController,
                                          placeholder: 'Email',
                                          obscure: false,
                                          suffix: Icon(
                                            Icons.email,
                                            color: AppColors.black,
                                            size: 20.sp,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 0,
                                        ),
                                        child: TextFormBase(
                                          colorform: AppColors.metallicGray
                                              .withAlpha(100),
                                          controller: _passwordController,
                                          placeholder: 'Senha',
                                          obscure: !_passwordVisible,
                                          suffix: IconButton(
                                            icon: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: AppColors.black,
                                              size: 20.sp,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      ElevatedButtonBase(
                                        textColor: AppColors.accentWhite,
                                        height: 45.h,
                                        width: 0.5.sw,
                                        fontSize: 16.sp,
                                        isLoading:
                                            isLoading, // Adiciona o estado de loading
                                        onPressed: () {
                                          if (!isLoading) {
                                            // 3. Chama o método signIn do ViewModel
                                            ref
                                                .read(
                                                  loginViewModelProvider
                                                      .notifier,
                                                )
                                                .signIn(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                );
                                          }
                                        },
                                        text: 'Login',
                                        backgroundColor: AppColors.primaryGreen,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Rodapé
              Positioned(
                bottom: 20.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Senai 2025',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.lightGray,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
