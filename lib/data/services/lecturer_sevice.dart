import 'dart:math';
import '../models/lecturer_model.dart';

/// Service mô phỏng lấy dữ liệu giảng viên từ API (cố định, không random mỗi lần)
class LecturerService {
  final Random _random = Random();

  /// Mô phỏng API call (delay + xác suất lỗi)
  Future<Map<String, dynamic>> fetchLecturers() async {
    // Giả lập độ trễ mạng 1–2 giây
    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(1000)));

    // Giả lập 10% xác suất lỗi
    final isError = _random.nextInt(10) == 0;
    if (isError) {
      return {
        'statusCode': 500,
        'message': 'Internal Server Error (Fake API)',
        'data': null,
      };
    }

    // Nếu không lỗi → trả dữ liệu cố định
    final lecturers = _generateFixedLecturers();

    return {'statusCode': 200, 'message': 'Success', 'data': lecturers};
  }

  /// Dữ liệu giảng viên cố định
  List<LecturerModel> _generateFixedLecturers() {
    return [
      LecturerModel(
        maGiangVien: 'GV001',
        tenTaiKhoan: 'nguyenvana',
        hoVaTen: 'Nguyễn Văn A',
        email: 'nguyenvana@university.edu.vn',
        ngaySinh: DateTime(1980, 5, 12),
        soDienThoai: '0901234567',
        soHocPhanDangDay: 3,
        soDonNghiDayCanDuyet: 1,
        soDonDayBuCanDuyet: 2,
        tongSoBuoiDay: 100,
        soBuoiNghi: 5,
        soBuoiDayBu: 5,
      ),
      LecturerModel(
        maGiangVien: 'GV002',
        tenTaiKhoan: 'tranthib',
        hoVaTen: 'Trần Thị B',
        email: 'tranthib@university.edu.vn',
        ngaySinh: DateTime(1985, 7, 8),
        soDienThoai: '0912345678',
        soHocPhanDangDay: 2,
        soDonNghiDayCanDuyet: 2,
        soDonDayBuCanDuyet: 3,
        tongSoBuoiDay: 90,
        soBuoiNghi: 3,
        soBuoiDayBu: 2,
      ),
      LecturerModel(
        maGiangVien: 'GV003',
        tenTaiKhoan: 'lehuuc',
        hoVaTen: 'Lê Hữu C',
        email: 'lehuuc@university.edu.vn',
        ngaySinh: DateTime(1978, 10, 20),
        soDienThoai: '0987654321',
        soHocPhanDangDay: 4,
        soDonNghiDayCanDuyet: 0,
        soDonDayBuCanDuyet: 1,
        tongSoBuoiDay: 120,
        soBuoiNghi: 4,
        soBuoiDayBu: 4,
      ),
      LecturerModel(
        maGiangVien: 'GV004',
        tenTaiKhoan: 'phamthid',
        hoVaTen: 'Phạm Thị D',
        email: 'phamthid@university.edu.vn',
        ngaySinh: DateTime(1990, 3, 15),
        soDienThoai: '0331234567',
        soHocPhanDangDay: 1,
        soDonNghiDayCanDuyet: 1,
        soDonDayBuCanDuyet: 0,
        tongSoBuoiDay: 60,
        soBuoiNghi: 2,
        soBuoiDayBu: 1,
      ),
      LecturerModel(
        maGiangVien: 'GV005',
        tenTaiKhoan: 'hoangvanh',
        hoVaTen: 'Hoàng Văn H',
        email: 'hoangvanh@university.edu.vn',
        ngaySinh: DateTime(1988, 9, 9),
        soDienThoai: '0709876543',
        soHocPhanDangDay: 5,
        soDonNghiDayCanDuyet: 3,
        soDonDayBuCanDuyet: 2,
        tongSoBuoiDay: 110,
        soBuoiNghi: 6,
        soBuoiDayBu: 5,
      ),
    ];
  }
}
