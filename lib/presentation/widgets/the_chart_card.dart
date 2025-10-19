import 'package:flutter/material.dart';

class TheChartCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget chartComponent;

  const TheChartCard({
    super.key,
    required this.title,
    required this.icon,
    required this.chartComponent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(230, 238, 248, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    // Handle download
                  },
                  icon: const Icon(Icons.download, color: Color(0xFF4C7EAA)),
                ),
              ],
            ),
          ),
          
          // Chart Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: chartComponent,
          ),
        ],
      ),
    );
  }
}
