class ScheduleEntry {
  String id;
  String courseId;
  DateTime date;
  DateTime startTime;
  DateTime endTime;
  String roomId;
  String instructorId;
  String subjectName;
  String className;
  List<int> periods;
  String status;
  int studentCount;
  int numberOfPeriods;
  String? lessonContent;
  List<String>? documents;
  String? leaveReason;
  List<String>? leaveDocuments;
  DateTime? makeupDate;
  List<int>? makeupPeriods;
  String? makeupRoomId;
  String? makeupStatus;

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
    required this.numberOfPeriods,
    this.lessonContent,
    this.documents,
    this.leaveReason,
    this.leaveDocuments,
    this.makeupDate,
    this.makeupPeriods,
    this.makeupRoomId,
    this.makeupStatus,
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
