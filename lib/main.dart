import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/themes/app_theme.dart';
import 'presentation/screens/splash_page.dart';
import 'package:tlu_schedule_app/data/services/static_data.dart';
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
        home: SplashPage(),
        //home: HomeGiangVien(user: staticUsers.firstWhere((u) => u.id == 'gv01'))
    );
  }
}
