import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/schedule_model.dart';
import '../../data/models/user_model.dart';
import '../../data/mock_data.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class DangKyNghiPage extends StatefulWidget {
  final ScheduleEntry schedule;
  final UserAccount user;

  const DangKyNghiPage({super.key, required this.schedule, required this.user});

  @override
  State<DangKyNghiPage> createState() => _DangKyNghiPageState();
}

class _DangKyNghiPageState extends State<DangKyNghiPage> {
  // --- THÊM MỚI: Biến để lưu thông tin học phần ---
  late Course _course;
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<File> _selectedFiles = [];

  @override
  void initState() {
    super.initState();

    // --- THAY ĐỔI: Tìm học phần tương ứng khi khởi tạo ---
    try {
      _course = mockCourses.firstWhere((c) => c.id == widget.schedule.courseId);
    } catch (e) {
      // Xử lý lỗi nếu không tìm thấy Course, mặc dù điều này không nên xảy ra
      _course = Course(
        id: 'error', courseCode: 'N/A', subjectName: 'Không tìm thấy học phần',
        className: 'N/A', instructorId: '', semesterId: '', courseType: '',
        totalPeriods: 0, credits: 0, studentCount: 0,
      );
    }

    // Luôn tải lý do và file đã có (nếu có) để người dùng có thể xem và sửa
    _reasonController.text = widget.schedule.leaveReason ?? '';
    if (widget.schedule.leaveDocuments != null) {
      // Tạo đối tượng File giả từ tên file đã lưu để hiển thị
      _selectedFiles.addAll(
        widget.schedule.leaveDocuments!.map((fileName) => File(fileName)),
      );
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _getVietnameseDayOfWeek(DateTime date) {
    const days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ Nhật'];
    return days[date.weekday - 1];
  }

  // --- CÁC HÀM XỬ LÝ FILE ---
  Future<void> _pickFile() async {
    FocusScope.of(context).unfocus();
    try {
      FilePickerResult? result =
      await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.paths.map((path) => File(path!)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn file: $e')),
      );
    }
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

  Widget _buildAttachmentSection() {
    return Column(
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
              tooltip: 'Đính kèm minh chứng',
            ),
            if (_selectedFiles.isEmpty)
              const Expanded(
                child: Text(
                  'Đính kèm minh chứng...',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
            if (_selectedFiles.isNotEmpty)
              Expanded(
                child: _buildFileChip(_selectedFiles.first),
              ),
          ],
        ),
        if (_selectedFiles.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _selectedFiles
                  .skip(1)
                  .map((file) => _buildFileChip(file))
                  .toList(),
            ),
          ),
      ],
    );
  }

  void _submitLeaveRequest() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      // NOTE: Đây là nơi bạn sẽ gọi service để cập nhật dữ liệu trên server (Firebase)
      // Tạm thời, chúng ta chỉ cập nhật trên đối tượng widget.schedule
      // để UI trang trước đó có thể cập nhật khi pop về.
      setState(() {
        widget.schedule.status = 'pending_leave';
        widget.schedule.leaveReason = _reasonController.text;
        widget.schedule.leaveDocuments = _selectedFiles
            .map((file) => file.path.split(Platform.pathSeparator).last)
            .toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật đơn xin nghỉ thành công.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool isUpdate = widget.schedule.status == 'pending_leave';
    final String buttonLabel = isUpdate ? 'Cập nhật đơn' : 'Gửi đơn';

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký nghỉ')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- THAY ĐỔI: Lấy thông tin từ _course ---
              Text(
                'Học phần: ${_course.subjectName} (${_course.className})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                icon: Icons.access_time,
                label: 'Thời gian:',
                child: Text(
                  ' ${DateFormat('HH:mm').format(widget.schedule.startTime)} - ${DateFormat('HH:mm').format(widget.schedule.endTime)}',
                  style: const TextStyle(color: Colors.red, fontSize: 21),
                ),
              ),
              _buildInfoRow(
                context,
                icon: Icons.location_on_outlined,
                label: 'Phòng học:',
                child: Text(' ${widget.schedule.roomId}'),
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
                icon: Icons.person_outline,
                label: 'Giảng viên:',
                child: Text(
                  ' ${widget.user.fullName} - ${widget.user.id.toUpperCase()}',
                ),
              ),
              const Divider(height: 32, thickness: 1),
              _buildSectionTitle(
                context,
                'Lý do xin nghỉ:',
                Icons.edit_note,
              ),
              const SizedBox(height: 8),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _reasonController,
                  maxLines: 5,
                  minLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: 'Nhập lý do xin nghỉ của bạn...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.4),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập lý do xin nghỉ.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Phần đính kèm file
              _buildAttachmentSection(),
              const SizedBox(height: 32),
              // Nút bấm luôn hiển thị
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitLeaveRequest,
                  icon: const Icon(Icons.send),
                  label: Text(buttonLabel),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                ),
              ),
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
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
