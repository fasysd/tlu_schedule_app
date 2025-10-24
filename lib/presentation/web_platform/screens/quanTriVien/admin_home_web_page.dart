// lib/presentation/web_platform/screens/quanTriVien/admin_home_web_page.dart

import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/core/themes/theme_utils.dart';
import 'admin_quan_ly_nguoi_dung_web_page.dart';
import 'admin_quan_ly_danh_muc_chung_web_page.dart';
import 'admin_quan_ly_hoc_ky_web_page.dart'; // <-- IMPORT TRANG MỚI

class AdminHomeWebPage extends StatefulWidget {
  const AdminHomeWebPage({super.key});

  @override
  State<AdminHomeWebPage> createState() => _AdminHomeWebPageState();
}

class _AdminHomeWebPageState extends State<AdminHomeWebPage> {
  int _selectedIndex = 0;

  // [1] State mới để quản lý trang con trong "Danh mục chung"
  String? _subPageIndex;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme();
    final sidebarColor =
        context.appColor('xanhDuong') ?? const Color(0xFF598CBF);

    // [2] Cập nhật logic để lấy tiêu đề trang
    String pageTitle = _getPageTitle();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SIDEBAR ---
            Container(
              width: 300,
              height: double.infinity,
              color: sidebarColor,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... (Phần logo và tiêu đề sidebar giữ nguyên)
                  Center(child: Container(/* ... Logo ... */)),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'TLU\nHỆ THỐNG QUẢN LÝ LỊCH TRÌNH',
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16),

                  // --- MENU ITEMS ---
                  _buildSidebarMenu(
                    context,
                    currentIndex: _selectedIndex,
                    onSelect: (i) {
                      setState(() {
                        _selectedIndex = i;
                        // [3] Reset trang con khi chuyển mục menu chính
                        _subPageIndex = null;
                      });
                    },
                  ),

                  const Spacer(),

                  // --- LOGOUT BUTTON ---
                  // --- LOGOUT BUTTON ---
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        // TODO: Thêm logic đăng xuất ở đây
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        'Đăng xuất',
                        style: textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 8),
                ],
              ),
            ),

            // --- MAIN CONTENT AREA ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pageTitle, style: textTheme.headlineLarge),
                    const SizedBox(height: 24),
                    Expanded(child: _buildBodyContent(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [2] Hàm lấy tiêu đề trang đã được tách ra
  String _getPageTitle() {
    if (_selectedIndex == 2 && _subPageIndex != null) {
      switch (_subPageIndex) {
        case 'hocKy':
          return 'Quản lý học kỳ';
        case 'khoa':
          return 'Quản lý khoa';
        case 'boMon':
          return 'Quản lý bộ môn';
        case 'phongHoc':
          return 'Quản lý phòng học';
        case 'tietHoc':
          return 'Quản lý tiết học';
      }
    }

    switch (_selectedIndex) {
      case 1:
        return 'Quản lý người dùng';
      case 2:
        return 'Danh mục chung';
      default:
        return 'Trang chủ';
    }
  }

  // [4] HÀM QUAN TRỌNG NHẤT: Cập nhật logic hiển thị nội dung
  Widget _buildBodyContent(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        // return _buildHomePageContent(context); // Tách ra nếu cần
        return const Text('Nội dung trang chủ');
      case 1:
        return const AdminQuanLyNguoiDungWebPage();
      case 2:
        // Nếu chưa chọn trang con, hiển thị danh sách các mục
        if (_subPageIndex == null) {
          return AdminQuanLyDanhMucChungWebPage(
            onNavigate: (pageId) {
              setState(() {
                _subPageIndex = pageId;
              });
            },
          );
        }
        // Nếu đã chọn trang con, hiển thị trang con tương ứng
        switch (_subPageIndex) {
          case 'hocKy':
            return const AdminQuanLyHocKyWebPage();
          default:
            return Text('Trang không tồn tại: ${_subPageIndex}');
        }
      default:
        return const Text('Trang không tồn tại');
    }
  }

  // ... (các hàm build widget khác như _buildSidebarMenu, _sidebarNavItem giữ nguyên)
  Widget _buildSidebarMenu(
    BuildContext context, {
    required int currentIndex,
    required ValueChanged<int> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sidebarNavItem(
          context,
          icon: Icons.home_filled,
          label: 'Trang chủ',
          selected: currentIndex == 0,
          onTap: () => onSelect(0),
        ),
        _sidebarNavItem(
          context,
          icon: Icons.people_alt_rounded,
          label: 'Người dùng',
          selected: currentIndex == 1,
          onTap: () => onSelect(1),
        ),
        _sidebarNavItem(
          context,
          icon: Icons.view_list_rounded,
          label: 'Danh mục chung',
          selected: currentIndex == 2,
          onTap: () => onSelect(2),
        ),
      ],
    );
  }

  Widget _sidebarNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool selected = false,
    VoidCallback? onTap,
  }) {
    final selectedBg = Colors.white.withOpacity(0.12);
    final textTheme = context.appTextTheme();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: selected ? selectedBg : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
