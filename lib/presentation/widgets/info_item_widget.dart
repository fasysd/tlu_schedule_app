import 'package:flutter/material.dart';

class InfoItemWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final double? fontSize;

  const InfoItemWidget({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).textTheme.bodyMedium?.color;
    final double finalFontSize = fontSize ?? 17.0;

    return Row(
      children: [
        Icon(icon, size: finalFontSize + 4, color: color ?? defaultColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: finalFontSize, color: color ?? defaultColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
