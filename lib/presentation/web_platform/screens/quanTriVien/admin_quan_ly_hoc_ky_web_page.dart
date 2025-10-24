import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlu_schedule_app/core/themes/theme_utils.dart';
import 'package:tlu_schedule_app/data/sub/models/giai_doan_model.dart';
import 'package:tlu_schedule_app/data/sub/models/hoc_ky_model.dart';
import 'package:tlu_schedule_app/data/sub/services/giai_doan_service.dart';
import 'package:tlu_schedule_app/data/sub/services/hoc_ky_service.dart';

class AdminQuanLyHocKyWebPage extends StatefulWidget {
  const AdminQuanLyHocKyWebPage({super.key});

  @override
  State<AdminQuanLyHocKyWebPage> createState() =>
      _AdminQuanLyHocKyWebPageState();
}

class _AdminQuanLyHocKyWebPageState extends State<AdminQuanLyHocKyWebPage> {
  final TextEditingController _searchController = TextEditingController();
  // Khởi tạo service
  final HocKyService _hocKyService = HocKyService();
  List<HocKyModel> _dsHocKy = [];
  final GiaiDoanService _giaiDoanService = GiaiDoanService();

  @override
  void initState() {
    super.initState();
    _loadSemesters();
  }

  // Hàm load dữ liệu từ service (đồng bộ)
  void _loadSemesters() {
    setState(() {
      _dsHocKy = _hocKyService.getAll();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Hàm hiển thị SnackBar tiện ích
  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme();
    final accent = context.appColor('xanhDuongNhat') ?? const Color(0xFFC3D9E9);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.9), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildSearchField(context)),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _openAddOrEditDialog(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Thêm học kỳ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      context.appColor('xanhDuong') ?? const Color(0xFF598DC0),
                  foregroundColor: context.appColor('trang') ?? Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildSemesterTable(context, textTheme)),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final accent = context.appColor('xanhDuongNhat') ?? const Color(0xFFC3D9E9);
    final primary = context.appColor('xanhDuong') ?? const Color(0xFF598DC0);

    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade700),
        hintText: 'Tìm kiếm theo tên học kỳ',
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accent.withOpacity(0.9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              )
            : null,
      ),
    );
  }

  Widget _buildSemesterTable(BuildContext context, TextTheme textTheme) {
    final String query = _searchController.text.trim().toLowerCase();
    final List<HocKyModel> filtered = _dsHocKy.where((s) {
      // Mở rộng tìm kiếm cho cả mã học kỳ
      return s.tenHocKy.toLowerCase().contains(query) ||
          s.id.toLowerCase().contains(query);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, size: 48, color: Colors.grey.shade500),
            const SizedBox(height: 8),
            Text(
              'Không có học kỳ nào',
              style: textTheme.labelLarge?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              'Hãy thêm học kỳ mới để bắt đầu quản lý',
              style: textTheme.labelMedium?.copyWith(color: Colors.black45),
            ),
          ],
        ),
      );
    }

    final headerBg =
        (context.appColor('xanhDuongNhat') ?? const Color(0xFFC3D9E9))
            .withOpacity(0.4);

    final dateFormat = DateFormat('dd/MM/yyyy');

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: SizedBox(
              width: constraints.maxWidth,
              child: DataTableTheme(
                data: DataTableThemeData(
                  headingRowColor: MaterialStatePropertyAll(headerBg),
                  headingTextStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  dataTextStyle: textTheme.labelMedium,
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 60,
                  dividerThickness: 0.8,
                ),
                child: DataTable(
                  columnSpacing: 28,
                  horizontalMargin: 16,
                  columns: const [
                    DataColumn(label: Text('STT')),
                    DataColumn(label: Text('Mã học kỳ')), // <-- CỘT MỚI
                    DataColumn(label: Text('Tên học kỳ')),
                    DataColumn(label: Text('Thời gian bắt đầu')),
                    DataColumn(label: Text('Thời gian kết thúc')),
                    DataColumn(label: Text('')), // Cột cho nút menu
                  ],
                  rows: List.generate(filtered.length, (index) {
                    final semester = filtered[index];
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text(semester.id)), // <-- DỮ LIỆU CỘT MỚI
                        DataCell(Text(semester.tenHocKy)),
                        DataCell(Text(dateFormat.format(semester.batDau))),
                        DataCell(Text(dateFormat.format(semester.ketThuc))),
                        DataCell(_buildActionsMenu(context, semester)),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionsMenu(BuildContext context, HocKyModel semester) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'view':
            _showSemesterInfoDialog(context, semester);
            break;
          case 'edit':
            _openAddOrEditDialog(context, hocKy: semester);
            break;
          case 'delete':
            _confirmDeleteSemester(context, semester);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text('Xem thông tin'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: Colors.green),
              SizedBox(width: 8),
              Text('Sửa thông tin'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Xóa học kỳ'),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.more_horiz_rounded),
    );
  }

  // Thay thế hoàn toàn hàm cũ bằng hàm này
  void _showSemesterInfoDialog(BuildContext context, HocKyModel semester) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final textTheme = Theme.of(context).textTheme;
    final headerBg =
        (context.appColor('xanhDuongNhat') ?? const Color(0xFFC3D9E9))
            .withOpacity(0.4);

    // Sử dụng StatefulBuilder để dialog có thể tự cập nhật trạng thái
    showDialog(
      context: context,
      builder: (_) {
        // Dùng ValueNotifier để quản lý danh sách giai đoạn và cập nhật UI
        final dsGiaiDoanNotifier = ValueNotifier<List<GiaiDoanModel>>(
          _giaiDoanService.getAllByHocKy(semester.id),
        );

        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: const Text('Thông tin chi tiết học kỳ'),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... (Phần thông tin học kỳ cơ bản giữ nguyên)
                  Text.rich(
                    TextSpan(
                      style: textTheme.bodyLarge,
                      children: [
                        const TextSpan(
                          text: 'Mã học kỳ: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: semester.id),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      style: textTheme.bodyLarge,
                      children: [
                        const TextSpan(
                          text: 'Tên học kỳ: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: semester.tenHocKy),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      style: textTheme.bodyLarge,
                      children: [
                        const TextSpan(
                          text: 'Thời gian: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '${dateFormat.format(semester.batDau)} - ${dateFormat.format(semester.ketThuc)}',
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 32, thickness: 1),

                  // --- PHẦN NÂNG CẤP ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Danh sách giai đoạn',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Nút "Thêm giai đoạn"
                      TextButton.icon(
                        onPressed: () {
                          // Gọi dialog thêm/sửa và cập nhật lại list khi thành công
                          _openAddOrEditGiaiDoanDialog(
                            context,
                            idHocKy: semester.id,
                            onSuccess: () {
                              dsGiaiDoanNotifier.value = _giaiDoanService
                                  .getAllByHocKy(semester.id);
                            },
                          );
                        },
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Thêm giai đoạn'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Sử dụng ValueListenableBuilder để lắng nghe thay đổi và rebuild bảng
                  ValueListenableBuilder<List<GiaiDoanModel>>(
                    valueListenable: dsGiaiDoanNotifier,
                    builder: (context, dsGiaiDoan, child) {
                      if (dsGiaiDoan.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(
                            child: Text(
                              'Học kỳ này chưa có giai đoạn nào.',
                              style: textTheme.labelMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        );
                      }
                      // Bảng Giai Đoạn
                      return SizedBox(
                        width: double.infinity,
                        child: DataTableTheme(
                          data: DataTableThemeData(
                            headingRowColor: MaterialStatePropertyAll(headerBg),
                            headingTextStyle: textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            dataTextStyle: textTheme.labelMedium,
                            dataRowMinHeight: 48,
                            dividerThickness: 0.8,
                          ),
                          child: DataTable(
                            columnSpacing: 24,
                            horizontalMargin: 12,
                            columns: const [
                              DataColumn(label: Text('STT')),
                              DataColumn(label: Text('Mã giai đoạn')),
                              DataColumn(label: Text('Tên giai đoạn')),
                              DataColumn(label: Text('Thời gian bắt đầu')),
                              DataColumn(label: Text('Thời gian kết thúc')),
                              DataColumn(label: Text('')),
                            ],
                            rows: List.generate(dsGiaiDoan.length, (index) {
                              final giaiDoan = dsGiaiDoan[index];
                              return DataRow(
                                cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(giaiDoan.id)),
                                  DataCell(Text(giaiDoan.tenGiaiDoan)),
                                  DataCell(
                                    Text(dateFormat.format(giaiDoan.batDau)),
                                  ),
                                  DataCell(
                                    Text(dateFormat.format(giaiDoan.ketThuc)),
                                  ),
                                  DataCell(
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          // Mở dialog sửa
                                          _openAddOrEditGiaiDoanDialog(
                                            context,
                                            idHocKy: semester.id,
                                            giaiDoan: giaiDoan,
                                            onSuccess: () {
                                              dsGiaiDoanNotifier
                                                  .value = _giaiDoanService
                                                  .getAllByHocKy(semester.id);
                                            },
                                          );
                                        } else if (value == 'delete') {
                                          // Hiển thị xác nhận xóa
                                          _confirmDeleteGiaiDoan(
                                            context,
                                            giaiDoan,
                                            onSuccess: () {
                                              dsGiaiDoanNotifier
                                                  .value = _giaiDoanService
                                                  .getAllByHocKy(semester.id);
                                            },
                                          );
                                        }
                                      },
                                      itemBuilder: (ctx) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, size: 18),
                                              SizedBox(width: 8),
                                              Text('Sửa'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 8),
                                              Text('Xóa'),
                                            ],
                                          ),
                                        ),
                                      ],
                                      icon: const Icon(
                                        Icons.more_horiz_rounded,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  // Thêm hàm mới này vào class _AdminQuanLyHocKyWebPageState
  Future<void> _openAddOrEditGiaiDoanDialog(
    BuildContext pageContext, {
    required String idHocKy,
    GiaiDoanModel? giaiDoan,
    required VoidCallback onSuccess,
  }) async {
    final formKey = GlobalKey<FormState>();
    final isEditing = giaiDoan != null;

    final idController = TextEditingController(text: giaiDoan?.id);
    final tenController = TextEditingController(text: giaiDoan?.tenGiaiDoan);

    final dateFormat = DateFormat('dd/MM/yyyy');
    final batDauController = TextEditingController(
      text: isEditing ? dateFormat.format(giaiDoan.batDau) : '',
    );
    final ketThucController = TextEditingController(
      text: isEditing ? dateFormat.format(giaiDoan.ketThuc) : '',
    );

    DateTime? selectedStartDate = giaiDoan?.batDau;
    DateTime? selectedEndDate = giaiDoan?.ketThuc;

    Future<void> pickDate(
      BuildContext context,
      TextEditingController controller,
      Function(DateTime) onDateSelected, {
      DateTime? initialDate,
    }) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        onDateSelected(picked);
        controller.text = dateFormat.format(picked);
      }
    }

    await showDialog(
      context: pageContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Sửa giai đoạn' : 'Thêm giai đoạn'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isEditing) ...[
                      TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(
                          labelText: 'Mã giai đoạn (ID)',
                        ),
                        validator: (v) =>
                            (v ?? '').isEmpty ? 'Vui lòng nhập ID' : null,
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: tenController,
                      decoration: const InputDecoration(
                        labelText: 'Tên giai đoạn',
                      ),
                      validator: (v) =>
                          (v ?? '').isEmpty ? 'Vui lòng nhập tên' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: batDauController,
                      decoration: const InputDecoration(
                        labelText: 'Ngày bắt đầu',
                      ),
                      readOnly: true,
                      onTap: () => pickDate(
                        dialogContext,
                        batDauController,
                        (date) => selectedStartDate = date,
                        initialDate: selectedStartDate,
                      ),
                      validator: (v) => (v ?? '').isEmpty
                          ? 'Vui lòng chọn ngày bắt đầu'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: ketThucController,
                      decoration: const InputDecoration(
                        labelText: 'Ngày kết thúc',
                      ),
                      readOnly: true,
                      onTap: () => pickDate(
                        dialogContext,
                        ketThucController,
                        (date) => selectedEndDate = date,
                        initialDate: selectedEndDate,
                      ),
                      validator: (v) => (v ?? '').isEmpty
                          ? 'Vui lòng chọn ngày kết thúc'
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (selectedStartDate == null || selectedEndDate == null) {
                    _showSnackbar('Vui lòng chọn đầy đủ ngày.', isError: true);
                    return;
                  }
                  if (selectedStartDate!.isAfter(selectedEndDate!)) {
                    _showSnackbar(
                      'Ngày kết thúc phải sau ngày bắt đầu.',
                      isError: true,
                    );
                    return;
                  }

                  try {
                    if (isEditing) {
                      final updated = giaiDoan.copyWith(
                        tenGiaiDoan: tenController.text,
                        batDau: selectedStartDate,
                        ketThuc: selectedEndDate,
                      );
                      _giaiDoanService.update(giaiDoan.id, updated);
                      _showSnackbar('Cập nhật giai đoạn thành công!');
                    } else {
                      final newGiaiDoan = GiaiDoanModel(
                        id: idController.text,
                        idHocKy: idHocKy,
                        tenGiaiDoan: tenController.text,
                        batDau: selectedStartDate!,
                        ketThuc: selectedEndDate!,
                      );
                      _giaiDoanService.add(newGiaiDoan);
                      _showSnackbar('Thêm giai đoạn thành công!');
                    }
                    Navigator.pop(dialogContext);
                    onSuccess(); // Gọi callback để cập nhật UI
                  } catch (e) {
                    _showSnackbar(e.toString(), isError: true);
                  }
                }
              },
              child: Text(isEditing ? 'Lưu' : 'Thêm'),
            ),
          ],
        );
      },
    );
  }

  // Thêm hàm mới này vào class _AdminQuanLyHocKyWebPageState
  void _confirmDeleteGiaiDoan(
    BuildContext context,
    GiaiDoanModel giaiDoan, {
    required VoidCallback onSuccess,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc muốn xóa giai đoạn "${giaiDoan.tenGiaiDoan}" không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        _giaiDoanService.delete(giaiDoan.id);
        _showSnackbar('Xóa giai đoạn thành công!');
        onSuccess(); // Gọi callback để cập nhật UI
      } catch (e) {
        _showSnackbar(e.toString(), isError: true);
      }
    }
  }

  void _confirmDeleteSemester(BuildContext context, HocKyModel semester) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${semester.tenHocKy}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        _hocKyService.delete(semester.id);
        _showSnackbar('Xóa học kỳ thành công!');
        _loadSemesters(); // Tải lại danh sách
      } catch (e) {
        _showSnackbar('Lỗi: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _openAddOrEditDialog(
    BuildContext pageContext, {
    HocKyModel? hocKy,
  }) async {
    final formKey = GlobalKey<FormState>();
    final isEditing = hocKy != null;

    final tenHocKyController = TextEditingController(text: hocKy?.tenHocKy);
    final idController = TextEditingController(text: hocKy?.id);
    final dateFormat = DateFormat('dd/MM/yyyy');
    final batDauController = TextEditingController(
      text: hocKy != null ? dateFormat.format(hocKy.batDau) : '',
    );
    final ketThucController = TextEditingController(
      text: hocKy != null ? dateFormat.format(hocKy.ketThuc) : '',
    );

    DateTime? selectedStartDate = hocKy?.batDau;
    DateTime? selectedEndDate = hocKy?.ketThuc;

    Future<void> pickDate(
      BuildContext context,
      TextEditingController controller,
      Function(DateTime) onDateSelected, {
      DateTime? initialDate,
    }) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        onDateSelected(picked);
        controller.text = dateFormat.format(picked);
      }
    }

    await showDialog(
      context: pageContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Sửa học kỳ' : 'Thêm học kỳ'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isEditing) ...[
                    TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'Mã học kỳ (ID)',
                      ),
                      validator: (v) =>
                          (v ?? '').isEmpty ? 'Vui lòng nhập ID' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: tenHocKyController,
                    decoration: const InputDecoration(labelText: 'Tên học kỳ'),
                    validator: (v) =>
                        (v ?? '').isEmpty ? 'Vui lòng nhập tên học kỳ' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: batDauController,
                    decoration: const InputDecoration(
                      labelText: 'Ngày bắt đầu',
                      hintText: 'dd/MM/yyyy',
                    ),
                    readOnly: true,
                    onTap: () => pickDate(
                      dialogContext,
                      batDauController,
                      (date) => selectedStartDate = date,
                      initialDate: selectedStartDate,
                    ),
                    validator: (v) =>
                        (v ?? '').isEmpty ? 'Vui lòng chọn ngày bắt đầu' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: ketThucController,
                    decoration: const InputDecoration(
                      labelText: 'Ngày kết thúc',
                      hintText: 'dd/MM/yyyy',
                    ),
                    readOnly: true,
                    onTap: () => pickDate(
                      dialogContext,
                      ketThucController,
                      (date) => selectedEndDate = date,
                      initialDate: selectedEndDate,
                    ),
                    validator: (v) => (v ?? '').isEmpty
                        ? 'Vui lòng chọn ngày kết thúc'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (selectedStartDate == null || selectedEndDate == null) {
                    _showSnackbar('Vui lòng chọn đầy đủ ngày.', isError: true);
                    return;
                  }
                  if (selectedStartDate!.isAfter(selectedEndDate!)) {
                    _showSnackbar(
                      'Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.',
                      isError: true,
                    );
                    return;
                  }

                  try {
                    if (isEditing) {
                      final updatedHocKy = hocKy!.copyWith(
                        tenHocKy: tenHocKyController.text,
                        batDau: selectedStartDate,
                        ketThuc: selectedEndDate,
                      );
                      _hocKyService.update(hocKy.id, updatedHocKy);
                      _showSnackbar('Cập nhật học kỳ thành công!');
                    } else {
                      final newHocKy = HocKyModel(
                        id: idController.text,
                        tenHocKy: tenHocKyController.text,
                        batDau: selectedStartDate!,
                        ketThuc: selectedEndDate!,
                      );
                      _hocKyService.add(newHocKy);
                      _showSnackbar('Thêm học kỳ thành công!');
                    }
                    Navigator.pop(dialogContext);
                    _loadSemesters(); // Tải lại danh sách
                  } catch (e) {
                    _showSnackbar('Lỗi: ${e.toString()}', isError: true);
                  }
                }
              },
              child: Text(isEditing ? 'Lưu thay đổi' : 'Thêm mới'),
            ),
          ],
        );
      },
    );
  }
}
