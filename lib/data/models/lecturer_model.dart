class LecturerModel {
  final String id;
  final String tenTaiKhoan;
  final String hoVaTen;
  final DateTime ngaySinh;
  final String email;
  final String soDienThoai;
  final int soHocPhanDangDay;
  final int soDonCanDuyet;
  final String duongDanAvatar;

  LecturerModel({
    required this.id,
    required this.tenTaiKhoan,
    required this.hoVaTen,
    required this.ngaySinh,
    required this.email,
    required this.soDienThoai,
    required this.soHocPhanDangDay,
    required this.soDonCanDuyet,
    this.duongDanAvatar = 'assets/images/defaultAvatar.png',
  });
}
