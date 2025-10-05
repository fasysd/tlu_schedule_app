import 'package:flutter/material.dart';

final Color _xanhDam = Color.fromRGBO(89, 141, 192, 100);
final Color _xanhNhat = Color.fromRGBO(195, 217, 233, 100);
final Color _xamDam = Color.fromRGBO(158, 158, 158, 100);
final Color _xamNhat = Color.fromRGBO(216, 216, 216, 100);
final Color _vang = Color.fromRGBO(255, 204, 0, 100);
final Color _do = Color.fromRGBO(255, 85, 88, 100);
final Color _trang = Color.fromRGBO(255, 255, 255, 100);
final Color _den = Color.fromRGBO(51, 51, 51, 100);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
    headlineSmall: TextStyle(fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  ),
);
