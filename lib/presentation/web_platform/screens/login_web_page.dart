import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/core/themes/theme_utils.dart';
import 'package:tlu_schedule_app/data/services/auth_service.dart';
import 'package:tlu_schedule_app/presentation/web_platform/screens/quanTriVien/admin_home_web_page.dart';

class LoginWebPage extends StatefulWidget {
  const LoginWebPage({super.key});

  @override
  State<LoginWebPage> createState() => _LoginWebPageState();
}

class _LoginWebPageState extends State<LoginWebPage> {
  final _formKey = GlobalKey<FormState>();
  bool _forgotPasswordMode = false;
  String _userName = '';
  String _email = '';
  String _password = '';

  void _setUserName(String? value) => setState(() => _userName = value ?? '');
  void _setEmail(String? value) => setState(() => _email = value ?? '');
  void _setPassword(String? value) => setState(() => _password = value ?? '');

  String? _validateUserName(String? value) =>
      (value == null || value.isEmpty) ? 'Vui lòng nhập tài khoản!' : null;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Email không hợp lệ';
    return null;
  }

  String? _validatePassword(String? value) =>
      (value == null || value.isEmpty) ? 'Vui lòng nhập mật khẩu!' : null;

  void _clickForgotPassword() {
    setState(() {
      _forgotPasswordMode = !_forgotPasswordMode;
      _formKey.currentState?.reset();
    });
  }

  void _showVerifyDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng đang được phát triển')),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_forgotPasswordMode) {
      _showVerifyDialog();
      return;
    }

    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (_) => const Center(child: CircularProgressIndicator()),
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đăng nhập!!! TK: ${_userName} - MK: ${_password}'),
      ),
    );
    if (_userName == 'admin' && _password == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminHomeWebPage()),
      );
    }
    // try {
    //   final user = staticUsers.firstWhere(
    //     (acc) => acc.username == _userName && acc.password == _password,
    //   );
    //   Navigator.of(context).pop();
    //   await AuthService.login(_userName, _password);
    //
    //   if (user.role == 'giangvien') {
    //     // Navigator.pushReplacement(
    //     //   context,
    //     //   MaterialPageRoute(builder: (_) => HomeGiangVien(user: user)),
    //     // );
    //   } else if (user.role == 'phongdaotao') {
    //     // Navigator.pushReplacement(
    //     //   context,
    //     //   MaterialPageRoute(builder: (_) => const PhongdaotaoHomePage()),
    //     // );
    //   }
    // } catch (e) {
    //   Navigator.of(context).pop();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Sai tên đăng nhập hoặc mật khẩu.'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // Bên trái: ảnh nền + logo
          Expanded(
            flex: 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // Bên phải: form đăng nhập
          Expanded(
            flex: 3,
            child: Center(
              child: Card(
                elevation: 10,
                margin: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 50,
                  ),
                  child: SizedBox(
                    width: 400,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _forgotPasswordMode
                                ? 'Khôi phục mật khẩu'
                                : 'Đăng nhập hệ thống',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.appColor('xanhDuong'),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),

                          // Tên đăng nhập
                          Text(
                            'Tài khoản',
                            style: context.appTextTheme().titleMedium?.copyWith(
                              color: context.appColor('xanhDuong'),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            onChanged: _setUserName,
                            validator: _validateUserName,
                          ),
                          const SizedBox(height: 25),

                          // Mật khẩu hoặc email
                          Text(
                            _forgotPasswordMode ? 'Email' : 'Mật khẩu',
                            style: context.appTextTheme().titleMedium?.copyWith(
                              color: context.appColor('xanhDuong'),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            obscureText: !_forgotPasswordMode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            onChanged: _forgotPasswordMode
                                ? _setEmail
                                : _setPassword,
                            validator: _forgotPasswordMode
                                ? _validateEmail
                                : _validatePassword,
                          ),
                          const SizedBox(height: 30),

                          // Nút quên mật khẩu
                          TextButton(
                            onPressed: _clickForgotPassword,
                            child: Text(
                              _forgotPasswordMode
                                  ? 'Quay lại đăng nhập'
                                  : 'Quên mật khẩu?',
                              style: context
                                  .appTextTheme()
                                  .titleLarge
                                  ?.copyWith(
                                    color: context.appColor('xanhDuong'),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Nút đăng nhập
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.appColor('xanhDuong'),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _forgotPasswordMode
                                  ? 'Khôi phục mật khẩu'
                                  : 'Đăng nhập',
                              style: context
                                  .appTextTheme()
                                  .titleLarge
                                  ?.copyWith(color: context.appColor('trang')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
