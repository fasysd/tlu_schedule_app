import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/teaching_request_model.dart';
import 'package:tlu_schedule_app/presentation/widgets/sliver_appBar_backPage.dart';

class ThongTinDonPage extends StatelessWidget {
  final TeachingRequestModel teachingRequest;
  late final List<String> attachedImages = teachingRequest.anhMinhChung ?? [];

  ThongTinDonPage({super.key, required this.teachingRequest});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppbarBackpage(
                  textTittle: teachingRequest.loaiDon,
                  onPressedBack: () => Navigator.pop(context),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: teachingRequest.loaiDon == "Đơn xin nghỉ dạy"
                        ? _buildDonNghi(context)
                        : _buildDonDayBu(context),
                  ),
                ),
              ],
            ),
            // Nút xác nhận / từ chối
            if (teachingRequest.trangThai == 'Chưa xác nhận')
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        onPressed: () {
                          print('Đơn bị từ chối');
                        },
                        child: const Text('Từ chối'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          print('Đơn được xác nhận');
                        },
                        child: const Text('Xác nhận'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDonNghi(BuildContext context) {
    return [
      InfoSection(
        title: 'Thông tin học phần',
        children: [
          _buildInfoRowUniversal(
            context,
            icon: Icons.book_outlined,
            label: 'Tên học phần',
            value: teachingRequest.tenHocPhan,
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.code_outlined,
            label: 'Mã học phần',
            value: teachingRequest.maHocPhan,
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.person_outline,
            label: 'Giảng viên',
            value:
                teachingRequest.maGiangVien +
                ' - ' +
                teachingRequest.tenGiangVien,
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.calendar_month_outlined,
            label: 'Học kỳ',
            value: teachingRequest.hocKy,
          ),
        ],
      ),
      InfoSection(
        title: 'Thông tin buổi học',
        children: [
          _buildInfoRowUniversal(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'Ngày',
            value: teachingRequest.ngayBuoiHocNghi.toString(),
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.access_time,
            label: 'Ca học',
            value: teachingRequest.caHocNghi,
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.location_on_outlined,
            label: 'Phòng học',
            value: teachingRequest.phongHocNghi,
          ),
        ],
      ),
      InfoSection(
        title: 'Thông tin đơn nghỉ dạy',
        children: [
          _buildInfoRowUniversal(
            context,
            icon: Icons.person_outline,
            label: 'Giảng viên',
            value:
                teachingRequest.maGiangVien +
                ' - ' +
                teachingRequest.tenGiangVien,
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.calendar_today,
            label: 'Ngày gửi',
            value: teachingRequest.ngayGui.toString(),
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.message_outlined,
            label: 'Lý do',
            value: teachingRequest.lyDo.toString(),
          ),
          const SizedBox(height: 6),
          Text(
            'Hình ảnh đính kèm:',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 100,
            child: attachedImages.isNotEmpty
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: attachedImages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        showFullImage(
                          context,
                          Image.network(attachedImages[index]),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          attachedImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Text(
                    '*Không có hình ảnh đính kèm',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
          ),
          const SizedBox(height: 12),
          Divider(color: Theme.of(context).dividerColor, thickness: 1),
          const SizedBox(height: 8),
          _buildInfoRowUniversal(
            context,
            icon: Icons.info_outline,
            label: 'Trạng thái',
            value: teachingRequest.trangThai,
          ),
        ],
      ),
      const SizedBox(height: 100),
    ];
  }

  List<Widget> _buildDonDayBu(BuildContext context) {
    return [
      InfoSection(
        title: 'Thông tin học phần',
        children: [
          _buildInfoRowUniversal(
            context,
            icon: Icons.book_outlined,
            label: 'Tên học phần',
            value: teachingRequest.tenHocPhan,
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.code_outlined,
            label: 'Mã học phần',
            value: teachingRequest.maHocPhan,
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.person_outline,
            label: 'Giảng viên',
            value:
                teachingRequest.maGiangVien +
                ' - ' +
                teachingRequest.tenGiangVien,
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.calendar_month_outlined,
            label: 'Học kỳ',
            value: teachingRequest.hocKy,
          ),
        ],
      ),
      InfoSection(
        title: 'Thông tin buổi học dạy bù',
        children: [
          _buildInfoRowUniversal(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'Ngày',
            value: teachingRequest.ngayBuoiHocDayBu.toString(),
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.access_time,
            label: 'Ca học',
            value: teachingRequest.caHocDayBu.toString(),
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.location_on_outlined,
            label: 'Phòng học',
            value: teachingRequest.phongHocDayBu.toString(),
          ),
        ],
      ),
      InfoSection(
        title: 'Thông tin buổi học nghỉ',
        children: [
          _buildInfoRowUniversal(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'Ngày',
            value: teachingRequest.ngayBuoiHocNghi.toString(),
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.access_time,
            label: 'Ca học',
            value: teachingRequest.caHocNghi,
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.location_on_outlined,
            label: 'Phòng học',
            value: teachingRequest.phongHocNghi.toString(),
          ),
        ],
      ),
      InfoSection(
        title: 'Thông tin đơn nghỉ dạy',
        children: [
          _buildInfoRowUniversal(
            context,
            icon: Icons.person_outline,
            label: 'Giảng viên',
            value:
                teachingRequest.maGiangVien +
                ' - ' +
                teachingRequest.tenGiangVien,
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.calendar_today,
            label: 'Ngày gửi',
            value: teachingRequest.ngayGui.toString(),
          ),
          _buildInfoRowUniversal(
            context,
            icon: Icons.message_outlined,
            label: 'Lý do',
            value: teachingRequest.lyDo.toString(),
          ),
          const SizedBox(height: 6),
          Text(
            'Hình ảnh đính kèm:',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 100,
            child: attachedImages.isNotEmpty
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: attachedImages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        showFullImage(
                          context,
                          Image.network(attachedImages[index]),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          attachedImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Text(
                    '*Không có hình ảnh đính kèm',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
          ),
          const SizedBox(height: 12),
          Divider(color: Theme.of(context).dividerColor, thickness: 1),
          const SizedBox(height: 8),
          _buildInfoRowUniversal(
            context,
            icon: Icons.info_outline,
            label: 'Trạng thái',
            value: teachingRequest.trangThai,
          ),
        ],
      ),
      const SizedBox(height: 100),
    ];
  }

  Widget _buildInfoRowUniversal(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    double iconSize = 18,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelMedium,
              children: [
                TextSpan(
                  text: '$label: ',
                  style:
                      labelStyle ??
                      const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value,
                  style: valueStyle ?? Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showFullImage(BuildContext context, Widget image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16),
        child: Stack(
          children: [
            InteractiveViewer(minScale: 1, maxScale: 4, child: image),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 5,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
