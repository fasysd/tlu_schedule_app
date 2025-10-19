import 'package:flutter/material.dart';

class TheReportItem extends StatelessWidget {
  final String title;
  final String description;
  final String type; // 'excel' or 'pdf'
  final VoidCallback onDownload;

  const TheReportItem({
    super.key,
    required this.title,
    required this.description,
    required this.type,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isExcel = type == 'excel';
    final iconColor = isExcel ? Colors.green : Colors.red;
    final backgroundColor = isExcel ? Colors.green[50] : Colors.red[50];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          ),
          
          // Download Button
          ElevatedButton.icon(
            onPressed: onDownload,
            icon: const Icon(Icons.download, size: 14),
            label: const Text('Tải xuống'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
