import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/the_stat_card.dart';
import '../widgets/the_chart_card.dart';
import '../widgets/the_report_item.dart';

class TrangBaoCaoThongKe extends StatefulWidget {
  const TrangBaoCaoThongKe({super.key});

  @override
  State<TrangBaoCaoThongKe> createState() => _TrangBaoCaoThongKeState();
}

class _TrangBaoCaoThongKeState extends State<TrangBaoCaoThongKe> {
  String _selectedPeriod = 'hocKy';
  final List<Map<String, dynamic>> _teachingHoursData = [
    {
      'giangVien': 'Nguyễn Văn A',
      'khoa': 'Công nghệ thông tin',
      'soHocPhan': 5,
      'gioLyThuyet': 45,
      'gioThucHanh': 30,
      'tongGioGiang': 75,
    },
    {
      'giangVien': 'Trần Thị B',
      'khoa': 'Công nghệ thông tin',
      'soHocPhan': 4,
      'gioLyThuyet': 36,
      'gioThucHanh': 24,
      'tongGioGiang': 60,
    },
    {
      'giangVien': 'Lê Văn C',
      'khoa': 'Công nghệ thông tin',
      'soHocPhan': 3,
      'gioLyThuyet': 27,
      'gioThucHanh': 18,
      'tongGioGiang': 45,
    },
    {
      'giangVien': 'Phạm Thị D',
      'khoa': 'Công nghệ thông tin',
      'soHocPhan': 4,
      'gioLyThuyet': 36,
      'gioThucHanh': 24,
      'tongGioGiang': 60,
    },
  ];

  final List<Map<String, dynamic>> _availableReports = [
    {
      'title': 'Báo cáo tổng kết học kỳ',
      'description': 'Thống kê tổng hợp về các học phần, giảng viên và sinh viên trong học kỳ hiện tại',
      'type': 'excel',
    },
    {
      'title': 'Báo cáo giờ giảng',
      'description': 'Chi tiết giờ giảng của từng giảng viên theo khoa và bộ môn',
      'type': 'excel',
    },
    {
      'title': 'Báo cáo đơn từ',
      'description': 'Thống kê các loại đơn từ và tình trạng xử lý',
      'type': 'pdf',
    },
    {
      'title': 'Báo cáo tình hình nghỉ dạy',
      'description': 'Thống kê tình hình nghỉ dạy và dạy bù của giảng viên',
      'type': 'pdf',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // AppBar
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
                        'Báo cáo thống kê',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header với thông tin học kỳ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Học kỳ: 2023-2024/II',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Period Filter
                    _buildPeriodFilter(),
                    const SizedBox(height: 20),
                    
                    // Stats Summary
                    _buildStatsSummary(),
                    const SizedBox(height: 20),
                    
                    // Charts
                    _buildChartsSection(),
                    const SizedBox(height: 20),
                    
                    // Teaching Hours Table
                    _buildTeachingHoursTable(),
                    const SizedBox(height: 20),
                    
                    // Available Reports
                    _buildAvailableReports(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodFilter() {
    return Row(
      children: [
        Text(
          'Thời gian:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                _buildPeriodButton('hocKy', 'Học kỳ'),
                _buildPeriodButton('nam', 'Năm học'),
                _buildPeriodButton('tuyChinh', 'Tùy chỉnh'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Handle filter
              },
              icon: Image.asset(
                'assets/images/icons/filter_icon.png',
                height: 16,
              ),
              label: const Text('Bộ lọc'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {
                // Handle export
              },
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Xuất báo cáo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodButton(String period, String label) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = period;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSummary() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        TheStatCard(
          title: 'Tổng số học phần',
          value: '128',
          trend: 'up',
          percentage: '12',
          icon: Icons.book_outlined,
        ),
        TheStatCard(
          title: 'Tổng giờ giảng',
          value: '1,485',
          trend: 'up',
          percentage: '8',
          icon: Icons.access_time,
        ),
        TheStatCard(
          title: 'Số giảng viên',
          value: '48',
          trend: 'up',
          percentage: '5',
          icon: Icons.people_outline,
        ),
        TheStatCard(
          title: 'Số sinh viên',
          value: '1,850',
          trend: 'up',
          percentage: '15',
          icon: Icons.school_outlined,
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        TheChartCard(
          title: 'Phân bố học phần theo khoa',
          icon: Icons.pie_chart_outline,
          chartComponent: _buildPieChartPlaceholder(),
        ),
        TheChartCard(
          title: 'Tổng giờ giảng theo tháng',
          icon: Icons.bar_chart,
          chartComponent: _buildBarChartPlaceholder(),
        ),
      ],
    );
  }

  Widget _buildTeachingHoursTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(230, 238, 248, 1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thống kê giờ giảng',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                ),
                IconButton(
                  onPressed: () {
                    // Handle download
                  },
                  icon: const Icon(Icons.download, color: Color(0xFF4C7EAA)),
                ),
              ],
            ),
          ),
          
          // Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
              columns: const [
                DataColumn(label: Text('Giảng viên')),
                DataColumn(label: Text('Khoa')),
                DataColumn(label: Text('Số HP')),
                DataColumn(label: Text('Lý thuyết')),
                DataColumn(label: Text('Thực hành')),
                DataColumn(label: Text('Tổng giờ')),
              ],
              rows: _teachingHoursData.map((data) {
                return DataRow(
                  cells: [
                    DataCell(Text(data['giangVien'])),
                    DataCell(Text(data['khoa'])),
                    DataCell(Text(data['soHocPhan'].toString())),
                    DataCell(Text(data['gioLyThuyet'].toString())),
                    DataCell(Text(data['gioThucHanh'].toString())),
                    DataCell(Text(
                      data['tongGioGiang'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hiển thị 1-4 trong số 48 giảng viên',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
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

  Widget _buildPaginationButton(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? Theme.of(context).primaryColor : Colors.grey[300]!,
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isActive ? Colors.white : Colors.grey[600],
            ),
      ),
    );
  }

  Widget _buildAvailableReports() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(230, 238, 248, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              'Báo cáo có sẵn',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
          ),
          
          // Reports List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _availableReports.map((report) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TheReportItem(
                    title: report['title'],
                    description: report['description'],
                    type: report['type'],
                    onDownload: () {
                      // Handle download
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartPlaceholder() {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pie chart placeholder
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).primaryColor.withAlpha(64), width: 8),
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).primaryColor, width: 8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem('CNTT (35%)', const Color(0xFF4C7EAA)),
              _buildLegendItem('Điện tử (25%)', const Color(0xFF6B9AC4)),
              _buildLegendItem('Cơ khí (20%)', const Color(0xFF97C4DE)),
              _buildLegendItem('Khác (20%)', const Color(0xFFD1E5F2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildBarChartPlaceholder() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBarItem('T1', 30),
          _buildBarItem('T2', 45),
          _buildBarItem('T3', 60),
          _buildBarItem('T4', 75),
          _buildBarItem('T5', 90),
          _buildBarItem('T6', 65),
          _buildBarItem('T7', 40),
          _buildBarItem('T8', 20),
        ],
      ),
    );
  }

  Widget _buildBarItem(String label, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
