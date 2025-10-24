// D:/Others/FlutterProjects/tlu_schedule_app/lib/data/sub/services/giai_doan_service.dart
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

  /// Lấy tất cả các giai đoạn.
  /// Trả về một danh sách không thể thay đổi để bảo vệ dữ liệu gốc.
  List<GiaiDoanModel> getAll() {
    return List.unmodifiable(_dsGiaiDoan);
  }

  /// Lấy một giai đoạn cụ thể theo ID.
  /// Trả về null nếu không tìm thấy.
  GiaiDoanModel? getById(String id) {
    try {
      return _dsGiaiDoan.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Thêm một giai đoạn mới vào danh sách.
  /// Ném ra một [Exception] nếu ID đã tồn tại.
  void add(GiaiDoanModel giaiDoan) {
    final existed = _dsGiaiDoan.any(
      (g) => g.id.toUpperCase() == giaiDoan.id.toUpperCase(),
    );
    if (existed) {
      throw Exception('ID giai đoạn "${giaiDoan.id}" đã tồn tại.');
    }
    _dsGiaiDoan.add(giaiDoan);
  }

  /// Cập nhật thông tin của một giai đoạn đã có.
  /// Ném ra một [Exception] nếu không tìm thấy giai đoạn để cập nhật.
  void update(String id, GiaiDoanModel updated) {
    final index = _dsGiaiDoan.indexWhere((g) => g.id == id);
    if (index == -1) {
      throw Exception('Không tìm thấy giai đoạn có ID: "$id" để cập nhật.');
    }
    _dsGiaiDoan[index] = updated.copyWith(id: id);
  }

  /// Xóa một giai đoạn khỏi danh sách dựa trên ID.
  void delete(String id) {
    _dsGiaiDoan.removeWhere((g) => g.id == id);
  }

  /// Lấy tất cả các giai đoạn thuộc về một học kỳ cụ thể.
  List<GiaiDoanModel> getAllByHocKy(String idHocKy) {
    return _dsGiaiDoan.where((g) => g.idHocKy == idHocKy).toList();
  }

  /// (Tùy chọn) Lấy giai đoạn đang diễn ra dựa vào ngày hệ thống.
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
