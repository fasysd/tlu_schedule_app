import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';
import 'package:tlu_schedule_app/data/services/user_service.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';

  static final UserService _userService = UserService();

  /// Đăng nhập
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final result = await _userService.login(username, password);

    if (result['status'] == 200) {
      final userData = result['data'] as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userIdKey, userData['id']);

      return {
        'status': 200,
        'message': 'Đăng nhập thành công',
        'user': userData,
      };
    }

    return {'status': 401, 'message': 'Tên đăng nhập hoặc mật khẩu không đúng'};
  }

  /// Đăng xuất
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Kiểm tra trạng thái đăng nhập
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Lấy thông tin người dùng hiện tại
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_userIdKey);
    if (id == null) return null;

    final result = await _userService.getUserById(id);
    if (result['status'] == 200) {
      return UserModel.fromJson(result['data']);
    }
    return null;
  }
}
