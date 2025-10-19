class LecturerModel {
  final String maGiangVien;
  final String tenTaiKhoan;
  final String hoVaTen;
  final DateTime ngaySinh;
  final String email;
  final String soDienThoai;

  // 🧩 Thông tin dạy học
  final int soHocPhanDangDay;

  // 🧾 Thông tin đơn từ
  final int soDonNghiDayCanDuyet;
  final int soDonDayBuCanDuyet;

  // 📊 Thống kê
  final int tongSoBuoiDay;
  final int soBuoiNghi;
  final int soBuoiDayBu;

  // 🧍‍♂️ Ảnh đại diện
  final String duongDanAvatar;

  LecturerModel({
    required this.maGiangVien,
    required this.tenTaiKhoan,
    required this.hoVaTen,
    required this.ngaySinh,
    required this.email,
    required this.soDienThoai,
    required this.soHocPhanDangDay,
    required this.soDonNghiDayCanDuyet,
    required this.soDonDayBuCanDuyet,
    required this.tongSoBuoiDay,
    required this.soBuoiNghi,
    required this.soBuoiDayBu,
    this.duongDanAvatar = 'assets/images/defaultAvatar.png',
  });

  /// ✅ Chuyển từ JSON sang Object
  factory LecturerModel.fromJson(Map<String, dynamic> json) {
    return LecturerModel(
      maGiangVien: json['maGiangVien'] ?? '',
      tenTaiKhoan: json['tenTaiKhoan'] ?? '',
      hoVaTen: json['hoVaTen'] ?? '',
      ngaySinh: DateTime.tryParse(json['ngaySinh'] ?? '') ?? DateTime(2000),
      email: json['email'] ?? '',
      soDienThoai: json['soDienThoai'] ?? '',
      soHocPhanDangDay: json['soHocPhanDangDay'] ?? 0,
      soDonNghiDayCanDuyet: json['soDonNghiDayCanDuyet'] ?? 0,
      soDonDayBuCanDuyet: json['soDonDayBuCanDuyet'] ?? 0,
      tongSoBuoiDay: json['tongSoBuoiDay'] ?? 0,
      soBuoiNghi: json['soBuoiNghi'] ?? 0,
      soBuoiDayBu: json['soBuoiDayBu'] ?? 0,
      duongDanAvatar:
          json['duongDanAvatar'] ?? 'assets/images/defaultAvatar.png',
    );
  }

  /// ✅ Chuyển từ Object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'maGiangVien': maGiangVien,
      'tenTaiKhoan': tenTaiKhoan,
      'hoVaTen': hoVaTen,
      'ngaySinh': ngaySinh.toIso8601String(),
      'email': email,
      'soDienThoai': soDienThoai,
      'soHocPhanDangDay': soHocPhanDangDay,
      'soDonNghiDayCanDuyet': soDonNghiDayCanDuyet,
      'soDonDayBuCanDuyet': soDonDayBuCanDuyet,
      'tongSoBuoiDay': tongSoBuoiDay,
      'soBuoiNghi': soBuoiNghi,
      'soBuoiDayBu': soBuoiDayBu,
      'duongDanAvatar': duongDanAvatar,
    };
  }

  /// 🧮 Hàm tính tỉ lệ (có thể dùng trong giao diện thống kê)
  double get tiLeHoanThanh =>
      tongSoBuoiDay == 0 ? 0 : ((tongSoBuoiDay - soBuoiNghi) / tongSoBuoiDay);
  double get tiLeNghiDay =>
      tongSoBuoiDay == 0 ? 0 : (soBuoiNghi / tongSoBuoiDay);
  double get tiLeDayBu =>
      tongSoBuoiDay == 0 ? 0 : (soBuoiDayBu / tongSoBuoiDay);
}
