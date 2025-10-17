import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/mock_data.dart';

class AttendanceDialog extends StatefulWidget {
  final Set<String> presentStudentIds;
  final bool isReadOnly;

  const AttendanceDialog({
    super.key,
    required this.presentStudentIds,
    this.isReadOnly = false,
  });

  @override
  State<AttendanceDialog> createState() => _AttendanceDialogState();
}

class _AttendanceDialogState extends State<AttendanceDialog> {
  late Set<String> _tempPresentIds;

  @override
  void initState() {
    super.initState();
    _tempPresentIds = Set.from(widget.presentStudentIds);
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    const TextStyle tableTextStyle = TextStyle(fontSize: 14);
    const TextStyle headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

    return AlertDialog(
      title: null,
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.only(bottom: 16.0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: const Color.fromRGBO(89, 141, 192, 1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color.fromRGBO(89, 141, 192, 1),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.isReadOnly ? 'Danh sách sinh viên' : 'Điểm danh',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
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
                  columns: [
                    if (!widget.isReadOnly)
                      const DataColumn(
                        label: Expanded(
                          child: Text('Có mặt', textAlign: TextAlign.center, style: headerStyle),
                        ),
                      ),
                    const DataColumn(label: Text('Họ tên', style: headerStyle)),
                    const DataColumn(label: Text('MSV', style: headerStyle)),
                    const DataColumn(label: Text('Ngày sinh', style: headerStyle)),
                  ],
                  rows: mockStudents.map((student) {
                    return DataRow(
                      cells: [
                        if (!widget.isReadOnly)
                          DataCell(
                            Center(
                              child: Checkbox(
                                value: _tempPresentIds.contains(student.id),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _tempPresentIds.add(student.id);
                                    } else {
                                      _tempPresentIds.remove(student.id);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        DataCell(Text(student.fullName, style: tableTextStyle)),
                        DataCell(Text(student.id, style: tableTextStyle)),
                        DataCell(Text(dateFormatter.format(student.dateOfBirth), style: tableTextStyle)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: widget.isReadOnly
          ? null
          : <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Lưu'),
          onPressed: () {
            Navigator.of(context).pop(_tempPresentIds);
          },
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
