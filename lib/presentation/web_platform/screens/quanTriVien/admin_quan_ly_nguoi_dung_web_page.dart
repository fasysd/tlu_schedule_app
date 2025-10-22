import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/core/themes/theme_utils.dart';

class AdminQuanLyNguoiDungWebPage extends StatelessWidget {
  const AdminQuanLyNguoiDungWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme();
    return Center(
      child: Text('Người dùng', style: textTheme.headlineLarge),
    );
  }
}
