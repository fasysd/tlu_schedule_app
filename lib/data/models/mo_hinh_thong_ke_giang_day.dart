class MoHinhThongKeGiangDay {
  // Thông tin giảng viên
  final String maGiangVien;
  final String hoVaTen;
  final String email;
  final String duongDanAvatar;

  // Thống kê giờ giảng dạy
  final int tongSoTiet; // Tổng số tiết được phân công
  final int soTietDaDay; // Số tiết đã hoàn thành
  final int soTietNghi; // Số tiết nghỉ
  final int soTietDayBu; // Số tiết dạy bù
  final int soTietConLai; // Số tiết còn lại chưa dạy

  // Thống kê theo thời gian
  final String hocKy;
  final String namHoc;

  // Thống kê tài chính (nếu có)
  final double gioGiangTheoChuanDinh; // Giờ giảng theo chuẩn định mức
  final double gioGiangVuotChuanDinh; // Giờ giảng vượt chuẩn
  final double gioTangCa; // Giờ tăng ca
  final double tongGioThanhToan; // Tổng giờ cần thanh toán

  MoHinhThongKeGiangDay({
    required this.maGiangVien,
    required this.hoVaTen,
    required this.email,
    this.duongDanAvatar = 'assets/images/defaultAvatar.png',
    required this.tongSoTiet,
    required this.soTietDaDay,
    required this.soTietNghi,
    required this.soTietDayBu,
    required this.soTietConLai,
    required this.hocKy,
    required this.namHoc,
    required this.gioGiangTheoChuanDinh,
    required this.gioGiangVuotChuanDinh,
    required this.gioTangCa,
    required this.tongGioThanhToan,
  });

  /// Từ JSON → Object
  factory MoHinhThongKeGiangDay.fromJson(Map<String, dynamic> json) {
    return MoHinhThongKeGiangDay(
      maGiangVien: json['maGiangVien'] ?? '',
      hoVaTen: json['hoVaTen'] ?? '',
      email: json['email'] ?? '',
      duongDanAvatar:
          json['duongDanAvatar'] ?? 'assets/images/defaultAvatar.png',
      tongSoTiet: json['tongSoTiet'] ?? 0,
      soTietDaDay: json['soTietDaDay'] ?? 0,
      soTietNghi: json['soTietNghi'] ?? 0,
      soTietDayBu: json['soTietDayBu'] ?? 0,
      soTietConLai: json['soTietConLai'] ?? 0,
      hocKy: json['hocKy'] ?? '',
      namHoc: json['namHoc'] ?? '',
      gioGiangTheoChuanDinh:
          (json['gioGiangTheoChuanDinh'] ?? 0).toDouble(),
      gioGiangVuotChuanDinh: (json['gioGiangVuotChuanDinh'] ?? 0).toDouble(),
      gioTangCa: (json['gioTangCa'] ?? 0).toDouble(),
      tongGioThanhToan: (json['tongGioThanhToan'] ?? 0).toDouble(),
    );
  }

  /// Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'maGiangVien': maGiangVien,
      'hoVaTen': hoVaTen,
      'email': email,
      'duongDanAvatar': duongDanAvatar,
      'tongSoTiet': tongSoTiet,
      'soTietDaDay': soTietDaDay,
      'soTietNghi': soTietNghi,
      'soTietDayBu': soTietDayBu,
      'soTietConLai': soTietConLai,
      'hocKy': hocKy,
      'namHoc': namHoc,
      'gioGiangTheoChuanDinh': gioGiangTheoChuanDinh,
      'gioGiangVuotChuanDinh': gioGiangVuotChuanDinh,
      'gioTangCa': gioTangCa,
      'tongGioThanhToan': tongGioThanhToan,
    };
  }

  /// Tính tỷ lệ hoàn thành
  double get tiLeHoanThanh =>
      tongSoTiet == 0 ? 0 : (soTietDaDay / tongSoTiet);

  /// Tính tỷ lệ nghỉ
  double get tiLeNghi => tongSoTiet == 0 ? 0 : (soTietNghi / tongSoTiet);

  /// Tính tỷ lệ dạy bù
  double get tiLeDayBu =>
      soTietNghi == 0 ? 0 : (soTietDayBu / soTietNghi);
}

