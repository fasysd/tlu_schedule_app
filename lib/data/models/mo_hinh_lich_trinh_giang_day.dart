class MoHinhLichTrinhGiangDay {
  // Thông tin cơ bản
  final String maLichTrinh;
  final String maHocPhan;
  final String tenHocPhan;
  final String maLopHocPhan;
  final String hocKy;
  final String namHoc;

  // Thông tin giảng viên
  final String maGiangVien;
  final String tenGiangVien;

  // Thông tin thời gian
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final int tongSoBuoi;
  final int soTietMoiBuoi;
  final String thuTrongTuan; // "Thứ 2", "Thứ 3", etc.
  final String caHoc; // "Ca 1", "Ca 2", etc.
  final String phongHoc;

  // Thống kê tiến độ
  final int soBuoiDaDay;
  final int soBuoiNghi;
  final int soBuoiDayBu;
  final int soBuoiConLai;

  // Trạng thái
  final String trangThai; // "Đang diễn ra", "Hoàn thành", "Tạm dừng"

  // Chi tiết buổi học (optional)
  final List<dynamic>? danhSachBuoiHoc;

  MoHinhLichTrinhGiangDay({
    required this.maLichTrinh,
    required this.maHocPhan,
    required this.tenHocPhan,
    required this.maLopHocPhan,
    required this.hocKy,
    required this.namHoc,
    required this.maGiangVien,
    required this.tenGiangVien,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.tongSoBuoi,
    required this.soTietMoiBuoi,
    required this.thuTrongTuan,
    required this.caHoc,
    required this.phongHoc,
    required this.soBuoiDaDay,
    required this.soBuoiNghi,
    required this.soBuoiDayBu,
    required this.soBuoiConLai,
    required this.trangThai,
    this.danhSachBuoiHoc,
  });

  /// Từ JSON → Object
  factory MoHinhLichTrinhGiangDay.fromJson(Map<String, dynamic> json) {
    return MoHinhLichTrinhGiangDay(
      maLichTrinh: json['maLichTrinh'] ?? '',
      maHocPhan: json['maHocPhan'] ?? '',
      tenHocPhan: json['tenHocPhan'] ?? '',
      maLopHocPhan: json['maLopHocPhan'] ?? '',
      hocKy: json['hocKy'] ?? '',
      namHoc: json['namHoc'] ?? '',
      maGiangVien: json['maGiangVien'] ?? '',
      tenGiangVien: json['tenGiangVien'] ?? '',
      ngayBatDau: DateTime.tryParse(json['ngayBatDau'] ?? '') ?? DateTime.now(),
      ngayKetThuc: DateTime.tryParse(json['ngayKetThuc'] ?? '') ?? DateTime.now(),
      tongSoBuoi: json['tongSoBuoi'] ?? 0,
      soTietMoiBuoi: json['soTietMoiBuoi'] ?? 0,
      thuTrongTuan: json['thuTrongTuan'] ?? '',
      caHoc: json['caHoc'] ?? '',
      phongHoc: json['phongHoc'] ?? '',
      soBuoiDaDay: json['soBuoiDaDay'] ?? 0,
      soBuoiNghi: json['soBuoiNghi'] ?? 0,
      soBuoiDayBu: json['soBuoiDayBu'] ?? 0,
      soBuoiConLai: json['soBuoiConLai'] ?? 0,
      trangThai: json['trangThai'] ?? '',
      danhSachBuoiHoc: json['danhSachBuoiHoc'],
    );
  }

  /// Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'maLichTrinh': maLichTrinh,
      'maHocPhan': maHocPhan,
      'tenHocPhan': tenHocPhan,
      'maLopHocPhan': maLopHocPhan,
      'hocKy': hocKy,
      'namHoc': namHoc,
      'maGiangVien': maGiangVien,
      'tenGiangVien': tenGiangVien,
      'ngayBatDau': ngayBatDau.toIso8601String(),
      'ngayKetThuc': ngayKetThuc.toIso8601String(),
      'tongSoBuoi': tongSoBuoi,
      'soTietMoiBuoi': soTietMoiBuoi,
      'thuTrongTuan': thuTrongTuan,
      'caHoc': caHoc,
      'phongHoc': phongHoc,
      'soBuoiDaDay': soBuoiDaDay,
      'soBuoiNghi': soBuoiNghi,
      'soBuoiDayBu': soBuoiDayBu,
      'soBuoiConLai': soBuoiConLai,
      'trangThai': trangThai,
      'danhSachBuoiHoc': danhSachBuoiHoc,
    };
  }

  /// Tính tỷ lệ hoàn thành
  double get tiLeHoanThanh =>
      tongSoBuoi == 0 ? 0 : (soBuoiDaDay / tongSoBuoi);

  /// Tính tỷ lệ nghỉ
  double get tiLeNghi => tongSoBuoi == 0 ? 0 : (soBuoiNghi / tongSoBuoi);

  /// Tính tỷ lệ dạy bù
  double get tiLeDayBu => soBuoiNghi == 0 ? 0 : (soBuoiDayBu / soBuoiNghi);
}