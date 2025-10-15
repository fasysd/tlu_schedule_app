import 'dart:math';
import '../models/lecturer_model.dart';

//Sevice test thử

class LecturerService {
  final Random _random = Random();
  final List<String> _firstNames = [
    'Nguyễn',
    'Trần',
    'Lê',
    'Phạm',
    'Hoàng',
    'Huỳnh',
  ];
  final List<String> _lastNames = [
    'Văn A',
    'Thị B',
    'Văn C',
    'Thị D',
    'Hữu E',
    'Thị F',
  ];

  // Hàm tạo ra một ngày sinh ngẫu nhiên
  DateTime _generateRandomDateOfBirth() {
    final now = DateTime.now();
    // Giảng viên từ 25 đến 60 tuổi
    final minAge = 25;
    final maxAge = 60;

    // Ngày sinh ngẫu nhiên trong khoảng tuổi
    final year = now.year - _random.nextInt(maxAge - minAge) - minAge;
    final month = _random.nextInt(12) + 1;
    final day = _random.nextInt(28) + 1; // Chọn 28 để tránh lỗi tháng 2

    return DateTime(year, month, day);
  }

  // Hàm tạo ra một số điện thoại ngẫu nhiên
  String _generateRandomPhoneNumber() {
    final prefix = ['090', '091', '098', '033', '070'][_random.nextInt(5)];
    final suffix = _random.nextInt(9000000) + 1000000; // 7 số ngẫu nhiên
    return '$prefix$suffix';
  }

  /// Tạo ra 50 bản mẫu LecturerModel
  List<LecturerModel> generateSampleLecturers({int count = 50}) {
    final List<LecturerModel> lecturers = [];

    for (int i = 1; i <= count; i++) {
      final firstName = _firstNames[_random.nextInt(_firstNames.length)];
      final lastName = _lastNames[_random.nextInt(_lastNames.length)];
      final fullName = '$firstName $lastName'; // Thêm số để tên duy nhất
      final id = 'GV${i.toString().padLeft(3, '0')}';

      final lecturer = LecturerModel(
        id: id,
        tenTaiKhoan: 'gv_${fullName.replaceAll(' ', '').toLowerCase()}',
        hoVaTen: fullName,
        ngaySinh: _generateRandomDateOfBirth(),
        soDienThoai: _generateRandomPhoneNumber(),
        soHocPhanDangDay: _random.nextInt(5) + 1, // Từ 1 đến 5 học phần
        soDonCanDuyet: _random.nextInt(3), // Từ 0 đến 2 đơn cần duyệt
      );

      lecturers.add(lecturer);
    }

    return lecturers;
  }
}
