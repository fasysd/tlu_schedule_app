import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Map<String, Color> colors;

  const CustomColors({required this.colors});

  Color? operator [](String key) => colors[key];

  @override
  CustomColors copyWith({Map<String, Color>? colors}) {
    return CustomColors(colors: colors ?? this.colors);
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;

    final Map<String, Color> newColors = {};
    for (final key in colors.keys) {
      final baseColor = colors[key];
      final targetColor = other.colors[key];
      if (baseColor != null && targetColor != null) {
        newColors[key] = Color.lerp(baseColor, targetColor, t)!;
      } else {
        newColors[key] = baseColor ?? targetColor ?? Colors.transparent;
      }
    }
    return CustomColors(colors: newColors);
  }
}
