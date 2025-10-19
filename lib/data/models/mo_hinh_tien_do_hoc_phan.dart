class MoHinhTienDoHocPhan {
  // Thông tin học phần
  final String maHocPhan;
  final String tenHocPhan;
  final String maLopHocPhan;
  final String hocKy;
  final String namHoc;

  // Thông tin giảng viên
  final String maGiangVien;
  final String tenGiangVien;

  // Thống kê tiến độ
  final int tongSoBuoi;
  final int soBuoiHoanThanh;
  final int soBuoiNghi;
  final int soBuoiDayBu;
  final int soBuoiConLai;

  // Chi tiết buổi học (optional)
  final List<dynamic>? danhSachBuoiHoc;

  MoHinhTienDoHocPhan({
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
  factory MoHinhTienDoHocPhan.fromJson(Map<String, dynamic> json) {
    return MoHinhTienDoHocPhan(
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
      danhSachBuoiHoc: json['danhSachBuoiHoc'],
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
      'danhSachBuoiHoc': danhSachBuoiHoc,
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