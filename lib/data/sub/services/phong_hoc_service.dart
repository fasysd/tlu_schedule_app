import 'package:tlu_schedule_app/data/sub/models/phong_hoc_model.dart';

class PhongHocService {
  // Mô phỏng "cơ sở dữ liệu" trong bộ nhớ
  final List<PhongHocModel> _dsPhongHoc = [
    PhongHocModel(id: 'P101', tenPhongHoc: 'Phòng 101 - Nhà A1', sucChua: 50),
    PhongHocModel(id: 'P102', tenPhongHoc: 'Phòng 102 - Nhà A1', sucChua: 60),
    PhongHocModel(id: 'P201', tenPhongHoc: 'Phòng 201 - Nhà A2', sucChua: 80),
    PhongHocModel(id: 'PH_TINH', tenPhongHoc: 'Phòng máy tính', sucChua: 45),
  ];

  /// Lấy tất cả phòng học
  List<PhongHocModel> getAll() {
    return List.unmodifiable(_dsPhongHoc);
  }

  /// Lấy phòng học theo ID
  PhongHocModel? getById(String id) {
    try {
      return _dsPhongHoc.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Thêm phòng học mới
  void add(PhongHocModel phongHoc) {
    final existed = _dsPhongHoc.any((p) => p.id == phongHoc.id);
    if (existed) {
      throw Exception('ID "${phongHoc.id}" đã tồn tại.');
    }
    _dsPhongHoc.add(phongHoc);
  }

  /// Cập nhật thông tin phòng học
  void update(String id, PhongHocModel updated) {
    final index = _dsPhongHoc.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw Exception('Không tìm thấy phòng học có id: $id');
    }
    _dsPhongHoc[index] = updated.copyWith(id: id);
  }

  /// Xóa phòng học theo ID
  void delete(String id) {
    _dsPhongHoc.removeWhere((p) => p.id == id);
  }

  /// Lọc phòng học theo sức chứa tối thiểu
  List<PhongHocModel> getByMinCapacity(int min) {
    return _dsPhongHoc.where((p) => p.sucChua >= min).toList();
  }
}
