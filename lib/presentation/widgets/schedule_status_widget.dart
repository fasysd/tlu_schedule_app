import 'package:flutter/material.dart';
import 'info_item_widget.dart';

class ScheduleStatusWidget extends StatelessWidget {
  final String status;
  final double? fontSize;

  const ScheduleStatusWidget({super.key, required this.status, this.fontSize});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'scheduled':
      case 'held':
        return InfoItemWidget(
            icon: Icons.check_circle_outline,
            text: "Có dạy",
            color: Colors.green,
            fontSize: fontSize);
      case 'missed':
        return InfoItemWidget(
            icon: Icons.cancel_outlined,
            text: "Nghỉ dạy",
            color: Colors.red,
            fontSize: fontSize);
      case 'pending_leave':
        return InfoItemWidget(
            icon: Icons.hourglass_top_outlined,
            text: "Chờ duyệt nghỉ",
            color: Colors.orange.shade700,
            fontSize: fontSize);
      default:
        return const InfoItemWidget(
            icon: Icons.help_outline, text: "Không xác định");
    }
  }
}
