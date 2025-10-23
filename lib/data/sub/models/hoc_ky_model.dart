class HocKyModel {
  final String id;
  final String tenHocKy;
  final DateTime batDau;
  final DateTime ketThuc;

  HocKyModel({
    required this.id,
    required this.tenHocKy,
    required this.batDau,
    required this.ketThuc,
  });

  /// Tạo một đối tượng mặc định rỗng
  factory HocKyModel.empty() {
    return HocKyModel(
      id: '',
      tenHocKy: '',
      batDau: DateTime(1970, 1, 1),
      ketThuc: DateTime(1970, 1, 1),
    );
  }

  /// Tạo bản sao với khả năng ghi đè một số thuộc tính
  HocKyModel copyWith({
    String? id,
    String? tenHocKy,
    DateTime? batDau,
    DateTime? ketThuc,
  }) {
    return HocKyModel(
      id: id ?? this.id,
      tenHocKy: tenHocKy ?? this.tenHocKy,
      batDau: batDau ?? this.batDau,
      ketThuc: ketThuc ?? this.ketThuc,
    );
  }

  /// Chuyển JSON map thành đối tượng HocKyModel
  factory HocKyModel.fromJson(Map<String, dynamic> json) {
    return HocKyModel(
      id: json['id'] ?? '',
      tenHocKy: json['tenHocKy'] ?? '',
      batDau: DateTime.tryParse(json['batDau'] ?? '') ?? DateTime(1970, 1, 1),
      ketThuc: DateTime.tryParse(json['ketThuc'] ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  /// Chuyển đối tượng HocKyModel thành JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenHocKy': tenHocKy,
      'batDau': batDau.toIso8601String(),
      'ketThuc': ketThuc.toIso8601String(),
    };
  }
}
