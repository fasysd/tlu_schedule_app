import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/presentation/widgets/box_avatar.dart';
import 'package:tlu_schedule_app/presentation/widgets/sliver_appBar_backPage.dart';

class XemChiTietGiangVienPage extends StatefulWidget {
  final LecturerModel lecturerModel;
  const XemChiTietGiangVienPage({super.key, required this.lecturerModel});

  @override
  State<XemChiTietGiangVienPage> createState() =>
      _XemChiTietGiangVienPageState();
}

class _XemChiTietGiangVienPageState extends State<XemChiTietGiangVienPage> {
  bool _kieuThongKe = false;
  late LecturerModel lecturerInformation;
  @override
  void initState() {
    setState(() {
      lecturerInformation = widget.lecturerModel;
    });
  }

  void onPressedQuayLai() {
    Navigator.pop(context);
  }

  void onPressedXemTatCaDonPheDuyet() {}

  void onPressedXemTatCaHocPhan() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppbarBackpage(
              textTittle: 'Thông tin chi tiết',
              onPressedBack: onPressedQuayLai,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      padding: EdgeInsets.all(10),
                      // color: Colors.black,
                      child: Center(
                        child: BoxAvatar(
                          pathAvatar: 'assets/images/defaultAvatar.png',
                        ),
                      ),
                    ),

                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thông tin cá nhân',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Họ và tên: ' +
                                lecturerInformation.hoVaTen.toString(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            'Ngày sinh: ' +
                                DateFormat(
                                  'dd/MM/yyyy',
                                ).format(lecturerInformation.ngaySinh),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            'Email: ' + lecturerInformation.email,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            'SDT: ' + lecturerInformation.soDienThoai,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Đơn xin phê duyệt',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              TextButton(
                                onPressed: onPressedXemTatCaDonPheDuyet,
                                child: Text(
                                  'Xem tất cả',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 90,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) => Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phát triển ứng dụng di động',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelLarge,
                                    ),
                                    Text(
                                      'Loại: đơn xin nghỉ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    Text(
                                      'Ngày: 19/07/2025',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    Text(
                                      'Trạng thái: Chưa xác nhận',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            height: 90,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) => Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phát triển ứng dụng di động',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelLarge,
                                    ),
                                    Text(
                                      'Loại: đơn xin dạy bù',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    Text(
                                      'Ngày: 19/07/2025',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    Text(
                                      'Trạng thái: Chưa xác nhận',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Học phần đang dạy',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextButton(
                          onPressed: onPressedXemTatCaHocPhan,
                          child: Text(
                            'Xem tất cả',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: Colors.black),
                        ),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300.0),
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            ...List.generate(
                              10,
                              (index) => Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 0),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phát triển ứng dụng di động',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelLarge,
                                    ),
                                    Text(
                                      'Thời gian: 12/09/2025 - 12/12/2025',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    Text(
                                      'Học kì: 1_2024_2025',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    Text(
                                      'Số tín chỉ: 3',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
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
                            30,
                            100,
                            Colors.blue,
                          ),
                          SizedBox(height: 15),
                          buildShortStat2(
                            context,
                            'Tỉ lệ nghỉ dạy',
                            30,
                            100,
                            Colors.red,
                          ),
                          SizedBox(height: 15),
                          buildShortStat2(
                            context,
                            'Tỉ lệ dạy bù',
                            30,
                            100,
                            Colors.green,
                          ),
                          SizedBox(height: 15),
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
}
