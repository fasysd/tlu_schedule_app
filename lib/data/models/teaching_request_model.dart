class TeachingRequestModel {
  final String maDon;
  final String maLopHocPhan;
  final String maGiangVien;
  final String trangThai;
  final String loaiDon; // "Đơn xin nghỉ" hoặc "Đơn dạy bù"

  // Thông tin buổi học gốc
  final String soPhong;
  final DateTime ngayDay;
  final String caDay;

  // 🟢 Nếu là đơn xin nghỉ
  final String? lyDo; // có thể null
  final String? anhMinhChung; // đường dẫn ảnh minh chứng

  // 🔵 Nếu là đơn dạy bù
  final String? soPhongDayBu;
  final DateTime? ngayDayBu;
  final String? caDayBu;

  TeachingRequestModel({
    required this.maDon,
    required this.maLopHocPhan,
    required this.maGiangVien,
    required this.trangThai,
    required this.loaiDon,
    required this.soPhong,
    required this.ngayDay,
    required this.caDay,
    this.lyDo,
    this.anhMinhChung,
    this.soPhongDayBu,
    this.ngayDayBu,
    this.caDayBu,
  });

  /// Chuyển từ JSON → Object
  factory TeachingRequestModel.fromJson(Map<String, dynamic> json) {
    return TeachingRequestModel(
      maDon: json['maDon'] ?? '',
      maLopHocPhan: json['maLopHocPhan'] ?? '',
      maGiangVien: json['maGiangVien'] ?? '',
      trangThai: json['trangThai'] ?? 'Chưa xác nhận',
      loaiDon: json['loaiDon'] ?? 'Đơn nghỉ dạy',

      soPhong: json['soPhong'] ?? '',
      ngayDay: DateTime.parse(json['ngayDay']),
      caDay: json['caDay'] ?? '',

      // Nếu là đơn xin nghỉ
      lyDo: json['lyDo'],
      anhMinhChung: json['anhMinhChung'],

      // Nếu là đơn dạy bù
      soPhongDayBu: json['soPhongDayBu'],
      ngayDayBu: json['ngayDayBu'] != null
          ? DateTime.tryParse(json['ngayDayBu'])
          : null,
      caDayBu: json['caDayBu'],
    );
  }

  /// Chuyển từ Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'maDon': maDon,
      'maLopHocPhan': maLopHocPhan,
      'maGiangVien': maGiangVien,
      'trangThai': trangThai,
      'loaiDon': loaiDon,
      'soPhong': soPhong,
      'ngayDay': ngayDay.toIso8601String(),
      'caDay': caDay,

      // Nếu là đơn xin nghỉ
      if (lyDo != null) 'lyDo': lyDo,
      if (anhMinhChung != null) 'anhMinhChung': anhMinhChung,

      // Nếu là đơn dạy bù
      if (soPhongDayBu != null) 'soPhongDayBu': soPhongDayBu,
      if (ngayDayBu != null) 'ngayDayBu': ngayDayBu!.toIso8601String(),
      if (caDayBu != null) 'caDayBu': caDayBu,
    };
  }
}
