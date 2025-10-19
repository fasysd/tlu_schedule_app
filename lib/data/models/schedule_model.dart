class Course {
  final String id;
  final String courseCode;
  final String subjectName;
  final String className;
  final String instructorId;
  final String semesterId;
  final String courseType;
  final int totalPeriods;
  final int credits;
  final int studentCount;
  final int numberOfPeriods;

  Course({
    required this.id,
    required this.courseCode,
    required this.subjectName,
    required this.className,
    required this.instructorId,
    required this.semesterId,
    required this.courseType,
    required this.totalPeriods,
    required this.credits,
    required this.studentCount,
    required this.numberOfPeriods,
  });
}

class ScheduleEntry {
  final String id;
  final String courseId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final List<int> periods;
  final int numberOfPeriods;
  final String roomId;

  String status;
  String? lessonContent;
  List<String>? documents;
  String? leaveReason;
  List<String>? leaveDocuments;
  DateTime? makeupDate;
  List<int>? makeupPeriods;
  String? makeupRoomId;
  String? makeupStatus;
  DateTime? requestCreationTime;

  ScheduleEntry({
    required this.id,
    required this.courseId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.periods,
    required this.numberOfPeriods,
    required this.roomId,
    required this.status,
    this.lessonContent,
    this.documents,
    this.leaveReason,
    this.leaveDocuments,
    this.makeupDate,
    this.makeupPeriods,
    this.makeupRoomId,
    this.makeupStatus,
    this.requestCreationTime,
  });
}

class Semester {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  Semester({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });
}
