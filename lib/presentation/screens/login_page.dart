import 'dart:ui';
import 'package:flutter/material.dart';
import 'phongDaoTao_home_page.dart';

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
    if (value == null || value.isEmpty || value.length == 0) {
      return 'Vui lòng nhập tài khoản!!!';
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
    if (value == null || value.isEmpty || value.length == 0) {
      return 'Vui lòng nhập mật khẩu!!!';
    }
    return null;
  }

  void _clickForgotPassword() {
    setState(() {
      _forgotPasswordMode = !_forgotPasswordMode;
    });
    _formKey.currentState!.reset();
  }

  void _showVerifyDialog() {}

  void _submitForm() {
    // _formKey.currentState!.validate();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PhongdaotaoHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
            Expanded(
              child: Container(
                width: 300,
                child: Center(
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
                        SizedBox(height: 3),
                        TextFormField(
                          style: Theme.of(context).textTheme.titleMedium,
                          onChanged: _setUserName,
                          validator: _validateUserName,
                        ),
                        SizedBox(height: 20),

                        Text(
                          _forgotPasswordMode ? 'Email' : 'Mật khẩu',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 3),
                        TextFormField(
                          style: Theme.of(context).textTheme.titleMedium,
                          onChanged: _forgotPasswordMode
                              ? _setEmail
                              : _setPassword,
                          validator: _forgotPasswordMode
                              ? _validateEmail
                              : _validatePassword,
                        ),
                        SizedBox(height: 20),

                        Container(
                          child: Center(
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
                        ),
                        SizedBox(height: 20),

                        Container(
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              child: Text(
                                _forgotPasswordMode
                                    ? 'Khôi phục mật khẩu'
                                    : 'Đăng nhập',
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
