import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tlu_schedule_app/core/themes/theme_utils.dart';

class AdminHomeWebPage extends StatelessWidget {
  const AdminHomeWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SIDEBAR ---
          Container(
            width: 380,
            height: double.infinity,
            color: const Color(0xFF598CBF),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 150,
                    height: 140,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    'TLU\nHỆ THỐNG QUẢN LÝ LỊCH TRÌNH',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),

                // --- MENU ITEMS ---
                _buildMenuGroup([
                  '> Trang chủ',
                  '> Người dùng',
                  '> Danh mục khác',
                  '> Theo dõi dữ liệu',
                ]),

                const Spacer(),

                // --- LOGOUT BUTTON ---
                Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      'Đăng xuất',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // --- MAIN CONTENT AREA ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trang chủ',
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- LEFT CONTENT ---
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _sectionCard(
                                title: 'Chi tiết hệ thống',
                                children: [
                                  _infoRow(
                                    'Dung lượng lưu trữ:',
                                    '15GB / 30GB',
                                  ),
                                  _infoRow('Tốc độ xử lý trung bình:', '100ms'),
                                  _infoRow('Hiệu suất trung bình:', '98%'),
                                ],
                              ),
                              const SizedBox(height: 40),
                              _sectionCard(
                                title: 'Danh sách lỗi',
                                height: 350,
                                children: [
                                  Center(
                                    child: Text(
                                      'Không có lỗi nào được ghi nhận',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 40),

                        // --- RIGHT CONTENT: HOẠT ĐỘNG GẦN ĐÂY ---
                        Expanded(
                          flex: 3,
                          child: _sectionCard(
                            title: 'Hoạt động gần đây',
                            children: [
                              _activityCard(
                                '22:30 30/09/2025',
                                'Giảng viên A đã gửi yêu cầu nghỉ dạy',
                              ),
                              _activityCard(
                                '7:31 30/09/2025',
                                'Một lịch trình mới đã được tạo',
                              ),
                              _activityCard(
                                '7:30 30/09/2025',
                                'Phòng Đào tạo đã phê duyệt lịch dạy bù của Giảng viên B',
                              ),
                              _activityCard(
                                '7:30 30/09/2025',
                                '1 lớp học phần đã bị thay đổi lịch trình',
                              ),
                              _activityCard(
                                '7:05 30/09/2025',
                                'Giảng viên B đã gửi yêu cầu dạy bù',
                              ),
                              _activityCard(
                                '7:00 30/09/2025',
                                'Giảng viên B đã đăng nhập',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SIDEBAR MENU ITEM ---
  static Widget _menuItem(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // --- SECTION CARD ---
  static Widget _sectionCard({
    required String title,
    double? height,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFC3D9E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  // --- INFO ROW (Chi tiết hệ thống) ---
  static Widget _infoRow(String left, String right) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: GoogleFonts.inter(fontSize: 18, color: Colors.black),
          ),
          Text(
            right,
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // --- ACTIVITY CARD ---
  static Widget _activityCard(String time, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$time\n$content',
        style: GoogleFonts.inter(fontSize: 18, color: Colors.black87),
      ),
    );
  }

  static Widget _buildMenuGroup(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (label) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
