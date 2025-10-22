import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- THAY ĐỔI IMPORT ---
import '../../data/models/schedule_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/schedule_service.dart';
import '../../data/services/static_data.dart';

// --- KẾT THÚC THAY ĐỔI ---
import 'package:tlu_schedule_app/presentation/widgets/common_header.dart';
import 'chi_tiet_hoc_phan_page.dart';

// --- THAY ĐỔI: Tạo instance cho service ---
final scheduleService = ScheduleService();
// --- KẾT THÚC THAY ĐỔI ---

class CourseListPage extends StatefulWidget {
  final UserModel user;

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
    // --- THAY ĐỔI: Sử dụng staticSemesters trực tiếp ---
    if (staticSemesters.isEmpty) return;
    staticSemesters.sort((a, b) => b.startDate.compareTo(a.startDate));
    final now = DateTime.now();

    _selectedSemester = staticSemesters.firstWhere(
      (s) => now.isAfter(s.startDate) && now.isBefore(s.endDate),
      orElse: () => staticSemesters.first,
    );
    // --- KẾT THÚC THAY ĐỔI ---
    _loadCoursesForSemester();
  }

  void _loadCoursesForSemester() {
    if (_selectedSemester == null) {
      if (mounted) {
        setState(() {
          _allCoursesInSemester = [];
          _applyFilters();
        });
      }
      return;
    }

    // --- THAY ĐỔI: Sử dụng staticCourses trực tiếp ---
    final semesterCourses = staticCourses
        .where(
          (course) =>
              course.instructorId == widget.user.id &&
              course.semesterId == _selectedSemester!.id,
        )
        .toList();
    // --- KẾT THÚC THAY ĐỔI ---

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
          query,
        );
        final classNameMatch = course.className.toLowerCase().contains(query);
        return subjectNameMatch || classNameMatch;
      }).toList();
    }
    setState(() => _filteredCourses = tempCourses);
  }

  String _getVietnameseDayOfWeek(DateTime date) {
    const days = [
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'Chủ Nhật',
    ];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CommonHeader(user: widget.user),
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
                      return _buildCourseCard(_filteredCourses[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
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
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSemesterFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Text("Kỳ:", style: Theme.of(context).textTheme.titleMedium),
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
                  // --- THAY ĐỔI: Sử dụng staticSemesters trực tiếp ---
                  items: staticSemesters.map((Semester semester) {
                    return DropdownMenuItem<Semester>(
                      value: semester,
                      child: Text(
                        semester.id.replaceAll('_', ' - '),
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  // --- KẾT THÚC THAY ĐỔI ---
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
    return FutureBuilder<List<ScheduleEntry>>(
      future: scheduleService.getAllSchedules(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            margin: EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              title: Text(course.subjectName),
              subtitle: const Text('Lỗi tải lịch học.'),
            ),
          );
        }

        final schedules =
            snapshot.data?.where((s) => s.courseId == course.id).toList() ?? [];

        if (schedules.isEmpty) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              title: Text(course.subjectName),
              subtitle: const Text('Chưa có lịch học cho học phần này.'),
            ),
          );
        }

        final Map<String, Set<String>> groupedSchedules = {};
        for (var schedule in schedules) {
          final dayOfWeek = _getVietnameseDayOfWeek(schedule.date);
          final periodsString = 'Tiết ${schedule.periods.join('-')}';
          final scheduleKey = '• $dayOfWeek: $periodsString';
          groupedSchedules
              .putIfAbsent(scheduleKey, () => {})
              .add(schedule.roomId);
        }

        schedules.sort((a, b) => a.date.compareTo(b.date));
        final startDate = schedules.first.date;
        final endDate = schedules.last.date;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailPage(
                  course: course,
                  user: widget.user,
                  schedules: schedules,
                ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
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
                        child: Text(
                          'Thời gian:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Phòng học:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(${DateFormat('dd/MM/yyyy').format(startDate)} -> ${DateFormat('dd/MM/yyyy').format(endDate)})',
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
                            child: Text(
                              scheduleKey,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '• ${rooms.join(', ')}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Center(
                    child: Text(
                      'Bấm để xem chi tiết',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
