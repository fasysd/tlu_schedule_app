import 'package:tlu_schedule_app/data/sub/models/khoa_model.dart';

class KhoaService {
  // Mô phỏng cơ sở dữ liệu trong bộ nhớ
  final List<KhoaModel> _dsKhoa = [
    KhoaModel(id: '1', tenKhoa: 'Công nghệ thông tin'),
    KhoaModel(id: '2', tenKhoa: 'Cơ khí'),
    KhoaModel(id: '3', tenKhoa: 'Xây dựng'),
  ];

  /// Lấy tất cả khoa
  List<KhoaModel> getAll() {
    return List.unmodifiable(_dsKhoa);
  }

  /// Lấy khoa theo ID
  KhoaModel? getById(String id) {
    try {
      return _dsKhoa.firstWhere((k) => k.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Thêm khoa mới
  void add(KhoaModel khoa) {
    final existed = _dsKhoa.any((k) => k.id == khoa.id);
    if (existed) {
      throw Exception('Khoa với ID "${khoa.id}" đã tồn tại.');
    }
    _dsKhoa.add(khoa);
  }

  /// Cập nhật thông tin khoa
  void update(String id, KhoaModel updated) {
    final index = _dsKhoa.indexWhere((k) => k.id == id);
    if (index == -1) {
      throw Exception('Không tìm thấy khoa có ID: $id');
    }
    _dsKhoa[index] = updated.copyWith(id: id);
  }

  /// Xóa khoa theo ID
  void delete(String id) {
    _dsKhoa.removeWhere((k) => k.id == id);
  }
}
