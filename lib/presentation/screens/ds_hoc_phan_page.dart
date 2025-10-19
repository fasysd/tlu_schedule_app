import 'package:flutter/material.dart';
import '../../data/models/course_model.dart';
import '../../data/services/course_service.dart';
import '../widgets/card_course.dart';
import '../widgets/text_field_search.dart';
import 'tao_hoc_phan_page.dart';

class DshocphanPage extends StatefulWidget {
  const DshocphanPage({super.key});

  @override
  State<DshocphanPage> createState() => _DshocphanPageState();
}

class _DshocphanPageState extends State<DshocphanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CourseService _courseService = CourseService();

  // Data
  List<CourseModel> _courses = [];
  List<CourseModel> _filteredCourses = [];

  // Loading state
  bool _isLoading = true;

  // Search
  String _searchQuery = '';

  // Filter
  String _selectedHocKy = 'HK1';
  String _selectedNamHoc = '2024-2025';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
      _filterCourses();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _courseService.fetchCourses(
        hocKy: _selectedHocKy,
        namHoc: _selectedNamHoc,
      );
      setState(() {
        _courses = data;
        _filteredCourses = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    }
  }

  void _filterCourses() {
    List<CourseModel> filtered = _courses;

    // Filter by tab
    switch (_tabController.index) {
      case 0: // Tất cả
        break;
      case 1: // Đang dạy
        filtered = filtered.where((course) => course.trangThai == 'Đang dạy').toList();
        break;
      case 2: // Đã kết thúc
        filtered = filtered.where((course) => course.trangThai == 'Đã kết thúc').toList();
        break;
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((course) =>
          course.tenHocPhan.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.maHocPhan.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.tenGiangVien.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    setState(() {
      _filteredCourses = filtered;
    });
  }

  void _showFilterDialog() {
    String tempHocKy = _selectedHocKy;
    String tempNamHoc = _selectedNamHoc;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Bộ lọc học phần'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: tempHocKy,
                    decoration: const InputDecoration(
                      labelText: 'Học kỳ',
                    ),
                    items: ['HK1', 'HK2', 'HK3'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        tempHocKy = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: tempNamHoc,
                    decoration: const InputDecoration(
                      labelText: 'Năm học',
                    ),
                    items: ['2023-2024', '2024-2025', '2025-2026']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        tempNamHoc = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedHocKy = tempHocKy;
                      _selectedNamHoc = tempNamHoc;
                    });
                    Navigator.pop(context);
                    _loadData();
                  },
                  child: const Text('Áp dụng'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int get _totalCourses => _courses.length;
  int get _activeCourses => _courses.where((c) => c.trangThai == 'Đang dạy').length;
  int get _completedCourses => _courses.where((c) => c.trangThai == 'Đã kết thúc').length;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
            SliverAppBar(
                automaticallyImplyLeading: true,
                expandedHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(195, 217, 233, 1),
                              padding: const EdgeInsets.all(10),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Image.asset('assets/images/icons/back_icon.png'),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                                'Quản lý học phần',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Học kỳ: $_selectedNamHoc/$_selectedHocKy',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
              ),
                actions: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/icons/filter_icon.png',
                      height: 25,
                    ),
                    onPressed: _showFilterDialog,
                  ),
                ],
            ),
            SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    children: [
                      // Search and Add Button
                      Row(
                        children: [
                          Expanded(
                            child: TextfieldSearch(
                              hintText: 'Tìm kiếm học phần...',
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                                _filterCourses();
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const TaoHocPhanPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Thêm học phần'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(76, 126, 170, 1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Tabs
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: const Color.fromRGBO(76, 126, 170, 1),
                          unselectedLabelColor: Colors.grey[600],
                          indicatorColor: const Color.fromRGBO(76, 126, 170, 1),
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Tất cả'),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$_totalCourses',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Đang dạy'),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$_activeCourses',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Đã kết thúc'),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$_completedCourses',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredCourses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Không có học phần nào',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Hãy thêm học phần mới hoặc thay đổi bộ lọc',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _filteredCourses.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: CardCourse(
                              course: _filteredCourses[index],
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
