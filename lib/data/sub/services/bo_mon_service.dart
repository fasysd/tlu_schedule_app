import 'package:tlu_schedule_app/data/sub/models/bo_mon_model.dart';

class BoMonService {
  // Mô phỏng "cơ sở dữ liệu" trong bộ nhớ
  final List<BoMonModel> _dsBoMon = [
    BoMonModel(id: '1', idKhoa: 'CNTT', tenBoMon: 'Hệ thống thông tin'),
    BoMonModel(id: '2', idKhoa: 'CNTT', tenBoMon: 'An ninh mạng'),
    BoMonModel(id: '3', idKhoa: 'CNTT', tenBoMon: 'Trí tuệ nhân tạo'),
    BoMonModel(id: '4', idKhoa: 'CK', tenBoMon: 'Cơ khí chế tạo'),
  ];

  /// Lấy tất cả bộ môn
  List<BoMonModel> getAll() {
    return List.unmodifiable(_dsBoMon);
  }

  /// Lấy bộ môn theo ID
  BoMonModel? getById(String id) {
    try {
      return _dsBoMon.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Lấy tất cả bộ môn theo ID khoa
  List<BoMonModel> getByKhoa(String idKhoa) {
    return _dsBoMon.where((b) => b.idKhoa == idKhoa).toList();
  }

  /// Thêm bộ môn mới
  void add(BoMonModel boMon) {
    // Kiểm tra trùng ID
    final existed = _dsBoMon.any((b) => b.id == boMon.id);
    if (existed) {
      throw Exception('ID "${boMon.id}" đã tồn tại.');
    }
    _dsBoMon.add(boMon);
  }

  /// Cập nhật thông tin bộ môn
  void update(String id, BoMonModel updated) {
    final index = _dsBoMon.indexWhere((b) => b.id == id);
    if (index == -1) {
      throw Exception('Không tìm thấy bộ môn có id: $id');
    }
    _dsBoMon[index] = updated.copyWith(id: id);
  }

  /// Xóa bộ môn theo ID
  void delete(String id) {
    _dsBoMon.removeWhere((b) => b.id == id);
  }
}
