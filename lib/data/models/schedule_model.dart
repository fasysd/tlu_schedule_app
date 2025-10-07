class ScheduleEntry {
  final String id;
  final String courseId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String roomId;
  final String instructorId;
  final String subjectName;
  final String className;
  final List<int> periods;
  final String status;
  final int studentCount;

  ScheduleEntry({
    required this.id,
    required this.courseId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.roomId,
    required this.instructorId,
    required this.subjectName,
    required this.className,
    required this.periods,
    required this.status,
    required this.studentCount,
  });
}

class Course {
  final String id;
  final String subjectName;
  final String className;
  final String semesterId;
  final String instructorId;
  final int studentCount;
  final int requiredSessions;

  Course({
    required this.id,
    required this.subjectName,
    required this.className,
    required this.semesterId,
    required this.instructorId,
    required this.studentCount,
    required this.requiredSessions,
  });
}
