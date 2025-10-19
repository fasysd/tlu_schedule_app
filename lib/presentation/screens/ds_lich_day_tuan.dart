import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// --- THAY ĐỔI IMPORT ---
import '../../data/models/schedule_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/schedule_service.dart';
import '../../data/services/static_data.dart';
// --- KẾT THÚC THAY ĐỔI ---

// --- THAY ĐỔI: Tạo instance cho service ---
final scheduleService = ScheduleService();
// --- KẾT THÚC THAY ĐỔI ---

class ScheduleCell {
  final String subjectName;
  final String room;
  final int period;
  final int dayOfWeek;

  ScheduleCell({
    required this.subjectName,
    required this.room,
    required this.period,
    required this.dayOfWeek,
  });

  factory ScheduleCell.fromScheduleEntry(
      ScheduleEntry entry,
      Course course,
      int period,
      ) {
    return ScheduleCell(
      subjectName: course.subjectName,
      room: entry.roomId,
      period: period,
      dayOfWeek: entry.date.weekday,
    );
  }
}

class WeeklySchedulePage extends StatefulWidget {
  final UserAccount user;

  const WeeklySchedulePage({super.key, required this.user});

  @override
  State<WeeklySchedulePage> createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  late Future<Map<int, Map<int, ScheduleCell>>> _scheduleMatrixFuture;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadScheduleForWeek();
  }

  void _loadScheduleForWeek() {
    setState(() {
      _scheduleMatrixFuture = _processSchedules();
    });
  }

  Future<Map<int, Map<int, ScheduleCell>>> _processSchedules() async {
    // --- THAY ĐỔI: Sử dụng staticCourses ---
    final instructorCourseIds = staticCourses
        .where((c) => c.instructorId == widget.user.id)
        .map((c) => c.id)
        .toSet();
    // --- KẾT THÚC THAY ĐỔI ---

    final allSchedules = await scheduleService.getAllSchedules();

    final startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final userSchedulesInWeek = allSchedules
        .where((s) =>
    instructorCourseIds.contains(s.courseId) &&
        s.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        s.date.isBefore(endOfWeek.add(const Duration(days: 1))))
        .toList();

    final Map<int, Map<int, ScheduleCell>> scheduleMatrix = {};

    for (final schedule in userSchedulesInWeek) {
      // --- THAY ĐỔI: Sử dụng staticCourses ---
      final course = staticCourses.firstWhere((c) => c.id == schedule.courseId);
      // --- KẾT THÚC THAY ĐỔI ---

      for (final period in schedule.periods) {
        if (scheduleMatrix[period] == null) {
          scheduleMatrix[period] = {};
        }
        final day = schedule.date.weekday;

        scheduleMatrix[period]![day] = ScheduleCell.fromScheduleEntry(
          schedule,
          course,
          period,
        );
      }
    }
    return scheduleMatrix;
  }

  void _goToPreviousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      _loadScheduleForWeek();
    });
  }

  void _goToNextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
      _loadScheduleForWeek();
    });
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
      _loadScheduleForWeek();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _loadScheduleForWeek();
      });
    }
  }

  Widget _buildWeekSelector() {
    final startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final formatter = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: _goToPreviousWeek, tooltip: 'Tuần trước'),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Column(
                    children: [
                      Text(
                        'Tuần từ ${formatter.format(startOfWeek)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'đến ${formatter.format(endOfWeek)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: _goToNextWeek, tooltip: 'Tuần sau'),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _goToToday,
            child: const Text('Về tuần này'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> days = ["", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "CN"];
    final List<Map<String, String>> periods = [
      {"name": "Tiết 1", "time": "(7:00 - 7:50)"},
      {"name": "Tiết 2", "time": "(7:55 - 8:45)"},
      {"name": "Tiết 3", "time": "(8:50 - 9:40)"},
      {"name": "Tiết 4", "time": "(9:45 - 10:35)"},
      {"name": "Tiết 5", "time": "(10:40 - 11:30)"},
      {"name": "Tiết 6", "time": "(11:35 - 12:25)"},
      {"name": "Tiết 7", "time": "(12:55 - 13:45)"},
      {"name": "Tiết 8", "time": "(13:50 - 14:40)"},
      {"name": "Tiết 9", "time": "(14:45 - 15:35)"},
      {"name": "Tiết 10", "time": "(15:40 - 16:30)"},
      {"name": "Tiết 11", "time": "(16:35 - 17:25)"},
      {"name": "Tiết 12", "time": "(17:30 - 18:20)"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch dạy theo tuần')),
      body: Column(
        children: [
          _buildWeekSelector(),
          Expanded(
            child: FutureBuilder<Map<int, Map<int, ScheduleCell>>>(
              future: _scheduleMatrixFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Lỗi: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Không có lịch dạy trong tuần này."));
                }

                final scheduleData = snapshot.data!;

                return SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          border: TableBorder.all(width: 1),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FixedColumnWidth(150.0), 2: FixedColumnWidth(150.0),
                            3: FixedColumnWidth(150.0), 4: FixedColumnWidth(150.0),
                            5: FixedColumnWidth(150.0), 6: FixedColumnWidth(150.0),
                            7: FixedColumnWidth(150.0),
                          },
                          children: [
                            TableRow(children: days.map((day) => _buildHeaderCell(day)).toList()),
                            ...List.generate(periods.length, (periodIndex) {
                              int currentPeriod = periodIndex + 1;
                              return TableRow(
                                children: List.generate(8, (dayIndex) {
                                  if (dayIndex == 0) {
                                    return _buildPeriodCell(
                                      periods[periodIndex]['name']!,
                                      periods[periodIndex]['time']!,
                                    );
                                  }
                                  final cellData = scheduleData[currentPeriod]?[dayIndex];
                                  return _buildScheduleCell(cellData);
                                }),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey[200],
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPeriodCell(String period, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Text(period, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildScheduleCell(ScheduleCell? cell) {
    if (cell == null) {
      return const SizedBox(height: 80);
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cell.subjectName,
            style: const TextStyle(fontSize: 13, color: Colors.indigo, fontWeight: FontWeight.bold),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            cell.room,
            style: const TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
