// E:/Apps/Flutter/project/tlu_schedule_app/lib/data/mock_data.dart
// FILE NÀY ĐÓNG VAI TRÒ TẬP HỢP DỮ LIỆU TỪ CÁC NGUỒN

import 'models/user_model.dart';
import 'models/schedule_model.dart';
import 'models/student_model.dart';
import 'services/static_data.dart'; // Import dữ liệu tĩnh
import 'services/schedule_service.dart'; // Import service để lấy dữ liệu động

// =================================================================================
// XUẤT RA CÁC BIẾN DỮ LIỆU ĐỂ UI SỬ DỤNG
// =================================================================================

// Dữ liệu tĩnh
final List<Course> mockCourses = staticCourses;
final List<Semester> mockSemesters = staticSemesters;
final List<UserAccount> userAccounts = staticUsers;
final List<Student> mockStudents = staticStudents;

// Dữ liệu động (sẽ được lấy từ service)
// Khởi tạo một instance của service để các file khác có thể truy cập
final ScheduleService scheduleService = ScheduleService();

// BIẾN mockSchedules ĐÃ ĐƯỢC XÓA.
// Mọi truy cập đến lịch học phải thông qua `scheduleService.getAllSchedules()`.
