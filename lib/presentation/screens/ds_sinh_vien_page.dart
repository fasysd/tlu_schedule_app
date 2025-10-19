import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/models/student_model.dart';
import 'package:tlu_schedule_app/data/services/static_data.dart';

enum StudentListPageMode { viewOnly, attendance, absentList }

class StudentListPage extends StatefulWidget {
  final StudentListPageMode mode;
  final Set<String> presentStudentIds;
  final int totalStudentCount;

  const StudentListPage({
    super.key,
    required this.mode,
    this.presentStudentIds = const {},
    required this.totalStudentCount,
  });

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late Set<String> _tempPresentIds;

  @override
  void initState() {
    super.initState();
    _tempPresentIds = Set.from(widget.presentStudentIds);
  }

  @override
  Widget build(BuildContext context) {
    late List<Student> studentsToDisplay;
    late String pageTitle;
    late Color appBarColor;
    late bool isReadOnly;

    switch (widget.mode) {
      case StudentListPageMode.viewOnly:
        pageTitle = 'Danh sách sinh viên';
        appBarColor = const Color.fromRGBO(89, 141, 192, 1);
        studentsToDisplay = staticStudents
            .take(widget.totalStudentCount)
            .toList();
        isReadOnly = true;
        break;
      case StudentListPageMode.attendance:
        pageTitle = 'Điểm danh';
        appBarColor = const Color.fromRGBO(89, 141, 192, 1);
        studentsToDisplay = staticStudents
            .take(widget.totalStudentCount)
            .toList();
        isReadOnly = false;
        break;
      case StudentListPageMode.absentList:
        pageTitle = 'Danh sách vắng';
        appBarColor = Colors.orange.shade700;
        studentsToDisplay = staticStudents
            .take(widget.totalStudentCount)
            .where((student) => !_tempPresentIds.contains(student.id))
            .toList();
        isReadOnly = true;
        break;
    }

    final dateFormatter = DateFormat('dd/MM/yyyy');
    const TextStyle tableTextStyle = TextStyle(fontSize: 14);
    const TextStyle headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      body: studentsToDisplay.isEmpty
          ? const Center(
        child: Text(
          'Không có sinh viên nào trong danh sách này.',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      )
          : LayoutBuilder(
        builder: (context, constraints) {
          final double tableWidth = constraints.maxWidth;
          final int columnCount = isReadOnly ? 3 : 4;
          final double columnWidth = tableWidth / columnCount;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 0,
                horizontalMargin: 0,
                headingRowHeight: 40,
                dataRowMinHeight: 48,
                dataRowMaxHeight: 48,
                columns: [
                  if (!isReadOnly)
                    DataColumn(
                      label: SizedBox(
                        width: columnWidth,
                        child: const Center(
                          child: Text('Có mặt', style: headerStyle),
                        ),
                      ),
                    ),
                  DataColumn(
                    label: SizedBox(
                      width: columnWidth,
                      child: const Center(
                        child: Text('Họ tên', style: headerStyle),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: columnWidth,
                      child: const Center(
                        child: Text('MSV', style: headerStyle),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: columnWidth,
                      child: const Center(
                        child: Text('Ngày sinh', style: headerStyle),
                      ),
                    ),
                  ),
                ],
                rows: studentsToDisplay.map((student) {
                  return DataRow(
                    cells: [
                      if (!isReadOnly)
                        DataCell(
                          SizedBox(
                            width: columnWidth,
                            child: Center(
                              child: Checkbox(
                                value: _tempPresentIds.contains(
                                  student.id,
                                ),
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
                        ),
                      DataCell(
                        SizedBox(
                          width: columnWidth,
                          child: Center(
                            child: Text(
                              student.fullName,
                              style: tableTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: columnWidth,
                          child: Center(
                            child: Text(
                              student.id,
                              style: tableTextStyle,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: columnWidth,
                          child: Center(
                            child: Text(
                              dateFormatter.format(student.dateOfBirth),
                              style: tableTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: widget.mode == StudentListPageMode.attendance
          ? _buildSaveButton()
          : null,
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Lưu'),
        onPressed: () {
          Navigator.of(context).pop(_tempPresentIds);
        },
      ),
    );
  }
}
