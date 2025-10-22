import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/core/themes/theme_utils.dart';

class AdminQuanLyDanhMucKhacWebPage extends StatelessWidget {
  const AdminQuanLyDanhMucKhacWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme();
    return Center(
      child: Text('Danh mục khác', style: textTheme.headlineLarge),
    );
  }
}
