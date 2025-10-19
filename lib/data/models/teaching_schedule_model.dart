class TeachingScheduleModel {
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
  
  // Thông tin lịch trình
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final int tongSoBuoi;
  final int soTietMoiBuoi;
  final String thuTrongTuan; // "Thứ 2", "Thứ 3", etc.
  final String caHoc; // "Ca 1", "Ca 2", etc.
  final String phongHoc;
  
  // Thông tin tiến độ
  final int soBuoiDaDay;
  final int soBuoiNghi;
  final int soBuoiDayBu;
  final int soBuoiConLai;
  
  // Trạng thái
  final String trangThai; // "Đang diễn ra", "Hoàn thành", "Tạm dừng"
  
  // Danh sách chi tiết các buổi học
  final List<BuoiHocModel>? danhSachBuoiHoc;

  TeachingScheduleModel({
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

  factory TeachingScheduleModel.fromJson(Map<String, dynamic> json) {
    return TeachingScheduleModel(
      maLichTrinh: json['maLichTrinh'] ?? '',
      maHocPhan: json['maHocPhan'] ?? '',
      tenHocPhan: json['tenHocPhan'] ?? '',
      maLopHocPhan: json['maLopHocPhan'] ?? '',
      hocKy: json['hocKy'] ?? '',
      namHoc: json['namHoc'] ?? '',
      maGiangVien: json['maGiangVien'] ?? '',
      tenGiangVien: json['tenGiangVien'] ?? '',
      ngayBatDau: DateTime.parse(json['ngayBatDau']),
      ngayKetThuc: DateTime.parse(json['ngayKetThuc']),
      tongSoBuoi: json['tongSoBuoi'] ?? 0,
      soTietMoiBuoi: json['soTietMoiBuoi'] ?? 0,
      thuTrongTuan: json['thuTrongTuan'] ?? '',
      caHoc: json['caHoc'] ?? '',
      phongHoc: json['phongHoc'] ?? '',
      soBuoiDaDay: json['soBuoiDaDay'] ?? 0,
      soBuoiNghi: json['soBuoiNghi'] ?? 0,
      soBuoiDayBu: json['soBuoiDayBu'] ?? 0,
      soBuoiConLai: json['soBuoiConLai'] ?? 0,
      trangThai: json['trangThai'] ?? 'Đang diễn ra',
      danhSachBuoiHoc: json['danhSachBuoiHoc'] != null
          ? (json['danhSachBuoiHoc'] as List)
              .map((e) => BuoiHocModel.fromJson(e))
              .toList()
          : null,
    );
  }

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
      if (danhSachBuoiHoc != null)
        'danhSachBuoiHoc':
            danhSachBuoiHoc!.map((e) => e.toJson()).toList(),
    };
  }

  // Tính tỷ lệ hoàn thành
  double get tiLeHoanThanh =>
      tongSoBuoi == 0 ? 0 : (soBuoiDaDay / tongSoBuoi);

  // Tính tỷ lệ nghỉ
  double get tiLeNghi => tongSoBuoi == 0 ? 0 : (soBuoiNghi / tongSoBuoi);

  // Tính tỷ lệ dạy bù
  double get tiLeDayBu => soBuoiNghi == 0 ? 0 : (soBuoiDayBu / soBuoiNghi);

  // Tính tổng số tiết
  int get tongSoTiet => tongSoBuoi * soTietMoiBuoi;

  // Tính số tiết đã dạy
  int get soTietDaDay => soBuoiDaDay * soTietMoiBuoi;

  // Tính số tiết nghỉ
  int get soTietNghi => soBuoiNghi * soTietMoiBuoi;

  // Tính số tiết dạy bù
  int get soTietDayBu => soBuoiDayBu * soTietMoiBuoi;
}

class BuoiHocModel {
  final String maBuoiHoc;
  final int buoiSo; // Buổi số thứ tự
  final DateTime ngayHoc;
  final String caHoc;
  final String phongHoc;
  final String trangThai; // "Chưa dạy", "Đã dạy", "Nghỉ", "Dạy bù"
  
  // Thông tin nội dung buổi học
  final String? noiDungDay;
  final String? ghiChu;
  final DateTime? thoiGianBatDau;
  final DateTime? thoiGianKetThuc;
  
  // Thông tin điểm danh
  final int? tongSoSinhVien;
  final int? soSinhVienCoMat;
  final int? soSinhVienVang;
  final double? tiLeChuyenCan;
  
  // Thông tin nghỉ dạy
  final String? lyDoNghi;
  final List<String>? anhMinhChung;
  final String? trangThaiDuyetNghi; // "Chờ duyệt", "Đã duyệt", "Từ chối"
  final DateTime? ngayDangKyNghi;
  final String? nguoiDuyetNghi;
  
  // Thông tin dạy bù
  final DateTime? ngayDayBu;
  final String? caHocDayBu;
  final String? phongHocDayBu;
  final String? trangThaiDuyetDayBu;
  final DateTime? ngayDangKyDayBu;
  final String? nguoiDuyetDayBu;

  BuoiHocModel({
    required this.maBuoiHoc,
    required this.buoiSo,
    required this.ngayHoc,
    required this.caHoc,
    required this.phongHoc,
    required this.trangThai,
    this.noiDungDay,
    this.ghiChu,
    this.thoiGianBatDau,
    this.thoiGianKetThuc,
    this.tongSoSinhVien,
    this.soSinhVienCoMat,
    this.soSinhVienVang,
    this.tiLeChuyenCan,
    this.lyDoNghi,
    this.anhMinhChung,
    this.trangThaiDuyetNghi,
    this.ngayDangKyNghi,
    this.nguoiDuyetNghi,
    this.ngayDayBu,
    this.caHocDayBu,
    this.phongHocDayBu,
    this.trangThaiDuyetDayBu,
    this.ngayDangKyDayBu,
    this.nguoiDuyetDayBu,
  });

  factory BuoiHocModel.fromJson(Map<String, dynamic> json) {
    return BuoiHocModel(
      maBuoiHoc: json['maBuoiHoc'] ?? '',
      buoiSo: json['buoiSo'] ?? 0,
      ngayHoc: DateTime.parse(json['ngayHoc']),
      caHoc: json['caHoc'] ?? '',
      phongHoc: json['phongHoc'] ?? '',
      trangThai: json['trangThai'] ?? 'Chưa dạy',
      noiDungDay: json['noiDungDay'],
      ghiChu: json['ghiChu'],
      thoiGianBatDau: json['thoiGianBatDau'] != null
          ? DateTime.tryParse(json['thoiGianBatDau'])
          : null,
      thoiGianKetThuc: json['thoiGianKetThuc'] != null
          ? DateTime.tryParse(json['thoiGianKetThuc'])
          : null,
      tongSoSinhVien: json['tongSoSinhVien'],
      soSinhVienCoMat: json['soSinhVienCoMat'],
      soSinhVienVang: json['soSinhVienVang'],
      tiLeChuyenCan: json['tiLeChuyenCan']?.toDouble(),
      lyDoNghi: json['lyDoNghi'],
      anhMinhChung: json['anhMinhChung'] != null
          ? List<String>.from(json['anhMinhChung'])
          : null,
      trangThaiDuyetNghi: json['trangThaiDuyetNghi'],
      ngayDangKyNghi: json['ngayDangKyNghi'] != null
          ? DateTime.tryParse(json['ngayDangKyNghi'])
          : null,
      nguoiDuyetNghi: json['nguoiDuyetNghi'],
      ngayDayBu: json['ngayDayBu'] != null
          ? DateTime.tryParse(json['ngayDayBu'])
          : null,
      caHocDayBu: json['caHocDayBu'],
      phongHocDayBu: json['phongHocDayBu'],
      trangThaiDuyetDayBu: json['trangThaiDuyetDayBu'],
      ngayDangKyDayBu: json['ngayDangKyDayBu'] != null
          ? DateTime.tryParse(json['ngayDangKyDayBu'])
          : null,
      nguoiDuyetDayBu: json['nguoiDuyetDayBu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maBuoiHoc': maBuoiHoc,
      'buoiSo': buoiSo,
      'ngayHoc': ngayHoc.toIso8601String(),
      'caHoc': caHoc,
      'phongHoc': phongHoc,
      'trangThai': trangThai,
      if (noiDungDay != null) 'noiDungDay': noiDungDay,
      if (ghiChu != null) 'ghiChu': ghiChu,
      if (thoiGianBatDau != null)
        'thoiGianBatDau': thoiGianBatDau!.toIso8601String(),
      if (thoiGianKetThuc != null)
        'thoiGianKetThuc': thoiGianKetThuc!.toIso8601String(),
      if (tongSoSinhVien != null) 'tongSoSinhVien': tongSoSinhVien,
      if (soSinhVienCoMat != null) 'soSinhVienCoMat': soSinhVienCoMat,
      if (soSinhVienVang != null) 'soSinhVienVang': soSinhVienVang,
      if (tiLeChuyenCan != null) 'tiLeChuyenCan': tiLeChuyenCan,
      if (lyDoNghi != null) 'lyDoNghi': lyDoNghi,
      if (anhMinhChung != null) 'anhMinhChung': anhMinhChung,
      if (trangThaiDuyetNghi != null) 'trangThaiDuyetNghi': trangThaiDuyetNghi,
      if (ngayDangKyNghi != null)
        'ngayDangKyNghi': ngayDangKyNghi!.toIso8601String(),
      if (nguoiDuyetNghi != null) 'nguoiDuyetNghi': nguoiDuyetNghi,
      if (ngayDayBu != null) 'ngayDayBu': ngayDayBu!.toIso8601String(),
      if (caHocDayBu != null) 'caHocDayBu': caHocDayBu,
      if (phongHocDayBu != null) 'phongHocDayBu': phongHocDayBu,
      if (trangThaiDuyetDayBu != null) 'trangThaiDuyetDayBu': trangThaiDuyetDayBu,
      if (ngayDangKyDayBu != null)
        'ngayDangKyDayBu': ngayDangKyDayBu!.toIso8601String(),
      if (nguoiDuyetDayBu != null) 'nguoiDuyetDayBu': nguoiDuyetDayBu,
    };
  }

  // Kiểm tra có cần cảnh báo không
  bool get canhBaoNghiDay => 
      trangThai == 'Nghỉ' && trangThaiDuyetNghi == 'Chờ duyệt';

  bool get canhBaoDayBu => 
      trangThai == 'Nghỉ' && ngayDayBu == null;

  // Tính tỷ lệ chuyên cần
  double get tiLeChuyenCanTinhToan =>
      tongSoSinhVien == null || tongSoSinhVien == 0 
          ? 0 
          : (soSinhVienCoMat ?? 0) / tongSoSinhVien;
}

