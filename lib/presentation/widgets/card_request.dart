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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.only(left: 8),
        width: double.infinity,
        height: 130,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: Color.fromRGBO(89, 141, 192, 1),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phát triển ứng dụng di động',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Loại: ' + teachingRequest.loaiDon,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Ngày: ' +
                  DateFormat('dd/MM/yyyy').format(teachingRequest.ngayDay),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Trạng thái: ' + teachingRequest.trangThai,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
