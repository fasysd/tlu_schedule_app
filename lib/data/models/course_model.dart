class CourseModel {
  final String maHocPhan; // Mã học phần, ví dụ: APP101
  final String tenHocPhan; // Tên học phần, ví dụ: PHÁT TRIỂN ỨNG DỤNG DI ĐỘNG
  final int soTinChi; // Số tín chỉ
  final String lopHoc; // Lớp học phần
  final DateTime ngayBatDau; // Ngày bắt đầu học phần
  final DateTime ngayKetThuc; // Ngày kết thúc học phần
  final Map<String, Set<String>> lichHoc; // ⬅ đổi thành 1 map duy nhất

  CourseModel({
    required this.maHocPhan,
    required this.tenHocPhan,
    required this.soTinChi,
    required this.lopHoc,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.lichHoc,
  });

  /// 🔹 Tạo model mặc định (dùng khi test hoặc hiển thị tạm)
  static CourseModel defaultCourse() {
    return CourseModel(
      maHocPhan: 'APP101',
      tenHocPhan: 'Lập trình Flutter cơ bản',
      soTinChi: 3,
      lopHoc: 'DHKTPM15A',
      ngayBatDau: DateTime(2025, 9, 5),
      ngayKetThuc: DateTime(2025, 12, 15),
      lichHoc: {
        '• Thứ Hai: Tiết 1-3': {'B101'},
        '• Thứ Tư: Tiết 4-6': {'B203'},
        '• Thứ Sáu: Tiết 1-3': {'C305'},
      },
    );
  }

  /// 🔹 Chuyển từ JSON → CourseModel
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, Set<String>> lichHocParsed = {};
    (json['lichHoc'] as Map<String, dynamic>? ?? {}).forEach((key, value) {
      lichHocParsed[key] = Set<String>.from(value);
    });

    return CourseModel(
      maHocPhan: json['maHocPhan'] ?? '',
      tenHocPhan: json['tenHocPhan'] ?? '',
      soTinChi: json['soTinChi'] ?? 0,
      lopHoc: json['lopHoc'] ?? '',
      ngayBatDau: DateTime.tryParse(json['ngayBatDau'] ?? '') ?? DateTime.now(),
      ngayKetThuc:
          DateTime.tryParse(json['ngayKetThuc'] ?? '') ?? DateTime.now(),
      lichHoc: lichHocParsed,
    );
  }

  /// 🔹 Chuyển từ CourseModel → JSON
  Map<String, dynamic> toJson() {
    final Map<String, List<String>> lichHocConverted = {};
    lichHoc.forEach((key, value) {
      lichHocConverted[key] = value.toList();
    });

    return {
      'maHocPhan': maHocPhan,
      'tenHocPhan': tenHocPhan,
      'soTinChi': soTinChi,
      'lopHoc': lopHoc,
      'ngayBatDau': ngayBatDau.toIso8601String(),
      'ngayKetThuc': ngayKetThuc.toIso8601String(),
      'lichHoc': lichHocConverted,
    };
  }

  /// 🔹 Copy model với giá trị mới
  CourseModel copyWith({
    String? maHocPhan,
    String? tenHocPhan,
    int? soTinChi,
    String? lopHoc,
    DateTime? ngayBatDau,
    DateTime? ngayKetThuc,
    Map<String, Set<String>>? lichHoc,
  }) {
    return CourseModel(
      maHocPhan: maHocPhan ?? this.maHocPhan,
      tenHocPhan: tenHocPhan ?? this.tenHocPhan,
      soTinChi: soTinChi ?? this.soTinChi,
      lopHoc: lopHoc ?? this.lopHoc,
      ngayBatDau: ngayBatDau ?? this.ngayBatDau,
      ngayKetThuc: ngayKetThuc ?? this.ngayKetThuc,
      lichHoc: lichHoc ?? this.lichHoc,
    );
  }

  @override
  String toString() {
    final lich = lichHoc.entries
        .map((e) => '${e.key} (${e.value.join(', ')})')
        .join(' | ');
    return '$maHocPhan - $tenHocPhan ($soTinChi tín chỉ) | Lớp: $lopHoc | Lịch học: $lich';
  }
}
