class TietHocModel {
  final String id;
  final String tenTietHoc;
  final DateTime batDau;
  final DateTime ketThuc;

  TietHocModel({
    required this.id,
    required this.tenTietHoc,
    required this.batDau,
    required this.ketThuc,
  });

  /// Tạo một đối tượng mặc định rỗng
  factory TietHocModel.empty() {
    return TietHocModel(
      id: '',
      tenTietHoc: '',
      batDau: DateTime(1970, 1, 1),
      ketThuc: DateTime(1970, 1, 1),
    );
  }

  /// Tạo bản sao với khả năng ghi đè một số thuộc tính
  TietHocModel copyWith({
    String? id,
    String? tenHocKy,
    DateTime? batDau,
    DateTime? ketThuc,
  }) {
    return TietHocModel(
      id: id ?? this.id,
      tenTietHoc: tenHocKy ?? this.tenTietHoc,
      batDau: batDau ?? this.batDau,
      ketThuc: ketThuc ?? this.ketThuc,
    );
  }

  /// Chuyển JSON map thành đối tượng HocKyModel
  factory TietHocModel.fromJson(Map<String, dynamic> json) {
    return TietHocModel(
      id: json['id'] ?? '',
      tenTietHoc: json['tenHocKy'] ?? '',
      batDau: DateTime.tryParse(json['batDau'] ?? '') ?? DateTime(1970, 1, 1),
      ketThuc: DateTime.tryParse(json['ketThuc'] ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  /// Chuyển đối tượng HocKyModel thành JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenHocKy': tenTietHoc,
      'batDau': batDau.toIso8601String(),
      'ketThuc': ketThuc.toIso8601String(),
    };
  }
}
