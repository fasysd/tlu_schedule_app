import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/presentation/widgets/box_avatar.dart';

class CardLecturer extends StatelessWidget {
  final LecturerModel lecturerModel;
  final VoidCallback? onPressed;
  final bool selected;

  const CardLecturer({
    super.key,
    required this.lecturerModel,
    this.onPressed,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(width: selected ? 1.5 : 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                BoxAvatar(pathAvatar: lecturerModel.duongDanAvatar, size: 90),
                if (selected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecturerModel.hoVaTen,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Mã: ${lecturerModel.maGiangVien}',
                    style: theme.textTheme.labelMedium,
                  ),
                  Text(
                    'Học phần đang dạy: ${lecturerModel.soHocPhanDangDay}',
                    style: theme.textTheme.labelMedium,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 16,
                        color: Colors.blueGrey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Đơn cần duyệt: ${lecturerModel.soDonNghiDayCanDuyet + lecturerModel.soDonDayBuCanDuyet}',
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
