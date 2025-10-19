class AttendanceReportModel {
  // Thông tin học phần
  final String maHocPhan;
  final String tenHocPhan;
  final String maLopHocPhan;
  final String hocKy;
  final String namHoc;
  
  // Thông tin giảng viên
  final String maGiangVien;
  final String tenGiangVien;
  
  // Thống kê chuyên cần tổng quan
  final int tongSoSinhVien;
  final int tongSoBuoiHoc;
  final int soBuoiDaDiemDanh;
  final double tiLeChuyenCanTrungBinh;
  
  // Thống kê chi tiết theo sinh viên
  final List<SinhVienAttendanceModel>? danhSachSinhVien;
  
  // Thống kê theo buổi học
  final List<BuoiHocAttendanceModel>? danhSachBuoiHoc;

  AttendanceReportModel({
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

  factory AttendanceReportModel.fromJson(Map<String, dynamic> json) {
    return AttendanceReportModel(
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
      tiLeChuyenCanTrungBinh: (json['tiLeChuyenCanTrungBinh'] ?? 0).toDouble(),
      danhSachSinhVien: json['danhSachSinhVien'] != null
          ? (json['danhSachSinhVien'] as List)
              .map((e) => SinhVienAttendanceModel.fromJson(e))
              .toList()
          : null,
      danhSachBuoiHoc: json['danhSachBuoiHoc'] != null
          ? (json['danhSachBuoiHoc'] as List)
              .map((e) => BuoiHocAttendanceModel.fromJson(e))
              .toList()
          : null,
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
      'tongSoSinhVien': tongSoSinhVien,
      'tongSoBuoiHoc': tongSoBuoiHoc,
      'soBuoiDaDiemDanh': soBuoiDaDiemDanh,
      'tiLeChuyenCanTrungBinh': tiLeChuyenCanTrungBinh,
      if (danhSachSinhVien != null)
        'danhSachSinhVien':
            danhSachSinhVien!.map((e) => e.toJson()).toList(),
      if (danhSachBuoiHoc != null)
        'danhSachBuoiHoc':
            danhSachBuoiHoc!.map((e) => e.toJson()).toList(),
    };
  }
}

class SinhVienAttendanceModel {
  final String maSinhVien;
  final String hoTen;
  final String lop;
  final int soBuoiCoMat;
  final int soBuoiVang;
  final double tiLeChuyenCan;
  final String trangThai; // "Đạt", "Không đạt", "Cảnh báo"

  SinhVienAttendanceModel({
    required this.maSinhVien,
    required this.hoTen,
    required this.lop,
    required this.soBuoiCoMat,
    required this.soBuoiVang,
    required this.tiLeChuyenCan,
    required this.trangThai,
  });

  factory SinhVienAttendanceModel.fromJson(Map<String, dynamic> json) {
    return SinhVienAttendanceModel(
      maSinhVien: json['maSinhVien'] ?? '',
      hoTen: json['hoTen'] ?? '',
      lop: json['lop'] ?? '',
      soBuoiCoMat: json['soBuoiCoMat'] ?? 0,
      soBuoiVang: json['soBuoiVang'] ?? 0,
      tiLeChuyenCan: (json['tiLeChuyenCan'] ?? 0).toDouble(),
      trangThai: json['trangThai'] ?? 'Đạt',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSinhVien': maSinhVien,
      'hoTen': hoTen,
      'lop': lop,
      'soBuoiCoMat': soBuoiCoMat,
      'soBuoiVang': soBuoiVang,
      'tiLeChuyenCan': tiLeChuyenCan,
      'trangThai': trangThai,
    };
  }
}

class BuoiHocAttendanceModel {
  final int buoiSo;
  final DateTime ngayHoc;
  final String caHoc;
  final String phongHoc;
  final int tongSoSinhVien;
  final int soSinhVienCoMat;
  final int soSinhVienVang;
  final double tiLeChuyenCan;
  final String? noiDungDay;
  final String? ghiChu;

  BuoiHocAttendanceModel({
    required this.buoiSo,
    required this.ngayHoc,
    required this.caHoc,
    required this.phongHoc,
    required this.tongSoSinhVien,
    required this.soSinhVienCoMat,
    required this.soSinhVienVang,
    required this.tiLeChuyenCan,
    this.noiDungDay,
    this.ghiChu,
  });

  factory BuoiHocAttendanceModel.fromJson(Map<String, dynamic> json) {
    return BuoiHocAttendanceModel(
      buoiSo: json['buoiSo'] ?? 0,
      ngayHoc: DateTime.parse(json['ngayHoc']),
      caHoc: json['caHoc'] ?? '',
      phongHoc: json['phongHoc'] ?? '',
      tongSoSinhVien: json['tongSoSinhVien'] ?? 0,
      soSinhVienCoMat: json['soSinhVienCoMat'] ?? 0,
      soSinhVienVang: json['soSinhVienVang'] ?? 0,
      tiLeChuyenCan: (json['tiLeChuyenCan'] ?? 0).toDouble(),
      noiDungDay: json['noiDungDay'],
      ghiChu: json['ghiChu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buoiSo': buoiSo,
      'ngayHoc': ngayHoc.toIso8601String(),
      'caHoc': caHoc,
      'phongHoc': phongHoc,
      'tongSoSinhVien': tongSoSinhVien,
      'soSinhVienCoMat': soSinhVienCoMat,
      'soSinhVienVang': soSinhVienVang,
      'tiLeChuyenCan': tiLeChuyenCan,
      if (noiDungDay != null) 'noiDungDay': noiDungDay,
      if (ghiChu != null) 'ghiChu': ghiChu,
    };
  }
}

