class GiaiDoanModel {
  final String id;
  final String idHocKy;
  final String tenGiaiDoan;
  final DateTime batDau;
  final DateTime ketThuc;

  GiaiDoanModel({
    required this.id,
    required this.idHocKy,
    required this.tenGiaiDoan,
    required this.batDau,
    required this.ketThuc,
  });

  /// Tạo một đối tượng rỗng (mặc định)
  factory GiaiDoanModel.empty() {
    return GiaiDoanModel(
      id: '',
      idHocKy: '',
      tenGiaiDoan: '',
      batDau: DateTime(1970, 1, 1),
      ketThuc: DateTime(1970, 1, 1),
    );
  }

  /// Tạo bản sao với các giá trị có thể thay đổi
  GiaiDoanModel copyWith({
    String? id,
    String? idHocKy,
    String? tenGiaiDoan,
    DateTime? batDau,
    DateTime? ketThuc,
  }) {
    return GiaiDoanModel(
      id: id ?? this.id,
      idHocKy: idHocKy ?? this.idHocKy,
      tenGiaiDoan: tenGiaiDoan ?? this.tenGiaiDoan,
      batDau: batDau ?? this.batDau,
      ketThuc: ketThuc ?? this.ketThuc,
    );
  }

  /// Tạo đối tượng từ JSON (Map)
  factory GiaiDoanModel.fromJson(Map<String, dynamic> json) {
    return GiaiDoanModel(
      id: json['id'] ?? '',
      idHocKy: json['idHocKy'] ?? '',
      tenGiaiDoan: json['tenGiaiDoan'] ?? '',
      batDau: DateTime.tryParse(json['batDau'] ?? '') ?? DateTime(1970, 1, 1),
      ketThuc: DateTime.tryParse(json['ketThuc'] ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  /// (Tuỳ chọn) Chuyển đối tượng thành JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idHocKy': idHocKy,
      'tenGiaiDoan': tenGiaiDoan,
      'batDau': batDau.toIso8601String(),
      'ketThuc': ketThuc.toIso8601String(),
    };
  }
}
