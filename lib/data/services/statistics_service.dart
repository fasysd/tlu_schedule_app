import '../models/teaching_statistics_model.dart';
import '../models/course_progress_model.dart';
import '../models/teaching_schedule_model.dart';
import '../models/attendance_report_model.dart';
import '../models/payment_report_model.dart';

class StatisticsService {
  /// Lấy danh sách thống kê giờ dạy của tất cả giảng viên
  Future<List<TeachingStatisticsModel>> fetchTeachingStatistics({
    String? hocKy,
    String? namHoc,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    // Dữ liệu mẫu
    return [
      TeachingStatisticsModel(
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
        tongGioThanhToan: 60.0,
      ),
      TeachingStatisticsModel(
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
        tongGioThanhToan: 90.0,
      ),
      TeachingStatisticsModel(
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
        tongGioThanhToan: 47.0,
      ),
      TeachingStatisticsModel(
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
        tongGioThanhToan: 74.0,
      ),
      TeachingStatisticsModel(
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
        tongGioThanhToan: 103.0,
      ),
    ];
  }

  /// Lấy danh sách báo cáo tiến độ theo học phần
  Future<List<CourseProgressModel>> fetchCourseProgress({
    String? hocKy,
    String? namHoc,
    String? maGiangVien,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    // Dữ liệu mẫu
    return [
      CourseProgressModel(
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
      CourseProgressModel(
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
      CourseProgressModel(
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
      CourseProgressModel(
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
      CourseProgressModel(
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
      CourseProgressModel(
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
  Future<List<TeachingScheduleModel>> fetchTeachingSchedules({
    String? hocKy,
    String? namHoc,
    String? maGiangVien,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    // Dữ liệu mẫu
    return [
      TeachingScheduleModel(
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
      TeachingScheduleModel(
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
  Future<List<AttendanceReportModel>> fetchAttendanceReports({
    String? hocKy,
    String? namHoc,
    String? maHocPhan,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    return [
      AttendanceReportModel(
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
            hoTen: 'Nguyễn Văn B',
            lop: 'IT001.01',
            soBuoiCoMat: 9,
            soBuoiVang: 1,
            tiLeChuyenCan: 0.9,
            trangThai: 'Đạt',
          ),
          SinhVienAttendanceModel(
            maSinhVien: 'SV002',
            hoTen: 'Trần Thị C',
            lop: 'IT001.01',
            soBuoiCoMat: 7,
            soBuoiVang: 3,
            tiLeChuyenCan: 0.7,
            trangThai: 'Cảnh báo',
          ),
        ],
      ),
    ];
  }

  /// Lấy báo cáo thanh toán giờ giảng
  Future<List<PaymentReportModel>> fetchPaymentReports({
    String? hocKy,
    String? namHoc,
    String? maGiangVien,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));

    return [
      PaymentReportModel(
        maGiangVien: 'GV001',
        hoVaTen: 'Nguyễn Văn A',
        email: 'nguyenvana@tlu.edu.vn',
        boMon: 'Công nghệ thông tin',
        hocKy: 'HK1',
        namHoc: '2024-2025',
        gioGiangChuanDinh: 60.0,
        gioGiangVuotChuanDinh: 0.0,
        tongGioGiang: 60.0,
        soBuoiNghi: 3,
        soBuoiDayBu: 2,
        tiLeDayBu: 0.67,
        donGiaGioChuan: 50000.0,
        donGiaGioVuotChuan: 75000.0,
        tongTienThanhToan: 3000000.0,
        trangThaiThanhToan: 'Chưa thanh toán',
        danhSachHocPhan: [
          HocPhanPaymentModel(
            maHocPhan: 'IT001',
            tenHocPhan: 'Lập trình hướng đối tượng',
            maLopHocPhan: 'IT001.01',
            tongSoTiet: 45,
            soTietDaDay: 30,
            soTietNghi: 6,
            soTietDayBu: 3,
            gioGiangThucTe: 30.0,
            tienThanhToan: 1500000.0,
          ),
          HocPhanPaymentModel(
            maHocPhan: 'IT002',
            tenHocPhan: 'Cấu trúc dữ liệu và giải thuật',
            maLopHocPhan: 'IT002.01',
            tongSoTiet: 45,
            soTietDaDay: 36,
            soTietNghi: 3,
            soTietDayBu: 3,
            gioGiangThucTe: 30.0,
            tienThanhToan: 1500000.0,
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

