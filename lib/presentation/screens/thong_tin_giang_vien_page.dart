import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/presentation/widgets/box_avatar.dart';
import 'package:tlu_schedule_app/presentation/widgets/sliver_appBar_backPage.dart';

class ThongTinGiangVienPage extends StatefulWidget {
  final LecturerModel lecturerModel;
  const ThongTinGiangVienPage({super.key, required this.lecturerModel});

  @override
  State<ThongTinGiangVienPage> createState() => _ThongTinGiangVienPageState();
}

class _ThongTinGiangVienPageState extends State<ThongTinGiangVienPage> {
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
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 160,
                      padding: EdgeInsets.all(10),
                      // color: Colors.black,
                      child: Center(
                        child: BoxAvatar(
                          pathAvatar: 'assets/images/defaultAvatar.png',
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Thông tin cá nhân',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mã giảng viên: ' +
                                lecturerInformation.maGiangVien.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Họ và tên: ' +
                                lecturerInformation.hoVaTen.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Ngày sinh: ' +
                                DateFormat(
                                  'dd/MM/yyyy',
                                ).format(lecturerInformation.ngaySinh),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Email: ' + lecturerInformation.email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'SDT: ' + lecturerInformation.soDienThoai,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Thông tin khác',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Số đơn nghỉ dạy cần duyệt: ' + 1.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Số đơn dạy bù cần duyệt: ' + 3.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Số học phần đang dạy: ' + 30.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Thống kê tổng quát',
                          style: Theme.of(context).textTheme.headlineLarge,
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
