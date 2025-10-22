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
    String? tenTietHoc,
    DateTime? batDau,
    DateTime? ketThuc,
  }) {
    return TietHocModel(
      id: id ?? this.id,
      tenTietHoc: tenTietHoc ?? this.tenTietHoc,
      batDau: batDau ?? this.batDau,
      ketThuc: ketThuc ?? this.ketThuc,
    );
  }

  /// Chuyển JSON map thành đối tượng TietHocModel
  factory TietHocModel.fromJson(Map<String, dynamic> json) {
    return TietHocModel(
      id: json['id'] ?? '',
      tenTietHoc: json['tenTietHoc'] ?? '',
      batDau: DateTime.tryParse(json['batDau'] ?? '') ?? DateTime(1970, 1, 1),
      ketThuc: DateTime.tryParse(json['ketThuc'] ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  /// Chuyển đối tượng TietHocModel thành JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenTietHoc': tenTietHoc,
      'batDau': batDau.toIso8601String(),
      'ketThuc': ketThuc.toIso8601String(),
    };
  }

  /// Hàm xác định tiết học hiện tại dựa trên thời gian thực
  static TietHocModel? getCurrent(List<TietHocModel> dsTietHoc) {
    final now = DateTime.now();
    for (final tiet in dsTietHoc) {
      if (now.isAfter(tiet.batDau) && now.isBefore(tiet.ketThuc)) {
        return tiet;
      }
    }
    return null; // Không có tiết học nào đang diễn ra
  }
}
