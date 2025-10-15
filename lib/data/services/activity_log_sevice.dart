import 'dart:math';
import '../models/activity_log_model.dart';

// Cần đảm bảo lớp ActivityLog của bạn đã được định nghĩa và import.
// import 'đường_dẫn_của_bạn/activity_log.dart';

class ActivityLogService {
  Future<List<ActivityLog>> fetchActivityLogSFromApi() async {
    return generateSampleLogs();
  }

  final Random _random = Random();

  // Danh sách các hành động mẫu
  final List<String> _actions = [
    'Giảng viên Nguyễn Văn A đã gửi yêu cầu nghỉ dạy',
    'Yêu cầu của Giảng viên Trần Thị B đã được duyệt',
    'Quản trị viên đã cập nhật thông tin môn học "Lập trình Web"',
    'Hệ thống tự động nhắc nhở phê duyệt đơn nghỉ dạy',
    'Giảng viên Lê Hữu C đã hoàn thành nhập điểm',
    'Tài khoản của phòng đào tạo đã đăng nhập',
  ];

  /// Tạo ra một DateTime ngẫu nhiên trong 24 giờ qua
  DateTime _generateRandomTime() {
    final now = DateTime.now();
    // Tạo mốc thời gian ngẫu nhiên trong 24 giờ (tối đa 86400 giây)
    final randomSeconds = _random.nextInt(86400);

    // Trừ đi số giây ngẫu nhiên từ thời điểm hiện tại
    return now.subtract(Duration(seconds: randomSeconds));
  }

  /// Tạo ra 50 bản mẫu ActivityLog
  List<ActivityLog> generateSampleLogs({int count = 50}) {
    final List<ActivityLog> logs = [];

    for (int i = 1; i <= count; i++) {
      final logId = 'LOG${i.toString().padLeft(4, '0')}';
      final randomAction = _actions[_random.nextInt(_actions.length)];

      final log = ActivityLog(
        id: logId,
        time: _generateRandomTime(),
        content: randomAction,
      );

      logs.add(log);
    }

    // Sắp xếp theo thời gian mới nhất (DESC) để mô phỏng nhật ký hoạt động
    logs.sort((a, b) => b.time.compareTo(a.time));

    return logs;
  }
}
