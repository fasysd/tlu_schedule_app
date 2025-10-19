import 'package:flutter/material.dart';
import '../../data/models/payment_report_model.dart';

class CardPaymentReport extends StatelessWidget {
  final PaymentReportModel paymentReport;

  const CardPaymentReport({
    super.key,
    required this.paymentReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với thông tin giảng viên
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue[100],
                child: Icon(
                  Icons.person,
                  color: Colors.blue[700],
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentReport.hoVaTen,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      paymentReport.maGiangVien,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Text(
                      paymentReport.boMon,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 15),

          // Thống kê giờ giảng
          Text(
            'Thống kê giờ giảng',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Giờ chuẩn',
                  '${paymentReport.gioGiangChuanDinh.toStringAsFixed(1)}h',
                  Icons.schedule,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Giờ vượt chuẩn',
                  '${paymentReport.gioGiangVuotChuanDinh.toStringAsFixed(1)}h',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Tổng giờ',
                  '${paymentReport.tongGioGiang.toStringAsFixed(1)}h',
                  Icons.timer,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Tỷ lệ dạy bù',
                  '${(paymentReport.tiLeDayBu * 100).toStringAsFixed(1)}%',
                  Icons.update,
                  Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 15),

          // Thông tin thanh toán
          Text(
            'Thông tin thanh toán',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 15),

          _buildPaymentRow(
            context,
            'Tiền giờ chuẩn',
            paymentReport.tienGioChuan,
          ),
          const SizedBox(height: 10),
          _buildPaymentRow(
            context,
            'Tiền giờ vượt chuẩn',
            paymentReport.tienGioVuotChuan,
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng tiền thanh toán',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${paymentReport.tongTienThanhToan.toStringAsFixed(0)} VNĐ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 2),
          const SizedBox(height: 15),

          // Chi tiết học phần
          Text(
            'Chi tiết học phần',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 15),

          if (paymentReport.danhSachHocPhan != null)
            ...paymentReport.danhSachHocPhan!.map((hocPhan) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            hocPhan.tenHocPhan,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Text(
                          '${hocPhan.tienThanhToan.toStringAsFixed(0)} VNĐ',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${hocPhan.maHocPhan} - ${hocPhan.maLopHocPhan}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Đã dạy: ${hocPhan.soTietDaDay}/${hocPhan.tongSoTiet} tiết',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Text(
                          '${(hocPhan.tiLeHoanThanh * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),

          // Cảnh báo nếu có
          if (paymentReport.canhBaoTiLeDayBu)
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tỷ lệ dạy bù thấp (${(paymentReport.tiLeDayBu * 100).toStringAsFixed(1)}%)',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.orange[900],
                          ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color color;
    IconData icon;
    
    switch (paymentReport.trangThaiThanhToan) {
      case 'Đã thanh toán':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Đang xử lý':
        color = Colors.orange;
        icon = Icons.hourglass_empty;
        break;
      default:
        color = Colors.red;
        icon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            paymentReport.trangThaiThanhToan,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(77), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 5),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 12,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(
    BuildContext context,
    String label,
    double value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Text(
          '${value.toStringAsFixed(0)} VNĐ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

