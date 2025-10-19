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
        'http://thichtrangtri.com/wp-content/uploads/2025/05/anh-nga-xe-1.jpg',
        'https://top10tphcm.com/wp-content/uploads/2024/03/hinh-anh-te-xe-tray-xuoc-tay-chan-nam-nu-07.jpg',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAlwTxfmMwTktb3R3BnWRyH1VSQd4QXu8fLQ&s',
        'https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2025/2/4/cho-can-tiem-vac-xin-17386559460781323603876.jpg',
        'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2022/3/4/1020052/Vu-No-Lop-Xe-Oto.jpg',
        'https://media.vov.vn/sites/default/files/styles/large/public/2021-06/cut_4.jpg',
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
          idGiangVien: lecturer.id,
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
            i % 2,
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
        id: 'GV001',
        tenTaiKhoan: 'nguyenvana',
        hoVaTen: 'Nguyễn Văn A',
        email: 'nguyenvana@university.edu.vn',
        ngaySinh: DateTime(1980, 5, 12),
        soDienThoai: '0901234567',
        soHocPhanDangDay: 3,
        soDonCanDuyet: 1,
      ),
      LecturerModel(
        id: 'GV002',
        tenTaiKhoan: 'tranthib',
        hoVaTen: 'Trần Thị B',
        email: 'tranthib@university.edu.vn',
        ngaySinh: DateTime(1985, 7, 8),
        soDienThoai: '0912345678',
        soHocPhanDangDay: 2,
        soDonCanDuyet: 2,
      ),
      LecturerModel(
        id: 'GV003',
        tenTaiKhoan: 'lehuuc',
        hoVaTen: 'Lê Hữu C',
        email: 'lehuuc@university.edu.vn',
        ngaySinh: DateTime(1978, 10, 20),
        soDienThoai: '0987654321',
        soHocPhanDangDay: 4,
        soDonCanDuyet: 0,
      ),
      LecturerModel(
        id: 'GV004',
        tenTaiKhoan: 'phamthid',
        hoVaTen: 'Phạm Thị D',
        email: 'phamthid@university.edu.vn',
        ngaySinh: DateTime(1990, 3, 15),
        soDienThoai: '0331234567',
        soHocPhanDangDay: 1,
        soDonCanDuyet: 1,
      ),
      LecturerModel(
        id: 'GV005',
        tenTaiKhoan: 'hoangvanh',
        hoVaTen: 'Hoàng Văn H',
        email: 'hoangvanh@university.edu.vn',
        ngaySinh: DateTime(1988, 9, 9),
        soDienThoai: '0709876543',
        soHocPhanDangDay: 5,
        soDonCanDuyet: 3,
      ),
    ];
  }
}
