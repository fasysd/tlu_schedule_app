import 'package:flutter/material.dart';
import '../../data/models/teaching_statistics_model.dart';

class CardTeachingStatistics extends StatelessWidget {
  final TeachingStatisticsModel statistics;

  const CardTeachingStatistics({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với thông tin giảng viên
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(statistics.duongDanAvatar),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(width: 15),
              // Thông tin
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statistics.hoVaTen,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      statistics.maGiangVien,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Text(
                      statistics.email,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 15),

          // Thống kê số liệu
          Text(
            'Thống kê giảng dạy',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 15),

          _buildStatRow(
            context,
            'Tổng số tiết',
            statistics.tongSoTiet.toString(),
            Icons.school,
            Colors.blue,
          ),
          const SizedBox(height: 10),
          _buildStatRow(
            context,
            'Đã giảng dạy',
            statistics.soTietDaDay.toString(),
            Icons.check_circle,
            Colors.green,
          ),
          const SizedBox(height: 10),
          _buildStatRow(
            context,
            'Tiết nghỉ',
            statistics.soTietNghi.toString(),
            Icons.cancel,
            Colors.red,
          ),
          const SizedBox(height: 10),
          _buildStatRow(
            context,
            'Tiết dạy bù',
            statistics.soTietDayBu.toString(),
            Icons.update,
            Colors.orange,
          ),
          const SizedBox(height: 10),
          _buildStatRow(
            context,
            'Còn lại',
            statistics.soTietConLai.toString(),
            Icons.pending,
            Colors.grey,
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 15),

          // Tỷ lệ hoàn thành
          _buildProgressBar(
            context,
            'Tỷ lệ hoàn thành',
            statistics.tiLeHoanThanh,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildProgressBar(
            context,
            'Tỷ lệ nghỉ',
            statistics.tiLeNghi,
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildProgressBar(
            context,
            'Tỷ lệ dạy bù (so với nghỉ)',
            statistics.tiLeDayBu,
            Colors.green,
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 15),

          // Thống kê thanh toán
          Text(
            'Thông tin thanh toán',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 15),

          _buildPaymentRow(
            context,
            'Giờ giảng theo chuẩn',
            statistics.gioGiangTheoChuanDinh,
          ),
          const SizedBox(height: 10),
          _buildPaymentRow(
            context,
            'Giờ giảng vượt chuẩn',
            statistics.gioGiangVuotChuanDinh,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng giờ thanh toán',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '${statistics.tongGioThanhToan.toStringAsFixed(1)} giờ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.blue,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '${(value * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(
    BuildContext context,
    String label,
    double value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Text(
          '${value.toStringAsFixed(1)} giờ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

