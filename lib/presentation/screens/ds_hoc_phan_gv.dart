// E:/Apps/Flutter/project/tlu_schedule_app/lib/presentation/screens/ds_hoc_phan_gv.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/mock_data.dart';
import 'package:tlu_schedule_app/data/models/schedule_model.dart';
import 'package:tlu_schedule_app/data/models/user_model.dart';
import '../widgets/warning_helper.dart';
import 'chi_tiet_hoc_phan_page.dart';

// BỎ CLASS GROUPEDCOURSE VÌ DÙNG TRỰC TIẾP COURSE MODEL

class CourseListPage extends StatefulWidget {
  final UserAccount user;
  const CourseListPage({super.key, required this.user});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  Semester? _selectedSemester;
  List<Course> _allCoursesInSemester = [];
  List<Course> _filteredCourses = [];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initialize();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
  }

  void _initialize() {
    if (mockSemesters.isEmpty) return;
    mockSemesters.sort((a, b) => b.startDate.compareTo(a.startDate));
    final now = DateTime.now();

    _selectedSemester = mockSemesters.firstWhere(
          (s) => now.isAfter(s.startDate) && now.isBefore(s.endDate),
      orElse: () => mockSemesters.first,
    );
    _loadCoursesForSemester();
  }

  void _loadCoursesForSemester() {
    if (_selectedSemester == null) {
      if (mounted) setState(() {
        _allCoursesInSemester = [];
        _applyFilters();
      });
      return;
    }

    // LẤY HỌC PHẦN DỰA TRÊN instructorId và semesterId
    final semesterCourses = mockCourses.where((course) =>
    course.instructorId == widget.user.id &&
        course.semesterId == _selectedSemester!.id
    ).toList();

    if (mounted) {
      setState(() {
        _allCoursesInSemester = semesterCourses;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    List<Course> tempCourses = List.from(_allCoursesInSemester);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      tempCourses = tempCourses.where((course) {
        final subjectNameMatch = course.subjectName.toLowerCase().contains(
            query);
        final classNameMatch = course.className.toLowerCase().contains(query);
        return subjectNameMatch || classNameMatch;
      }).toList();
    }
    setState(() => _filteredCourses = tempCourses);
  }

  String _getVietnameseDayOfWeek(DateTime date) {
    // ... (Hàm này giữ nguyên)
    const days = [
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'Chủ Nhật'
    ];
    return days[date.weekday - 1];
  }

  // ... (build, _buildHeader, _buildSearchBar, _buildSemesterFilterBar giữ nguyên)
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildSemesterFilterBar(),
          Expanded(
            child: _filteredCourses.isEmpty
                ? Center(
              child: Text(
                _searchQuery.isNotEmpty
                    ? 'Không tìm thấy kết quả phù hợp.'
                    : 'Không có học phần nào trong kỳ này.',
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _filteredCourses.length,
              itemBuilder: (context, index) {
                // TRUYỀN COURSE THAY VÌ GROUPEDCOURSE
                return _buildCourseCard(_filteredCourses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    // ... (Giữ nguyên không đổi)
    final warningDetails = getWarningDetails(widget.user.warningStatus);
    final warningText = warningDetails['text'];
    final warningColor = warningDetails['color'];

    return Container(
      width: double.infinity,
      color: const Color.fromRGBO(89, 141, 192, 1),
      padding: EdgeInsets.only(
        top: MediaQuery
            .of(context)
            .padding
            .top,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(widget.user.avatarPath),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Giảng viên",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
                Text(
                  widget.user.fullName,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, color: warningColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      warningText,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    // ... (Giữ nguyên không đổi)
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm theo tên học phần, lớp...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, size: 20),
            onPressed: () {
              _searchController.clear();
            },
          )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Theme
                .of(context)
                .primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSemesterFilterBar() {
    // ... (Giữ nguyên không đổi)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Text("Kỳ:", style: Theme
              .of(context)
              .textTheme
              .titleMedium),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Semester>(
                  value: _selectedSemester,
                  isExpanded: true,
                  items: mockSemesters.map((Semester semester) {
                    return DropdownMenuItem<Semester>(
                      value: semester,
                      child: Text(
                        semester.id.replaceAll('_', ' - '),
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (Semester? newValue) {
                    setState(() {
                      _selectedSemester = newValue;
                      _loadCoursesForSemester();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    // Dùng FutureBuilder để lấy dữ liệu lịch học từ service
    return FutureBuilder<List<ScheduleEntry>>(
      future: scheduleService.getAllSchedules(),
      builder: (context, snapshot) {
        // Trong khi chờ dữ liệu, hiển thị một card loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            margin: EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // Nếu có lỗi, hiển thị card lỗi
        if (snapshot.hasError) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              title: Text(course.subjectName),
              subtitle: const Text('Lỗi tải lịch học.'),
            ),
          );
        }

        // Lấy tất cả buổi học của học phần này từ dữ liệu đã nhận được
        final schedules = snapshot.data
            ?.where((s) => s.courseId == course.id)
            .toList() ?? [];

        if (schedules.isEmpty) {
          // Xử lý trường hợp học phần không có lịch học nào
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              title: Text(course.subjectName),
              subtitle: const Text('Chưa có lịch học cho học phần này.'),
            ),
          );
        }

        // --- Phần logic còn lại giữ nguyên ---
        final Map<String, Set<String>> groupedSchedules = {};
        for (var schedule in schedules) {
          final dayOfWeek = _getVietnameseDayOfWeek(schedule.date);
          final periodsString = 'Tiết ${schedule.periods.join('-')}';
          final scheduleKey = '• $dayOfWeek: $periodsString';
          groupedSchedules.putIfAbsent(scheduleKey, () => {}).add(
              schedule.roomId);
        }

        schedules.sort((a, b) => a.date.compareTo(b.date));
        final startDate = schedules.first.date;
        final endDate = schedules.last.date;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // Truyền cả danh sách lịch đã lọc để trang sau không cần gọi lại service
                builder: (context) =>
                    CourseDetailPage(course: course,
                        user: widget.user,
                        schedules: schedules),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black, width: 1),
            ),
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Học phần: ${course.subjectName}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    'Lớp: ${course.className}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const Divider(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(
                        flex: 3,
                        child: Text('Thời gian:', style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Text('Phòng học:', style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(${DateFormat('dd/MM/yyyy').format(
                        startDate)} -> ${DateFormat('dd/MM/yyyy').format(
                        endDate)})',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ...groupedSchedules.entries.map((entry) {
                    final scheduleKey = entry.key;
                    final rooms = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(scheduleKey,
                                style: const TextStyle(fontSize: 13)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Text('• ${rooms.join(', ')}',
                                style: const TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
