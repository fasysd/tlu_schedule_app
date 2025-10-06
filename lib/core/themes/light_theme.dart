import 'package:flutter/material.dart';

final Color _xanhDuongDam = Color.fromRGBO(0, 55, 126, 100);
final Color _xanhDuong = Color.fromRGBO(89, 141, 192, 100);
final Color _xanhDuongNhat = Color.fromRGBO(195, 217, 233, 100);
final Color _xamDam = Color.fromRGBO(158, 158, 158, 100);
final Color _xamNhat = Color.fromRGBO(216, 216, 216, 100);
final Color _vang = Color.fromRGBO(255, 204, 0, 100);
final Color _do = Color.fromRGBO(255, 85, 88, 100);
final Color _trang = Color.fromRGBO(255, 255, 255, 100);
final Color _den = Color.fromRGBO(51, 51, 51, 100);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  scaffoldBackgroundColor: _trang,
  appBarTheme: AppBarTheme(
    backgroundColor: _xanhDuong,
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
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),

    // Dành cho nhãn, nút, chú thích
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _xanhDuong,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(21)),
      ),
      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: _trang,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(_xanhDuongDam), // màu chữ
      backgroundColor: WidgetStatePropertyAll(Colors.transparent), // nền
      overlayColor: WidgetStatePropertyAll(_xanhDuongNhat), // khi nhấn
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    // ================= TextStyle =================
    labelStyle: TextStyle(
      color: Colors.blueGrey,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    hintStyle: TextStyle(color: _den, fontSize: 16),
    helperStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
    errorStyle: TextStyle(
      color: Colors.red,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),

    // ================= Fill & Background =================
    filled: true,
    fillColor: Colors.grey[100],

    // ================= Border =================
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
      borderSide: BorderSide(color: Colors.grey, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
      borderSide: BorderSide(color: Colors.grey, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
      borderSide: BorderSide(color: Colors.redAccent, width: 2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(21),
      borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
    ),

    // ================= Padding =================
    isDense: true,
    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    // ================= Icons =================
    prefixStyle: TextStyle(color: Colors.grey[700]),
    suffixStyle: TextStyle(color: Colors.grey[700]),
    prefixIconColor: Colors.grey[700],
    suffixIconColor: Colors.grey[700],
    // ================= Floating label behavior =================
    floatingLabelBehavior: FloatingLabelBehavior.auto, // hoặc .always
  ),
);
