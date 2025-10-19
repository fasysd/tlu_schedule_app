import 'package:flutter/material.dart';

Map<String, dynamic> getWarningDetails(String status) {
  switch (status) {
    case 'warning':
      return {
        'text': 'Cảnh báo',
        'color': Colors.yellow.shade700,
      };
    case 'danger':
      return {
        'text': 'Cảnh báo nguy hiểm',
        'color': Colors.red.shade700,
      };
    default:
      return {
        'text': 'Không có cảnh báo',
        'color': Colors.green,
      };
  }
}
