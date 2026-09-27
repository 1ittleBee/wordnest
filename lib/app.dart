import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

/// মূল অ্যাপ্লিকেশন উইজেট — Root Application Widget
class WordNestApp extends StatelessWidget {
  const WordNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordNest 🌳 — বাংলা শব্দ খোঁজ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
