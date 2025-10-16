import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/presentation/widgets/box_avatar.dart';

class CardLecturer extends StatelessWidget {
  final LecturerModel lecturerModel;
  final VoidCallback? onPressed;
  const CardLecturer({
    super.key,
    required this.lecturerModel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: const BoxDecoration(
          border: Border(
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
              child: BoxAvatar(pathAvatar: lecturerModel.duongDanAvatar),
            ),
            const SizedBox(width: 9),
            Column(
              spacing: 0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 27,
                  child: Text(
                    'Tài khoản: ${lecturerModel.tenTaiKhoan}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis, // 👈 tránh text tràn
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
                    'Số đơn cần duyệt: ${lecturerModel.soDonCanDuyet}',
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
