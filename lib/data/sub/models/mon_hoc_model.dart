class MonHocModel {
  final String id;
  final String idBoMon;
  final String tenMonHoc;
  final int soTiet;

  MonHocModel({
    required this.id,
    required this.idBoMon,
    required this.tenMonHoc,
    required this.soTiet,
  });

  /// Tạo một đối tượng mặc định rỗng
  factory MonHocModel.empty() {
    return MonHocModel(id: '', idBoMon: '', tenMonHoc: '', soTiet: 0);
  }

  /// Tạo bản sao với khả năng ghi đè một số thuộc tính
  MonHocModel copyWith({
    String? id,
    String? idBoMon,
    String? tenMonHoc,
    int? soTiet,
  }) {
    return MonHocModel(
      id: id ?? this.id,
      idBoMon: idBoMon ?? this.idBoMon,
      tenMonHoc: tenMonHoc ?? this.tenMonHoc,
      soTiet: soTiet ?? this.soTiet,
    );
  }

  /// Chuyển JSON map thành đối tượng MonHocModel
  factory MonHocModel.fromJson(Map<String, dynamic> json) {
    return MonHocModel(
      id: json['id'] ?? '',
      idBoMon: json['idBoMon'] ?? '',
      tenMonHoc: json['tenMonHoc'] ?? '',
      soTiet: json['soTiet'] is int
          ? json['soTiet']
          : int.tryParse(json['soTiet']?.toString() ?? '0') ?? 0,
    );
  }

  /// Chuyển đối tượng MonHocModel thành JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idBoMon': idBoMon,
      'tenMonHoc': tenMonHoc,
      'soTiet': soTiet,
    };
  }
}
