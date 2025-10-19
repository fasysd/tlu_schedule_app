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
    super.initState();
    lecturerInformation = widget.lecturerModel;
  }

  void onPressedQuayLai() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppbarBackpage(
              textTittle: 'Thông tin giảng viên',
              onPressedBack: onPressedQuayLai,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            child: BoxAvatar(
                              size: 120,
                              pathAvatar:
                                  lecturerInformation.duongDanAvatar ??
                                  'assets/images/defaultAvatar.png',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            lecturerInformation.hoVaTen,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            lecturerInformation.maGiangVien,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // --- THÔNG TIN CÁ NHÂN ---
                    buildSectionTitle(
                      context,
                      'Thông tin cá nhân',
                      Icons.person_outline,
                    ),
                    buildInfoCard([
                      _buildInfoRow1(
                        'Ngày sinh:',
                        DateFormat(
                          'dd/MM/yyyy',
                        ).format(lecturerInformation.ngaySinh),
                      ),
                      _buildInfoRow1('Email:', lecturerInformation.email),
                      _buildInfoRow1(
                        'Số điện thoại:',
                        lecturerInformation.soDienThoai,
                      ),
                    ], context),

                    const SizedBox(height: 20),

                    // --- THÔNG TIN KHÁC ---
                    buildSectionTitle(
                      context,
                      'Thông tin giảng dạy',
                      Icons.school_outlined,
                    ),
                    buildInfoCard([
                      _buildInfoRow2(
                        'Học phần đang dạy:',
                        lecturerInformation.soHocPhanDangDay.toString(),
                      ),
                      _buildInfoRow2(
                        'Đơn nghỉ dạy cần duyệt:',
                        lecturerInformation.soDonNghiDayCanDuyet.toString(),
                      ),
                      _buildInfoRow2(
                        'Đơn dạy bù cần duyệt:',
                        lecturerInformation.soDonDayBuCanDuyet.toString(),
                      ),
                    ], context),

                    const SizedBox(height: 20),

                    // --- THỐNG KÊ ---
                    Row(
                      children: [
                        buildSectionTitle(
                          context,
                          'Thống kê tổng quát',
                          Icons.bar_chart_outlined,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _kieuThongKe = !_kieuThongKe;
                            });
                          },
                          icon: const Icon(
                            Icons.swap_horiz,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    buildStatisticCard(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard(List<Widget> children, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow1(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(flex: 6, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildInfoRow2(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, right: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  Widget buildStatisticCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(89, 141, 192, 1),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          buildShortStat(
            context,
            'Tỉ lệ hoàn thành',
            lecturerInformation.tongSoBuoiDay,
            lecturerInformation.tongSoBuoiDay,
            Colors.blue,
          ),
          const SizedBox(height: 14),
          buildShortStat(
            context,
            'Tỉ lệ nghỉ dạy',
            lecturerInformation.soBuoiNghi,
            lecturerInformation.tongSoBuoiDay,
            Colors.redAccent,
          ),
          const SizedBox(height: 14),
          buildShortStat(
            context,
            'Tỉ lệ dạy bù',
            lecturerInformation.soBuoiDayBu,
            lecturerInformation.soBuoiNghi,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget buildShortStat(
    BuildContext context,
    String label,
    int value1,
    int value2,
    Color color,
  ) {
    if (value2 == 0) value2 = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            Text(
              _kieuThongKe
                  ? '$value1 / $value2'
                  : '${(100 * value1 / value2).floor()}%',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value1 / value2,
            backgroundColor: Colors.grey.shade300,
            color: color,
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}
