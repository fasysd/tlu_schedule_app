// main.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/themes/app_theme.dart';
import 'data/mock_data.dart';
import 'data/models/user_model.dart';
import 'presentation/screens/splash_page.dart';
import 'presentation/screens/home_giangvien.dart';

void main() {
  // Khởi tạo locale 'vi_VN'
  initializeDateFormatting('vi_VN', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tìm user từ mock data
    final UserAccount currentUser = userAccounts.firstWhere((u) => u.id == 'gv01');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TLU Schedule',
      theme: AppTheme.light,
      home: SplashPage(), // Bắt đầu từ SplashPage để có luồng đăng nhập
      // home: HomeGiangVien(user: currentUser), // Hoặc vào thẳng trang chủ để test
    );
  }
}
    