import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/core/themes/theme_utils.dart';

enum UserRole { phongDaoTao, giangVien }

class AdminQuanLyNguoiDungWebPage extends StatefulWidget {
  const AdminQuanLyNguoiDungWebPage({super.key});

  @override
  State<AdminQuanLyNguoiDungWebPage> createState() =>
      _AdminQuanLyNguoiDungWebPageState();
}

class _AdminQuanLyNguoiDungWebPageState
    extends State<AdminQuanLyNguoiDungWebPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<_UserRow> _users = <_UserRow>[];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top actions: Search    Add button
        Row(
          children: [
            Expanded(child: _buildSearchField(context)),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _openAddUserDialog(context),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Thêm tài khoản'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Table
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    (context.appColor('xanhDuongNhat') ??
                            const Color(0xFFC3D9E9))
                        .withOpacity(0.9),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: _buildUserTable(context, textTheme),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Tìm kiếm',
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
    final List<_UserRow> filtered = _users.where((u) {
      final account = u.displayAccountName.toLowerCase();
      final name = u.fullName.toLowerCase();
      final email = u.email.toLowerCase();
      final phone = u.phone;
      return account.contains(query) ||
          name.contains(query) ||
          email.contains(query) ||
          phone.contains(query);
    }).toList();

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
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
              for (int i = 0; i < filtered.length; i)
                DataRow(
                  cells: [
                    DataCell(Text('${i + 1}')),
                    DataCell(Text(_roleLabel(filtered[i].role))),
                    DataCell(Text(filtered[i].displayAccountName)),
                    DataCell(Text(filtered[i].fullName)),
                    DataCell(Text(filtered[i].email)),
                    DataCell(Text(filtered[i].phone)),
                    DataCell(
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz_rounded),
                          onPressed: () {
                            // sẽ bổ sung sau
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
    );
  }

  Future<void> _openAddUserDialog(BuildContext pageContext) async {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    bool useDefaultPassword = true;
    UserRole selectedRole = UserRole.giangVien; // default Giảng viên

    await showDialog(
      context: pageContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
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
                        // Tên tài khoản (id phần sau tiền tố)
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Tên tài khoản',
                            hintText: 'Ví dụ: 1001 hoặc nguyenan',
                          ),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty)
                              return 'Vui lòng nhập Tên tài khoản';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Mật khẩu    checkbox dùng mặc định
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                enabled: !useDefaultPassword,
                                decoration: const InputDecoration(
                                  labelText: 'Mật khẩu',
                                ),
                                validator: (v) {
                                  if (useDefaultPassword) return null;
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty)
                                    return 'Vui lòng nhập Mật khẩu';
                                  if (value.length < 6)
                                    return 'Mật khẩu tối thiểu 6 ký tự';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Checkbox(
                              value: useDefaultPassword,
                              onChanged: (val) => setLocalState(
                                () => useDefaultPassword = val ?? true,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('Dùng mật khẩu mặc định'),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Vai trò (checkbox nhưng ràng buộc chọn 1)
                        Wrap(
                          spacing: 24,
                          runSpacing: 8,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: selectedRole == UserRole.phongDaoTao,
                                  onChanged: (val) {
                                    if (val == true)
                                      setLocalState(
                                        () =>
                                            selectedRole = UserRole.phongDaoTao,
                                      );
                                  },
                                ),
                                const Text('Phòng đào tạo'),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: selectedRole == UserRole.giangVien,
                                  onChanged: (val) {
                                    if (val == true)
                                      setLocalState(
                                        () => selectedRole = UserRole.giangVien,
                                      );
                                  },
                                ),
                                const Text('Giảng viên'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Tên
                        TextFormField(
                          controller: fullNameController,
                          decoration: const InputDecoration(labelText: 'Tên'),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Vui lòng nhập Tên';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Email
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty) return 'Vui lòng nhập Email';
                            final emailRegex = RegExp(
                              r'^[^@]  @[^@]  \.[^@]  $',
                            );
                            if (!emailRegex.hasMatch(value))
                              return 'Email không hợp lệ';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Số điện thoại
                        TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Số điện thoại',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            final value = (v ?? '').trim();
                            if (value.isEmpty)
                              return 'Vui lòng nhập Số điện thoại';
                            final phoneRegex = RegExp(r'^[0-9]{9,11}$');
                            if (!phoneRegex.hasMatch(value))
                              return 'Số điện thoại không hợp lệ';
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
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    final usernamePart = usernameController.text.trim();
                    final display = _rolePrefix(selectedRole) + usernamePart;

                    final exists = _users.any(
                      (u) =>
                          u.displayAccountName.toLowerCase() ==
                          display.toLowerCase(),
                    );
                    if (exists) {
                      ScaffoldMessenger.of(pageContext).showSnackBar(
                        const SnackBar(
                          content: Text('Tên tài khoản đã tồn tại'),
                        ),
                      );
                      return;
                    }

                    final item = _UserRow(
                      role: selectedRole,
                      usernamePart: usernamePart,
                      fullName: fullNameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                    );
                    setState(() {
                      _users.add(item);
                    });
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Xác nhận thêm tài khoản'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _roleLabel(UserRole role) =>
      role == UserRole.phongDaoTao ? 'Phòng đào tạo' : 'Giảng viên';
  String _rolePrefix(UserRole role) =>
      role == UserRole.phongDaoTao ? 'DT_' : 'GV_';
}

class _UserRow {
  final UserRole role;
  final String usernamePart; // phần sau tiền tố
  final String fullName;
  final String email;
  final String phone;

  _UserRow({
    required this.role,
    required this.usernamePart,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  String get displayAccountName =>
      (role == UserRole.phongDaoTao ? 'DT_' : 'GV_') + usernamePart;
}
