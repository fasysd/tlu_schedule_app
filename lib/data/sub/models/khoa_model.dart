class KhoaModel {
  final String id;
  final String tenKhoa;

  KhoaModel({required this.id, required this.tenKhoa});

  /// Tạo một đối tượng mặc định rỗng
  factory KhoaModel.empty() {
    return KhoaModel(id: '', tenKhoa: '');
  }

  /// Tạo bản sao với khả năng ghi đè một số thuộc tính
  KhoaModel copyWith({String? id, String? tenKhoa}) {
    return KhoaModel(id: id ?? this.id, tenKhoa: tenKhoa ?? this.tenKhoa);
  }

  /// Chuyển JSON map thành đối tượng KhoaModel
  factory KhoaModel.fromJson(Map<String, dynamic> json) {
    return KhoaModel(id: json['id'] ?? '', tenKhoa: json['tenKhoa'] ?? '');
  }

  /// Chuyển đối tượng KhoaModel thành JSON map
  Map<String, dynamic> toJson() {
    return {'id': id, 'tenKhoa': tenKhoa};
  }
}
