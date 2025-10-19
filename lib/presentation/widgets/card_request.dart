import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/data/models/teaching_request_model.dart';

class CardRequest extends StatelessWidget {
  final TeachingRequestModel teachingRequest;
  final VoidCallback? onPressed;

  const CardRequest({
    super.key,
    required this.teachingRequest,
    required this.onPressed,
  });

  Color _statusColor(BuildContext context) {
    switch (teachingRequest.trangThai) {
      case 'Đã duyệt':
        return Colors.green;
      case 'Từ chối':
        return Colors.redAccent;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: const Color.fromRGBO(89, 141, 192, 1),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon minh họa loại đơn
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                teachingRequest.loaiDon == 'Đơn xin nghỉ dạy'
                    ? Icons.event_busy
                    : Icons.event_available,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),

            // Nội dung chính
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teachingRequest.tenHocPhan ?? 'Tên học phần không xác định',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Người gửi: ${teachingRequest.tenGiangVien} (${teachingRequest.maGiangVien})',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Loại đơn: ${teachingRequest.loaiDon}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Ngày gửi: ${DateFormat('dd/MM/yyyy').format(teachingRequest.ngayGui)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Trạng thái:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(context).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          teachingRequest.trangThai,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: _statusColor(context)),
                        ),
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
