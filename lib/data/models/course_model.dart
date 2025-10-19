class CourseModel {
  final String maHocPhan; // Mã học phần, ví dụ: APP101
  final String tenHocPhan; // Tên học phần, ví dụ: PHÁT TRIỂN ỨNG DỤNG DI ĐỘNG
  final int soTinChi; // Số tín chỉ, ví dụ: 3

  CourseModel({
    required this.maHocPhan,
    required this.tenHocPhan,
    required this.soTinChi,
  });

  /// Chuyển từ JSON → CourseModel (phục vụ khi lấy từ API/Firebase)
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      maHocPhan: json['maHocPhan'] ?? '',
      tenHocPhan: json['tenHocPhan'] ?? '',
      soTinChi: json['soTinChi'] ?? 0,
    );
  }

  /// Chuyển từ CourseModel → JSON (phục vụ khi lưu trữ)
  Map<String, dynamic> toJson() {
    return {
      'maHocPhan': maHocPhan,
      'tenHocPhan': tenHocPhan,
      'soTinChi': soTinChi,
    };
  }

  /// Tạo bản sao (copy) với giá trị mới
  CourseModel copyWith({String? maHocPhan, String? tenHocPhan, int? soTinChi}) {
    return CourseModel(
      maHocPhan: maHocPhan ?? this.maHocPhan,
      tenHocPhan: tenHocPhan ?? this.tenHocPhan,
      soTinChi: soTinChi ?? this.soTinChi,
    );
  }

  @override
  String toString() {
    return '$maHocPhan - $tenHocPhan ($soTinChi tín chỉ)';
  }
}
