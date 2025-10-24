// lib/presentation/web_platform/screens/quanTriVien/admin_quan_ly_danh_muc_chung_web_page.dart

import 'package:flutter/material.dart';

class AdminQuanLyDanhMucChungWebPage extends StatelessWidget {
  /// Callback để báo cho trang cha biết người dùng đã chọn một mục
  final ValueChanged<String> onNavigate;

  const AdminQuanLyDanhMucChungWebPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    // Sử dụng ListView để hiển thị các nút theo chiều dọc, đẹp hơn
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      children: [
        _buildNavigationButton(
          context,
          icon: Icons
              .calendar_month_outlined, // Icon lịch, phù hợp với học kỳ/năm học
          label: 'Quản lý học kỳ',
          onPressed: () {
            onNavigate('hocKy');
          },
        ),
        const SizedBox(height: 16),
        _buildNavigationButton(
          context,
          icon: Icons
              .account_balance_outlined, // Icon toà nhà, biểu trưng cho Khoa
          label: 'Quản lý khoa',
          onPressed: () {
            onNavigate('khoa');
          },
        ),
        const SizedBox(height: 16),
        _buildNavigationButton(
          context,
          icon: Icons.groups_2_outlined, // Icon nhóm nhỏ, phù hợp với bộ môn
          label: 'Quản lý bộ môn',
          onPressed: () {
            onNavigate('boMon');
          },
        ),
        const SizedBox(height: 16),
        _buildNavigationButton(
          context,
          icon:
              Icons.meeting_room_outlined, // Icon phòng, rất hợp với phòng học
          label: 'Quản lý phòng học',
          onPressed: () {
            onNavigate('phongHoc');
          },
        ),
        const SizedBox(height: 16),
        _buildNavigationButton(
          context,
          icon: Icons
              .hourglass_bottom_outlined, // Icon đồng hồ cát, biểu trưng cho tiết/thời gian
          label: 'Quản lý tiết học',
          onPressed: () {
            onNavigate('tietHoc');
          },
        ),
      ],
    );
  }

  Widget _buildNavigationButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 1,
        minimumSize: const Size(double.infinity, 60),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        textStyle: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
    );
  }
}
