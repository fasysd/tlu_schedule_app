import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/models/course_model.dart';

class CardCourse extends StatelessWidget {
  final CourseModel courseModel;
  const CardCourse({super.key, required this.courseModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Mở chi tiết học phần')));
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Học phần: ${courseModel.tenHocPhan}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                'Lớp: ${courseModel.lopHoc}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
              const Divider(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Thời gian:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Phòng học:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '(${DateFormat('dd/MM/yyyy').format(courseModel.ngayBatDau)} -> ${DateFormat('dd/MM/yyyy').format(courseModel.ngayKetThuc)})',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),

              ...courseModel.lichHoc.entries.map((entry) {
                final scheduleKey = entry.key;
                final rooms = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          scheduleKey,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '• ${rooms.join(', ')}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
