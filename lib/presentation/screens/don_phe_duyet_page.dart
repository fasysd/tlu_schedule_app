import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/models/schedule_model.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';
import 'package:tlu_schedule_app/data/services/schedule_service.dart';
import 'package:tlu_schedule_app/data/services/static_data.dart';
import 'package:tlu_schedule_app/presentation/widgets/common_header.dart';
import 'dang_ky_bu_page.dart';
import 'dang_ky_nghi_page.dart';

final scheduleService = ScheduleService();

class DonPheDuyetPage extends StatefulWidget {
  final UserAccount user;
  const DonPheDuyetPage({super.key, required this.user});

  @override
  State<DonPheDuyetPage> createState() => _DonPheDuyetPageState();
}

class _DonPheDuyetPageState extends State<DonPheDuyetPage> {
  late Future<List<ScheduleEntry>> _requestsFuture;
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _requestsFuture = _loadAllRequests();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  Future<List<ScheduleEntry>> _loadAllRequests() async {
    final allSchedules = await scheduleService.getAllSchedules();
    final requests = allSchedules.where((s) {
      return s.status == 'pending_leave' || s.makeupStatus == 'pending_makeup';
    }).toList();
    requests.sort(
          (a, b) => (b.requestCreationTime ?? b.date).compareTo(
        a.requestCreationTime ?? a.date,
      ),
    );
    return requests;
  }

  Map<String, dynamic> _getInfoForSchedule(ScheduleEntry schedule) {
    final course = staticCourses.firstWhere(
          (c) => c.id == schedule.courseId,
      orElse: () => Course(
        id: 'error',
        courseCode: 'N/A',
        subjectName: 'Không tìm thấy',
        className: 'N/A',
        instructorId: '',
        semesterId: '',
        courseType: '',
        totalPeriods: 0,
        credits: 0,
        studentCount: 0,
        numberOfPeriods: 0,
      ),
    );

    final lecturer = staticUsers.firstWhere(
          (u) => u.id == course.instructorId,
      orElse: () => UserAccount(
        id: 'error',
        username: '',
        password: '',
        email: '',
        role: '',
        fullName: 'Không tìm thấy',
        avatarPath: '',
        dateOfBirth: null,
      ),
    );

    return {'course': course, 'lecturer': lecturer};
  }

  void _navigateToDetail(
      BuildContext context,
      ScheduleEntry schedule,
      UserAccount lecturer,
      ) {
    if (schedule.status == 'pending_leave') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DangKyNghiPage(schedule: schedule, user: lecturer),
        ),
      );
    } else if (schedule.makeupStatus == 'pending_makeup') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DangKyBuPage(schedule: schedule, user: lecturer),
        ),
      );
    }
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('HH:mm\ndd/MM/yyyy').format(date);
  }

  String _getOriginalScheduleTime(ScheduleEntry schedule) {
    final date = DateFormat('dd/MM/yyyy').format(schedule.date);
    final startTime = DateFormat('HH:mm').format(schedule.startTime);
    final endTime = DateFormat('HH:mm').format(schedule.endTime);
    return '$date\n($startTime - $endTime)\nTiết ${schedule.periods.join('-')}';
  }

  String _getStatusText(ScheduleEntry schedule) {
    if (schedule.status == 'pending_leave') {
      return 'Chờ duyệt nghỉ';
    }
    if (schedule.makeupStatus == 'pending_makeup') {
      return 'Chờ duyệt bù';
    }
    return 'Không xác định';
  }

  Color _getStatusColor(ScheduleEntry schedule) {
    if (schedule.status == 'pending_leave') {
      return Colors.orange;
    }
    if (schedule.makeupStatus == 'pending_makeup') {
      return Colors.teal;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonHeader(user: widget.user),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Đơn xin phê duyệt',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Listener(
            onPointerSignal: (pointerSignal) {
              if (pointerSignal is PointerScrollEvent) {
                final newOffset = _horizontalScrollController.offset +
                    pointerSignal.scrollDelta.dy;
                _horizontalScrollController.jumpTo(
                  newOffset.clamp(
                    _horizontalScrollController.position.minScrollExtent,
                    _horizontalScrollController.position.maxScrollExtent,
                  ),
                );
              }
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: FutureBuilder<List<ScheduleEntry>>(
                future: _requestsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Không có đơn xin phê duyệt nào.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  final requests = snapshot.data!;
                  const headerStyle = TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  );
                  const cellStyle =
                  TextStyle(fontSize: 12, color: Colors.black54);

                  final List<String> headers = [
                    'Chi tiết',
                    'Tên lớp học phần',
                    'Giảng viên',
                    'Loại đơn',
                    'Phòng cũ',
                    'Phòng mới',
                    'Thời gian học',
                    'Thời gian lập đơn',
                    'Trạng thái đơn',
                  ];

                  return SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor:
                        WidgetStateProperty.all(Colors.grey.shade200),
                        border: TableBorder.all(
                            color: Colors.grey.shade400, width: 1),
                        columnSpacing: 24,
                        dataRowMinHeight: 70,
                        dataRowMaxHeight: 70,
                        columns: headers
                            .map(
                              (header) => DataColumn(
                            label: Center(
                              child: Text(
                                header,
                                style: headerStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                            .toList(),
                        rows: requests.map((schedule) {
                          final info = _getInfoForSchedule(schedule);
                          final Course course = info['course'];
                          final UserAccount lecturer = info['lecturer'];
                          final bool isMakeupRequest =
                              schedule.makeupStatus == 'pending_makeup';

                          return DataRow(
                            cells: [
                              DataCell(
                                Center(
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.visibility,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    tooltip: 'Xem chi tiết',
                                    onPressed: () => _navigateToDetail(
                                        context, schedule, lecturer),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    '${course.subjectName}\n(${course.className})',
                                    style: cellStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    lecturer.fullName,
                                    style: cellStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    isMakeupRequest ? 'Dạy bù' : 'Xin nghỉ',
                                    style: cellStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    schedule.roomId,
                                    style: cellStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    schedule.makeupRoomId ?? 'N/A',
                                    style: cellStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    _getOriginalScheduleTime(schedule),
                                    style: cellStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    _formatDateTime(
                                        schedule.requestCreationTime),
                                    style: cellStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(schedule)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getStatusText(schedule),
                                      style: cellStyle.copyWith(
                                          color: _getStatusColor(schedule),
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
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
            ),
          ),
        ),
      ],
    );
  }
}
