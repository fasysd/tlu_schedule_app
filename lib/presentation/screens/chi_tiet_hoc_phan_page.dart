import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/models/schedule_model.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';
import 'package:tlu_schedule_app/presentation/screens/dang_ky_bu_page.dart';
import 'package:tlu_schedule_app/presentation/screens/ds_sinh_vien_page.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  final UserModel user;

  final List<ScheduleEntry> schedules;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.user,
    required this.schedules,
  });

  String _getVietnameseDayOfWeek(DateTime date) {
    const days = [
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'Chủ Nhật',
    ];
    return days[date.weekday - 1];
  }

  void _navigateToStudentListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentListPage(
          mode: StudentListPageMode.viewOnly,
          totalStudentCount: course.studentCount,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (schedules.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Lỗi")),
        body: Center(child: Text("Không tìm thấy lịch học cho học phần này.")),
      );
    }
    schedules.sort((a, b) => a.date.compareTo(b.date));

    final taughtPeriods = schedules
        .where((s) => s.status != 'missed')
        .fold<int>(0, (prev, e) => prev + e.numberOfPeriods);
    final missedPeriods = schedules
        .where((s) => s.status == 'missed')
        .fold<int>(0, (prev, e) => prev + e.numberOfPeriods);
    final makeupPeriods = schedules
        .where((s) => s.makeupStatus != null)
        .fold<int>(0, (prev, e) => prev + (e.makeupPeriods?.length ?? 0));
    final attendanceRate = (course.totalPeriods > 0)
        ? (taughtPeriods / course.totalPeriods * 100).toStringAsFixed(0)
        : 0;

    final Map<String, Map<String, String>> scheduleInfo = {};
    for (var schedule in schedules) {
      final dayOfWeek = _getVietnameseDayOfWeek(schedule.date);
      final periodsString = 'Tiết ${schedule.periods.join('-')}';
      final key = '$dayOfWeek: $periodsString';

      if (!scheduleInfo.containsKey(key)) {
        scheduleInfo[key] = {
          'time': '• $dayOfWeek: $periodsString',
          'room': '• ${schedule.roomId}',
          'instructor': '• ${user.fullName}',
        };
      }
    }

    ScheduleEntry? firstEligibleMissedSchedule;
    bool isButtonEnabled = false;

    if (missedPeriods > 0) {
      try {
        final firstMissedSchedule = schedules.firstWhere(
          (s) => s.status == 'missed',
        );
        final now = DateTime.now();
        final isWithin7Days =
            now.difference(firstMissedSchedule.date).inDays <= 7;

        if (isWithin7Days) {
          firstEligibleMissedSchedule = firstMissedSchedule;
          isButtonEnabled = true;
        }
      } catch (e) {
        // Không tìm thấy buổi nghỉ, không làm gì cả, isButtonEnabled sẽ vẫn là false.
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(89, 141, 192, 1),
        elevation: 0,
        title: const Text(
          'Chi tiết học phần',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Thông tin học phần'),
            _buildInfoRow(
              context,
              label: 'Mã học phần:',
              value: course.courseCode,
            ),
            _buildInfoRow(
              context,
              label: 'Tên học phần:',
              value: course.subjectName,
            ),
            _buildInfoRow(
              context,
              label: 'Lớp học phần:',
              value: course.className,
            ),
            _buildInfoRow(
              context,
              label: 'Dạng môn:',
              value: course.courseType,
            ),
            _buildInfoRow(
              context,
              label: 'Số tiết:',
              value: '${course.totalPeriods} (${course.credits} tín chỉ)',
            ),
            _buildInfoRow(
              context,
              label: 'Giảng viên:',
              value: '${user.fullName} - ${user.id.toUpperCase()}',
            ),
            _buildInfoRow(
              context,
              label: 'Thời gian:',
              value:
                  '${DateFormat('dd/MM/yyyy').format(schedules.first.date)} -> ${DateFormat('dd/MM/yyyy').format(schedules.last.date)}',
            ),
            _buildInfoRow(
              context,
              label: 'Sinh viên:',
              value: '${course.studentCount}',
              trailing: SizedBox(
                height: 24,
                child: ElevatedButton(
                  onPressed: () => _navigateToStudentListPage(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    backgroundColor: const Color.fromRGBO(89, 141, 192, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Danh sách',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ),

            _buildSectionTitle(context, 'Lịch học phần'),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
              },
              children: [
                const TableRow(
                  children: [
                    Text(
                      'Thời gian',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Phòng học',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                ...scheduleInfo.values.map(
                  (info) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          info['time']!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          info['room']!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            _buildSectionTitle(context, 'Quá trình học phần'),
            _buildInfoRow(
              context,
              label: 'Số tiết đã dạy:',
              value: '$taughtPeriods',
            ),
            _buildInfoRow(
              context,
              label: 'Số tiết đã nghỉ:',
              value: '$missedPeriods',
            ),
            _buildInfoRow(
              context,
              label: 'Số tiết đã bù:',
              value: '$makeupPeriods',
            ),
            _buildInfoRow(
              context,
              label: 'Tỉ lệ chuyên cần:',
              value: '$attendanceRate%',
            ),
            const SizedBox(height: 24),
            if (missedPeriods > 0)
              Center(
                child: ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DangKyBuPage(
                                schedule: firstEligibleMissedSchedule!,
                                user: user,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(89, 141, 192, 1),
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Đăng ký bù',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
