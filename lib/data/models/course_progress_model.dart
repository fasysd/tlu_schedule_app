class CourseProgressModel {
  // Thông tin học phần
  final String maHocPhan;
  final String tenHocPhan;
  final String maLopHocPhan;
  final String hocKy;
  final String namHoc;

  // Thông tin giảng viên
  final String maGiangVien;
  final String tenGiangVien;

  // Thông tin tiến độ
  final int tongSoBuoi; // Tổng số buổi học theo kế hoạch
  final int soBuoiHoanThanh; // Số buổi đã hoàn thành
  final int soBuoiNghi; // Số buổi nghỉ
  final int soBuoiDayBu; // Số buổi đã dạy bù
  final int soBuoiConLai; // Số buổi còn lại chưa dạy

  // Thông tin chi tiết
  final List<BuoiHocDetail>? danhSachBuoiHoc; // Danh sách chi tiết các buổi học

  CourseProgressModel({
    required this.maHocPhan,
    required this.tenHocPhan,
    required this.maLopHocPhan,
    required this.hocKy,
    required this.namHoc,
    required this.maGiangVien,
    required this.tenGiangVien,
    required this.tongSoBuoi,
    required this.soBuoiHoanThanh,
    required this.soBuoiNghi,
    required this.soBuoiDayBu,
    required this.soBuoiConLai,
    this.danhSachBuoiHoc,
  });

  /// Từ JSON → Object
  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    return CourseProgressModel(
      maHocPhan: json['maHocPhan'] ?? '',
      tenHocPhan: json['tenHocPhan'] ?? '',
      maLopHocPhan: json['maLopHocPhan'] ?? '',
      hocKy: json['hocKy'] ?? '',
      namHoc: json['namHoc'] ?? '',
      maGiangVien: json['maGiangVien'] ?? '',
      tenGiangVien: json['tenGiangVien'] ?? '',
      tongSoBuoi: json['tongSoBuoi'] ?? 0,
      soBuoiHoanThanh: json['soBuoiHoanThanh'] ?? 0,
      soBuoiNghi: json['soBuoiNghi'] ?? 0,
      soBuoiDayBu: json['soBuoiDayBu'] ?? 0,
      soBuoiConLai: json['soBuoiConLai'] ?? 0,
      danhSachBuoiHoc: json['danhSachBuoiHoc'] != null
          ? (json['danhSachBuoiHoc'] as List)
              .map((e) => BuoiHocDetail.fromJson(e))
              .toList()
          : null,
    );
  }

  /// Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'maHocPhan': maHocPhan,
      'tenHocPhan': tenHocPhan,
      'maLopHocPhan': maLopHocPhan,
      'hocKy': hocKy,
      'namHoc': namHoc,
      'maGiangVien': maGiangVien,
      'tenGiangVien': tenGiangVien,
      'tongSoBuoi': tongSoBuoi,
      'soBuoiHoanThanh': soBuoiHoanThanh,
      'soBuoiNghi': soBuoiNghi,
      'soBuoiDayBu': soBuoiDayBu,
      'soBuoiConLai': soBuoiConLai,
      if (danhSachBuoiHoc != null)
        'danhSachBuoiHoc':
            danhSachBuoiHoc!.map((e) => e.toJson()).toList(),
    };
  }

  /// Tính tỷ lệ hoàn thành
  double get tiLeHoanThanh =>
      tongSoBuoi == 0 ? 0 : (soBuoiHoanThanh / tongSoBuoi);

  /// Tính tỷ lệ nghỉ
  double get tiLeNghi => tongSoBuoi == 0 ? 0 : (soBuoiNghi / tongSoBuoi);

  /// Tính tỷ lệ dạy bù
  double get tiLeDayBu => soBuoiNghi == 0 ? 0 : (soBuoiDayBu / soBuoiNghi);
}

/// Model cho chi tiết từng buổi học
class BuoiHocDetail {
  final int buoiSo; // Buổi số (1, 2, 3...)
  final DateTime ngayHoc;
  final String caHoc;
  final String phongHoc;
  final String trangThai; // "Hoàn thành", "Nghỉ", "Dạy bù", "Chưa dạy"
  final DateTime? ngayDayBu; // Nếu là buổi nghỉ và đã dạy bù

  BuoiHocDetail({
    required this.buoiSo,
    required this.ngayHoc,
    required this.caHoc,
    required this.phongHoc,
    required this.trangThai,
    this.ngayDayBu,
  });

  factory BuoiHocDetail.fromJson(Map<String, dynamic> json) {
    return BuoiHocDetail(
      buoiSo: json['buoiSo'] ?? 0,
      ngayHoc: DateTime.parse(json['ngayHoc']),
      caHoc: json['caHoc'] ?? '',
      phongHoc: json['phongHoc'] ?? '',
      trangThai: json['trangThai'] ?? 'Chưa dạy',
      ngayDayBu: json['ngayDayBu'] != null
          ? DateTime.tryParse(json['ngayDayBu'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buoiSo': buoiSo,
      'ngayHoc': ngayHoc.toIso8601String(),
      'caHoc': caHoc,
      'phongHoc': phongHoc,
      'trangThai': trangThai,
      if (ngayDayBu != null) 'ngayDayBu': ngayDayBu!.toIso8601String(),
    };
  }
}

