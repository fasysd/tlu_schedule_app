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
      backgroundColor: Colors.white,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFD32F2F),
        unselectedItemColor: Theme.of(context).disabledColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: 'Giảng viên'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Học phần'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Thống kê'),
        ],
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
        CommonHeader(
          user: user,
          onLogout: onLogout,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.analytics, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrangBaoCaoThongKe(),
                    ),
                  );
                },
                tooltip: 'Báo cáo thống kê',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Thống kê nhanh
              _buildQuickStats(context),
              const SizedBox(height: 16),
              // Thống kê tổng quát
              _buildGeneralStats(context),
              const SizedBox(height: 16),
              // Hoạt động gần đây
              _buildRecentActivity(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thống kê nhanh',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Giảng viên',
                    soLuongGiangVien.toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Học phần',
                    hocPhanDangMo.toString(),
                    Icons.calendar_month,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Đơn nghỉ dạy',
                    donXinNghiDay.toString(),
                    Icons.pause_circle,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Đơn dạy bù',
                    donXinDayBu.toString(),
                    Icons.schedule,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralStats(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Thống kê tổng quát',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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
            _buildProgressBar(
              context,
              'Tỉ lệ hoàn thành',
              soLuongTietHocHoanThan,
              soLuongTietHoc,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildProgressBar(
              context,
              'Tỉ lệ nghỉ dạy',
              soLuongTietHocNghiDay,
              soLuongTietHoc,
              Colors.red,
            ),
            const SizedBox(height: 12),
            _buildProgressBar(
              context,
              'Tỉ lệ dạy bù',
              soLuongTietHocDayBu,
              soLuongTietHocNghiDay,
              Colors.green,
            ),
          ],
        ),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoạt động gần đây',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (listActivityLog.isEmpty)
              const Center(
                child: Text('Không có hoạt động nào'),
              )
            else
              ...listActivityLog.take(5).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildActivityItem(context, item),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, ActivityLog item) {
    final formattedTime = DateFormat('HH:mm dd/MM/yyyy').format(item.time);

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                formattedTime,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget cho danh sách giảng viên
class _DanhSachGiangVienPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách giảng viên'),
        backgroundColor: const Color.fromRGBO(89, 141, 192, 1),
        foregroundColor: Colors.white,
      ),
      body: const DsgiangvienPage(),
    );
  }
}

// Widget cho danh sách học phần
class _DanhSachHocPhanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách học phần'),
        backgroundColor: const Color.fromRGBO(89, 141, 192, 1),
        foregroundColor: Colors.white,
      ),
      body: const DshocphanPage(),
    );
  }
}

// Widget cho thống kê
class _ThongKePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
        backgroundColor: const Color.fromRGBO(89, 141, 192, 1),
        foregroundColor: Colors.white,
      ),
      body: const TrangThongKeGioDay(),
    );
  }
}
