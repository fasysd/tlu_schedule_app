import 'package:flutter/material.dart';
import '../../data/models/course_model.dart';

class CourseService {
  /// Lấy danh sách học phần
  Future<List<CourseModel>> fetchCourses({
    String? hocKy,
    String? namHoc,
    String? maGiangVien,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));
    
    // Dummy data phù hợp với dự án quản lý lịch trình giảng dạy
    return [
      CourseModel(
        maHocPhan: 'IT3012-02',
        tenHocPhan: 'Cấu trúc dữ liệu và giải thuật',
        maLopHocPhan: 'IT3012-02',
        hocKy: hocKy ?? 'HK1',
        namHoc: namHoc ?? '2024-2025',
        maGiangVien: 'GV001',
        tenGiangVien: 'Nguyễn Văn B',
        boMon: 'Khoa CNTT',
        soTinChi: 3,
        soSinhVien: 40,
        thoiGianHoc: 'Thứ 3',
        gioBatDau: '09:00',
        gioKetThuc: '11:45',
        phongHoc: 'P.301',
        ngayBatDau: DateTime(2024, 9, 1),
        ngayKetThuc: DateTime(2024, 12, 20),
        tongSoBuoi: 28,
        soBuoiDaDay: 10,
        soBuoiNghi: 1,
        soBuoiDayBu: 1,
        soBuoiConLai: 18,
        trangThai: 'Đang dạy',
        tiLeHoanThanh: 0.36,
      ),
      CourseModel(
        maHocPhan: 'IT3100-01',
        tenHocPhan: 'Lập trình hướng đối tượng',
        maLopHocPhan: 'IT3100-01',
        hocKy: hocKy ?? 'HK1',
        namHoc: namHoc ?? '2024-2025',
        maGiangVien: 'GV002',
        tenGiangVien: 'Trần Thị B',
        boMon: 'Khoa CNTT',
        soTinChi: 4,
        soSinhVien: 38,
        thoiGianHoc: 'Thứ 3, 5',
        gioBatDau: '13:30',
        gioKetThuc: '16:00',
        phongHoc: 'TC-305',
        ngayBatDau: DateTime(2024, 9, 1),
        ngayKetThuc: DateTime(2024, 12, 20),
        tongSoBuoi: 30,
        soBuoiDaDay: 15,
        soBuoiNghi: 0,
        soBuoiDayBu: 0,
        soBuoiConLai: 15,
        trangThai: 'Đang dạy',
        tiLeHoanThanh: 0.50,
      ),
      CourseModel(
        maHocPhan: 'IT3080-03',
        tenHocPhan: 'Mạng máy tính',
        maLopHocPhan: 'IT3080-03',
        hocKy: hocKy ?? 'HK1',
        namHoc: namHoc ?? '2024-2025',
        maGiangVien: 'GV003',
        tenGiangVien: 'Lê Văn C',
        boMon: 'Khoa CNTT',
        soTinChi: 3,
        soSinhVien: 42,
        thoiGianHoc: 'Thứ 4, 6',
        gioBatDau: '09:30',
        gioKetThuc: '12:00',
        phongHoc: 'TC-201',
        ngayBatDau: DateTime(2024, 9, 1),
        ngayKetThuc: DateTime(2024, 12, 20),
        tongSoBuoi: 28,
        soBuoiDaDay: 28,
        soBuoiNghi: 0,
        soBuoiDayBu: 0,
        soBuoiConLai: 0,
        trangThai: 'Đã kết thúc',
        tiLeHoanThanh: 1.0,
      ),
      CourseModel(
        maHocPhan: 'IT3120-01',
        tenHocPhan: 'Phân tích thiết kế hệ thống',
        maLopHocPhan: 'IT3120-01',
        hocKy: hocKy ?? 'HK1',
        namHoc: namHoc ?? '2024-2025',
        maGiangVien: 'GV004',
        tenGiangVien: 'Phạm Thị D',
        boMon: 'Khoa CNTT',
        soTinChi: 3,
        soSinhVien: 40,
        thoiGianHoc: 'Thứ 2, 5',
        gioBatDau: '13:30',
        gioKetThuc: '16:00',
        phongHoc: 'TC-302',
        ngayBatDau: DateTime(2024, 9, 1),
        ngayKetThuc: DateTime(2024, 12, 20),
        tongSoBuoi: 28,
        soBuoiDaDay: 8,
        soBuoiNghi: 2,
        soBuoiDayBu: 1,
        soBuoiConLai: 20,
        trangThai: 'Đang dạy',
        tiLeHoanThanh: 0.29,
      ),
      CourseModel(
        maHocPhan: 'IT3090-02',
        tenHocPhan: 'Cơ sở dữ liệu',
        maLopHocPhan: 'IT3090-02',
        hocKy: hocKy ?? 'HK1',
        namHoc: namHoc ?? '2024-2025',
        maGiangVien: 'GV005',
        tenGiangVien: 'Hoàng Văn E',
        boMon: 'Khoa CNTT',
        soTinChi: 3,
        soSinhVien: 45,
        thoiGianHoc: 'Thứ 2, 4',
        gioBatDau: '07:00',
        gioKetThuc: '09:30',
        phongHoc: 'TC-404',
        ngayBatDau: DateTime(2024, 9, 1),
        ngayKetThuc: DateTime(2024, 12, 20),
        tongSoBuoi: 28,
        soBuoiDaDay: 12,
        soBuoiNghi: 1,
        soBuoiDayBu: 1,
        soBuoiConLai: 16,
        trangThai: 'Đang dạy',
        tiLeHoanThanh: 0.43,
      ),
    ];
  }

  /// Tạo học phần mới
  Future<bool> createCourse(CourseModel course) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Cập nhật học phần
  Future<bool> updateCourse(CourseModel course) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Xóa học phần
  Future<bool> deleteCourse(String maHocPhan) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Tạo lại lịch trình học phần
  Future<bool> recreateSchedule(String maHocPhan) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Lấy thống kê học phần
  Future<Map<String, dynamic>> getCourseStatistics({
    String? hocKy,
    String? namHoc,
  }) async {
    // TODO: Thay thế bằng API call thực tế
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'tongSoHocPhan': 128,
      'hocPhanDangDay': 86,
      'hocPhanDaKetThuc': 42,
      'tiLeHoanThanhTrungBinh': 0.75,
      'soBuoiNghiTong': 15,
      'soBuoiDayBuTong': 12,
    };
  }
}

