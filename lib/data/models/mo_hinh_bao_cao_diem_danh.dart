class MoHinhBaoCaoDiemDanh {
  // Thông tin học phần
  final String maHocPhan;
  final String tenHocPhan;
  final String maLopHocPhan;
  final String hocKy;
  final String namHoc;

  // Thông tin giảng viên
  final String maGiangVien;
  final String tenGiangVien;

  // Thống kê điểm danh
  final int tongSoSinhVien;
  final int tongSoBuoiHoc;
  final int soBuoiDaDiemDanh;
  final double tiLeChuyenCanTrungBinh;

  // Chi tiết sinh viên và buổi học (optional)
  final List<dynamic>? danhSachSinhVien;
  final List<dynamic>? danhSachBuoiHoc;

  MoHinhBaoCaoDiemDanh({
    required this.maHocPhan,
    required this.tenHocPhan,
    required this.maLopHocPhan,
    required this.hocKy,
    required this.namHoc,
    required this.maGiangVien,
    required this.tenGiangVien,
    required this.tongSoSinhVien,
    required this.tongSoBuoiHoc,
    required this.soBuoiDaDiemDanh,
    required this.tiLeChuyenCanTrungBinh,
    this.danhSachSinhVien,
    this.danhSachBuoiHoc,
  });

  /// Từ JSON → Object
  factory MoHinhBaoCaoDiemDanh.fromJson(Map<String, dynamic> json) {
    return MoHinhBaoCaoDiemDanh(
      maHocPhan: json['maHocPhan'] ?? '',
      tenHocPhan: json['tenHocPhan'] ?? '',
      maLopHocPhan: json['maLopHocPhan'] ?? '',
      hocKy: json['hocKy'] ?? '',
      namHoc: json['namHoc'] ?? '',
      maGiangVien: json['maGiangVien'] ?? '',
      tenGiangVien: json['tenGiangVien'] ?? '',
      tongSoSinhVien: json['tongSoSinhVien'] ?? 0,
      tongSoBuoiHoc: json['tongSoBuoiHoc'] ?? 0,
      soBuoiDaDiemDanh: json['soBuoiDaDiemDanh'] ?? 0,
      tiLeChuyenCanTrungBinh: (json['tiLeChuyenCanTrungBinh'] as num?)?.toDouble() ?? 0.0,
      danhSachSinhVien: json['danhSachSinhVien'],
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
      'tongSoSinhVien': tongSoSinhVien,
      'tongSoBuoiHoc': tongSoBuoiHoc,
      'soBuoiDaDiemDanh': soBuoiDaDiemDanh,
      'tiLeChuyenCanTrungBinh': tiLeChuyenCanTrungBinh,
      'danhSachSinhVien': danhSachSinhVien,
      'danhSachBuoiHoc': danhSachBuoiHoc,
    };
  }

  /// Tính tỷ lệ điểm danh
  double get tiLeDiemDanh =>
      tongSoBuoiHoc == 0 ? 0 : (soBuoiDaDiemDanh / tongSoBuoiHoc);
}