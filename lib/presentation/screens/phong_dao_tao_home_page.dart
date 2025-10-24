import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/models/activity_log_model.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';
import 'package:tlu_schedule_app/data/services/activity_log_sevice.dart';
import 'package:tlu_schedule_app/data/services/auth_service.dart';
import 'package:tlu_schedule_app/data/services/static_data.dart';
import '../widgets/common_header.dart';
import 'ds_giang_vien_page.dart';
import 'ds_hoc_phan_page.dart';
import 'ds_don_xin_page.dart';
import 'trang_thong_ke_gio_day.dart';
import 'trang_bao_cao_thong_ke.dart';
import 'thong_ke_gio_day_page.dart';
import 'login_page.dart';
import 'tao_hoc_phan_page.dart';

class PhongdaotaoHomePage extends StatefulWidget {
  const PhongdaotaoHomePage({super.key});

  @override
  State<PhongdaotaoHomePage> createState() => _PhongdaotaoHomePageState();
}

class _PhongdaotaoHomePageState extends State<PhongdaotaoHomePage> {
  int _currentIndex = 0;
  String _hoTen = '';
  int _soLuongGiangVien = 0;
  int _hocPhanDangMo = 0;
  int _donXinNghiDay = 0;
  int _donXinDayBu = 0;
  bool _kieuThongKe = false;
  int _soLuongTietHoc = 0;
  int _soLuongTietHocHoanThan = 0;
  int _soLuongTietHocNghiDay = 0;
  int _soLuongTietHocDayBu = 0;
  List<ActivityLog> _listActivityLog = [];
  late UserAccount _user;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    fetchData();
  }

  void _initializeUser() {
    // Tạo user account cho phòng đào tạo
    _user = UserAccount(
      id: 'pdt001',
      username: 'phongdaotao',
      password: '123456',
      fullName: 'Nguyễn Thị A',
      email: 'pdt@tlu.edu.vn',
      role: 'phongdaotao',
      avatarPath: 'assets/images/defaultAvatar.png',
      warningStatus: 'normal',
    );
  }

  Future<void> fetchData() async {
    // Gọi API trước
    final fetchedActivityLogs = await ActivityLogService()
        .fetchActivityLogSFromApi();

    // Cập nhật state sau khi có dữ liệu
    setState(() {
      _hoTen = 'Nguyễn Thị A';
      _soLuongGiangVien = 130;
      _hocPhanDangMo = 30;
      _donXinNghiDay = 3;
      _donXinDayBu = 4;
      _soLuongTietHoc = 30 * 45;
      _soLuongTietHocHoanThan = 15 * 45;
      _soLuongTietHocNghiDay = 30;
      _soLuongTietHocDayBu = 10;
      _listActivityLog = fetchedActivityLogs;
    });
  }

  void _logout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await AuthService.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeContent(
        user: _user,
        onLogout: _logout,
        soLuongGiangVien: _soLuongGiangVien,
        hocPhanDangMo: _hocPhanDangMo,
        donXinNghiDay: _donXinNghiDay,
        donXinDayBu: _donXinDayBu,
        kieuThongKe: _kieuThongKe,
        soLuongTietHoc: _soLuongTietHoc,
        soLuongTietHocHoanThan: _soLuongTietHocHoanThan,
        soLuongTietHocNghiDay: _soLuongTietHocNghiDay,
        soLuongTietHocDayBu: _soLuongTietHocDayBu,
        listActivityLog: _listActivityLog,
        onToggleThongKe: () {
          setState(() {
            _kieuThongKe = !_kieuThongKe;
          });
        },
      ),
      _DanhSachGiangVienPage(),
      _DanhSachHocPhanPage(),
      _ThongKePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  emoji: '🏠',
                  label: 'Trang chủ',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _buildNavItem(
                  context,
                  emoji: '👨‍🏫',
                  label: 'Giảng viên',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _buildNavItem(
                  context,
                  emoji: '🎓',
                  label: 'Học phần',
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                _buildNavItem(
                  context,
                  emoji: '📊',
                  label: 'Thống kê',
                  isSelected: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String emoji,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1976D2) : const Color(0xFF666666),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Widget cho trang chủ
class _HomeContent extends StatelessWidget {
  final UserAccount user;
  final VoidCallback onLogout;
  final int soLuongGiangVien;
  final int hocPhanDangMo;
  final int donXinNghiDay;
  final int donXinDayBu;
  final bool kieuThongKe;
  final int soLuongTietHoc;
  final int soLuongTietHocHoanThan;
  final int soLuongTietHocNghiDay;
  final int soLuongTietHocDayBu;
  final List<ActivityLog> listActivityLog;
  final VoidCallback onToggleThongKe;

  const _HomeContent({
    required this.user,
    required this.onLogout,
    required this.soLuongGiangVien,
    required this.hocPhanDangMo,
    required this.donXinNghiDay,
    required this.donXinDayBu,
    required this.kieuThongKe,
    required this.soLuongTietHoc,
    required this.soLuongTietHocHoanThan,
    required this.soLuongTietHocNghiDay,
    required this.soLuongTietHocDayBu,
    required this.listActivityLog,
    required this.onToggleThongKe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header với thiết kế giống HTML
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo text only
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TRƯỜNG ĐẠI HỌC THỦY LỢI',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF1976D2),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'THUYLOI UNIVERSITY',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF1976D2),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  // User menu
                  Row(
                    children: [
                      // Notification bell
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications, color: Color(0xFF1976D2), size: 24),
                            onPressed: () {
                              // Notification functionality
                            },
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF44336),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '12',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // User profile
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.account_circle, color: Color(0xFF1976D2), size: 32),
                        onSelected: (value) {
                          if (value == 'logout') {
                            onLogout();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(Icons.person, color: Color(0xFF1976D2)),
                                SizedBox(width: 8),
                                Text('Thông tin tài khoản'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Color(0xFFD32F2F)),
                                SizedBox(width: 8),
                                Text('Đăng xuất'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Nội dung chính với scroll
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thống kê nhanh
                _buildQuickStats(context),
                const SizedBox(height: 24),
                
                // Hoạt động gần đây
                _buildRecentActivity(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // Stats Grid giống HTML
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              context,
              'Tổng số lớp học',
              '156',
              '🎓',
              const Color(0xFF4CAF50),
              '+8 lớp mới',
            ),
            _buildStatCard(
              context,
              'Môn học đang mở',
              '89',
              '📚',
              const Color(0xFF2196F3),
              '+5 môn mới',
            ),
            _buildStatCard(
              context,
              'Đơn chờ duyệt',
              '23',
              '📋',
              const Color(0xFFFF9800),
              'Cần xử lý',
            ),
            _buildStatCard(
              context,
              'Cảnh báo tiến độ',
              '7',
              '⚠️',
              const Color(0xFFF44336),
              'Cần can thiệp',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String emoji,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1976D2),
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF666666),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF1976D2),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getIconBackgroundColor(Color color) {
    if (color == const Color(0xFF4CAF50)) return const Color(0xFFE8F5E8);
    if (color == const Color(0xFF2196F3)) return const Color(0xFFE3F2FD);
    if (color == const Color(0xFFFF9800)) return const Color(0xFFFFF3E0);
    if (color == const Color(0xFFF44336)) return const Color(0xFFFFEBEE);
    return color.withOpacity(0.1);
  }

  Color _getChangeBackgroundColor(Color color) {
    if (color == const Color(0xFF4CAF50)) return const Color(0xFFE8F5E8);
    if (color == const Color(0xFF2196F3)) return const Color(0xFFE3F2FD);
    if (color == const Color(0xFFFF9800)) return const Color(0xFFFFF3E0);
    if (color == const Color(0xFFF44336)) return const Color(0xFFFFEBEE);
    return color.withOpacity(0.1);
  }

  Color _getChangeTextColor(Color color) {
    if (color == const Color(0xFF4CAF50)) return const Color(0xFF4CAF50);
    if (color == const Color(0xFF2196F3)) return const Color(0xFF2196F3);
    if (color == const Color(0xFFFF9800)) return const Color(0xFFFF9800);
    if (color == const Color(0xFFF44336)) return const Color(0xFFF44336);
    return color;
  }

  Widget _buildQuickAccess(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        // Function Grid giống HTML
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          childAspectRatio: 0.8,
          children: [
            _buildFunctionCard(
              context,
              'Danh sách giảng viên',
              'Xem, thêm, sửa, xóa thông tin giảng viên',
              '📋',
            ),
            _buildFunctionCard(
              context,
              'Phân công giảng dạy',
              'Gán giảng viên cho lớp học và môn học',
              '🎯',
            ),
            _buildFunctionCard(
              context,
              'Quản lý tải giảng',
              'Theo dõi số giờ dạy của từng giảng viên',
              '⏱️',
            ),
            _buildFunctionCard(
              context,
              'Lịch cá nhân',
              'Xem lịch dạy của từng giảng viên',
              '📅',
            ),
            _buildFunctionCard(
              context,
              'Nghỉ dạy & Dạy bù',
              'Quản lý đăng ký nghỉ và phê duyệt',
              '🏥',
            ),
            _buildFunctionCard(
              context,
              'Phê duyệt đơn',
              'Phê duyệt các đơn nghỉ dạy và dạy bù',
              '✅',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFunctionCard(
    BuildContext context,
    String title,
    String description,
    String emoji,
  ) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF666666),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Truy cập',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
        Text(
          'Thống kê tiến độ đào tạo theo tháng',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C3E50),
          ),
        ),
            const Spacer(),
            IconButton(
              onPressed: onToggleThongKe,
              icon: const Icon(Icons.swap_horiz),
              tooltip: 'Chuyển đổi hiển thị',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Biểu đồ cột đơn giản
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildChartBar(context, 'T1', 80, const Color(0xFF2196F3)),
                  _buildChartBar(context, 'T2', 65, const Color(0xFF2196F3)),
                  _buildChartBar(context, 'T3', 90, const Color(0xFF2196F3)),
                  _buildChartBar(context, 'T4', 75, const Color(0xFF2196F3)),
                  _buildChartBar(context, 'T5', 85, const Color(0xFF2196F3)),
                  _buildChartBar(context, 'T6', 70, const Color(0xFF2196F3)),
                ],
              ),
              const SizedBox(height: 20),
              // Thông tin chi tiết
              Row(
                children: [
                  Expanded(
                    child: _buildStatInfo(
                      context,
                      'Lớp học hoàn thành',
                      '142',
                      Icons.check_circle,
                      const Color(0xFF4CAF50),
                    ),
                  ),
                  Expanded(
                    child: _buildStatInfo(
                      context,
                      'Đơn chờ duyệt',
                      '23',
                      Icons.pending_actions,
                      const Color(0xFFFF9800),
                    ),
                  ),
                  Expanded(
                    child: _buildStatInfo(
                      context,
                      'Cảnh báo tiến độ',
                      '7',
                      Icons.warning,
                      const Color(0xFFF44336),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartBar(BuildContext context, String label, double height, Color color) {
    return Column(
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatInfo(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    String label,
    int value1,
    int value2,
    Color color,
  ) {
    final percentage = value2 > 0 ? (value1 / value2 * 100).round() : 0;
    final displayValue = kieuThongKe ? '$value1/$value2' : '$percentage%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              displayValue,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value2 > 0 ? value1 / value2 : 0,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🕒 Hoạt động gần đây',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF667EEA),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              listActivityLog.isEmpty
                  ? _buildEmptyActivity()
                  : Column(
                      children: [
                        _buildActivityItem(
                          context,
                          'Thêm giảng viên mới',
                          '2 giờ trước',
                          '👨‍🏫',
                        ),
                        const SizedBox(height: 15),
                        _buildActivityItem(
                          context,
                          'Cập nhật lịch học tuần 8',
                          '4 giờ trước',
                          '📅',
                        ),
                        const SizedBox(height: 15),
                        _buildActivityItem(
                          context,
                          'Phê duyệt đơn nghỉ dạy',
                          '6 giờ trước',
                          '✅',
                        ),
                        const SizedBox(height: 15),
                        _buildActivityItem(
                          context,
                          'Xuất báo cáo tháng 10',
                          '1 ngày trước',
                          '📊',
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyActivity() {
    return const Center(
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: Color(0xFF666666),
          ),
          SizedBox(height: 16),
          Text(
            'Không có hoạt động nào',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, String title, String time, String emoji) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF333333),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget cho danh sách giảng viên
class _DanhSachGiangVienPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Modern header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1976D2),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quản lý giảng viên',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Danh sách và thông tin giảng viên',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        // Search functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {
                        // Filter functionality
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          const Expanded(
            child: DsgiangvienPage(),
          ),
        ],
      ),
    );
  }
}

// Widget cho danh sách học phần
class _DanhSachHocPhanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF1976D2)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.school,
                                color: Color(0xFF9C27B0),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Quản lý Học phần',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: const Color(0xFF333333),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Quản lý lớp học, môn học và lịch trình giảng dạy',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content - Function Cards
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Function Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.8,
                    children: [
                      _buildHocPhanFunctionCard(
                        context,
                        'Quản lý lớp học',
                        'Thêm, sửa, xóa thông tin lớp học',
                        Icons.school,
                        const Color(0xFF9C27B0),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const _QuanLyLopHocPage(),
                          ),
                        ),
                      ),
                      _buildHocPhanFunctionCard(
                        context,
                        'Quản lý môn học',
                        'Quản lý danh sách môn học và chương trình',
                        Icons.menu_book,
                        const Color(0xFF2196F3),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _QuanLyMonHocPage(),
                            ),
                          );
                        },
                      ),
                      _buildHocPhanFunctionCard(
                        context,
                        'Sinh lịch tự động',
                        'Tạo lịch tự động cho các lớp',
                        Icons.flash_on,
                        const Color(0xFFFF9800),
                      ),
                      _buildHocPhanFunctionCard(
                        context,
                        'Cảnh báo lịch trình',
                        'Phát hiện xung đột, chậm tiến độ',
                        Icons.warning,
                        const Color(0xFFFF9800),
                      ),
                      _buildHocPhanFunctionCard(
                        context,
                        'Lịch trình giảng dạy',
                        'Xem và điều chỉnh lịch tổng thể',
                        Icons.assignment,
                        const Color(0xFF795548),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHocPhanFunctionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.transparent),
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: color,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF666666),
              height: 1.4,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Truy cập',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// Widget cho thống kê
class _ThongKePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Modern header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1976D2),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thống kê & Báo cáo',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Phân tích và báo cáo tổng hợp',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.white),
                      onPressed: () {
                        // Export report functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        // Refresh data functionality
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          const Expanded(
            child: TrangThongKeGioDay(),
          ),
        ],
      ),
    );
  }
}

// Widget cho Quản lý lớp học
class _QuanLyLopHocPage extends StatefulWidget {
  const _QuanLyLopHocPage();

  @override
  State<_QuanLyLopHocPage> createState() => _QuanLyLopHocPageState();
}

class _QuanLyLopHocPageState extends State<_QuanLyLopHocPage> {
  String selectedSemester = 'HK1 2024-2025';
  String selectedSemesterFilter = 'Tất cả học kỳ';
  String selectedFacultyFilter = 'Tất cả khoa';
  
  // Form controllers
  final TextEditingController _maLopController = TextEditingController();
  final TextEditingController _soSinhVienController = TextEditingController();
  final TextEditingController _phongHocController = TextEditingController();
  final TextEditingController _giangVienController = TextEditingController();
  final TextEditingController _tenLopController = TextEditingController();
  final TextEditingController _lichHocController = TextEditingController();
  final TextEditingController _monHocController = TextEditingController();
  
  // Error states
  Map<String, bool> _fieldErrors = {};

  @override
  void dispose() {
    _maLopController.dispose();
    _soSinhVienController.dispose();
    _phongHocController.dispose();
    _giangVienController.dispose();
    _tenLopController.dispose();
    _lichHocController.dispose();
    _monHocController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      _fieldErrors.clear();
    });
  }

  bool _validateForm() {
    Map<String, bool> errors = {};
    
    if (_maLopController.text.trim().isEmpty) {
      errors['maLop'] = true;
    }
    if (_soSinhVienController.text.trim().isEmpty) {
      errors['soSinhVien'] = true;
    }
    if (_phongHocController.text.trim().isEmpty) {
      errors['phongHoc'] = true;
    }
    if (_giangVienController.text.trim().isEmpty) {
      errors['giangVien'] = true;
    }
    if (_tenLopController.text.trim().isEmpty) {
      errors['tenLop'] = true;
    }
    if (_lichHocController.text.trim().isEmpty) {
      errors['lichHoc'] = true;
    }
    if (_monHocController.text.trim().isEmpty) {
      errors['monHoc'] = true;
    }
    if (selectedSemester.isEmpty) {
      errors['hocKy'] = true;
    }
    
    setState(() {
      _fieldErrors = errors;
    });
    
    return errors.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF1976D2), size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Quản lý lớp học',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF333333),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Tổng số: 6 lớp học',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF666666),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showAddClassModal(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Thêm',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Search and Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey[600], size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Tìm kiếm...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSemesterFilter,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        items: [
                          'Tất cả học kỳ',
                          'HK1 2024-2025',
                          'HK2 2024-2025',
                          'HK3 2024-2025',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedSemesterFilter = newValue;
                            });
                          }
                        },
                        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFacultyFilter,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        items: [
                          'Tất cả khoa',
                          'Khoa Công nghệ thông tin',
                          'Khoa Xây dựng',
                          'Khoa Cơ khí',
                          'Khoa Điện',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedFacultyFilter = newValue;
                            });
                          }
                        },
                        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Class List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                _buildClassCard(
                  'TLU2021',
                  'Kỹ thuật Xây dựng 01',
                  '45 sinh viên',
                  'T2, T4 (7:00-9:00)',
                  'Phòng A101',
                  'Toán cao cấp',
                  'TS. Nguyễn Văn A',
                  'HK1 2024-2025',
                ),
                const SizedBox(height: 12),
                _buildClassCard(
                  'TLU2022',
                  'Cơ khí Động lực 02',
                  '38 sinh viên',
                  'T3, T5 (9:00-11:00)',
                  'Phòng B205',
                  'Vật lý đại cương',
                  'ThS. Trần Thị B',
                  'HK1 2024-2025',
                ),
                const SizedBox(height: 12),
                _buildClassCard(
                  'TLU2023',
                  'Công nghệ Thông tin 03',
                  '42 sinh viên',
                  'T2, T6 (13:00-15:00)',
                  'Phòng C301',
                  'Lập trình Java',
                  'TS. Lê Văn C',
                  'HK1 2024-2025',
                ),
                const SizedBox(height: 12),
                _buildClassCard(
                  'TLU2024',
                  'Kinh tế Xây dựng 04',
                  '35 sinh viên',
                  'T3, T5 (15:00-17:00)',
                  'Phòng D102',
                  'Kinh tế học đại cương',
                  'ThS. Phạm Thị D',
                  'HK1 2024-2025',
                ),
                const SizedBox(height: 12),
                _buildClassCard(
                  'TLU2025',
                  'Môi trường Xây dựng 05',
                  '40 sinh viên',
                  'T4, T6 (9:00-11:00)',
                  'Phòng E201',
                  'Hóa học môi trường',
                  'TS. Hoàng Văn E',
                  'HK1 2024-2025',
                ),
                const SizedBox(height: 12),
                _buildClassCard(
                  'TLU2026',
                  'Thủy lợi Thủy điện 06',
                  '33 sinh viên',
                  'T2, T4 (15:00-17:00)',
                  'Phòng F103',
                  'Cơ học thủy khí',
                  'ThS. Ngô Thị F',
                  'HK1 2024-2025',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(
    String classCode,
    String className,
    String studentCount,
    String schedule,
    String room,
    String subject,
    String teacher,
    String semester,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  classCode,
                  style: const TextStyle(
                    color: Color(0xFF1976D2),
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            className,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.people, color: Colors.grey[600], size: 14),
              const SizedBox(width: 4),
              Text(studentCount, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, color: Colors.grey[600], size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(schedule, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey[600], size: 14),
              const SizedBox(width: 4),
              Text(room, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          const SizedBox(height: 8),
          Text(
            subject,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            teacher,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                semester,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showClassDetailModal(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Chi tiết →',
                  style: TextStyle(
                    color: Color(0xFF1976D2),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClassDetailModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Chi tiết lớp học',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF666666),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Class Code Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'TLU2022',
                            style: TextStyle(
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Class Name
                        const Text(
                          'Cơ khí Động lực 02',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Semester
                        const Text(
                          'HK1 2024-2025',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Information Cards
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1976D2),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: const Icon(
                                            Icons.people,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Số sinh viên',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const Text(
                                                '38 sinh viên',
                                                style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1976D2),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: const Icon(
                                            Icons.location_on,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Phòng học',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const Text(
                                                'Phòng B205',
                                                style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1976D2),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: const Icon(
                                            Icons.calendar_today,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Lịch học',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const Text(
                                                'T3, T5 (9:00-11:00)',
                                                style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1976D2),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: const Icon(
                                            Icons.menu_book,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Môn học',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const Text(
                                                'Vật lý đại cương',
                                                style: TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1976D2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Giảng viên phụ trách',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Text(
                                      'ThS. Trần Thị B',
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(color: Color(0xFF1976D2)),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Đóng',
                                style: TextStyle(
                                  color: Color(0xFF1976D2),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Handle edit logic here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Chức năng chỉnh sửa sẽ được phát triển!'),
                                    backgroundColor: Color(0xFF1976D2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Chỉnh sửa',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddClassModal(BuildContext context) {
    _clearErrors(); // Clear any previous errors
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Thêm lớp học mới',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF666666),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Form Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Form Fields - 2 Columns
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFormField('Mã lớp học', 'VD: TLU2021', 'maLop', _maLopController),
                                  const SizedBox(height: 16),
                                  _buildFormField('Số sinh viên', '0', 'soSinhVien', _soSinhVienController),
                                  const SizedBox(height: 16),
                                  _buildFormField('Phòng học', 'VD: Phòng A101', 'phongHoc', _phongHocController),
                                  const SizedBox(height: 16),
                                  _buildFormField('Giảng viên', 'VD: TS. Nguyễn Văn A', 'giangVien', _giangVienController),
                                  const SizedBox(height: 16),
                                  // Display selected semester
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F2FD),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFF1976D2), width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF1976D2),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Học kỳ đã chọn: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1976D2),
                                          ),
                                        ),
                                        Text(
                                          selectedSemester,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1976D2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Right Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFormField('Tên lớp học', 'VD: Kỹ thuật Xây dựng 01', 'tenLop', _tenLopController),
                                  const SizedBox(height: 16),
                                  _buildFormField('Lịch học', 'VD: T2, T4 (7:00-9:00)', 'lichHoc', _lichHocController),
                                  const SizedBox(height: 16),
                                  _buildFormField('Môn học', 'VD: Toán cao cấp', 'monHoc', _monHocController),
                                  const SizedBox(height: 16),
                                  _buildDropdownField('Học kỳ'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Hủy',
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                if (_validateForm()) {
                                  // Handle add class logic here
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Đã thêm lớp học mới thành công!'),
                                      backgroundColor: Color(0xFF1976D2),
                                    ),
                                  );
                                } else {
                                  // Show error message if validation fails
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Vui lòng điền đầy đủ thông tin!'),
                                      backgroundColor: Color(0xFFFF6B6B),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Thêm lớp học',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField(String label, String placeholder, String fieldKey, TextEditingController controller) {
    bool hasError = _fieldErrors[fieldKey] ?? false;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError ? const Color(0xFFFF6B6B) : const Color(0xFFE0E0E0),
              width: hasError ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            onChanged: (value) {
              if (hasError && value.trim().isNotEmpty) {
                setState(() {
                  _fieldErrors.remove(fieldKey);
                });
              }
            },
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Please fill out this field.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownField(String label) {
    bool hasError = _fieldErrors['hocKy'] ?? false;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError ? const Color(0xFFFF6B6B) : const Color(0xFFE0E0E0),
              width: hasError ? 2 : 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedSemester,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
            items: [
              DropdownMenuItem(
                value: 'HK1 2024-2025',
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedSemester == 'HK1 2024-2025' 
                        ? const Color(0xFF1976D2) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'HK1 2024-2025',
                    style: TextStyle(
                      color: selectedSemester == 'HK1 2024-2025' 
                          ? Colors.white 
                          : const Color(0xFF333333),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'HK2 2024-2025',
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedSemester == 'HK2 2024-2025' 
                        ? const Color(0xFF1976D2) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'HK2 2024-2025',
                    style: TextStyle(
                      color: selectedSemester == 'HK2 2024-2025' 
                          ? Colors.white 
                          : const Color(0xFF333333),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'HK3 2024-2025',
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedSemester == 'HK3 2024-2025' 
                        ? const Color(0xFF1976D2) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'HK3 2024-2025',
                    style: TextStyle(
                      color: selectedSemester == 'HK3 2024-2025' 
                          ? Colors.white 
                          : const Color(0xFF333333),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedSemester = newValue;
                  _fieldErrors.remove('hocKy');
                });
              }
            },
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF666666),
              size: 20,
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Please fill out this field.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// Quản lý môn học page
class _QuanLyMonHocPage extends StatefulWidget {
  @override
  State<_QuanLyMonHocPage> createState() => _QuanLyMonHocPageState();
}

class _QuanLyMonHocPageState extends State<_QuanLyMonHocPage> {
  String selectedFilter = 'Tất cả';
  String selectedSemester = 'HK1 2024-2025';
  String selectedFaculty = 'Tất cả khoa';
  int currentPage = 1;
  final int totalCourses = 12;

  // Course data
  final List<Map<String, String>> allCourses = [
    {'name': 'Cơ sở dữ liệu', 'code': 'IT30001', 'instructor': 'Nguyễn Văn A', 'credits': '2 tín chỉ', 'students': '45 sinh viên', 'schedule': 'Thứ 2, 4', 'time': '07:00 - 09:30', 'room': 'TC-404', 'status': 'Đang dạy'},
    {'name': 'Lập trình hướng đối tượng', 'code': 'IT31001', 'instructor': 'Trần Thị B', 'credits': '3 tín chỉ', 'students': '38 sinh viên', 'schedule': 'Thứ 3, 5', 'time': '09:00 - 11:30', 'room': 'TC-405', 'status': 'Đang dạy'},
    {'name': 'Mạng máy tính', 'code': 'IT30800', 'instructor': 'Lê Văn C', 'credits': '2 tín chỉ', 'students': '42 sinh viên', 'schedule': 'Thứ 2, 6', 'time': '13:00 - 15:30', 'room': 'TC-406', 'status': 'Đã kết thúc'},
    {'name': 'Phân tích thiết kế hệ thống', 'code': 'IT31201', 'instructor': 'Phạm Thị D', 'credits': '3 tín chỉ', 'students': '35 sinh viên', 'schedule': 'Thứ 4, 6', 'time': '15:00 - 17:30', 'room': 'TC-407', 'status': 'Đã kết thúc'},
    {'name': 'Cơ sở dữ liệu nâng cao', 'code': 'IT30002', 'instructor': 'Nguyễn Văn E', 'credits': '3 tín chỉ', 'students': '40 sinh viên', 'schedule': 'Thứ 3, 5', 'time': '07:00 - 09:30', 'room': 'TC-408', 'status': 'Đang dạy'},
    {'name': 'Lập trình web', 'code': 'IT31002', 'instructor': 'Trần Thị F', 'credits': '2 tín chỉ', 'students': '35 sinh viên', 'schedule': 'Thứ 2, 4', 'time': '13:00 - 15:30', 'room': 'TC-409', 'status': 'Đang dạy'},
    {'name': 'An toàn thông tin', 'code': 'IT30801', 'instructor': 'Lê Văn G', 'credits': '3 tín chỉ', 'students': '30 sinh viên', 'schedule': 'Thứ 4, 6', 'time': '09:00 - 11:30', 'room': 'TC-410', 'status': 'Đã kết thúc'},
    {'name': 'Trí tuệ nhân tạo', 'code': 'IT31202', 'instructor': 'Phạm Thị H', 'credits': '3 tín chỉ', 'students': '28 sinh viên', 'schedule': 'Thứ 3, 5', 'time': '15:00 - 17:30', 'room': 'TC-411', 'status': 'Đã kết thúc'},
  ];

  List<Map<String, String>> get filteredCourses {
    if (selectedFilter == 'Tất cả') {
      return allCourses;
    } else if (selectedFilter == 'Đang dạy') {
      return allCourses.where((course) => course['status'] == 'Đang dạy').toList();
    } else if (selectedFilter == 'Đã kết thúc') {
      return allCourses.where((course) => course['status'] == 'Đã kết thúc').toList();
    }
    return allCourses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF1976D2), size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Quản lý môn học',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF333333),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Search and Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tìm kiếm môn học...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showFilterModal(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_list, color: Colors.grey[600], size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Bộ lọc',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showAddCourseModal(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1976D2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              const Text(
                                'Thêm môn học',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter Navigation
                Row(
                  children: [
                    _buildFilterTab('Tất cả ${allCourses.length}', selectedFilter == 'Tất cả'),
                    const SizedBox(width: 20),
                    _buildFilterTab('Đang dạy ${allCourses.where((course) => course['status'] == 'Đang dạy').length}', selectedFilter == 'Đang dạy'),
                    const SizedBox(width: 20),
                    _buildFilterTab('Đã kết thúc ${allCourses.where((course) => course['status'] == 'Đã kết thúc').length}', selectedFilter == 'Đã kết thúc'),
                  ],
                ),
              ],
            ),
          ),
          // Course List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                return _buildCourseCard(filteredCourses[index]);
              },
            ),
          ),
          // Pagination
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hiển thị ${filteredCourses.length} môn học',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    _buildPaginationButton('Trước', false),
                    const SizedBox(width: 8),
                    _buildPaginationButton('1', true),
                    const SizedBox(width: 8),
                    _buildPaginationButton('2', false),
                    const SizedBox(width: 8),
                    _buildPaginationButton('3', false),
                    const SizedBox(width: 8),
                    _buildPaginationButton('Sau', false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = text.split(' ')[0];
        });
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? const Color(0xFF333333) : Colors.grey[600],
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: text.length * 8.0,
            color: isSelected ? const Color(0xFF1976D2) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Map<String, String> course) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  course['name']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              Text(
                course['code']!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.download, color: Colors.grey[600], size: 16),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Giảng viên: ${course['instructor']}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.assignment, color: Colors.grey[600], size: 14),
              const SizedBox(width: 4),
              Text(
                'Số tín chỉ: ${course['credits']}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.people, color: Colors.grey[600], size: 14),
              const SizedBox(width: 4),
              Text(
                'Số sinh viên: ${course['students']}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.grey[600], size: 14),
              const SizedBox(width: 4),
              Text(
                'Lịch học: ${course['schedule']}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.grey[600], size: 14),
              const SizedBox(width: 4),
              Text(
                course['time']!,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 16),
              Text(
                'Phòng: ${course['room']}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: course['status'] == 'Đang dạy' 
                      ? const Color(0xFFE8F5E8) 
                      : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  course['status']!,
                  style: TextStyle(
                    color: course['status'] == 'Đang dạy' 
                        ? const Color(0xFF2E7D32) 
                        : const Color(0xFFD32F2F),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1976D2) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? const Color(0xFF1976D2) : const Color(0xFFE0E0E0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showAddCourseModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1976D2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Tạo môn học mới',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bước 1: Thông tin cơ bản',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Mã môn học
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mã môn học',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFFE0E0E0)),
                                    ),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        hintText: 'IT4014-1',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1976D2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.refresh, color: Colors.white, size: 16),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Tự động sinh',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Môn học
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Môn học',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE0E0E0)),
                              ),
                              child: const Text(
                                'Chọn môn học',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF333333),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Course Details Display
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF1976D2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.bar_chart,
                                color: Color(0xFF1976D2),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Số tiết: 45 (15 LT + 30 TH)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1976D2),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Số buổi: 15',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1976D2),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Tần suất: 1 buổi/tuần',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1976D2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Loại lớp
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Loại lớp',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildRadioOption('Lý thuyết', false),
                                const SizedBox(width: 20),
                                _buildRadioOption('Thực hành', false),
                                const SizedBox(width: 20),
                                _buildRadioOption('Hỗn hợp', true),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // File danh sách sinh viên
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'File danh sách sinh viên',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFFE0E0E0)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.upload, color: Colors.grey[600], size: 16),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Chọn file Excel...',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.download, color: Colors.white, size: 16),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Tải mẫu',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.arrow_back, color: Color(0xFF666666), size: 16),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Quay lại',
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Handle next logic here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Chức năng tiếp theo sẽ được phát triển!'),
                                    backgroundColor: Color(0xFF1976D2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Tiếp theo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadioOption(String text, bool isSelected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFF1976D2) : Colors.grey,
              width: 2,
            ),
          ),
          child: isSelected
              ? Container(
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1976D2),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? const Color(0xFF1976D2) : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1976D2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Bộ lọc môn học',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trạng thái môn học
                        const Text(
                          'Trạng thái môn học',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildFilterRadioOption('Tất cả', selectedFilter == 'Tất cả'),
                            const SizedBox(width: 20),
                            _buildFilterRadioOption('Đang dạy', selectedFilter == 'Đang dạy'),
                            const SizedBox(width: 20),
                            _buildFilterRadioOption('Đã kết thúc', selectedFilter == 'Đã kết thúc'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Học kỳ
                        const Text(
                          'Học kỳ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedSemester,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF333333),
                              ),
                              items: [
                                'HK1 2024-2025',
                                'HK2 2024-2025',
                                'HK3 2024-2025',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedSemester = newValue;
                                  });
                                }
                              },
                              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                              isExpanded: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Khoa
                        const Text(
                          'Khoa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedFaculty,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF333333),
                              ),
                              items: [
                                'Tất cả khoa',
                                'Khoa Công nghệ thông tin',
                                'Khoa Xây dựng',
                                'Khoa Cơ khí',
                                'Khoa Điện',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedFaculty = newValue;
                                  });
                                }
                              },
                              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                              isExpanded: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Hủy',
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  // Apply filters
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Áp dụng',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterRadioOption(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = text;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF1976D2) : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected
                ? Container(
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1976D2),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? const Color(0xFF1976D2) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
