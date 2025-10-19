class TeachingRequestModel {
  // Thông tin chung
  final String maDon;
  final String loaiDon; // "Đơn xin nghỉ dạy" hoặc "Đơn dạy bù"
  final String trangThai;

  // Thông tin học phần
  final String tenHocPhan;
  final String maHocPhan;
  final String tenGiangVien;
  final String hocKy;

  // Thông tin giảng viên (mới thêm)
  final String tenTaiKhoan; // tài khoản đăng nhập
  final String maGiangVien; // id giảng viên

  // Thông tin buổi học gốc
  final DateTime ngayBuoiHocNghi;
  final String caHocNghi;
  final String phongHocNghi;
  final String buoiHocSo; // Ví dụ: "13/15"

  // Thông tin đơn nghỉ dạy
  final String nguoiGui;
  final DateTime ngayGui;
  final String? lyDo; // Có thể null
  final List<String>? anhMinhChung;

  // Thông tin buổi học dạy bù
  final DateTime? ngayBuoiHocDayBu;
  final String? caHocDayBu;
  final String? phongHocDayBu;

  TeachingRequestModel({
    required this.maDon,
    required this.loaiDon,
    required this.trangThai,
    required this.tenHocPhan,
    required this.maHocPhan,
    required this.tenGiangVien,
    required this.hocKy,
    required this.tenTaiKhoan,
    required this.maGiangVien,
    required this.ngayBuoiHocNghi,
    required this.caHocNghi,
    required this.phongHocNghi,
    required this.buoiHocSo,
    required this.nguoiGui,
    required this.ngayGui,
    this.lyDo,
    this.anhMinhChung,
    this.ngayBuoiHocDayBu,
    this.caHocDayBu,
    this.phongHocDayBu,
  });

  /// Từ JSON → Object
  factory TeachingRequestModel.fromJson(Map<String, dynamic> json) {
    return TeachingRequestModel(
      maDon: json['maDon'] ?? '',
      loaiDon: json['loaiDon'] ?? 'Đơn xin nghỉ dạy',
      trangThai: json['trangThai'] ?? 'Chưa xác nhận',
      tenHocPhan: json['tenHocPhan'] ?? '',
      maHocPhan: json['maHocPhan'] ?? '',
      tenGiangVien: json['tenGiangVien'] ?? '',
      hocKy: json['hocKy'] ?? '',
      tenTaiKhoan: json['tenTaiKhoan'] ?? '',
      maGiangVien: json['idGiangVien'] ?? '',
      ngayBuoiHocNghi: DateTime.parse(json['ngayBuoiHoc']),
      caHocNghi: json['caHoc'] ?? '',
      phongHocNghi: json['phongHoc'] ?? '',
      buoiHocSo: json['buoiHocSo'] ?? '',
      nguoiGui: json['nguoiGui'] ?? '',
      ngayGui: DateTime.parse(json['ngayGui']),
      lyDo: json['lyDo'],
      anhMinhChung: json['anhMinhChung'] != null
          ? List<String>.from(json['anhMinhChung'])
          : null,
      ngayBuoiHocDayBu: json['ngayBuoiHocDayBu'] != null
          ? DateTime.tryParse(json['ngayBuoiHocDayBu'])
          : null,
      caHocDayBu: json['caHocDayBu'],
      phongHocDayBu: json['phongHocDayBu'],
    );
  }

  /// Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'maDon': maDon,
      'loaiDon': loaiDon,
      'trangThai': trangThai,
      'tenHocPhan': tenHocPhan,
      'maHocPhan': maHocPhan,
      'tenGiangVien': tenGiangVien,
      'hocKy': hocKy,
      'tenTaiKhoan': tenTaiKhoan,
      'idGiangVien': maGiangVien,
      'ngayBuoiHoc': ngayBuoiHocNghi.toIso8601String(),
      'caHoc': caHocNghi,
      'phongHoc': phongHocNghi,
      'buoiHocSo': buoiHocSo,
      'nguoiGui': nguoiGui,
      'ngayGui': ngayGui.toIso8601String(),
      if (lyDo != null) 'lyDo': lyDo,
      if (anhMinhChung != null) 'anhMinhChung': anhMinhChung,
      if (ngayBuoiHocDayBu != null)
        'ngayBuoiHocDayBu': ngayBuoiHocDayBu!.toIso8601String(),
      if (caHocDayBu != null) 'caHocDayBu': caHocDayBu,
      if (phongHocDayBu != null) 'phongHocDayBu': phongHocDayBu,
    };
  }
}
