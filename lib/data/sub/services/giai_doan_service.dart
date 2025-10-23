import 'package:tlu_schedule_app/data/sub/models/giai_doan_model.dart';

class GiaiDoanService {
  // Mô phỏng "cơ sở dữ liệu" trong bộ nhớ
  final List<GiaiDoanModel> _dsGiaiDoan = [
    GiaiDoanModel(
      id: 'GD1_HK1',
      idHocKy: 'HK1_2025',
      tenGiaiDoan: 'Giữa kỳ',
      batDau: DateTime(2025, 10, 1),
      ketThuc: DateTime(2025, 11, 15),
    ),
    GiaiDoanModel(
      id: 'GD2_HK1',
      idHocKy: 'HK1_2025',
      tenGiaiDoan: 'Cuối kỳ',
      batDau: DateTime(2025, 11, 16),
      ketThuc: DateTime(2026, 1, 10),
    ),
    GiaiDoanModel(
      id: 'GD1_HK2',
      idHocKy: 'HK2_2025',
      tenGiaiDoan: 'Giữa kỳ',
      batDau: DateTime(2026, 3, 15),
      ketThuc: DateTime(2026, 4, 30),
    ),
  ];

  /// Lấy tất cả giai đoạn
  List<GiaiDoanModel> getAll() {
    return List.unmodifiable(_dsGiaiDoan);
  }

  /// Lấy giai đoạn theo ID
  GiaiDoanModel? getById(String id) {
    try {
      return _dsGiaiDoan.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Thêm giai đoạn mới
  void add(GiaiDoanModel giaiDoan) {
    final existed = _dsGiaiDoan.any((g) => g.id == giaiDoan.id);
    if (existed) {
      throw Exception('ID "${giaiDoan.id}" đã tồn tại.');
    }
    _dsGiaiDoan.add(giaiDoan);
  }

  /// Cập nhật giai đoạn theo ID
  void update(String id, GiaiDoanModel updated) {
    final index = _dsGiaiDoan.indexWhere((g) => g.id == id);
    if (index == -1) {
      throw Exception('Không tìm thấy giai đoạn có id: $id');
    }
    _dsGiaiDoan[index] = updated.copyWith(id: id);
  }

  /// Xóa giai đoạn theo ID
  void delete(String id) {
    _dsGiaiDoan.removeWhere((g) => g.id == id);
  }

  /// Lấy tất cả giai đoạn thuộc một học kỳ
  List<GiaiDoanModel> getAllByHocKy(String idHocKy) {
    return _dsGiaiDoan.where((g) => g.idHocKy == idHocKy).toList();
  }

  /// Lấy giai đoạn hiện tại (dựa theo ngày hệ thống)
  GiaiDoanModel? getCurrent() {
    final now = DateTime.now();
    try {
      return _dsGiaiDoan.firstWhere(
        (g) => now.isAfter(g.batDau) && now.isBefore(g.ketThuc),
      );
    } catch (e) {
      return null;
    }
  }
}
