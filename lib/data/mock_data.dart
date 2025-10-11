import 'models/user_model.dart';
import 'models/schedule_model.dart';

final List<UserAccount> userAccounts = [
  UserAccount(
    id: 'gv01',
    username: 'gv01',
    password: '123',
    email: 'gv@01',
    role: 'giangvien',
    fullName: 'Nguyễn Thị A',
    avatarPath: 'assets/images/teacher_logo.jpg',
    departmentId: 'dept_cs',
  ),
  UserAccount(
    id: 'dt01',
    username: 'dt01',
    password: '123',
    email: 'dt@01',
    role: 'phongdaotao',
    fullName: 'Phòng đào tạo TLU',
    avatarPath: 'assets/images/tlu_logo.png',
  ),
];

// --- DỮ-LIỆU LỊCH GIẢNG DẠY ---
// Dữ-liệu này mô-phỏng các buổi-học (ScheduleEntry) được lấy về cho giảng-viên 'gv01'
final List<ScheduleEntry> mockSchedules = [
  // Thứ 2, Ngày 29/9/2025
  ScheduleEntry(
    id: 'sched_001',
    courseId: 'course_pm_01',
    subjectName: 'Phát triển ứng dụng cho các thiết bị di động',
    className: '64KTPM3 + 64KTPM.NB',
    date: DateTime(2025, 9, 29),
    startTime: DateTime(2025, 9, 29, 7, 0),
    endTime: DateTime(2025, 9, 29, 8, 45),
    periods: [1, 2],
    roomId: '329-A2',
    instructorId: 'gv01',
    status: 'scheduled',
    studentCount: 45,
  ),
  ScheduleEntry(
    id: 'sched_002',
    courseId: 'course_nmlt_01',
    subjectName: 'Nhập môn lập trình',
    className: '64KTPM1',
    date: DateTime(2025, 9, 29),
    startTime: DateTime(2025, 9, 29, 8, 50),
    endTime: DateTime(2025, 9, 29, 10, 35),
    periods: [3, 4],
    roomId: '325-A2',
    instructorId: 'gv01',
    status: 'scheduled',
    studentCount: 50,
  ),

  // Thứ 3, Ngày 30/9/2025
  ScheduleEntry(
    id: 'sched_003',
    courseId: 'course_hm_01',
    subjectName: 'Học máy',
    className: '63KTPM2',
    date: DateTime(2025, 9, 30),
    startTime: DateTime(2025, 9, 30, 7, 0),
    endTime: DateTime(2025, 9, 30, 9, 35),
    periods: [1, 2, 3],
    roomId: '325-A2',
    instructorId: 'gv01',
    status: 'scheduled',
    studentCount: 40,
  ),

  ScheduleEntry(
    id: 'sched_003',
    courseId: 'course_hm_01',
    subjectName: 'Học máy',
    className: '63KTPM2',
    date: DateTime(2025, 9, 30),
    startTime: DateTime(2025, 9, 30, 7, 0),
    endTime: DateTime(2025, 9, 30, 9, 35),
    periods: [1, 2, 3],
    roomId: '325-A2',
    instructorId: 'gv01',
    status: 'scheduled',
    studentCount: 40,
  ),
  // THÊM BUỔI HỌC MỚI VÀO CÙNG NGÀY
  ScheduleEntry(
    id: 'sched_004',
    courseId: 'course_ctdl_01',
    subjectName: 'Cấu trúc dữ liệu',
    className: '64KTPM4',
    date: DateTime(2025, 9, 31), // Cùng ngày với "Học máy"
    startTime: DateTime(2025, 9, 31, 10, 0),
    endTime: DateTime(2025, 9, 31, 11, 45),
    periods: [5, 6],
    roomId: '401-A2',
    instructorId: 'gv01',
    status: 'scheduled',
    studentCount: 55,
  ),
];
