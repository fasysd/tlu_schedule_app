import 'package:flutter/material.dart';
import 'custom_colors.dart';

extension CustomColorContext on BuildContext {
  Color? appColor(String key) {
    final ext = Theme.of(this).extension<CustomColors>();
    return ext?.colors[key];
  }

  TextTheme appTextTheme() {
    final ext = Theme.of(this).textTheme;
    return ext;
  }
}
