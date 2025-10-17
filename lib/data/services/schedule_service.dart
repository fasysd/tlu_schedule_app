import '../models/schedule_model.dart';
import 'static_data.dart';

class WeeklySession {
  final int dayOfWeek;
  final List<int> periods;
  final String roomId;

  WeeklySession({
    required this.dayOfWeek,
    required this.periods,
    required this.roomId,
  });
}

class ScheduleService {
  List<ScheduleEntry>? _cachedSchedules;

  Future<List<ScheduleEntry>> getAllSchedules() async {
    if (_cachedSchedules != null) {
      return _cachedSchedules!;
    }
    await Future.delayed(const Duration(milliseconds: 100));
    _cachedSchedules = _initializeAllSchedules();
    return _cachedSchedules!;
  }

  // SỬA ĐỔI HÀM NÀY
  List<ScheduleEntry> _initializeAllSchedules() {
    return [
      // Ví dụ: Môn Lập trình di động có 2 buổi/tuần với phòng học khác nhau
      ..._generateSchedulesForCourse(
        courseId: 'course_pm_01',
        semesterId: '1_2025_2026',
        sessions: [
          WeeklySession(dayOfWeek: DateTime.monday, periods: [1, 2], roomId: '329-A2'),
          WeeklySession(dayOfWeek: DateTime.thursday, periods: [1, 2], roomId: '325-A2'), // <-- Phòng học khác
        ],
      ),
      // Môn Nhập môn lập trình chỉ có 1 buổi/tuần
      ..._generateSchedulesForCourse(
        courseId: 'course_nmlt_01',
        semesterId: '1_2025_2026',
        sessions: [
          WeeklySession(dayOfWeek: DateTime.tuesday, periods: [3, 4, 5], roomId: '401-A9'),
        ],
      ),
      ..._generateSchedulesForCourse(
        courseId: 'course_hm_01',
        semesterId: '1_2025_2026',
        sessions: [
          WeeklySession(dayOfWeek: DateTime.friday, periods: [7, 8], roomId: '505-C1'),
        ],
      ),
      ..._generateSchedulesForCourse(
        courseId: 'course_ctdl_01',
        semesterId: '2_2024_2025',
        sessions: [
          WeeklySession(dayOfWeek: DateTime.wednesday, periods: [1, 2, 3], roomId: '301-B5'),
        ],
      ),
    ];
  }

  // SỬA ĐỔI HÀM NÀY
  List<ScheduleEntry> _generateSchedulesForCourse({
    required String courseId,
    required String semesterId,
    required List<WeeklySession> sessions, // <-- Thay đổi tham số
  }) {
    final semester = staticSemesters.firstWhere((s) => s.id == semesterId);
    final DateTime semesterStart = semester.startDate;
    final DateTime semesterEnd = semester.endDate;

    final List<ScheduleEntry> schedules = [];
    int scheduleIdCounter = 0;

    // Lặp qua từng ngày trong khoảng thời gian của học kỳ
    for (DateTime day = semesterStart;
    day.isBefore(semesterEnd.add(const Duration(days: 1)));
    day = day.add(const Duration(days: 1))) {
      // Tìm xem có session nào khớp với ngày hiện tại không
      for (final session in sessions) {
        if (day.weekday == session.dayOfWeek) {
          final periods = session.periods;
          final roomId = session.roomId;
          final numberOfPeriods = periods.length;

          // --- Phần logic tính toán thời gian giữ nguyên ---
          final int startPeriod = periods.first;
          late DateTime startTime;
          if (startPeriod <= 6) {
            startTime = DateTime(day.year, day.month, day.day, 6, 0)
                .add(Duration(minutes: (startPeriod * 55) - 55));
          } else {
            startTime = DateTime(day.year, day.month, day.day, 11, 55)
                .add(Duration(minutes: ((startPeriod - 6) * 55)));
          }
          final endTime =
          startTime.add(Duration(minutes: numberOfPeriods * 50 - 5));

          final scheduleId =
              '${courseId}_${scheduleIdCounter.toString().padLeft(3, '0')}';
          schedules.add(
            ScheduleEntry(
              id: scheduleId,
              courseId: courseId,
              date: day,
              startTime: startTime,
              endTime: endTime,
              periods: periods,
              numberOfPeriods: numberOfPeriods,
              roomId: roomId,
              status: day.isBefore(DateTime.now()) ? 'missed' : 'scheduled',
              lessonContent: day.isBefore(DateTime.now())
                  ? 'Nội dung buổi học ngày ${day.day}/${day.month}/${day.year}.'
                  : null,
            ),
          );
          scheduleIdCounter++;
        }
      }
    }
    return schedules;
  }
}
