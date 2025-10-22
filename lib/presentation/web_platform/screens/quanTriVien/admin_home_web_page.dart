import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/core/themes/theme_utils.dart';
import 'admin_quan_ly_nguoi_dung_web_page.dart';
import 'admin_quan_ly_danh_muc_khac_web_page.dart';

class AdminHomeWebPage extends StatefulWidget {
  const AdminHomeWebPage({super.key});

  @override
  State<AdminHomeWebPage> createState() => _AdminHomeWebPageState();
}

class _AdminHomeWebPageState extends State<AdminHomeWebPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme();
    final sidebarColor =
        context.appColor('xanhDuong') ?? const Color(0xFF598CBF);
    String pageTitle;
    switch (_selectedIndex) {
      case 1:
        pageTitle = 'Người dùng';
        break;
      case 2:
        pageTitle = 'Danh mục khác';
        break;
      case 3:
        pageTitle = 'Theo dõi dữ liệu';
        break;
      case 0:
      default:
        pageTitle = 'Trang chủ';
    }
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
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
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
                    onSelect: (i) => setState(() => _selectedIndex = i),
                  ),

                  const Spacer(),

                  // --- LOGOUT BUTTON ---
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(true);
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

  Widget _buildBodyContent(BuildContext context) {
    if (_selectedIndex == 1) {
      return const AdminQuanLyNguoiDungWebPage();
    }
    if (_selectedIndex == 2) {
      return const AdminQuanLyDanhMucKhacWebPage();
    }
    if (_selectedIndex == 3) {
      final textTheme = context.appTextTheme();
      return Center(
        child: Text('Theo dõi dữ liệu', style: textTheme.headlineLarge),
      );
    }
    final textTheme = context.appTextTheme();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- LEFT CONTENT ---
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _sectionCard(
                context: context,
                title: 'Chi tiết hệ thống',
                children: [
                  _infoRow(context, 'Dung lượng lưu trữ:', '15GB / 30GB'),
                  _infoRow(context, 'Tốc độ xử lý trung bình:', '100ms'),
                  _infoRow(context, 'Hiệu suất trung bình:', '98%'),
                ],
              ),
              const SizedBox(height: 24),
              _sectionCard(
                context: context,
                title: 'Danh sách lỗi',
                height: 285,
                children: [
                  Center(
                    child: Text(
                      'Không có lỗi nào được ghi nhận',
                      style: textTheme.labelLarge?.copyWith(
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 32),

        // --- RIGHT CONTENT: HOẠT ĐỘNG GẦN ĐÂY ---
        Expanded(
          flex: 3,
          child: _activitySection(
            context: context,
            title: 'Hoạt động gần đây',
            activities: const [
              ['22:30 30/09/2025', 'Giảng viên A đã gửi yêu cầu nghỉ dạy'],
              ['7:31 30/09/2025', 'Một lịch trình mới đã được tạo'],
              [
                '7:30 30/09/2025',
                'Phòng Đào tạo đã phê duyệt lịch dạy bù của Giảng viên B',
              ],
              ['7:30 30/09/2025', '1 lớp học phần đã bị thay đổi lịch trình'],
              ['7:05 30/09/2025', 'Giảng viên B đã gửi yêu cầu dạy bù'],
              ['7:00 30/09/2025', 'Giảng viên B đã đăng nhập'],
            ],
          ),
        ),
      ],
    );
  }
}

// --- SECTION CARD ---
Widget _sectionCard({
  required BuildContext context,
  required String title,
  double? height,
  List<Widget>? actions,
  required List<Widget> children,
}) {
  final accent = context.appColor('xanhDuongNhat') ?? const Color(0xFFC3D9E9);
  final textTheme = context.appTextTheme();
  return Container(
    width: double.infinity,
    height: height,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: textTheme.titleLarge),
            if (actions != null && actions.isNotEmpty) Row(children: actions),
          ],
        ),
        const SizedBox(height: 16),
        if (height != null)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
      ],
    ),
  );
}

// --- INFO ROW (Chi tiết hệ thống) ---
Widget _infoRow(BuildContext context, String left, String right) {
  final textTheme = context.appTextTheme();
  final chipBg = context.appColor('xanhDuongNhat') ?? const Color(0xFFC3D9E9);
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: chipBg.withOpacity(0.9)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: chipBg.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            right,
            style: textTheme.labelLarge?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

// --- ACTIVITY CARD ---
Widget _activityCard(BuildContext context, String time, String content) {
  final textTheme = context.appTextTheme();
  final border = context.appColor('xamNhat') ?? const Color(0xFFD8D8D8);
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.access_time, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: textTheme.labelMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 6),
              Text(content, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    ),
  );
}

// --- SIDEBAR MENU SECTION ---
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
        label: 'Danh mục khác',
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

// --- ACTIVITY SECTION WITH SCROLL ---
Widget _activitySection({
  required BuildContext context,
  required String title,
  required List<List<String>> activities,
}) {
  final accent = context.appColor('xanhDuongNhat') ?? const Color(0xFFC3D9E9);
  final textTheme = context.appTextTheme();
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
        Text(title, style: textTheme.titleLarge),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: activities.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, index) {
              final item = activities[index];
              return _activityCard(context, item[0], item[1]);
            },
          ),
        ),
      ],
    ),
  );
}
