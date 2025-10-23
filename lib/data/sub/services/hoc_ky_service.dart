import 'package:tlu_schedule_app/data/sub/models/hoc_ky_model.dart';

class HocKyService {
  // Mô phỏng "database" trong bộ nhớ
  final List<HocKyModel> _dsHocKy = [
    HocKyModel(
      id: 'HK1_2025',
      tenHocKy: 'Học kỳ 1 - Năm học 2025',
      batDau: DateTime(2025, 9, 1),
      ketThuc: DateTime(2026, 1, 15),
    ),
    HocKyModel(
      id: 'HK2_2025',
      tenHocKy: 'Học kỳ 2 - Năm học 2025',
      batDau: DateTime(2026, 2, 15),
      ketThuc: DateTime(2026, 6, 30),
    ),
  ];

  /// Lấy tất cả học kỳ
  List<HocKyModel> getAll() {
    return List.unmodifiable(_dsHocKy);
  }

  /// Lấy học kỳ theo ID
  HocKyModel? getById(String id) {
    try {
      return _dsHocKy.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Thêm học kỳ mới
  void add(HocKyModel hocKy) {
    final existed = _dsHocKy.any((h) => h.id == hocKy.id);
    if (existed) {
      throw Exception('ID "${hocKy.id}" đã tồn tại.');
    }
    _dsHocKy.add(hocKy);
  }

  /// Cập nhật thông tin học kỳ
  void update(String id, HocKyModel updated) {
    final index = _dsHocKy.indexWhere((h) => h.id == id);
    if (index == -1) {
      throw Exception('Không tìm thấy học kỳ có id: $id');
    }
    _dsHocKy[index] = updated.copyWith(id: id);
  }

  /// Xóa học kỳ theo ID
  void delete(String id) {
    _dsHocKy.removeWhere((h) => h.id == id);
  }

  /// (Tuỳ chọn) Lấy học kỳ hiện tại dựa theo ngày hệ thống
  HocKyModel? getCurrent() {
    final now = DateTime.now();
    try {
      return _dsHocKy.firstWhere(
        (h) => now.isAfter(h.batDau) && now.isBefore(h.ketThuc),
      );
    } catch (e) {
      return null;
    }
  }
}
