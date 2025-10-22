import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/services/auth_service.dart';
import 'package:tlu_schedule_app/presentation/web_platform/screens/login_web_page.dart';

class SplashWebPage extends StatefulWidget {
  const SplashWebPage({super.key});

  @override
  State<SplashWebPage> createState() => _SplashWebPageState();
}

class _SplashWebPageState extends State<SplashWebPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 1400));

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginWebPage()));

    // if (mounted) {
    //   final isLoggedIn = await AuthService.isLoggedIn();
    //
    //   if (isLoggedIn) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => const PhongdaotaoHomePage()),
    //     );
    //   } else {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (_) => const LoginMobilePage()),
    //     );
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo.png'),
              Text('TLU', style: Theme.of(context).textTheme.displayLarge),
              Text(
                'HỆ THỐNG QUẢN LÝ LỊCH TRÌNH',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
