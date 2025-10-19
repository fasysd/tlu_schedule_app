import 'package:flutter/material.dart';

class ThongKePage extends StatelessWidget {
  const ThongKePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thống kê')),
      body: Center(child: Text('Dữ liệu thống kê')),
    );
  }
}
