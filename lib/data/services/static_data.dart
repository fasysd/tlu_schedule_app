import '../models/user_model.dart';
import '../models/schedule_model.dart';
import '../models/student_model.dart';

final List<Course> staticCourses = [
  Course(
    id: 'course_pm_01',
    courseCode: 'CSE441',
    subjectName: 'Phát triển ứng dụng cho các thiết bị di động',
    className: '64KTPM3 + 64KTPM.NB',
    instructorId: 'gv01',
    semesterId: '1_2025_2026',
    courseType: 'Lý thuyết',
    totalPeriods: 45,
    credits: 3,
    studentCount: 45,
    numberOfPeriods: 2,
  ),
  Course(
    id: 'course_nmlt_01',
    courseCode: 'CSE101',
    subjectName: 'Nhập môn lập trình',
    className: '64KTPM1',
    instructorId: 'gv01',
    semesterId: '1_2025_2026',
    courseType: 'Lý thuyết + Thực hành',
    totalPeriods: 60,
    credits: 4,
    studentCount: 50,
    numberOfPeriods: 2,
  ),
  Course(
    id: 'course_hm_01',
    courseCode: 'CSE484',
    subjectName: 'Học máy',
    className: '63KTPM2',
    instructorId: 'gv01',
    semesterId: '1_2025_2026',
    courseType: 'Lý thuyết',
    totalPeriods: 45,
    credits: 3,
    studentCount: 40,
    numberOfPeriods: 3,
  ),
];

final List<Semester> staticSemesters = [
  Semester(
    id: '1_2024_2025',
    name: 'Học kỳ 1 năm học 2024-2025',
    startDate: DateTime(2024, 9, 5),
    endDate: DateTime(2025, 1, 15),
  ),
  Semester(
    id: '2_2024_2025',
    name: 'Học kỳ 2 năm học 2024-2025',
    startDate: DateTime(2025, 2, 10),
    endDate: DateTime(2025, 6, 25),
  ),
  Semester(
    id: '1_2025_2026',
    name: 'Học kỳ 1 năm học 2025-2026',
    startDate: DateTime(2025, 10, 8),
    endDate: DateTime(2026, 9, 20),
  ),
];

final List<UserAccount> staticUsers = [
  UserAccount(
    id: 'gv01',
    username: 'gv01',
    password: '123',
    email: 'gv@01',
    role: 'giangvien',
    fullName: 'Nguyễn Thị A',
    avatarPath: 'assets/images/teacher_logo.jpg',
    dateOfBirth: DateTime(1985, 5, 20),
    phone: '0947589365',
    departmentId: 'dept_cs',
    warningStatus: 'none',
  ),
  UserAccount(
    id: 'dt01',
    username: 'dt01',
    password: '123',
    email: 'dt@01',
    role: 'phongdaotao',
    fullName: 'Phòng đào tạo TLU',
    avatarPath: 'assets/images/defaultAvatar.png',
    dateOfBirth: null,
  ),
];

final List<Student> staticStudents = List.generate(
  55,
  (index) => Student(
    id: '64${123456 + index}',
    fullName:
        'Nguyễn Văn ${String.fromCharCode(65 + (index % 26))}${index + 1}',
    dateOfBirth: DateTime(2004, 5, 10 + index),
  ),
);
