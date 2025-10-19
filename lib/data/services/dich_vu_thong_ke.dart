import '../models/mo_hinh_thong_ke_giang_day.dart';
import '../models/mo_hinh_tien_do_hoc_phan.dart';
import '../models/mo_hinh_lich_trinh_giang_day.dart';
import '../models/mo_hinh_bao_cao_diem_danh.dart';
import '../models/sinh_vien_attendance_model.dart';

class DichVuThongKe {
  /// Lấy danh sách thống kê giờ dạy của tất cả giảng viên
  Future<List<MoHinhThongKeGiangDay>> fetchTeachingStatistics({
    String? hocKy,
    String? namHoc,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    // Dữ liệu mẫu
    return [
      MoHinhThongKeGiangDay(
        maGiangVien: 'GV001',
        hoVaTen: 'Nguyễn Văn A',
        email: 'nguyenvana@tlu.edu.vn',
        tongSoTiet: 90,
        soTietDaDay: 60,
        soTietNghi: 6,
        soTietDayBu: 4,
        soTietConLai: 30,
        hocKy: 'HK1',
        namHoc: '2024-2025',
        gioGiangTheoChuanDinh: 60.0,
        gioGiangVuotChuanDinh: 0.0,
        gioTangCa: 0.0,
        tongGioThanhToan: 60.0,
      ),
      MoHinhThongKeGiangDay(
        maGiangVien: 'GV002',
        hoVaTen: 'Trần Thị B',
        email: 'tranthib@tlu.edu.vn',
        tongSoTiet: 120,
        soTietDaDay: 90,
        soTietNghi: 9,
        soTietDayBu: 9,
        soTietConLai: 30,
        hocKy: 'HK1',
        namHoc: '2024-2025',
        gioGiangTheoChuanDinh: 80.0,
        gioGiangVuotChuanDinh: 10.0,
        gioTangCa: 0.0,
        tongGioThanhToan: 90.0,
      ),
      MoHinhThongKeGiangDay(
        maGiangVien: 'GV003',
        hoVaTen: 'Lê Văn C',
        email: 'levanc@tlu.edu.vn',
        tongSoTiet: 75,
        soTietDaDay: 45,
        soTietNghi: 3,
        soTietDayBu: 2,
        soTietConLai: 30,
        hocKy: 'HK1',
        namHoc: '2024-2025',
        gioGiangTheoChuanDinh: 50.0,
        gioGiangVuotChuanDinh: 0.0,
        gioTangCa: 0.0,
        tongGioThanhToan: 47.0,
      ),
      MoHinhThongKeGiangDay(
        maGiangVien: 'GV004',
        hoVaTen: 'Phạm Thị D',
        email: 'phamthid@tlu.edu.vn',
        tongSoTiet: 105,
        soTietDaDay: 75,
        soTietNghi: 6,
        soTietDayBu: 5,
        soTietConLai: 30,
        hocKy: 'HK1',
        namHoc: '2024-2025',
        gioGiangTheoChuanDinh: 70.0,
        gioGiangVuotChuanDinh: 5.0,
        gioTangCa: 0.0,
        tongGioThanhToan: 74.0,
      ),
      MoHinhThongKeGiangDay(
        maGiangVien: 'GV005',
        hoVaTen: 'Hoàng Văn E',
        email: 'hoangvane@tlu.edu.vn',
        tongSoTiet: 135,
        soTietDaDay: 105,
        soTietNghi: 12,
        soTietDayBu: 10,
        soTietConLai: 30,
        hocKy: 'HK1',
        namHoc: '2024-2025',
        gioGiangTheoChuanDinh: 90.0,
        gioGiangVuotChuanDinh: 15.0,
        gioTangCa: 0.0,
        tongGioThanhToan: 103.0,
      ),
    ];
  }

  /// Lấy danh sách báo cáo tiến độ theo học phần
  Future<List<MoHinhTienDoHocPhan>> fetchCourseProgress({
    String? hocKy,
    String? namHoc,
    String? maGiangVien,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    // Dữ liệu mẫu
    return [
      MoHinhTienDoHocPhan(
        maHocPhan: 'IT001',
        tenHocPhan: 'Lập trình hướng đối tượng',
        maLopHocPhan: 'IT001.01',
        hocKy: 'HK1',
        namHoc: '2024-2025',
        maGiangVien: 'GV001',
        tenGiangVien: 'Nguyễn Văn A',
        tongSoBuoi: 15,
        soBuoiHoanThanh: 10,
        soBuoiNghi: 2,
        soBuoiDayBu: 1,
        soBuoiConLai: 5,
      ),
      MoHinhTienDoHocPhan(
        maHocPhan: 'IT002',
        tenHocPhan: 'Cấu trúc dữ liệu và giải thuật',
        maLopHocPhan: 'IT002.01',
        hocKy: 'HK1',
        namHoc: '2024-2025',
        maGiangVien: 'GV001',
        tenGiangVien: 'Nguyễn Văn A',
        tongSoBuoi: 15,
        soBuoiHoanThanh: 12,
        soBuoiNghi: 1,
        soBuoiDayBu: 1,
        soBuoiConLai: 3,
      ),
      MoHinhTienDoHocPhan(
        maHocPhan: 'IT003',
        tenHocPhan: 'Cơ sở dữ liệu',
        maLopHocPhan: 'IT003.02',
        hocKy: 'HK1',
        namHoc: '2024-2025',
        maGiangVien: 'GV002',
        tenGiangVien: 'Trần Thị B',
        tongSoBuoi: 15,
        soBuoiHoanThanh: 13,
        soBuoiNghi: 2,
        soBuoiDayBu: 2,
        soBuoiConLai: 2,
      ),
      MoHinhTienDoHocPhan(
        maHocPhan: 'IT004',
        tenHocPhan: 'Mạng máy tính',
        maLopHocPhan: 'IT004.01',
        hocKy: 'HK1',
        namHoc: '2024-2025',
        maGiangVien: 'GV003',
        tenGiangVien: 'Lê Văn C',
        tongSoBuoi: 15,
        soBuoiHoanThanh: 9,
        soBuoiNghi: 1,
        soBuoiDayBu: 0,
        soBuoiConLai: 6,
      ),
      MoHinhTienDoHocPhan(
        maHocPhan: 'IT005',
        tenHocPhan: 'Hệ điều hành',
        maLopHocPhan: 'IT005.03',
        hocKy: 'HK1',
        namHoc: '2024-2025',
        maGiangVien: 'GV004',
        tenGiangVien: 'Phạm Thị D',
        tongSoBuoi: 15,
        soBuoiHoanThanh: 11,
        soBuoiNghi: 2,
        soBuoiDayBu: 2,
        soBuoiConLai: 4,
      ),
      MoHinhTienDoHocPhan(
        maHocPhan: 'IT006',
        tenHocPhan: 'Trí tuệ nhân tạo',
        maLopHocPhan: 'IT006.01',
        hocKy: 'HK1',
        namHoc: '2024-2025',
        maGiangVien: 'GV005',
        tenGiangVien: 'Hoàng Văn E',
        tongSoBuoi: 15,
        soBuoiHoanThanh: 14,
        soBuoiNghi: 1,
        soBuoiDayBu: 1,
        soBuoiConLai: 1,
      ),
    ];
  }

  /// Lấy thống kê tổng quát
  Future<Map<String, dynamic>> fetchOverallStatistics({
    String? hocKy,
    String? namHoc,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    return {
      'tongSoGiangVien': 130,
      'tongSoHocPhan': 45,
      'tongSoTiet': 4050,
      'tongSoTietHoanThanh': 2835,
      'tongSoTietNghi': 135,
      'tongSoTietDayBu': 108,
    };
  }

  /// Lấy danh sách lịch trình giảng dạy chi tiết
  Future<List<MoHinhLichTrinhGiangDay>> fetchTeachingSchedules({
    String? hocKy,
    String? namHoc,
    String? maGiangVien,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    // Dữ liệu mẫu
    return [
      MoHinhLichTrinhGiangDay(
        maLichTrinh: 'LT001',
        maHocPhan: 'IT001',
        tenHocPhan: 'Lập trình hướng đối tượng',
        maLopHocPhan: 'IT001.01',
        hocKy: 'HK1',
        namHoc: '2024-2025',
        maGiangVien: 'GV001',
        tenGiangVien: 'Nguyễn Văn A',
        ngayBatDau: DateTime(2024, 9, 1),
        ngayKetThuc: DateTime(2024, 12, 31),
        tongSoBuoi: 15,
        soTietMoiBuoi: 3,
        thuTrongTuan: 'Thứ 2',
        caHoc: 'Ca 1',
        phongHoc: 'A101',
        soBuoiDaDay: 10,
        soBuoiNghi: 2,
        soBuoiDayBu: 1,
        soBuoiConLai: 5,
        trangThai: 'Đang diễn ra',
      ),
      MoHinhLichTrinhGiangDay(
        maLichTrinh: 'LT002',
        maHocPhan: 'IT002',
        tenHocPhan: 'Cấu trúc dữ liệu và giải thuật',
        maLopHocPhan: 'IT002.01',
        hocKy: 'HK1',
        namHoc: '2024-2025',
        maGiangVien: 'GV001',
        tenGiangVien: 'Nguyễn Văn A',
        ngayBatDau: DateTime(2024, 9, 1),
        ngayKetThuc: DateTime(2024, 12, 31),
        tongSoBuoi: 15,
        soTietMoiBuoi: 3,
        thuTrongTuan: 'Thứ 4',
        caHoc: 'Ca 2',
        phongHoc: 'A102',
        soBuoiDaDay: 12,
        soBuoiNghi: 1,
        soBuoiDayBu: 1,
        soBuoiConLai: 3,
        trangThai: 'Đang diễn ra',
      ),
    ];
  }

  /// Lấy báo cáo điểm danh chi tiết
  Future<List<MoHinhBaoCaoDiemDanh>> fetchAttendanceReports({
    String? hocKy,
    String? namHoc,
    String? maHocPhan,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    return [
      MoHinhBaoCaoDiemDanh(
        maHocPhan: 'IT001',
        tenHocPhan: 'Lập trình hướng đối tượng',
        maLopHocPhan: 'IT001.01',
        hocKy: 'HK1',
        namHoc: '2024-2025',
        maGiangVien: 'GV001',
        tenGiangVien: 'Nguyễn Văn A',
        tongSoSinhVien: 45,
        tongSoBuoiHoc: 15,
        soBuoiDaDiemDanh: 10,
        tiLeChuyenCanTrungBinh: 0.85,
        danhSachSinhVien: [
          SinhVienAttendanceModel(
            maSinhVien: 'SV001',
            hoVaTen: 'Nguyễn Văn B',
            lop: 'IT001.01',
            soBuoiCoMat: 9,
            tongSoBuoi: 10,
            tiLeChuyenCan: 0.9,
          ),
          SinhVienAttendanceModel(
            maSinhVien: 'SV002',
            hoVaTen: 'Trần Thị C',
            lop: 'IT001.01',
            soBuoiCoMat: 7,
            tongSoBuoi: 10,
            tiLeChuyenCan: 0.7,
          ),
        ],
      ),
    ];
  }

  /// Lấy cảnh báo và thông báo
  Future<List<Map<String, dynamic>>> fetchAlertsAndNotifications({
    String? hocKy,
    String? namHoc,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        'id': 'ALERT001',
        'loai': 'Cảnh báo',
        'tieuDe': 'Giảng viên có tỷ lệ nghỉ cao',
        'noiDung': 'GV002 có tỷ lệ nghỉ dạy 15%, vượt quá mức cho phép 10%',
        'mucDo': 'Cao',
        'ngayTao': DateTime.now().subtract(const Duration(days: 2)),
        'trangThai': 'Chưa xử lý',
      },
      {
        'id': 'ALERT002',
        'loai': 'Thông báo',
        'tieuDe': 'Học phần sắp kết thúc',
        'noiDung': 'Học phần IT001 chỉ còn 2 buổi học nữa',
        'mucDo': 'Trung bình',
        'ngayTao': DateTime.now().subtract(const Duration(days: 1)),
        'trangThai': 'Đã xem',
      },
      {
        'id': 'ALERT003',
        'loai': 'Cảnh báo',
        'tieuDe': 'Buổi dạy bù chưa được thực hiện',
        'noiDung': 'GV003 có 2 buổi nghỉ chưa được dạy bù',
        'mucDo': 'Cao',
        'ngayTao': DateTime.now(),
        'trangThai': 'Chưa xử lý',
      },
    ];
  }
}

