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
      ..._generateSchedulesForCourse(
        courseId: 'course_pm_01',
        semesterId: '1_2025_2026',
        sessions: [
          WeeklySession(
            dayOfWeek: DateTime.monday,
            periods: [1, 2],
            roomId: '329-A2',
          ),
          WeeklySession(
            dayOfWeek: DateTime.thursday,
            periods: [1, 2],
            roomId: '325-A2',
          ),
          // <-- Phòng học khác
        ],
      ),
      ..._generateSchedulesForCourse(
        courseId: 'course_nmlt_01',
        semesterId: '1_2025_2026',
        sessions: [
          WeeklySession(
            dayOfWeek: DateTime.monday,
            periods: [3, 4, 5],
            roomId: '401-A9',
          ),
        ],
      ),
      ..._generateSchedulesForCourse(
        courseId: 'course_hm_01',
        semesterId: '1_2025_2026',
        sessions: [
          WeeklySession(
            dayOfWeek: DateTime.friday,
            periods: [7, 8],
            roomId: '505-C1',
          ),
        ],
      ),
      ..._generateSchedulesForCourse(
        courseId: 'course_ctdl_01',
        semesterId: '2_2024_2025',
        sessions: [
          WeeklySession(
            dayOfWeek: DateTime.wednesday,
            periods: [1, 2, 3],
            roomId: '301-B5',
          ),
        ],
      ),
    ];
  }

  // SỬA ĐỔI HÀM NÀY
  List<ScheduleEntry> _generateSchedulesForCourse({
    required String courseId,
    required String semesterId,
    required List<WeeklySession> sessions,
  }) {
    final semester = staticSemesters.firstWhere((s) => s.id == semesterId);
    final DateTime semesterStart = semester.startDate;
    final DateTime semesterEnd = semester.endDate;

    final List<ScheduleEntry> schedules = [];
    int scheduleIdCounter = 0;

    // Lặp qua từng ngày trong khoảng thời gian của học kỳ
    for (
      DateTime day = semesterStart;
      day.isBefore(semesterEnd.add(const Duration(days: 1)));
      day = day.add(const Duration(days: 1))
    ) {
      for (final session in sessions) {
        if (day.weekday == session.dayOfWeek) {
          final periods = session.periods;
          final roomId = session.roomId;
          final numberOfPeriods = periods.length;

          final int startPeriod = periods.first;
          late DateTime startTime;

          if (startPeriod >= 1 && startPeriod <= 6) {
            final baseTime = DateTime(day.year, day.month, day.day, 7, 0);
            startTime = baseTime.add(Duration(minutes: (startPeriod - 1) * 55));
          } else {
            final baseTime = DateTime(day.year, day.month, day.day, 12, 55);
            startTime = baseTime.add(Duration(minutes: (startPeriod - 7) * 55));
          }

          final endTime = startTime.add(Duration(minutes: numberOfPeriods * 55 - 5));

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
