import 'package:flutter/material.dart';
import '../../data/models/mo_hinh_thong_ke_giang_day.dart';

class TheThongKeGiangDay extends StatelessWidget {
  final MoHinhThongKeGiangDay teachingStatistics;

  const TheThongKeGiangDay({
    super.key,
    required this.teachingStatistics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với avatar và thông tin giảng viên
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).primaryColor.withAlpha(30),
                backgroundImage: teachingStatistics.duongDanAvatar.isNotEmpty
                    ? NetworkImage(teachingStatistics.duongDanAvatar)
                    : null,
                child: teachingStatistics.duongDanAvatar.isEmpty
                    ? Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teachingStatistics.hoVaTen,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mã GV: ${teachingStatistics.maGiangVien}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Text(
                      teachingStatistics.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Thống kê tổng quan
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      'Tổng tiết',
                      teachingStatistics.tongSoTiet.toString(),
                      Colors.blue,
                    ),
                    _buildStatItem(
                      context,
                      'Đã dạy',
                      teachingStatistics.soTietDaDay.toString(),
                      Colors.green,
                    ),
                    _buildStatItem(
                      context,
                      'Nghỉ',
                      teachingStatistics.soTietNghi.toString(),
                      Colors.red,
                    ),
                    _buildStatItem(
                      context,
                      'Dạy bù',
                      teachingStatistics.soTietDayBu.toString(),
                      Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      'Còn lại',
                      teachingStatistics.soTietConLai.toString(),
                      Colors.grey,
                    ),
                    _buildStatItem(
                      context,
                      'Hoàn thành',
                      '${teachingStatistics.tiLeHoanThanh.toStringAsFixed(1)}%',
                      teachingStatistics.tiLeHoanThanh >= 80 ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Thông tin học kỳ và năm học
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Học kỳ: ${teachingStatistics.hocKy} - ${teachingStatistics.namHoc}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Thông tin tài chính (nếu có)
          if (teachingStatistics.gioGiangTheoChuanDinh > 0) ...[
            Row(
              children: [
                Icon(Icons.account_balance_wallet, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Giờ chuẩn: ${teachingStatistics.gioGiangTheoChuanDinh.toStringAsFixed(1)}h',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Giờ tăng ca: ${teachingStatistics.gioTangCa.toStringAsFixed(1)}h',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiến độ giảng dạy',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: teachingStatistics.tiLeHoanThanh / 100,
                backgroundColor: Colors.grey[300],
                color: teachingStatistics.tiLeHoanThanh >= 80 
                    ? Colors.green 
                    : teachingStatistics.tiLeHoanThanh >= 60 
                        ? Colors.orange 
                        : Colors.red,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${teachingStatistics.tiLeHoanThanh.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}
