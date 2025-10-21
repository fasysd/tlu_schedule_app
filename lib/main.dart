import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tlu_schedule_app/presentation/screens/login_page.dart';
import 'core/themes/app_theme.dart';
import 'presentation/screens/splash_page.dart';
import 'package:tlu_schedule_app/data/services/static_data.dart';
import 'presentation/screens/home_giangvien.dart';
// import 'core/config/firebase_config.dart'; // Tắt Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase - Tạm thời tắt để test giao diện
  // await FirebaseConfig.initialize();
  
  // Initialize Vietnamese date formatting
  await initializeDateFormatting('vi_VN', null);
  
  runApp(const MyApp());
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
      home: LoginPage(),
    );
  }
}
