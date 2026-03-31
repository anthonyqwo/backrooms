import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_colors.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const BackroomsApp());
}

/// App 根元件
class BackroomsApp extends StatelessWidget {
  const BackroomsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '後室 Backrooms',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        textTheme: GoogleFonts.notoSansTextTheme(ThemeData.dark().textTheme)
            .apply(
              bodyColor: AppColors.textPrimary,
              displayColor: AppColors.textPrimary,
            ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primary,
          elevation: 0,
          titleTextStyle: GoogleFonts.creepster(
            color: AppColors.primary,
            fontSize: 26,
            letterSpacing: 3,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
