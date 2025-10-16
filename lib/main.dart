import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/themes/app_theme.dart';
import 'data/mock_data.dart';
import 'presentation/screens/splash_page.dart';
import 'presentation/screens/home_giangvien.dart';

void main() {
  initializeDateFormatting('vi_VN', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TLU Schedule',
      theme: AppTheme.light,
      //home: SplashPage(),
      home: HomeGiangVien(user: userAccounts.firstWhere((u) => u.id == 'gv01'))
    );
  }
}
    