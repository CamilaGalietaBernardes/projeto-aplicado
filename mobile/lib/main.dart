import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/routes/app_router.dart';
import 'package:mobile/view_model/stock_notification_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    // Inicializa o monitor de notificações de estoque
    ref.watch(stockNotificationMonitorProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        title: 'Galvanoville',
        theme: ThemeData(
          fontFamily: GoogleFonts.lexend().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.white, // Cor de fundo do menu
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: Colors.white, // Cor de fundo do diálogo
            titleTextStyle: TextStyle(
              color: Colors.black, // Cor do título
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            contentTextStyle: TextStyle(
              color: Colors.black, // Cor do conteúdo
              fontSize: 16,
            ),
          ),
        ),
        routerConfig: goRouter,
      ),
    );
  }
}
