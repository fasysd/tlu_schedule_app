import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/core/themes/custom_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  extensions: [
    CustomColors(
      colors: {
        "xanhDuongDam": const Color.fromRGBO(0, 55, 126, 1), //xanhDuongDam
        "xanhDuong": const Color.fromRGBO(89, 141, 192, 1), //xanhDuong
        "xanhDuongNhat": const Color.fromRGBO(195, 217, 233, 1), //xanhDuongNhat
        "xamDam": const Color.fromRGBO(158, 158, 158, 1), //xamDam
        "xamNhat": const Color.fromRGBO(216, 216, 216, 1), //xamNhat
        "vang": const Color.fromRGBO(255, 204, 0, 1), //vang
        "do": const Color.fromRGBO(255, 85, 88, 1), //do
        "trang": Colors.white, //trang
        "den": const Color.fromRGBO(51, 51, 51, 1), //den
      },
    ),
  ],
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromRGBO(89, 141, 192, 1),
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  textTheme: const TextTheme(
    // Dành cho banner, màn hình chính, title app lớn
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.normal),

    // Dành cho tiêu đề phần, card, tiêu đề trang
    headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.normal),

    // Dành cho tiêu đề trong widget nhỏ hơn
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),

    // Dành cho nội dung chính
    bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),

    // Dành cho nhãn, nút, chú thích
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
  ),
);
