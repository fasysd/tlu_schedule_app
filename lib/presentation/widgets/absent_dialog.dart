import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/mock_data.dart';

class AbsentStudentsDialog extends StatelessWidget {
  final Set<String> presentStudentIds;

  const AbsentStudentsDialog({super.key, required this.presentStudentIds});

  @override
  Widget build(BuildContext context) {
    final absentStudents = mockStudents
        .where((student) => !presentStudentIds.contains(student.id))
        .toList();

    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    const TextStyle tableTextStyle = TextStyle(fontSize: 14);
    const TextStyle headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: null,
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      actions: const [],
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ),
      backgroundColor: Colors.white,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.orange.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Nút X
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.orange.shade700,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Danh sách vắng',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            if (absentStudents.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  'Không có sinh viên nào vắng mặt.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              )
            else
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.55,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 8,
                    horizontalMargin: 8,
                    headingRowHeight: 40,
                    dataRowMinHeight: 48,
                    dataRowMaxHeight: 48,
                    columns: const [
                      DataColumn(label: Text('Họ tên', style: headerStyle)),
                      DataColumn(label: Text('MSV', style: headerStyle)),
                      DataColumn(label: Text('Ngày sinh', style: headerStyle)),
                    ],
                    rows: absentStudents.map((student) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(student.fullName, style: tableTextStyle),
                          ),
                          DataCell(Text(student.id, style: tableTextStyle)),
                          DataCell(
                            Text(
                              dateFormatter.format(student.dateOfBirth),
                              style: tableTextStyle,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
