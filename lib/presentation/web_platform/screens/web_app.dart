import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/core/themes/app_theme.dart';
import 'package:tlu_schedule_app/presentation/web_platform/screens/splash_web_page.dart';

class WebApp extends StatelessWidget {
  const WebApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web App',
      theme: AppTheme.light,
      home: const SplashWebPage(),
    );
  }
}
