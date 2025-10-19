import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/models/activity_log_model.dart';
import 'package:tlu_schedule_app/data/services/activity_log_sevice.dart';
import 'ds_giang_vien_page.dart';
import 'ds_hoc_phan_page.dart';
import 'ds_don_xin_page.dart';
import 'trang_thong_ke_gio_day.dart';

class PhongdaotaoHomePage extends StatefulWidget {
  const PhongdaotaoHomePage({super.key});

  @override
  State<PhongdaotaoHomePage> createState() => _PhongdaotaoHomePageState();
}

class _PhongdaotaoHomePageState extends State<PhongdaotaoHomePage> {
  String _vaiTro = '';
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
  late List<ActivityLog> _listActivityLog;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Gọi API trước
    final fetchedActivityLogs = await ActivityLogService()
        .fetchActivityLogSFromApi();

    // Cập nhật state sau khi có dữ liệu
    setState(() {
      _vaiTro = 'Phòng đào tạo';
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

  void onPressed_dsGiangVien() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DsgiangvienPage()));
  }

  void onPressed_dsHocPhan() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DshocphanPage()));
  }

  void onPressed_dsDonXin() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DsdonxinPage()));
  }

  void onPressed_thongKe() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const TrangThongKeGioDay()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              floating: false,
              pinned: false,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: Row(
                    children: [
                      const SizedBox(width: 40),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 70,
                        alignment: Alignment.center,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _vaiTro,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            _hoTen,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 30,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildNavigationButton(
                          context,
                          'assets/images/icons/user_icon.png',
                          onPressed_dsGiangVien,
                        ),
                        buildNavigationButton(
                          context,
                          'assets/images/icons/lesson_icon.png',
                          onPressed_dsHocPhan,
                        ),
                        buildNavigationButton(
                          context,
                          'assets/images/icons/form_icon.png',
                          onPressed_dsDonXin,
                        ),
                        buildNavigationButton(
                          context,
                          'assets/images/icons/stats_icon.png',
                          onPressed_thongKe,
                        ),
                      ],
                    ),
                    Column(
                      spacing: 10,
                      children: [
                        buildShortStat1(
                          context,
                          'Giảng viên',
                          _soLuongGiangVien.toString(),
                          'assets/images/icons/user_icon.png',
                        ),
                        buildShortStat1(
                          context,
                          'Học phần đang mở',
                          _hocPhanDangMo.toString(),
                          'assets/images/icons/lesson_icon.png',
                        ),
                        buildShortStat1(
                          context,
                          'Đơn nghỉ dạy cần duyệt',
                          _donXinNghiDay.toString(),
                          'assets/images/icons/form_icon.png',
                        ),
                        buildShortStat1(
                          context,
                          'Đơn dạy bù cần duyệt',
                          _donXinDayBu.toString(),
                          'assets/images/icons/form_icon.png',
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: Colors.grey, // màu viền
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.25,
                            ), // màu bóng (và độ mờ)
                            spreadRadius: 0, // độ lan bóng
                            blurRadius: 4, // độ mờ bóng (càng lớn càng mịn)
                            offset: Offset(0, 4), // hướng đổ bóng (x, y)
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Thống kê tổng quát',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _kieuThongKe = !_kieuThongKe;
                                  });
                                },
                                icon: Image.asset(
                                  'assets/images/icons/change_icon.png',
                                  height: 23,
                                ),
                              ),
                            ],
                          ),
                          buildShortStat2(
                            context,
                            'Tỉ lệ hoàn thành',
                            _soLuongTietHocHoanThan,
                            _soLuongTietHoc,
                            Colors.blue,
                          ),
                          SizedBox(height: 15),
                          buildShortStat2(
                            context,
                            'Tỉ lệ nghỉ dạy',
                            _soLuongTietHocNghiDay,
                            _soLuongTietHoc,
                            Colors.red,
                          ),
                          SizedBox(height: 15),
                          buildShortStat2(
                            context,
                            'Tỉ lệ dạy bù',
                            _soLuongTietHocDayBu,
                            _soLuongTietHocNghiDay,
                            Colors.green,
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: Colors.grey, // màu viền
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.25,
                            ), // màu bóng (và độ mờ)
                            spreadRadius: 0, // độ lan bóng
                            blurRadius: 4, // độ mờ bóng (càng lớn càng mịn)
                            offset: Offset(0, 4), // hướng đổ bóng (x, y)
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(width: 2)),
                            ),
                            child: Text(
                              'Hoạt động gần đây',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                          SizedBox(height: 10),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 400.0, // Chiều cao tối đa là 200
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 10,
                                children: _listActivityLog.map((item) {
                                  return buildActivityLog(
                                    context,
                                    item.time,
                                    item.content,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavigationButton(
    BuildContext context,
    String pathIcon,
    void onPressed(),
  ) {
    return SizedBox(
      width: 75,
      height: 75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)),
        onPressed: onPressed,
        child: Image.asset(pathIcon),
      ),
    );
  }

  Widget buildShortStat1(
    BuildContext context,
    String label,
    String value,
    String pathIcon,
  ) {
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: Colors.grey, // màu viền
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // màu bóng (và độ mờ)
            spreadRadius: 0, // độ lan bóng
            blurRadius: 4, // độ mờ bóng (càng lớn càng mịn)
            offset: Offset(0, 4), // hướng đổ bóng (x, y)
          ),
        ],
      ),
      child: Center(
        child: Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(width: 5),
            Image.asset(pathIcon, width: 25),
          ],
        ),
      ),
    );
  }

  Widget buildShortStat2(
    BuildContext context,
    String label,
    int value1,
    int value2,
    Color color,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              Text(
                _kieuThongKe
                    ? value1.toString() + '/' + value2.toString()
                    : (100 * value1 / value2).floor().toString() + '%',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 15,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                color: Colors.grey, // màu viền
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25), // màu bóng (và độ mờ)
                  spreadRadius: 0, // độ lan bóng
                  blurRadius: 4, // độ mờ bóng (càng lớn càng mịn)
                  offset: Offset(0, 4), // hướng đổ bóng (x, y)
                ),
              ],
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value1 / value2,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActivityLog(BuildContext context, DateTime time, String content) {
    // 👇 format: 06/10/2025 21:45
    String formattedTime = DateFormat('HH:mm dd/MM/yyyy').format(time);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formattedTime, style: Theme.of(context).textTheme.labelMedium),
          Text(content, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
