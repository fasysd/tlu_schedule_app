import 'package:flutter/material.dart';
import '../../data/models/teaching_statistics_model.dart';
import '../../data/models/course_progress_model.dart';
import '../../data/services/statistics_service.dart';
import '../widgets/card_teaching_statistics.dart';
import '../widgets/card_course_progress.dart';
import 'bao_cao_thanh_toan_page.dart';

class ThongkegdiodayPage extends StatefulWidget {
  const ThongkegdiodayPage({super.key});

  @override
  State<ThongkegdiodayPage> createState() => _ThongkegdiodayPageState();
}

class _ThongkegdiodayPageState extends State<ThongkegdiodayPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StatisticsService _statisticsService = StatisticsService();

  // Data
  List<TeachingStatisticsModel> _teachingStatistics = [];
  List<CourseProgressModel> _courseProgress = [];
  Map<String, dynamic> _overallStats = {};

  // Loading state
  bool _isLoadingTab1 = true;
  bool _isLoadingTab2 = true;

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
    setState(() {});
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadTeachingStatistics(),
      _loadCourseProgress(),
      _loadOverallStatistics(),
    ]);
  }

  Future<void> _loadTeachingStatistics() async {
    setState(() => _isLoadingTab1 = true);
    try {
      final data = await _statisticsService.fetchTeachingStatistics(
        hocKy: _selectedHocKy,
        namHoc: _selectedNamHoc,
      );
      setState(() {
        _teachingStatistics = data;
        _isLoadingTab1 = false;
      });
    } catch (e) {
      setState(() => _isLoadingTab1 = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    }
  }

  Future<void> _loadCourseProgress() async {
    setState(() => _isLoadingTab2 = true);
    try {
      final data = await _statisticsService.fetchCourseProgress(
        hocKy: _selectedHocKy,
        namHoc: _selectedNamHoc,
      );
      setState(() {
        _courseProgress = data;
        _isLoadingTab2 = false;
      });
    } catch (e) {
      setState(() => _isLoadingTab2 = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    }
  }

  Future<void> _loadOverallStatistics() async {
    try {
      final data = await _statisticsService.fetchOverallStatistics(
        hocKy: _selectedHocKy,
        namHoc: _selectedNamHoc,
      );
      setState(() {
        _overallStats = data;
      });
    } catch (e) {
      // Handle error silently or show message
    }
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
              title: const Text('Lọc theo học kỳ'),
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
                        Text(
                          'Thống kê giờ dạy',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
                  child: _buildOverallStatsCard(),
                ),
              ),
              SliverPersistentHeader(
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: const [
                      Tab(text: 'Thống kê theo GV'),
                      Tab(text: 'Tiến độ học phần'),
                      Tab(text: 'Báo cáo thanh toán'),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildTeachingStatisticsTab(),
              _buildCourseProgressTab(),
              _buildPaymentReportTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStatsCard() {
    if (_overallStats.isEmpty) {
      return const SizedBox.shrink();
    }

    final tongSoTiet = _overallStats['tongSoTiet'] ?? 0;
    final tongSoTietHoanThanh = _overallStats['tongSoTietHoanThanh'] ?? 0;
    final tongSoTietNghi = _overallStats['tongSoTietNghi'] ?? 0;
    final tongSoTietDayBu = _overallStats['tongSoTietDayBu'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Tổng quan $_selectedHocKy - $_selectedNamHoc',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildStatRow(
            context,
            'Tỉ lệ hoàn thành',
            tongSoTietHoanThanh,
            tongSoTiet,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            context,
            'Tỉ lệ nghỉ dạy',
            tongSoTietNghi,
            tongSoTiet,
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            context,
            'Tỉ lệ dạy bù',
            tongSoTietDayBu,
            tongSoTietNghi,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    int value1,
    int value2,
    Color color,
  ) {
    final percentage = value2 == 0 ? 0.0 : (value1 / value2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            Text(
              '$value1/$value2 (${(percentage * 100).toStringAsFixed(1)}%)',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 15,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeachingStatisticsTab() {
    if (_isLoadingTab1) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_teachingStatistics.isEmpty) {
      return const Center(
        child: Text('Không có dữ liệu thống kê'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTeachingStatistics,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _teachingStatistics.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: CardTeachingStatistics(
              statistics: _teachingStatistics[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseProgressTab() {
    if (_isLoadingTab2) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_courseProgress.isEmpty) {
      return const Center(
        child: Text('Không có dữ liệu tiến độ'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCourseProgress,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _courseProgress.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: CardCourseProgress(
              courseProgress: _courseProgress[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentReportTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Báo cáo thanh toán chi tiết',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Xem báo cáo thanh toán giờ giảng cho từng giảng viên',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BaoCaoThanhToanPage(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Xem báo cáo thanh toán'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom SliverPersistentHeaderDelegate for sticky TabBar
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}

