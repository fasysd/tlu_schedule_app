import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/models/schedule_model.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';
import 'package:tlu_schedule_app/data/services/schedule_service.dart';
import 'package:tlu_schedule_app/data/services/static_data.dart';
import 'package:tlu_schedule_app/presentation/widgets/common_header.dart';

final scheduleService = ScheduleService();

class ProfilePage extends StatefulWidget {
  final UserAccount user;
  final Function(int) onNavigate;

  const ProfilePage({super.key, required this.user, required this.onNavigate});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<ScheduleEntry>> _pendingRequestsFuture;
  late Future<List<Course>> _teachingCoursesFuture;

  @override
  void initState() {
    super.initState();
    _pendingRequestsFuture = _loadPendingRequests();
    _teachingCoursesFuture = _loadTeachingCourses();
  }

  Future<List<ScheduleEntry>> _loadPendingRequests() async {
    final allSchedules = await scheduleService.getAllSchedules();
    final instructorCourseIds = staticCourses
        .where((c) => c.instructorId == widget.user.id)
        .map((c) => c.id)
        .toSet();

    final requests = allSchedules.where((s) {
      return instructorCourseIds.contains(s.courseId) &&
          (s.status == 'pending_leave' || s.makeupStatus == 'pending_makeup');
    }).toList();

    requests.sort(
      (a, b) => (b.requestCreationTime ?? b.date).compareTo(
        a.requestCreationTime ?? a.date,
      ),
    );
    return requests;
  }

  Future<List<Course>> _loadTeachingCourses() async {
    final now = DateTime.now();
    final currentSemester = staticSemesters.firstWhere(
      (s) => now.isAfter(s.startDate) && now.isBefore(s.endDate),
      orElse: () => staticSemesters.first,
    );

    return staticCourses
        .where(
          (c) =>
              c.instructorId == widget.user.id &&
              c.semesterId == currentSemester.id,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonHeader(user: widget.user),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(
                  context,
                  'Thông tin cá nhân',
                  showViewAll: false,
                ),
                const SizedBox(height: 16),
                _buildPersonalInfo(context, widget.user),
                const SizedBox(height: 24),
                _buildSectionTitle(
                  context,
                  'Đơn xin phê duyệt',
                  showViewAll: true,
                  onPressed: () => widget.onNavigate(2),
                ),
                const SizedBox(height: 16),
                _buildPendingRequestsSection(),
                const SizedBox(height: 24),
                _buildSectionTitle(
                  context,
                  'Học phần đang dạy',
                  showViewAll: true,
                  onPressed: () => widget.onNavigate(1),
                ),
                const SizedBox(height: 16),
                _buildTeachingCoursesSection(),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Thống kê', showViewAll: false),
                const SizedBox(height: 16),
                _buildStatistics(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    required bool showViewAll,
    VoidCallback? onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        if (showViewAll)
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(89, 141, 192, 0.8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Xem chi tiết', style: TextStyle(fontSize: 12)),
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalInfo(BuildContext context, UserAccount user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(217, 230, 241, 1),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(user.avatarPath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Cột thông tin
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoRow('Họ và tên', user.fullName),
              _buildInfoRow('TK', user.username),
              _buildInfoRow(
                'Ngày sinh',
                user.dateOfBirth != null
                    ? DateFormat('dd/MM/yyyy').format(user.dateOfBirth!)
                    : 'Chưa có',
              ),
              _buildInfoRow('SĐT', user.phone ?? ""),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingRequestsSection() {
    return FutureBuilder<List<ScheduleEntry>>(
      future: _pendingRequestsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Không có đơn xin nào.');
        }
        final requests = snapshot.data!;

        final itemsToShow = requests
            .take(2)
            .map((req) => _buildRequestItem(req))
            .toList();

        if (requests.length > 2) {
          itemsToShow.add(
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                '...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: itemsToShow,
          ),
        );
      },
    );
  }

  Widget _buildRequestItem(ScheduleEntry request) {
    final course = staticCourses.firstWhere(
      (c) => c.id == request.courseId,
      orElse: () => Course(
        subjectName: "Không rõ",
        id: '',
        courseCode: '',
        className: '',
        instructorId: '',
        semesterId: '',
        courseType: '',
        totalPeriods: 0,
        credits: 0,
        studentCount: 0,
        numberOfPeriods: 0,
      ),
    );
    final isLeave = request.status == 'pending_leave';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(left: 12),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.subjectName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          _buildInfoRow('Loại', isLeave ? 'Đơn xin nghỉ' : 'Đơn xin dạy bù'),
          _buildInfoRow('Ngày', DateFormat('dd/MM/yyyy').format(request.date)),
          _buildInfoRow('Trạng thái', 'Chưa xác nhận'),
        ],
      ),
    );
  }

  Widget _buildTeachingCoursesSection() {
    return FutureBuilder<List<Course>>(
      future: _teachingCoursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Không có học phần nào.');
        }

        final courses = snapshot.data!;

        final itemsToShow = courses
            .take(2)
            .map((course) => _buildCourseItem(course))
            .toList();

        if (courses.length > 2) {
          itemsToShow.add(
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                '...',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: itemsToShow,
          ),
        );
      },
    );
  }

  Widget _buildCourseItem(Course course) {
    final semester = staticSemesters.firstWhere(
      (s) => s.id == course.semesterId,
      orElse: () => Semester(
        id: 'unknown',
        name: 'N/A',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      ),
    );
    final timeRange =
        '${DateFormat('dd/MM/yyyy').format(semester.startDate)} - ${DateFormat('dd/MM/yyyy').format(semester.endDate)}';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(left: 12),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.subjectName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          _buildInfoRow('Thời gian', timeRange),
          _buildInfoRow('Học kì', course.semesterId.replaceAll('_', ' - ')),
          _buildInfoRow('Số tín chỉ', course.credits.toString()),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    final stats = {
      'Buổi dạy đã hoàn thành:': '60%',
      'Buổi nghỉ dạy chưa bù:': '2%',
      'Buổi nghỉ dạy đã bù:': '8%',
      'Buổi dạy còn lại:': '30%',
    };

    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: stats.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: const TextStyle(fontSize: 14)),
                  Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
