import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tlu_schedule_app/presentation/screens/splash_page.dart';
import 'package:tlu_schedule_app/presentation/web_platform/screens/web_app.dart';
import 'core/themes/app_theme.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  initializeDateFormatting('vi_VN', null).then((_) {
    runApp(kIsWeb ? const WebApp() : const AppAndroid());
  });
}

class AppAndroid extends StatelessWidget {
  const AppAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TLU Schedule',
      theme: AppTheme.light,
      home: SplashAndroidPage(),
    );
  }
}
