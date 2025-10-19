class CourseModel {
  final String maHocPhan;
  final String tenHocPhan;
  final String maLopHocPhan;
  final String hocKy;
  final String namHoc;
  final String maGiangVien;
  final String tenGiangVien;
  final String boMon;
  final int soTinChi;
  final int soSinhVien;
  final String thoiGianHoc;
  final String gioBatDau;
  final String gioKetThuc;
  final String phongHoc;
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final int tongSoBuoi;
  final int soBuoiDaDay;
  final int soBuoiNghi;
  final int soBuoiDayBu;
  final int soBuoiConLai;
  final String trangThai;
  final double tiLeHoanThanh;

  CourseModel({
    required this.maHocPhan,
    required this.tenHocPhan,
    required this.maLopHocPhan,
    required this.hocKy,
    required this.namHoc,
    required this.maGiangVien,
    required this.tenGiangVien,
    required this.boMon,
    required this.soTinChi,
    required this.soSinhVien,
    required this.thoiGianHoc,
    required this.gioBatDau,
    required this.gioKetThuc,
    required this.phongHoc,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.tongSoBuoi,
    required this.soBuoiDaDay,
    required this.soBuoiNghi,
    required this.soBuoiDayBu,
    required this.soBuoiConLai,
    required this.trangThai,
    required this.tiLeHoanThanh,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      maHocPhan: json['maHocPhan'] ?? '',
      tenHocPhan: json['tenHocPhan'] ?? '',
      maLopHocPhan: json['maLopHocPhan'] ?? '',
      hocKy: json['hocKy'] ?? '',
      namHoc: json['namHoc'] ?? '',
      maGiangVien: json['maGiangVien'] ?? '',
      tenGiangVien: json['tenGiangVien'] ?? '',
      boMon: json['boMon'] ?? '',
      soTinChi: json['soTinChi'] ?? 0,
      soSinhVien: json['soSinhVien'] ?? 0,
      thoiGianHoc: json['thoiGianHoc'] ?? '',
      gioBatDau: json['gioBatDau'] ?? '',
      gioKetThuc: json['gioKetThuc'] ?? '',
      phongHoc: json['phongHoc'] ?? '',
      ngayBatDau: DateTime.parse(json['ngayBatDau']),
      ngayKetThuc: DateTime.parse(json['ngayKetThuc']),
      tongSoBuoi: json['tongSoBuoi'] ?? 0,
      soBuoiDaDay: json['soBuoiDaDay'] ?? 0,
      soBuoiNghi: json['soBuoiNghi'] ?? 0,
      soBuoiDayBu: json['soBuoiDayBu'] ?? 0,
      soBuoiConLai: json['soBuoiConLai'] ?? 0,
      trangThai: json['trangThai'] ?? 'Đang dạy',
      tiLeHoanThanh: (json['tiLeHoanThanh'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maHocPhan': maHocPhan,
      'tenHocPhan': tenHocPhan,
      'maLopHocPhan': maLopHocPhan,
      'hocKy': hocKy,
      'namHoc': namHoc,
      'maGiangVien': maGiangVien,
      'tenGiangVien': tenGiangVien,
      'boMon': boMon,
      'soTinChi': soTinChi,
      'soSinhVien': soSinhVien,
      'thoiGianHoc': thoiGianHoc,
      'gioBatDau': gioBatDau,
      'gioKetThuc': gioKetThuc,
      'phongHoc': phongHoc,
      'ngayBatDau': ngayBatDau.toIso8601String(),
      'ngayKetThuc': ngayKetThuc.toIso8601String(),
      'tongSoBuoi': tongSoBuoi,
      'soBuoiDaDay': soBuoiDaDay,
      'soBuoiNghi': soBuoiNghi,
      'soBuoiDayBu': soBuoiDayBu,
      'soBuoiConLai': soBuoiConLai,
      'trangThai': trangThai,
      'tiLeHoanThanh': tiLeHoanThanh,
    };
  }

  CourseModel copyWith({
    String? maHocPhan,
    String? tenHocPhan,
    String? maLopHocPhan,
    String? hocKy,
    String? namHoc,
    String? maGiangVien,
    String? tenGiangVien,
    String? boMon,
    int? soTinChi,
    int? soSinhVien,
    String? thoiGianHoc,
    String? gioBatDau,
    String? gioKetThuc,
    String? phongHoc,
    DateTime? ngayBatDau,
    DateTime? ngayKetThuc,
    int? tongSoBuoi,
    int? soBuoiDaDay,
    int? soBuoiNghi,
    int? soBuoiDayBu,
    int? soBuoiConLai,
    String? trangThai,
    double? tiLeHoanThanh,
  }) {
    return CourseModel(
      maHocPhan: maHocPhan ?? this.maHocPhan,
      tenHocPhan: tenHocPhan ?? this.tenHocPhan,
      maLopHocPhan: maLopHocPhan ?? this.maLopHocPhan,
      hocKy: hocKy ?? this.hocKy,
      namHoc: namHoc ?? this.namHoc,
      maGiangVien: maGiangVien ?? this.maGiangVien,
      tenGiangVien: tenGiangVien ?? this.tenGiangVien,
      boMon: boMon ?? this.boMon,
      soTinChi: soTinChi ?? this.soTinChi,
      soSinhVien: soSinhVien ?? this.soSinhVien,
      thoiGianHoc: thoiGianHoc ?? this.thoiGianHoc,
      gioBatDau: gioBatDau ?? this.gioBatDau,
      gioKetThuc: gioKetThuc ?? this.gioKetThuc,
      phongHoc: phongHoc ?? this.phongHoc,
      ngayBatDau: ngayBatDau ?? this.ngayBatDau,
      ngayKetThuc: ngayKetThuc ?? this.ngayKetThuc,
      tongSoBuoi: tongSoBuoi ?? this.tongSoBuoi,
      soBuoiDaDay: soBuoiDaDay ?? this.soBuoiDaDay,
      soBuoiNghi: soBuoiNghi ?? this.soBuoiNghi,
      soBuoiDayBu: soBuoiDayBu ?? this.soBuoiDayBu,
      soBuoiConLai: soBuoiConLai ?? this.soBuoiConLai,
      trangThai: trangThai ?? this.trangThai,
      tiLeHoanThanh: tiLeHoanThanh ?? this.tiLeHoanThanh,
    );
  }
}