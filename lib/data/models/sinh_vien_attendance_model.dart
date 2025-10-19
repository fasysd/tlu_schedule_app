class SinhVienAttendanceModel {
  final String maSinhVien;
  final String hoVaTen;
  final String lop;
  final int soBuoiCoMat;
  final int tongSoBuoi;
  final double tiLeChuyenCan;

  SinhVienAttendanceModel({
    required this.maSinhVien,
    required this.hoVaTen,
    required this.lop,
    required this.soBuoiCoMat,
    required this.tongSoBuoi,
    required this.tiLeChuyenCan,
  });

  factory SinhVienAttendanceModel.fromJson(Map<String, dynamic> json) {
    return SinhVienAttendanceModel(
      maSinhVien: json['maSinhVien'] ?? '',
      hoVaTen: json['hoVaTen'] ?? '',
      lop: json['lop'] ?? '',
      soBuoiCoMat: json['soBuoiCoMat'] ?? 0,
      tongSoBuoi: json['tongSoBuoi'] ?? 0,
      tiLeChuyenCan: (json['tiLeChuyenCan'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSinhVien': maSinhVien,
      'hoVaTen': hoVaTen,
      'lop': lop,
      'soBuoiCoMat': soBuoiCoMat,
      'tongSoBuoi': tongSoBuoi,
      'tiLeChuyenCan': tiLeChuyenCan,
    };
  }
}
