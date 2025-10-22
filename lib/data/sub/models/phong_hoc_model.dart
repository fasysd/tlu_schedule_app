class PhongHocModel {
  final String id;
  final String tenPhongHoc;
  final int sucChua;

  PhongHocModel({
    required this.id,
    required this.tenPhongHoc,
    required this.sucChua,
  });

  /// Tạo một đối tượng mặc định rỗng
  factory PhongHocModel.empty() {
    return PhongHocModel(id: '', tenPhongHoc: '', sucChua: 0);
  }

  /// Tạo bản sao với khả năng ghi đè một số thuộc tính
  PhongHocModel copyWith({String? id, String? tenPhongHoc, int? sucChua}) {
    return PhongHocModel(
      id: id ?? this.id,
      tenPhongHoc: tenPhongHoc ?? this.tenPhongHoc,
      sucChua: sucChua ?? this.sucChua,
    );
  }

  /// Chuyển JSON map thành đối tượng PhongHocModel
  factory PhongHocModel.fromJson(Map<String, dynamic> json) {
    return PhongHocModel(
      id: json['id'] ?? '',
      tenPhongHoc: json['tenPhongHoc'] ?? '',
      sucChua: json['sucChua'] is int
          ? json['sucChua']
          : int.tryParse(json['sucChua']?.toString() ?? '0') ?? 0,
    );
  }

  /// Chuyển đối tượng PhongHocModel thành JSON map
  Map<String, dynamic> toJson() {
    return {'id': id, 'tenPhongHoc': tenPhongHoc, 'sucChua': sucChua};
  }
}
