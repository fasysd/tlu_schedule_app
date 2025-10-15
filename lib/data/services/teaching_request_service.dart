import 'dart:math';
import '../models/teaching_request_model.dart';

class TeachingRequestService {
  /// Mô phỏng fetch API từ Firebase (nhưng không gọi thật)
  Future<Map<String, dynamic>> fetchTeachingRequests() async {
    // Giả lập độ trễ mạng (1–2 giây)
    await Future.delayed(Duration(milliseconds: 1000 + _random.nextInt(1000)));

    // Giả lập xác suất lỗi 10%
    final isError = _random.nextInt(10) == 0;

    if (isError) {
      // ❌ Giả lập lỗi server Firebase
      return {
        'statusCode': 500,
        'message': 'Internal Server Error (Firebase Simulation)',
        'data': null,
      };
    }

    // ✅ Nếu không lỗi → trả về danh sách request mẫu
    final List<TeachingRequestModel> list = List.generate(10, (i) {
      final loaiDon = _random.nextBool()
          ? 'Đơn xin nghỉ dạy'
          : 'Đơn xin dạy bù';

      return TeachingRequestModel(
        maDon: 'DON${i.toString().padLeft(3, '0')}',
        maLopHocPhan: 'CT${_random.nextInt(20).toString().padLeft(2, '0')}',
        maGiangVien: 'GV${_random.nextInt(999).toString().padLeft(3, '0')}',
        trangThai: _convertTrangThai(_random.nextInt(3)),
        loaiDon: loaiDon,
        soPhong: 'A${_random.nextInt(5) + 1}0${_random.nextInt(9)}',
        ngayDay: DateTime(2025, 10, _random.nextInt(28) + 1),
        caDay: _generateCaDay(),
        lyDo: loaiDon == 'Đơn xin nghỉ dạy' ? _generateLyDo() : null,
        anhMinhChung: loaiDon == 'Đơn xin nghỉ dạy'
            ? 'https://fakeurl.com/proof_$i.jpg'
            : null,
      );
    });

    return {'statusCode': 200, 'message': 'Success', 'data': list};
  }

  final Random _random = Random();

  String _convertTrangThai(int value) {
    switch (value) {
      case 1:
        return 'Đã xác nhận';
      case 2:
        return 'Đã từ chối';
      default:
        return 'Chưa xác nhận';
    }
  }

  String _generateCaDay() {
    final ca = _random.nextInt(3) + 1;
    switch (ca) {
      case 1:
        return 'Ca 1 (7h00 - 9h45)';
      case 2:
        return 'Ca 2 (9h55 - 12h30)';
      default:
        return 'Ca 3 (13h30 - 16h00)';
    }
  }

  String _generateLyDo() {
    final lyDoList = [
      'Bận việc gia đình',
      'Ốm đột xuất',
      'Tham gia hội nghị',
      'Có công tác đột xuất',
      'Lý do cá nhân',
    ];
    return lyDoList[_random.nextInt(lyDoList.length)];
  }
}
