import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:tlu_schedule_app/data/models/schedule_model.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';
import 'package:tlu_schedule_app/data/services/static_data.dart';
import 'package:tlu_schedule_app/presentation/widgets/schedule_status_widget.dart';
import 'dang_ky_nghi_page.dart';
import 'dang_ky_bu_page.dart';
import 'ds_sinh_vien_page.dart';

class ChiTietBuoiHocPage extends StatefulWidget {
  final ScheduleEntry schedule;
  final UserModel user;

  const ChiTietBuoiHocPage({
    super.key,
    required this.schedule,
    required this.user,
  });

  @override
  State<ChiTietBuoiHocPage> createState() => _ChiTietBuoiHocPageState();
}

class _ChiTietBuoiHocPageState extends State<ChiTietBuoiHocPage> {
  late Course _course;
  late String _originalLessonContent;
  late TextEditingController _contentController;
  bool _isContentChanged = false;

  Set<String> _presentStudentIds = {};

  final List<File> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    try {
      _course = staticCourses.firstWhere(
        (c) => c.id == widget.schedule.courseId,
      );
    } catch (e) {
      _course = Course(
        id: 'error',
        courseCode: 'N/A',
        subjectName: 'Không tìm thấy học phần',
        className: 'N/A',
        instructorId: '',
        semesterId: '',
        courseType: '',
        totalPeriods: 0,
        credits: 0,
        studentCount: 0,
        numberOfPeriods: 0,
      );
    }

    _originalLessonContent = widget.schedule.lessonContent ?? '';
    _contentController = TextEditingController(text: _originalLessonContent);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

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

  void _saveChanges() {
    widget.schedule.lessonContent = _contentController.text;

    setState(() {
      _originalLessonContent = _contentController.text;
      _isContentChanged = false;
    });

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu thay đổi nội dung.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToAttendancePage() async {
    final updatedPresentIds = await Navigator.push<Set<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => StudentListPage(
          mode: StudentListPageMode.attendance,
          presentStudentIds: _presentStudentIds,
          totalStudentCount: _course.studentCount,
        ),
      ),
    );

    if (updatedPresentIds != null) {
      setState(() {
        _presentStudentIds = updatedPresentIds;
      });
    }
  }

  void _navigateToAbsentListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentListPage(
          mode: StudentListPageMode.absentList,
          presentStudentIds: _presentStudentIds,
          totalStudentCount: _course.studentCount,
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    FocusScope.of(context).unfocus();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.paths.map((path) => File(path!)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi chọn file: $e')));
    }
  }

  void _navigateToLeaveRequest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DangKyNghiPage(schedule: widget.schedule, user: widget.user),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  Widget _buildActionButtons() {
    if (widget.schedule.status == 'pending_leave') {
      return Center(
        child: ElevatedButton.icon(
          onPressed: _navigateToLeaveRequest,
          icon: const Icon(Icons.description_outlined),
          label: const Text('Xem đơn đã gửi'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade700,
          ),
        ),
      );
    } else if (widget.schedule.status == 'missed') {
      final isPendingMakeup = widget.schedule.makeupStatus == 'pending_makeup';

      final now = DateTime.now();
      final bool isWithin7Days =
          now.difference(widget.schedule.date).inDays <= 7;

      final bool isButtonEnabled = isWithin7Days || isPendingMakeup;

      return Center(
        child: ElevatedButton.icon(
          onPressed: isButtonEnabled ? _showMakeupRequestDialog : null,
          icon: Icon(isPendingMakeup ? Icons.edit_calendar : Icons.add_task),
          label: Text(isPendingMakeup ? 'Xem đơn dạy bù' : 'Đăng ký bù'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isPendingMakeup ? Colors.teal : Colors.green,
            disabledBackgroundColor: Colors.grey.shade400,
          ),
        ),
      );
    } else {
      return Center(
        child: ElevatedButton(
          onPressed: _navigateToLeaveRequest,
          child: const Text('Đăng ký nghỉ'),
        ),
      );
    }
  }

  void _showMakeupRequestDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DangKyBuPage(schedule: widget.schedule, user: widget.user),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết buổi học'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Học phần: ${_course.subjectName} (${_course.className})',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                icon: Icons.access_time,
                label: 'Thời gian:',
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 21),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              ' ${DateFormat('HH:mm').format(widget.schedule.startTime)} - ${DateFormat('HH:mm').format(widget.schedule.endTime)}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildInfoRow(
                context,
                icon: Icons.location_on_outlined,
                label: 'Phòng học:',
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(' ${widget.schedule.roomId}'),
                ),
              ),
              _buildInfoRow(
                context,
                icon: Icons.calendar_today_outlined,
                child: Text(
                  'Tiết ${widget.schedule.periods.join('-')}, ${_getVietnameseDayOfWeek(widget.schedule.date)}, Ngày ${DateFormat('dd/MM/yyyy').format(widget.schedule.date)}',
                ),
              ),
              _buildInfoRow(
                context,
                icon: Icons.more_horiz,
                label: 'Trạng thái:',
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: ScheduleStatusWidget(
                    status: widget.schedule.status,
                    fontSize: 20,
                  ),
                ),
              ),
              _buildInfoRow(
                context,
                icon: Icons.person_outline,
                label: 'Giảng viên:',
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    ' ${widget.user.fullName} - ${widget.user.id.toUpperCase()}',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildStudentInfo(context),
              const SizedBox(height: 10),
              _buildSectionTitle(
                context,
                'Nội dung buổi học:',
                Icons.description_outlined,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                minLines: 3,
                onChanged: (newValue) {
                  setState(() {
                    _isContentChanged = newValue != _originalLessonContent;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: 'Nhập nội dung buổi học...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.4),
              ),
              _buildAttachmentSection(),
              if (_isContentChanged)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.save, size: 20),
                      label: const Text('Lưu nội dung'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    String? label,
    Widget? child,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(icon, size: 25, color: textTheme.bodySmall?.color),
          ),
          const SizedBox(width: 12),
          if (label != null)
            Text(label, style: textTheme.bodyMedium?.copyWith(fontSize: 20)),
          if (child != null)
            Expanded(
              child: DefaultTextStyle(
                style: textTheme.bodyMedium!.copyWith(fontSize: 20),
                child: child,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 25,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.folder_open_outlined,
                  size: 28,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: _pickFile,
                tooltip: 'Đính kèm tài liệu',
              ),
              const SizedBox(width: 8),
              if (_selectedFiles.isEmpty)
                const Expanded(
                  child: Text(
                    'Đính kèm tài liệu buổi học...',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              if (_selectedFiles.isNotEmpty)
                Expanded(child: _buildFileChip(_selectedFiles.first)),
            ],
          ),
          if (_selectedFiles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _selectedFiles.map(_buildFileChip).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFileChip(File file) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_drive_file, color: Colors.blue.shade700, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              file.path.split(Platform.pathSeparator).last,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFiles.remove(file);
                });
              },
              customBorder: const CircleBorder(),
              child: const Icon(Icons.close, color: Colors.red, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentInfo(BuildContext context) {
    final ButtonStyle smallButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    return Row(
      children: [
        const Icon(Icons.school_outlined),
        const SizedBox(width: 8),
        Text('Sinh viên: ${_presentStudentIds.length}/${_course.studentCount}'),
        const Spacer(),
        ElevatedButton(
          onPressed: _navigateToAttendancePage,
          style: smallButtonStyle,
          child: const Text('Điểm danh'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _navigateToAbsentListPage,
          style: smallButtonStyle.copyWith(
            backgroundColor: MaterialStateProperty.all(Colors.orange),
          ),
          child: const Text('Vắng'),
        ),
      ],
    );
  }
}
