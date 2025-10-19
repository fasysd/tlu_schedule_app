import 'package:flutter/material.dart';
import '../../data/models/course_progress_model.dart';

class CardCourseProgress extends StatelessWidget {
  final CourseProgressModel courseProgress;

  const CardCourseProgress({
    super.key,
    required this.courseProgress,
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
          // Thông tin học phần
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.book,
                  color: Colors.blue[700],
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseProgress.tenHocPhan,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${courseProgress.maHocPhan} - ${courseProgress.maLopHocPhan}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Text(
                      'GV: ${courseProgress.tenGiangVien}',
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

          // Thống kê tiến độ
          Text(
            'Báo cáo tiến độ',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 15),

          // Grid layout cho các thống kê
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Tổng số buổi',
                  courseProgress.tongSoBuoi.toString(),
                  Icons.calendar_month,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Hoàn thành',
                  courseProgress.soBuoiHoanThanh.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Buổi nghỉ',
                  courseProgress.soBuoiNghi.toString(),
                  Icons.cancel,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Dạy bù',
                  courseProgress.soBuoiDayBu.toString(),
                  Icons.update,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Còn lại',
                  courseProgress.soBuoiConLai.toString(),
                  Icons.pending,
                  Colors.grey,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 15),

          // Biểu đồ tiến độ
          Text(
            'Tiến độ thực hiện',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 15),

          _buildProgressBar(
            context,
            'Tỷ lệ hoàn thành',
            courseProgress.tiLeHoanThanh,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildProgressBar(
            context,
            'Tỷ lệ nghỉ',
            courseProgress.tiLeNghi,
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildProgressBar(
            context,
            'Tỷ lệ dạy bù (so với nghỉ)',
            courseProgress.tiLeDayBu,
            Colors.green,
          ),

          const SizedBox(height: 15),

          // Thông báo cảnh báo nếu có
          if (courseProgress.soBuoiNghi > courseProgress.soBuoiDayBu)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Còn ${courseProgress.soBuoiNghi - courseProgress.soBuoiDayBu} buổi chưa dạy bù',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.orange[900],
                          ),
                    ),
                  ),
                ],
              ),
            ),

          if (courseProgress.tiLeHoanThanh >= 1.0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Học phần đã hoàn thành',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(77), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 5),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 14,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
}

