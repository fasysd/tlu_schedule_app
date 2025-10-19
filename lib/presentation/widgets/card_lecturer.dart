import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/presentation/widgets/box_avatar.dart';

class CardLecturer extends StatelessWidget {
  final LecturerModel lecturerModel;
  final VoidCallback? onPressed;
  final bool selected; // bắt buộc, default false nếu muốn

  const CardLecturer({
    super.key,
    required this.lecturerModel,
    required this.onPressed,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          border: const Border(
            bottom: BorderSide(
              width: 2,
              color: Color.fromRGBO(89, 141, 192, 1),
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              child: Stack(
                children: [
                  BoxAvatar(pathAvatar: lecturerModel.duongDanAvatar),
                  if (selected)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 9),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 27,
                  child: Text(
                    'Mã giảng viên: ${lecturerModel.maGiangVien}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Text(
                    'Tên: ${lecturerModel.hoVaTen}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Text(
                    'Học phần đang dạy: ${lecturerModel.soHocPhanDangDay}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(
                  height: 27,
                  child: Text(
                    'Số đơn cần duyệt: ${lecturerModel.soDonDayBuCanDuyet + lecturerModel.soDonNghiDayCanDuyet}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
