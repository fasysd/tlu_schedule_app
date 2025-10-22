import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/core/themes/theme_utils.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';
import 'package:tlu_schedule_app/data/services/user_service.dart';

class AdminQuanLyNguoiDungWebPage extends StatefulWidget {
  const AdminQuanLyNguoiDungWebPage({super.key});

  @override
  State<AdminQuanLyNguoiDungWebPage> createState() =>
      _AdminQuanLyNguoiDungWebPageState();
}

class _AdminQuanLyNguoiDungWebPageState
    extends State<AdminQuanLyNguoiDungWebPage> {
  final TextEditingController _searchController = TextEditingController();
  final UserService _userService = UserService();
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final response = await _userService.getAllUsers();
    setState(() {
      if (response['status'] == 200) {
        final List data = response['data'] ?? [];
        _users = data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        _users = [];
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme();
    final accent = context.appColor('xanhDuongNhat') ?? const Color(0xFFC3D9E9);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.9), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildSearchField(context)),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _openAddUserDialog(context),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Thêm tài khoản'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      context.appColor('xanhDuong') ?? const Color(0xFF598DC0),
                  foregroundColor: context.appColor('trang') ?? Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildUserTable(context, textTheme)),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final accent = context.appColor('xanhDuongNhat') ?? const Color(0xFFC3D9E9);
    final primary = context.appColor('xanhDuong') ?? const Color(0xFF598DC0);
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade700),
        hintText: 'Tìm kiếm người dùng',
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accent.withOpacity(0.9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              )
            : null,
      ),
    );
  }

  Widget _buildUserTable(BuildContext context, TextTheme textTheme) {
    final String query = _searchController.text.trim().toLowerCase();
    final List<UserModel> filtered = _users.where((u) {
      final account = u.username.toLowerCase();
      final name = u.fullName.toLowerCase();
      final email = u.email.toLowerCase();
      final phone = u.phone ?? '';
      return account.contains(query) ||
          name.contains(query) ||
          email.contains(query) ||
          phone.contains(query);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline, size: 48, color: Colors.grey.shade500),
            const SizedBox(height: 8),
            Text(
              'Không có người dùng',
              style: textTheme.labelLarge?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              'Hãy thêm tài khoản mới để bắt đầu',
              style: textTheme.labelMedium?.copyWith(color: Colors.black45),
            ),
          ],
        ),
      );
    }

    final headerBg =
        (context.appColor('xanhDuongNhat') ?? const Color(0xFFC3D9E9))
            .withOpacity(0.4);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: constraints.maxWidth, // 👈 Giãn hết chiều rộng cha
                child: DataTableTheme(
                  data: DataTableThemeData(
                    headingRowColor: MaterialStatePropertyAll(headerBg),
                    headingTextStyle: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    dataTextStyle: textTheme.labelMedium,
                    dataRowMinHeight: 52,
                    dataRowMaxHeight: 60,
                    dividerThickness: 0.8,
                  ),
                  child: DataTable(
                    columnSpacing: 28,
                    horizontalMargin: 16,
                    columns: const [
                      DataColumn(label: Text('STT')),
                      DataColumn(label: Text('Vai trò')),
                      DataColumn(label: Text('Tên tài khoản')),
                      DataColumn(label: Text('Tên')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('SDT')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      for (int i = 0; i < filtered.length; i++)
                        DataRow(
                          cells: [
                            DataCell(Text('${i + 1}')),
                            DataCell(Text(filtered[i].role)),
                            DataCell(Text(filtered[i].username)),
                            DataCell(Text(filtered[i].fullName)),
                            DataCell(Text(filtered[i].email)),
                            DataCell(Text(filtered[i].phone ?? '')),
                            DataCell(
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(Icons.more_horiz_rounded),
                                  onPressed: () async {
                                    final RenderBox button =
                                        context.findRenderObject() as RenderBox;
                                    final overlay =
                                        Overlay.of(
                                              context,
                                            ).context.findRenderObject()
                                            as RenderBox;
                                    final position = RelativeRect.fromRect(
                                      Rect.fromPoints(
                                        button.localToGlobal(
                                          Offset.zero,
                                          ancestor: overlay,
                                        ),
                                        button.localToGlobal(
                                          button.size.bottomRight(Offset.zero),
                                          ancestor: overlay,
                                        ),
                                      ),
                                      Offset.zero & overlay.size,
                                    );

                                    // Hiển thị menu tại vị trí nút nhấn
                                    final selected = await showMenu<String>(
                                      context: context,
                                      position: position,
                                      items: [
                                        const PopupMenuItem(
                                          value: 'view',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(width: 8),
                                              Text('Xem thông tin'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(width: 8),
                                              Text('Sửa thông tin'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 8),
                                              Text('Xóa tài khoản'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );

                                    // Xử lý hành động sau khi chọn
                                    switch (selected) {
                                      case 'view':
                                        _showUserInfoDialog(filtered[i]);
                                        break;
                                      case 'edit':
                                        _openEditUserDialog(
                                          context,
                                          filtered[i],
                                        );
                                        break;
                                      case 'delete':
                                        _confirmDeleteUser(
                                          context,
                                          filtered[i],
                                        );
                                        break;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showUserInfoDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Thông tin người dùng'),
        content: Text(
          'Vai trò: ${user.role}\n'
          'Tên tài khoản: ${user.username}\n'
          'Tên: ${user.fullName}\n'
          'Email: ${user.email}\n'
          'Số điện thoại: ${user.phone}',
        ),
        actions: [
          TextButton(
            onPressed: () => _openEditUserDialog(context, user),
            child: const Text('Sửa thông tin'),
          ),
          TextButton(
            onPressed: () => _confirmDeleteUser(context, user),
            child: const Text('Xóa tài khoản'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _openEditUserDialog(BuildContext context, UserModel user) {
    // Gọi lại form thêm user, nhưng prefill thông tin cũ
  }

  void _confirmDeleteUser(BuildContext context, UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa tài khoản "${user.username}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final response = await _userService.deleteUser(user.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response['message'])));
      if (response['status'] == 200) {
        await loadUsers();
      }
    }
  }

  Future<void> _openAddUserDialog(BuildContext pageContext) async {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    final selectedRole = ValueNotifier<String>("Giảng viên");

    Future<void> onPressed_addUser(BuildContext dialogContext) async {
      if (!formKey.currentState!.validate()) return;

      final usernamePart = usernameController.text.trim();
      final fullUsername = _rolePrefix(selectedRole.value) + usernamePart;

      final item = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: fullUsername,
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
        role: selectedRole.value,
        fullName: fullNameController.text.trim(),
        avatarPath: '',
        phone: phoneController.text.trim(),
      );

      final response = await _userService.addUser(item);
      ScaffoldMessenger.of(
        pageContext,
      ).showSnackBar(SnackBar(content: Text(response['message'])));

      if (response['status'] == 201) {
        await loadUsers();
        Navigator.of(dialogContext).pop();
      }
    }

    await showDialog(
      context: pageContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Thêm tài khoản'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Tên tài khoản',
                        prefixText: _rolePrefix(selectedRole.value),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) {
                          return 'Vui lòng nhập Tên tài khoản';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Vai trò (radio)
                    ValueListenableBuilder<String>(
                      valueListenable: selectedRole,
                      builder: (context, value, _) => Wrap(
                        spacing: 24,
                        children: [
                          _radioRole(
                            'Phòng đào tạo',
                            'Phòng đào tạo',
                            value,
                            (val) => setState(() {
                              selectedRole.value = val;
                            }),
                          ),
                          _radioRole(
                            'Giảng viên',
                            'Giảng viên',
                            value,
                            (val) => setState(() {
                              selectedRole.value = val;
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Mật khẩu
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) {
                          return 'Vui lòng nhập Mật khẩu';
                        }
                        if (value.length < 6) {
                          return 'Mật khẩu tối thiểu 6 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Các trường khác (tên, email, sđt)
                    TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Tên',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Vui lòng nhập Tên' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) return 'Vui lòng nhập Email';
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Email không hợp lệ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        final value = (v ?? '').trim();
                        if (value.isEmpty) return 'Vui lòng nhập Số điện thoại';
                        final phoneRegex = RegExp(r'^[0-9]{9,11}$');
                        if (!phoneRegex.hasMatch(value)) {
                          return 'Số điện thoại không hợp lệ';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => onPressed_addUser(dialogContext),
              child: const Text('Xác nhận thêm tài khoản'),
            ),
          ],
        );
      },
    );
  }

  Widget _radioRole(
    String value,
    String label,
    String selected,
    void Function(String) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: selected,
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
        Text(label),
      ],
    );
  }

  String _rolePrefix(String role) => role == 'Phòng đào tạo' ? 'DT_' : 'GV_';
}
