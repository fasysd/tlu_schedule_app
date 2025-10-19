class PaymentReportModel {
  // Thông tin giảng viên
  final String maGiangVien;
  final String hoVaTen;
  final String email;
  final String boMon;
  
  // Thông tin học kỳ
  final String hocKy;
  final String namHoc;
  
  // Thống kê giờ giảng
  final double gioGiangChuanDinh; // Giờ giảng theo chuẩn định mức
  final double gioGiangVuotChuanDinh; // Giờ giảng vượt chuẩn định mức
  final double tongGioGiang; // Tổng giờ giảng
  
  // Thống kê nghỉ và dạy bù
  final int soBuoiNghi;
  final int soBuoiDayBu;
  final double tiLeDayBu; // Tỷ lệ dạy bù so với nghỉ
  
  // Thông tin thanh toán
  final double donGiaGioChuan; // Đơn giá giờ chuẩn
  final double donGiaGioVuotChuan; // Đơn giá giờ vượt chuẩn
  final double tongTienThanhToan; // Tổng tiền thanh toán
  
  // Trạng thái thanh toán
  final String trangThaiThanhToan; // "Chưa thanh toán", "Đã thanh toán", "Đang xử lý"
  final DateTime? ngayThanhToan;
  
  // Chi tiết các học phần
  final List<HocPhanPaymentModel>? danhSachHocPhan;

  PaymentReportModel({
    required this.maGiangVien,
    required this.hoVaTen,
    required this.email,
    required this.boMon,
    required this.hocKy,
    required this.namHoc,
    required this.gioGiangChuanDinh,
    required this.gioGiangVuotChuanDinh,
    required this.tongGioGiang,
    required this.soBuoiNghi,
    required this.soBuoiDayBu,
    required this.tiLeDayBu,
    required this.donGiaGioChuan,
    required this.donGiaGioVuotChuan,
    required this.tongTienThanhToan,
    required this.trangThaiThanhToan,
    this.ngayThanhToan,
    this.danhSachHocPhan,
  });

  factory PaymentReportModel.fromJson(Map<String, dynamic> json) {
    return PaymentReportModel(
      maGiangVien: json['maGiangVien'] ?? '',
      hoVaTen: json['hoVaTen'] ?? '',
      email: json['email'] ?? '',
      boMon: json['boMon'] ?? '',
      hocKy: json['hocKy'] ?? '',
      namHoc: json['namHoc'] ?? '',
      gioGiangChuanDinh: (json['gioGiangChuanDinh'] ?? 0).toDouble(),
      gioGiangVuotChuanDinh: (json['gioGiangVuotChuanDinh'] ?? 0).toDouble(),
      tongGioGiang: (json['tongGioGiang'] ?? 0).toDouble(),
      soBuoiNghi: json['soBuoiNghi'] ?? 0,
      soBuoiDayBu: json['soBuoiDayBu'] ?? 0,
      tiLeDayBu: (json['tiLeDayBu'] ?? 0).toDouble(),
      donGiaGioChuan: (json['donGiaGioChuan'] ?? 0).toDouble(),
      donGiaGioVuotChuan: (json['donGiaGioVuotChuan'] ?? 0).toDouble(),
      tongTienThanhToan: (json['tongTienThanhToan'] ?? 0).toDouble(),
      trangThaiThanhToan: json['trangThaiThanhToan'] ?? 'Chưa thanh toán',
      ngayThanhToan: json['ngayThanhToan'] != null
          ? DateTime.tryParse(json['ngayThanhToan'])
          : null,
      danhSachHocPhan: json['danhSachHocPhan'] != null
          ? (json['danhSachHocPhan'] as List)
              .map((e) => HocPhanPaymentModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maGiangVien': maGiangVien,
      'hoVaTen': hoVaTen,
      'email': email,
      'boMon': boMon,
      'hocKy': hocKy,
      'namHoc': namHoc,
      'gioGiangChuanDinh': gioGiangChuanDinh,
      'gioGiangVuotChuanDinh': gioGiangVuotChuanDinh,
      'tongGioGiang': tongGioGiang,
      'soBuoiNghi': soBuoiNghi,
      'soBuoiDayBu': soBuoiDayBu,
      'tiLeDayBu': tiLeDayBu,
      'donGiaGioChuan': donGiaGioChuan,
      'donGiaGioVuotChuan': donGiaGioVuotChuan,
      'tongTienThanhToan': tongTienThanhToan,
      'trangThaiThanhToan': trangThaiThanhToan,
      if (ngayThanhToan != null)
        'ngayThanhToan': ngayThanhToan!.toIso8601String(),
      if (danhSachHocPhan != null)
        'danhSachHocPhan':
            danhSachHocPhan!.map((e) => e.toJson()).toList(),
    };
  }

  // Tính tiền giờ chuẩn
  double get tienGioChuan => gioGiangChuanDinh * donGiaGioChuan;

  // Tính tiền giờ vượt chuẩn
  double get tienGioVuotChuan => gioGiangVuotChuanDinh * donGiaGioVuotChuan;

  // Kiểm tra có cần cảnh báo không
  bool get canhBaoTiLeDayBu => tiLeDayBu < 0.8; // Dưới 80% dạy bù
}

class HocPhanPaymentModel {
  final String maHocPhan;
  final String tenHocPhan;
  final String maLopHocPhan;
  final int tongSoTiet;
  final int soTietDaDay;
  final int soTietNghi;
  final int soTietDayBu;
  final double gioGiangThucTe;
  final double tienThanhToan;

  HocPhanPaymentModel({
    required this.maHocPhan,
    required this.tenHocPhan,
    required this.maLopHocPhan,
    required this.tongSoTiet,
    required this.soTietDaDay,
    required this.soTietNghi,
    required this.soTietDayBu,
    required this.gioGiangThucTe,
    required this.tienThanhToan,
  });

  factory HocPhanPaymentModel.fromJson(Map<String, dynamic> json) {
    return HocPhanPaymentModel(
      maHocPhan: json['maHocPhan'] ?? '',
      tenHocPhan: json['tenHocPhan'] ?? '',
      maLopHocPhan: json['maLopHocPhan'] ?? '',
      tongSoTiet: json['tongSoTiet'] ?? 0,
      soTietDaDay: json['soTietDaDay'] ?? 0,
      soTietNghi: json['soTietNghi'] ?? 0,
      soTietDayBu: json['soTietDayBu'] ?? 0,
      gioGiangThucTe: (json['gioGiangThucTe'] ?? 0).toDouble(),
      tienThanhToan: (json['tienThanhToan'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maHocPhan': maHocPhan,
      'tenHocPhan': tenHocPhan,
      'maLopHocPhan': maLopHocPhan,
      'tongSoTiet': tongSoTiet,
      'soTietDaDay': soTietDaDay,
      'soTietNghi': soTietNghi,
      'soTietDayBu': soTietDayBu,
      'gioGiangThucTe': gioGiangThucTe,
      'tienThanhToan': tienThanhToan,
    };
  }

  // Tính tỷ lệ hoàn thành
  double get tiLeHoanThanh =>
      tongSoTiet == 0 ? 0 : (soTietDaDay / tongSoTiet);

  // Tính tỷ lệ nghỉ
  double get tiLeNghi => tongSoTiet == 0 ? 0 : (soTietNghi / tongSoTiet);

  // Tính tỷ lệ dạy bù
  double get tiLeDayBu => soTietNghi == 0 ? 0 : (soTietDayBu / soTietNghi);
}

