import 'package:flutter/foundation.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';

class UserService {
  // Mô phỏng database trong bộ nhớ
  final List<UserModel> _users = [
    UserModel(
      id: '1',
      username: 'admin',
      password: '123',
      email: 'admin@tlu.edu.vn',
      role: 'admin',
      fullName: 'Quản trị viên',
      avatarPath: 'assets/images/admin.png',
      dateOfBirth: DateTime(1985, 5, 20),
      phone: '0900000001',
      departmentId: 'D001',
      warningStatus: 'none',
    ),
    UserModel(
      id: '2',
      username: 'GV_01',
      password: '123456',
      email: 'gv1@tlu.edu.vn',
      role: 'giangVien',
      fullName: 'Nguyễn Văn A',
      avatarPath: 'assets/images/lecturer1.png',
      dateOfBirth: DateTime(1990, 8, 10),
      phone: '0900000002',
      departmentId: 'KhoaCNTT',
      warningStatus: 'none',
    ),
    UserModel(
      id: '3',
      username: 'DT_02',
      password: '123456',
      email: 'daotao@tlu.edu.vn',
      role: 'daoTao',
      fullName: 'Phòng Đào tạo',
      avatarPath: 'assets/images/daotao.png',
      dateOfBirth: DateTime(1992, 1, 5),
      phone: '0900000003',
      departmentId: 'PhongDaoTao',
      warningStatus: 'none',
    ),
  ];

  // Giả lập độ trễ mạng
  final Duration _delay = const Duration(milliseconds: 800);

  /// Lấy danh sách tất cả người dùng
  Future<Map<String, dynamic>> getAllUsers() async {
    await Future.delayed(_delay);
    return {
      'status': 200,
      'message': 'Lấy danh sách người dùng thành công',
      'data': _users.map((u) => u.toJson()).toList(),
    };
  }

  /// Lấy thông tin người dùng theo ID
  Future<Map<String, dynamic>> getUserById(String id) async {
    await Future.delayed(_delay);
    try {
      final user = _users.firstWhere((u) => u.id == id);
      return {
        'status': 200,
        'message': 'Lấy thông tin người dùng thành công',
        'data': user.toJson(),
      };
    } catch (_) {
      return {
        'status': 404,
        'message': 'Không tìm thấy người dùng',
        'data': null,
      };
    }
  }

  /// Thêm người dùng mới (POST)
  Future<Map<String, dynamic>> addUser(UserModel user) async {
    await Future.delayed(_delay);
    final exists = _users.any(
      (u) =>
          u.username == user.username ||
          u.email.toLowerCase() == user.email.toLowerCase(),
    );

    if (exists) {
      return {
        'status': 409,
        'message': 'Tên đăng nhập hoặc email đã tồn tại',
        'data': null,
      };
    }

    _users.add(user);
    return {
      'status': 201,
      'message': 'Thêm người dùng thành công',
      'data': user.toJson(),
    };
  }

  /// Cập nhật thông tin người dùng (PUT)
  Future<Map<String, dynamic>> updateUser(
    String id,
    UserModel updatedUser,
  ) async {
    await Future.delayed(_delay);

    final index = _users.indexWhere((u) => u.id == id);
    if (index == -1) {
      return {
        'status': 404,
        'message': 'Không tìm thấy người dùng để cập nhật',
        'data': null,
      };
    }

    _users[index] = updatedUser;
    return {
      'status': 200,
      'message': 'Cập nhật người dùng thành công',
      'data': updatedUser.toJson(),
    };
  }

  /// Xoá người dùng (DELETE)
  Future<Map<String, dynamic>> deleteUser(String id) async {
    await Future.delayed(_delay);

    final before = _users.length;
    if (_users.firstWhere((u) => u.id == id).role == 'admin') {
      return {'status': 404, 'message': 'Không thể xóa admin'};
    }
    _users.removeWhere((u) => u.id == id);

    if (_users.length == before) {
      return {
        'status': 404,
        'message': 'Không tìm thấy người dùng để xoá',
        'data': null,
      };
    }

    return {
      'status': 200,
      'message': 'Xoá người dùng thành công',
      'data': {'id': id},
    };
  }

  /// Đăng nhập (mô phỏng API login)
  Future<Map<String, dynamic>> login(String username, String password) async {
    await Future.delayed(_delay);

    try {
      final user = _users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      return {
        'status': 200,
        'message': 'Đăng nhập thành công',
        'data': user.toJson(),
      };
    } catch (_) {
      return {
        'status': 401,
        'message': 'Tên đăng nhập hoặc mật khẩu không đúng',
        'data': null,
      };
    }
  }

  /// Lấy danh sách người dùng theo vai trò
  Future<Map<String, dynamic>> getUsersByRole(String role) async {
    await Future.delayed(_delay);
    final filtered = _users.where((u) => u.role == role).toList();

    return {
      'status': 200,
      'message': 'Lấy danh sách người dùng theo vai trò thành công',
      'data': filtered.map((u) => u.toJson()).toList(),
    };
  }

  /// Cập nhật trạng thái cảnh báo (warningStatus)
  Future<Map<String, dynamic>> updateWarningStatus(
    String id,
    String status,
  ) async {
    await Future.delayed(_delay);

    final user = _users.firstWhere(
      (u) => u.id == id,
      orElse: () => UserModel.empty(),
    );
    if (user.id.isEmpty) {
      return {
        'status': 404,
        'message': 'Không tìm thấy người dùng để cập nhật trạng thái',
        'data': null,
      };
    }

    final updated = user.copyWith(warningStatus: status);
    await updateUser(id, updated);

    return {
      'status': 200,
      'message': 'Cập nhật trạng thái cảnh báo thành công',
      'data': updated.toJson(),
    };
  }

  /// In danh sách người dùng ra console
  Future<void> printAllUsers() async {
    await Future.delayed(_delay);
    debugPrint('--- Danh sách người dùng ---');
    for (final user in _users) {
      debugPrint('${user.username} - ${user.role}');
    }
  }
}
