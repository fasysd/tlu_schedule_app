import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/services/auth_service.dart';
import '../../data/services/static_data.dart';
import 'home_giangvien.dart';
import 'phong_dao_tao_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _forgotPasswordMode = false;
  String _userName = '';
  String _email = '';
  String _password = '';

  void _setUserName(String? value) {
    setState(() {
      _userName = value ?? '';
    });
  }

  String? _validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tài khoản!';
    }
    return null;
  }

  void _setEmail(String? value) {
    setState(() {
      _email = value ?? '';
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  void _setPassword(String? value) {
    setState(() {
      _password = value ?? '';
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu!';
    }
    return null;
  }

  void _clickForgotPassword() {
    setState(() {
      _forgotPasswordMode = !_forgotPasswordMode;
    });
    _formKey.currentState!.reset();
  }

  void _showVerifyDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng đang được phát triển')),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_forgotPasswordMode) {
      _showVerifyDialog();
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Try static users first
      final user = staticUsers.firstWhere(
        (acc) => acc.username == _userName && acc.password == _password,
      );

      // Hide loading
      Navigator.of(context).pop();

      // Save to AuthService
      await AuthService.login(_userName, _password);

      if (user.role == 'giangvien') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeGiangVien(user: user),
          ),
        );
      } else if (user.role == 'phongdaotao') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PhongdaotaoHomePage(),
          ),
        );
      }
    } catch (e) {
      // Hide loading
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sai tên đăng nhập hoặc mật khẩu.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Image.asset('assets/images/background.png'),
                  ),
                  Image.asset('assets/images/logo.png'),
                ],
              ),
              Container(
                width: 300,
                padding: const EdgeInsets.only(top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tài khoản',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 3),
                      TextFormField(
                        obscureText: false,
                        decoration: const InputDecoration(),
                        style: Theme.of(context).textTheme.titleMedium,
                        onChanged: _setUserName,
                        validator: _validateUserName,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _forgotPasswordMode ? 'Email' : 'Mật khẩu',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 3),
                      TextFormField(
                        obscureText: !_forgotPasswordMode,
                        decoration: const InputDecoration(),
                        style: Theme.of(context).textTheme.titleMedium,
                        onChanged:
                        _forgotPasswordMode ? _setEmail : _setPassword,
                        validator: _forgotPasswordMode
                            ? _validateEmail
                            : _validatePassword,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: _clickForgotPassword,
                          child: Text(
                            textAlign: TextAlign.center,
                            _forgotPasswordMode
                                ? 'Quay lại đăng nhập'
                                : 'Quên mật khẩu',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            _forgotPasswordMode
                                ? 'Khôi phục mật khẩu'
                                : 'Đăng nhập',
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
