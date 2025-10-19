import 'package:flutter/material.dart';
import '../../data/models/payment_report_model.dart';
import '../../data/services/statistics_service.dart';
import '../widgets/card_payment_report.dart';

class BaoCaoThanhToanPage extends StatefulWidget {
  const BaoCaoThanhToanPage({super.key});

  @override
  State<BaoCaoThanhToanPage> createState() => _BaoCaoThanhToanPageState();
}

class _BaoCaoThanhToanPageState extends State<BaoCaoThanhToanPage> {
  final StatisticsService _statisticsService = StatisticsService();
  
  List<PaymentReportModel> _paymentReports = [];
  bool _isLoading = true;
  
  // Filter
  String _selectedHocKy = 'HK1';
  String _selectedNamHoc = '2024-2025';
  String _selectedTrangThai = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _statisticsService.fetchPaymentReports(
        hocKy: _selectedHocKy,
        namHoc: _selectedNamHoc,
      );
      setState(() {
        _paymentReports = data;
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

  void _showFilterDialog() {
    String tempHocKy = _selectedHocKy;
    String tempNamHoc = _selectedNamHoc;
    String tempTrangThai = _selectedTrangThai;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Lọc báo cáo thanh toán'),
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: tempTrangThai,
                    decoration: const InputDecoration(
                      labelText: 'Trạng thái thanh toán',
                    ),
                    items: ['Tất cả', 'Chưa thanh toán', 'Đã thanh toán', 'Đang xử lý']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        tempTrangThai = newValue!;
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
                      _selectedTrangThai = tempTrangThai;
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

  List<PaymentReportModel> get _filteredReports {
    if (_selectedTrangThai == 'Tất cả') {
      return _paymentReports;
    }
    return _paymentReports
        .where((report) => report.trangThaiThanhToan == _selectedTrangThai)
        .toList();
  }

  double get _tongTienThanhToan {
    return _filteredReports.fold(0.0, (sum, report) => sum + report.tongTienThanhToan);
  }

  int get _soGiangVienChuaThanhToan {
    return _filteredReports.where((report) => report.trangThaiThanhToan == 'Chưa thanh toán').length;
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
                          'Báo cáo thanh toán',
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
                  child: _buildSummaryCard(),
                ),
              ),
            ];
          },
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredReports.isEmpty
                  ? const Center(
                      child: Text('Không có dữ liệu báo cáo thanh toán'),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _filteredReports.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: CardPaymentReport(
                              paymentReport: _filteredReports[index],
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
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
          Text(
            'Tổng quan thanh toán $_selectedHocKy - $_selectedNamHoc',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Tổng tiền',
                  '${_tongTienThanhToan.toStringAsFixed(0)} VNĐ',
                  Icons.account_balance_wallet,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Chưa thanh toán',
                  _soGiangVienChuaThanhToan.toString(),
                  Icons.pending,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Tổng giảng viên',
                  _filteredReports.length.toString(),
                  Icons.person,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Đã thanh toán',
                  _filteredReports.where((r) => r.trangThaiThanhToan == 'Đã thanh toán').length.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withAlpha(77), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

