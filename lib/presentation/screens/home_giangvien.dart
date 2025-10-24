import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/schedule_model.dart';
import '../../data/models/user_model.dart';
// --- THAY ĐỔI IMPORT ---
import '../../data/services/static_data.dart';
import '../../data/services/schedule_service.dart';
import '../../data/services/auth_service.dart';
// --- KẾT THÚC THAY ĐỔI ---
import 'ds_lich_day_tuan.dart';
import '../widgets/schedule_status_widget.dart';
import 'chi_tiet_buoi_hoc_page.dart';
import '../widgets/info_item_widget.dart';
import 'ds_hoc_phan_gv.dart';
import 'don_phe_duyet_page.dart';
import 'ho_so_page.dart';
import '../widgets/common_header.dart';
import 'login_page.dart';
import 'trang_bao_cao_thong_ke.dart';

// --- THAY ĐỔI: Tạo instance cho service ---
final scheduleService = ScheduleService();
// --- KẾT THÚC THAY ĐỔI ---

class ScheduleData {
  final Map<String, List<ScheduleEntry>> groupedSchedules;
  final String? featuredScheduleId;

  ScheduleData({required this.groupedSchedules, this.featuredScheduleId});
}

class HomeGiangVien extends StatefulWidget {
  final UserAccount user;

  const HomeGiangVien({super.key, required this.user});

  @override
  State<HomeGiangVien> createState() => _HomeGiangVienState();
}

class _HomeGiangVienState extends State<HomeGiangVien> {
  int _currentIndex = 0;
  late Future<ScheduleData> _scheduleDataFuture;

  void _refreshSchedules() {
    setState(() {
      _scheduleDataFuture = _loadAndGroupSchedules(widget.user.id);
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
  void initState() {
    super.initState();
    _scheduleDataFuture = _loadAndGroupSchedules(widget.user.id);
  }

  Future<ScheduleData> _loadAndGroupSchedules(String instructorId) async {
    final allSchedules = await scheduleService.getAllSchedules();

    // --- THAY ĐỔI: Sử dụng staticCourses trực tiếp ---
    final instructorCourseIds = staticCourses
        .where((c) => c.instructorId == instructorId)
        .map((c) => c.id)
        .toSet();
    // --- KẾT THÚC THAY ĐỔI ---

    final userSchedules = allSchedules
        .where((s) => instructorCourseIds.contains(s.courseId))
        .toList();

    if (userSchedules.isEmpty) {
      return ScheduleData(groupedSchedules: {}, featuredScheduleId: null);
    }

    userSchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

    String? featuredId =
    userSchedules.isNotEmpty ? userSchedules.first.id : null;

    final Map<String, List<ScheduleEntry>> grouped = {};
    final DateFormat formatter = DateFormat("EEEE, 'Ngày' dd/MM/y", 'vi_VN');

    for (var schedule in userSchedules) {
      final String dateKey = formatter.format(schedule.date);
      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(schedule);
    }

    return ScheduleData(
        groupedSchedules: grouped, featuredScheduleId: featuredId);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeContent(
        user: widget.user,
        scheduleDataFuture: _scheduleDataFuture,
        onGoBack: _refreshSchedules,
        onLogout: _logout,
      ),
      CourseListPage(user: widget.user),
      DonPheDuyetPage(user: widget.user),
      ProfilePage(
        user: widget.user,
        onNavigate: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
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
              icon: Icon(Icons.calendar_month), label: 'Học phần'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Đơn phê duyệt'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final UserAccount user;
  final Future<ScheduleData> scheduleDataFuture;
  final VoidCallback onGoBack;
  final VoidCallback onLogout;

  const _HomeContent({
    required this.user,
    required this.scheduleDataFuture,
    required this.onGoBack,
    required this.onLogout,
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
              IconButton(
                icon:
                const Icon(Icons.grid_on_rounded, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WeeklySchedulePage(user: user)),
                  );
                },
                tooltip: 'Xem lịch theo tuần',
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<ScheduleData>(
            future: scheduleDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
              }
              if (!snapshot.hasData ||
                  snapshot.data!.groupedSchedules.isEmpty) {
                return const Center(child: Text("Không có lịch trình."));
              }

              final scheduleData = snapshot.data!;
              final groupedData = scheduleData.groupedSchedules;
              final featuredId = scheduleData.featuredScheduleId;
              final dateKeys = groupedData.keys.toList();

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: dateKeys.length,
                itemBuilder: (context, index) {
                  final date = dateKeys[index];
                  final schedulesForDay = groupedData[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _DateHeader(date: date),
                      const SizedBox(height: 12),
                      if (schedulesForDay.isNotEmpty)
                        ...schedulesForDay.map((schedule) {
                          final bool isFeatured = schedule.id == featuredId;

                          if (isFeatured) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _DetailedScheduleCard(
                                  schedule: schedule,
                                  user: user,
                                  onGoBack: onGoBack),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _SimpleScheduleCard(
                                  schedule: schedule,
                                  user: user,
                                  onGoBack: onGoBack),
                            );
                          }
                        }),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String date;
  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        date,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

class _DetailedScheduleCard extends StatelessWidget {
  final ScheduleEntry schedule;
  final UserAccount user;
  final VoidCallback onGoBack;

  const _DetailedScheduleCard({
    required this.schedule,
    required this.user,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    // --- THAY ĐỔI: Sử dụng staticCourses trực tiếp ---
    final course = staticCourses.firstWhere((c) => c.id == schedule.courseId,
        orElse: () => Course(
          id: 'error',
          courseCode: 'N/A',
          subjectName: 'Không tìm thấy học phần',
          className: 'N/A',
          instructorId: '',
          semesterId: '',
          courseType: '',
          totalPeriods: 0,
          credits: 0,
          studentCount: 0,
          numberOfPeriods: 0,
        ));
    // --- KẾT THÚC THAY ĐỔI ---

    final List<List<Widget>> infoRows = [
      [
        InfoItemWidget(
            icon: Icons.access_time,
            text:
            "${DateFormat('HH:mm').format(schedule.startTime)} - ${DateFormat('HH:mm').format(schedule.endTime)}",
            color: Colors.red),
        InfoItemWidget(
            icon: Icons.location_on_outlined, text: schedule.roomId),
      ],
      [
        InfoItemWidget(
            icon: Icons.calendar_today_outlined,
            text: "Tiết ${schedule.periods.join('-')}"),
        ScheduleStatusWidget(status: schedule.status),
      ],
      [
        InfoItemWidget(icon: Icons.person_outline, text: user.fullName),
        InfoItemWidget(
            icon: Icons.school_outlined, text: "${course.studentCount}"),
      ],
    ];

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChiTietBuoiHocPage(
              schedule: schedule,
              user: user,
            ),
          ),
        );
        onGoBack();
      },
      child: Card(
        color: const Color(0xFFE3F2FD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${course.subjectName} (${course.className})",
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              ...infoRows.map((rowItems) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(flex: 6, child: rowItems[0]),
                    Expanded(flex: 4, child: rowItems[1]),
                  ],
                ),
              )),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  "Bấm để xem chi tiết",
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleScheduleCard extends StatelessWidget {
  final ScheduleEntry schedule;
  final UserAccount user;
  final VoidCallback onGoBack;

  const _SimpleScheduleCard({
    required this.schedule,
    required this.user,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    // --- THAY ĐỔI: Sử dụng staticCourses trực tiếp ---
    final course = staticCourses.firstWhere((c) => c.id == schedule.courseId,
        orElse: () => Course(
          id: 'error',
          courseCode: 'N/A',
          subjectName: 'Không tìm thấy học phần',
          className: 'N/A',
          instructorId: '',
          semesterId: '',
          courseType: '',
          totalPeriods: 0,
          credits: 0,
          studentCount: 0,
          numberOfPeriods: 0,
        ));
    // --- KẾT THÚC THAY ĐỔI ---

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChiTietBuoiHocPage(
              schedule: schedule,
              user: user,
            ),
          ),
        );
        onGoBack();
      },
      child: Card(
        color: const Color(0xFFE3F2FD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: SizedBox(
                      width: 100,
                      child: Text(
                        DateFormat('HH:mm').format(schedule.startTime),
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${course.subjectName} (${course.className})",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${schedule.roomId}   Tiết ${schedule.periods.join('-')}",
                          style: const TextStyle(fontSize: 14),
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
    );
  }
}
