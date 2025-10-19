import 'dart:math';
import '../models/teaching_request_model.dart';
import '../models/lecturer_model.dart';

class TeachingRequestService {
  final Random _random = Random();

  /// Trả về danh sách TeachingRequest cố định (50 bản ghi)
  Future<Map<String, dynamic>> fetchTeachingRequests() async {
    await Future.delayed(const Duration(milliseconds: 1000)); // mô phỏng delay

    final lecturers = _generateFixedLecturers();
    final List<TeachingRequestModel> list = [];

    for (int i = 0; i < 50; i++) {
      final lecturer = lecturers[i % lecturers.length];
      final isDonNghi = i % 2 == 0; // xen kẽ đơn nghỉ và dạy bù

      final ngayHoc = DateTime(2025, 10, (i % 28) + 1);
      final ngayHocDayBu = ngayHoc.add(Duration(days: (i % 5) + 1));

      final List<String> attachedImages = [
        'https://cdn-media.sforum.vn/storage/app/media/anh-dep-82.jpg',
        'https://cdn-media.sforum.vn/storage/app/media/anh-dep-83.jpg',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_NrLmx2ubTubTGlsf79l-gvcJE_5A1y3Maw&s',
      ];

      list.add(
        TeachingRequestModel(
          maDon: 'DON${i.toString().padLeft(3, '0')}',
          loaiDon: isDonNghi ? 'Đơn xin nghỉ dạy' : 'Đơn xin dạy bù',
          trangThai: _convertTrangThai(i % 3),

          // Học phần
          tenHocPhan: 'Phát triển phần mềm ${i + 1}',
          maHocPhan: 'CS${100 + i}',
          hocKy: '1_2023_2024',

          // Giảng viên
          maGiangVien: lecturer.maGiangVien,
          tenGiangVien: lecturer.hoVaTen,
          tenTaiKhoan: lecturer.tenTaiKhoan,

          // Thông tin buổi học nghỉ
          ngayBuoiHocNghi: ngayHoc,
          caHocNghi: _generateCaDay(i),
          phongHocNghi: 'B${(i % 5) + 1}-30${(i % 9)}',
          buoiHocSo: '${(i % 15) + 1}/15',

          // Thông tin đơn
          nguoiGui: lecturer.hoVaTen,
          ngayGui: DateTime(2025, 7, (i % 28) + 1),
          lyDo: _generateLyDo(i),
          anhMinhChung: List.generate(
            i % 4,
            (_) => attachedImages[i % attachedImages.length],
          ),

          // Dạy bù (nếu có)
          ngayBuoiHocDayBu: isDonNghi ? null : ngayHocDayBu,
          caHocDayBu: isDonNghi ? null : _generateCaDay(i + 1),
          phongHocDayBu: isDonNghi ? null : 'B${(i % 4) + 2}-30${(i % 7) + 1}',
        ),
      );
    }

    return {'statusCode': 200, 'message': 'Success', 'data': list};
  }

  // -------------------
  // HÀM HỖ TRỢ
  // -------------------

  String _convertTrangThai(int value) {
    switch (value) {
      case 1:
        return 'Đã xác nhận';
      case 2:
        return 'Từ chối';
      default:
        return 'Chưa xác nhận';
    }
  }

  String _generateCaDay(int i) {
    switch (i % 3) {
      case 0:
        return 'Ca 1 (7h00 - 9h45)';
      case 1:
        return 'Ca 2 (9h55 - 12h30)';
      default:
        return 'Ca 3 (13h30 - 16h00)';
    }
  }

  String _generateLyDo(int i) {
    final lyDoList = [
      'Bận việc gia đình',
      'Ốm đột xuất',
      'Tham gia hội nghị',
      'Công tác đột xuất',
      'Lý do cá nhân',
    ];
    return lyDoList[i % lyDoList.length];
  }

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
