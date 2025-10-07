import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/schedule_model.dart';
import '../../data/models/user_model.dart';
import '../../data/mock_data.dart';

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

  @override
  void initState() {
    super.initState();
    _scheduleDataFuture = _loadAndGroupSchedules(widget.user.id);
  }

  Future<ScheduleData> _loadAndGroupSchedules(String instructorId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final userSchedules = mockSchedules.where((s) => s.instructorId == instructorId).toList();

    if (userSchedules.isEmpty) {
      return ScheduleData(groupedSchedules: {}, featuredScheduleId: null);
    }

    userSchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

    String? featuredId = userSchedules.first.id;

    final Map<String, List<ScheduleEntry>> grouped = {};
    final DateFormat formatter = DateFormat("E, 'Ngày' dd/MM/y", 'vi_VN');

    for (var schedule in userSchedules) {
      final String dateKey = formatter.format(schedule.date);
      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(schedule);
    }

    if (userSchedules.isNotEmpty) {
      final nextDay = userSchedules.last.date.add(const Duration(days: 1));
      final String nextDayKey = formatter.format(nextDay);
      if (grouped[nextDayKey] == null) {
        grouped[nextDayKey] = [];
      }
    }

    return ScheduleData(groupedSchedules: grouped, featuredScheduleId: featuredId);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeContent(user: widget.user, scheduleDataFuture: _scheduleDataFuture),
      const Center(child: Text("Lịch giảng viên")),
      const Center(child: Text("Thống kê")),
      const Center(child: Text("Thông tin cá nhân")),
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
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Lịch'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Thống kê'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Cá nhân'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final UserAccount user;
  final Future<ScheduleData> scheduleDataFuture;

  const _HomeContent({required this.user, required this.scheduleDataFuture});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF0D47A1),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(user.avatarPath),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text( "Giảng viên", style: TextStyle(color: Colors.white70, fontSize: 13),),
                    Text( user.fullName, style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, ),),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.circle, color: Colors.greenAccent, size: 12),
                        SizedBox(width: 4),
                        Text( "Không có cảnh báo", style: TextStyle(color: Colors.white, fontSize: 12),),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Body
          Expanded(
            child: FutureBuilder<ScheduleData>(
              future: scheduleDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.groupedSchedules.isEmpty) {
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
                        if (schedulesForDay.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Không có lịch dạy", style: TextStyle(color: Colors.grey)),
                          )
                        else
                          ...schedulesForDay.map((schedule) {
                            final bool isFeatured = schedule.id == featuredId;

                            if (isFeatured) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _DetailedScheduleCard(schedule: schedule, user: user),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _SimpleScheduleCard(schedule: schedule),
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
      ),
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
  const _DetailedScheduleCard({required this.schedule, required this.user});

  Widget _buildStatusItem(String status) {
    switch (status) {
      case 'scheduled':
      case 'held':
        return const _InfoItem(
            icon: Icons.check_circle_outline,
            text: "Có dạy",
            color: Colors.green);
      case 'missed':
        return const _InfoItem(
            icon: Icons.cancel_outlined,
            text: "Nghỉ dạy",
            color: Colors.red);
      case 'pending_leave':
        return _InfoItem(
            icon: Icons.hourglass_top_outlined,
            text: "Chờ duyệt nghỉ",
            color: Colors.orange.shade700);
      default:
        return const _InfoItem(icon: Icons.more_horiz, text: "Không xác định");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${schedule.subjectName} (${schedule.className})",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(
                    icon: Icons.access_time,
                    text: "${DateFormat('HH:mm').format(schedule.startTime)} - ${DateFormat('HH:mm').format(schedule.endTime)}",
                    color: Colors.red),
                _InfoItem(icon: Icons.location_on_outlined, text: schedule.roomId),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(icon: Icons.calendar_today_outlined, text: "Tiết ${schedule.periods.join('-')}"),
                _buildStatusItem(schedule.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(icon: Icons.person_outline, text: user.fullName),
                _InfoItem(icon: Icons.school_outlined, text: schedule.studentCount.toString()),
              ],
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Bấm để xem chi tiết",
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleScheduleCard extends StatelessWidget {
  final ScheduleEntry schedule;

  const _SimpleScheduleCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE3F2FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            Text(DateFormat('HH:mm').format(schedule.startTime),
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(schedule.subjectName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis,),
                  const SizedBox(height: 4),
                  Text("${schedule.roomId}   Tiết ${schedule.periods.join('-')}",
                      style: const TextStyle(color: Colors.black87)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _InfoItem({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.black87),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color ?? Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
