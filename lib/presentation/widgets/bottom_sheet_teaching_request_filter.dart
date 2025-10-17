import 'package:flutter/material.dart';

class BottomSheetTeachingResuestFilter extends StatelessWidget {
  const BottomSheetTeachingResuestFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Popup từ dưới lên', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text('Bạn có thể thêm các nút hoặc danh sách ở đây.'),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
