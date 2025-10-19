import 'package:flutter/material.dart';
import '../../data/models/course_model.dart';

class CardCourse extends StatelessWidget {
  final CourseModel course;

  const CardCourse({
    super.key,
    required this.course,
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
          // Header với tên học phần và actions
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(230, 238, 248, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.book,
                            color: const Color.fromRGBO(76, 126, 170, 1),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.tenHocPhan,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '(${course.maHocPhan})',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Giảng viên: ${course.tenGiangVien}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Implement download functionality
                    },
                    icon: Icon(
                      Icons.download,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement more actions
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 15),

          // Thông tin chi tiết học phần
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.school,
                  'Số tín chỉ',
                  '${course.soTinChi} tín chỉ',
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.people,
                  'Số sinh viên',
                  '${course.soSinhVien} sinh viên',
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.calendar_today,
                  'Lịch học',
                  course.thoiGianHoc,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 15),

          // Thông tin thời gian và phòng học
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${course.gioBatDau} - ${course.gioKetThuc}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  'Phòng: ${course.phongHoc}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 15),

          // Thông tin tiến độ giảng dạy
          if (course.trangThai == 'Đang dạy') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiến độ giảng dạy: ${course.soBuoiDaDay}/${course.tongSoBuoi} buổi',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  '${course.tiLeHoanThanh.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: const Color.fromRGBO(76, 126, 170, 1),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: course.tiLeHoanThanh.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(76, 126, 170, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Thống kê chi tiết
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Đã dạy',
                    course.soBuoiDaDay.toString(),
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Nghỉ',
                    course.soBuoiNghi.toString(),
                    Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Đã bù',
                    course.soBuoiDayBu.toString(),
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Cần bù',
                    (course.soBuoiNghi - course.soBuoiDayBu).toString(),
                    Colors.black,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Còn lại',
                    course.soBuoiConLai.toString(),
                    const Color.fromRGBO(76, 126, 170, 1),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to course details
                  },
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('Chi tiết'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(76, 126, 170, 1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to edit course
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Chỉnh sửa'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(76, 126, 170, 1),
                    side: const BorderSide(color: Color.fromRGBO(76, 126, 170, 1)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement recreate schedule
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Tạo lại'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(76, 126, 170, 1),
                  side: const BorderSide(color: Color.fromRGBO(76, 126, 170, 1)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(230, 238, 248, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: const Color.fromRGBO(76, 126, 170, 1),
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color color;
    String text;
    
    switch (course.trangThai) {
      case 'Đang dạy':
        color = Colors.green;
        text = 'Đang dạy';
        break;
      case 'Đã kết thúc':
        color = Colors.grey;
        text = 'Đã kết thúc';
        break;
      default:
        color = Colors.orange;
        text = course.trangThai;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(77), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

