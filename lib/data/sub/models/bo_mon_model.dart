class BoMonModel {
  final String id;
  final String idKhoa;
  final String? tenKhoa;
  final String tenBoMon;

  BoMonModel({
    required this.id,
    required this.idKhoa,
    this.tenKhoa,
    required this.tenBoMon,
  });

  /// Tạo một đối tượng trống (mặc định)
  factory BoMonModel.empty() {
    return BoMonModel(id: '', idKhoa: '', tenKhoa: '', tenBoMon: '');
  }

  /// Tạo bản sao có thể thay đổi từng thuộc tính
  BoMonModel copyWith({
    String? id,
    String? idKhoa,
    String? tenKhoa,
    String? tenBoMon,
  }) {
    return BoMonModel(
      id: id ?? this.id,
      idKhoa: idKhoa ?? this.idKhoa,
      tenKhoa: tenKhoa ?? this.tenKhoa,
      tenBoMon: tenBoMon ?? this.tenBoMon,
    );
  }

  /// Tạo đối tượng từ JSON
  factory BoMonModel.fromJson(Map<String, dynamic> json) {
    return BoMonModel(
      id: json['id'] ?? '',
      idKhoa: json['idKhoa'] ?? '',
      tenKhoa: json['tenKhoa'],
      tenBoMon: json['tenBoMon'] ?? '',
    );
  }

  /// Chuyển đối tượng sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idKhoa': idKhoa,
      'tenKhoa': tenKhoa,
      'tenBoMon': tenBoMon,
    };
  }

  @override
  String toString() {
    return 'BoMonModel(id: $id, idKhoa: $idKhoa, tenKhoa: $tenKhoa, tenBoMon: $tenBoMon)';
  }
}
