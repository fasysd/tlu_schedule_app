import 'package:flutter/material.dart';

class TaoHocPhanPage extends StatefulWidget {
  const TaoHocPhanPage({super.key});

  @override
  State<TaoHocPhanPage> createState() => _TaoHocPhanPageState();
}

class _TaoHocPhanPageState extends State<TaoHocPhanPage> {
  final _formKey = GlobalKey<FormState>();
  final _maHocPhanController = TextEditingController();
  final _tenHocPhanController = TextEditingController();
  final _maLopHocPhanController = TextEditingController();
  final _soTinChiController = TextEditingController();
  final _soSinhVienController = TextEditingController();
  final _phongHocController = TextEditingController();
  final _gioBatDauController = TextEditingController();
  final _gioKetThucController = TextEditingController();

  String _selectedHocKy = 'HK1';
  String _selectedNamHoc = '2024-2025';
  String _selectedMaGiangVien = '';
  String _selectedBoMon = 'Khoa CNTT';
  String _selectedThoiGianHoc = 'Thứ 2';
  DateTime _ngayBatDau = DateTime.now();
  DateTime _ngayKetThuc = DateTime.now().add(const Duration(days: 120));

  final List<String> _hocKyList = ['HK1', 'HK2', 'HK3'];
  final List<String> _namHocList = ['2023-2024', '2024-2025', '2025-2026'];
  final List<String> _boMonList = [
    'Khoa CNTT',
    'Khoa Điện',
    'Khoa Cơ khí',
    'Khoa Xây dựng',
    'Khoa Kinh tế',
  ];
  final List<String> _thoiGianHocList = [
    'Thứ 2',
    'Thứ 3',
    'Thứ 4',
    'Thứ 5',
    'Thứ 6',
    'Thứ 2, 4',
    'Thứ 3, 5',
    'Thứ 4, 6',
  ];

  @override
  void dispose() {
    _maHocPhanController.dispose();
    _tenHocPhanController.dispose();
    _maLopHocPhanController.dispose();
    _soTinChiController.dispose();
    _soSinhVienController.dispose();
    _phongHocController.dispose();
    _gioBatDauController.dispose();
    _gioKetThucController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _ngayBatDau : _ngayKetThuc,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _ngayBatDau = picked;
        } else {
          _ngayKetThuc = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement create course logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tạo học phần thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: true,
                expandedHeight: 80,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(195, 217, 233, 1),
                              padding: const EdgeInsets.all(10),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Image.asset('assets/images/icons/back_icon.png'),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Tạo học phần mới',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: _submitForm,
                    child: Text(
                      'Lưu',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ];
          },
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin cơ bản
                  _buildSectionTitle('Thông tin cơ bản'),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _maHocPhanController,
                    label: 'Mã học phần',
                    hint: 'VD: IT3012',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mã học phần';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _tenHocPhanController,
                    label: 'Tên học phần',
                    hint: 'VD: Cấu trúc dữ liệu và giải thuật',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên học phần';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _maLopHocPhanController,
                    label: 'Mã lớp học phần',
                    hint: 'VD: IT3012-02',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mã lớp học phần';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Học kỳ',
                          value: _selectedHocKy,
                          items: _hocKyList,
                          onChanged: (value) {
                            setState(() {
                              _selectedHocKy = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Năm học',
                          value: _selectedNamHoc,
                          items: _namHocList,
                          onChanged: (value) {
                            setState(() {
                              _selectedNamHoc = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  // Thông tin giảng dạy
                  _buildSectionTitle('Thông tin giảng dạy'),
                  const SizedBox(height: 15),
                  _buildDropdownField(
                    label: 'Bộ môn',
                    value: _selectedBoMon,
                    items: _boMonList,
                    onChanged: (value) {
                      setState(() {
                        _selectedBoMon = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _soTinChiController,
                          label: 'Số tín chỉ',
                          hint: '3',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập số tín chỉ';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Số tín chỉ phải là số';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTextField(
                          controller: _soSinhVienController,
                          label: 'Số sinh viên',
                          hint: '40',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập số sinh viên';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Số sinh viên phải là số';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  // Lịch học
                  _buildSectionTitle('Lịch học'),
                  const SizedBox(height: 15),
                  _buildDropdownField(
                    label: 'Thời gian học',
                    value: _selectedThoiGianHoc,
                    items: _thoiGianHocList,
                    onChanged: (value) {
                      setState(() {
                        _selectedThoiGianHoc = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _gioBatDauController,
                          label: 'Giờ bắt đầu',
                          hint: '09:00',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập giờ bắt đầu';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTextField(
                          controller: _gioKetThucController,
                          label: 'Giờ kết thúc',
                          hint: '11:45',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập giờ kết thúc';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _phongHocController,
                    label: 'Phòng học',
                    hint: 'P.301',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập phòng học';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          label: 'Ngày bắt đầu',
                          date: _ngayBatDau,
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildDateField(
                          label: 'Ngày kết thúc',
                          date: _ngayKetThuc,
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color.fromRGBO(76, 126, 170, 1),
                            side: const BorderSide(color: Color.fromRGBO(76, 126, 170, 1)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text('Hủy'),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(76, 126, 170, 1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text('Tạo học phần'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: const Color.fromRGBO(76, 126, 170, 1),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(76, 126, 170, 1)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(76, 126, 170, 1)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
