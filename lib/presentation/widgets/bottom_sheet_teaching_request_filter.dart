import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/teaching_request_filter_model.dart';
import 'package:tlu_schedule_app/data/models/course_model.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/presentation/screens/ds_lua_chon_giang_vien_page.dart';

class BottomSheetTeachingRequestFilter extends StatefulWidget {
  final TeachingRequestFilterModel? initialFilter;

  const BottomSheetTeachingRequestFilter({super.key, this.initialFilter});

  @override
  State<BottomSheetTeachingRequestFilter> createState() =>
      _BottomSheetTeachingRequestFilterState();
}

class _BottomSheetTeachingRequestFilterState
    extends State<BottomSheetTeachingRequestFilter> {
  late TeachingRequestFilterModel filter;

  @override
  void initState() {
    super.initState();
    filter =
        widget.initialFilter?.copyWith() ??
        TeachingRequestFilterModel.defaultFilter();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tiêu đề
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Text(
              'Lọc',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
          ),

          // Giảng viên
          _buildLecturerSection(context),

          // Loại đơn
          _buildLoaiDonSection(context),

          // Trạng thái
          _buildTrangThaiSection(context),

          // Học phần
          _buildCourseSection(context),

          // Nút hành động
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Thoát'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(filter),
                child: const Text('Xác nhận'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // Phần giảng viên
  Widget _buildLecturerSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Giảng viên', style: Theme.of(context).textTheme.bodyLarge),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  final selectedLecturers = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DsLuaChonGiangVienPage(
                        selectedLecturers: filter.lecturers,
                      ),
                    ),
                  );
                  if (selectedLecturers != null &&
                      selectedLecturers.isNotEmpty) {
                    setState(() {
                      filter = filter.copyWith(
                        lecturers: List<LecturerModel>.from(selectedLecturers),
                      );
                    });
                  }
                },
                icon: const Icon(Icons.add, color: Colors.blue, size: 28),
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: filter.lecturers.isEmpty
                ? const Center(
                    child: Text(
                      'Không có giảng viên được chọn',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filter.lecturers.length,
                    itemBuilder: (context, index) {
                      final lecturer = filter.lecturers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${lecturer.tenTaiKhoan} - ${lecturer.hoVaTen}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _showDialogDeleteLecturer(context, () {
                                    setState(() {
                                      filter.lecturers.removeAt(index);
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // Phần loại đơn
  Widget _buildLoaiDonSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Loại đơn', style: Theme.of(context).textTheme.bodyLarge),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: filter.includeDonXinNghi,
                      onChanged: (value) => setState(() {
                        filter = filter.copyWith(includeDonXinNghi: value!);
                      }),
                    ),
                    const Text('Đơn xin nghỉ'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: filter.includeDonDayBu,
                      onChanged: (value) => setState(() {
                        filter = filter.copyWith(includeDonDayBu: value!);
                      }),
                    ),
                    const Text('Đơn dạy bù'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // Phần trạng thái
  Widget _buildTrangThaiSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trạng thái', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 10),
          Wrap(
            runSpacing: 5,
            children: [
              _buildStatusCheckbox(
                'Xác nhận',
                filter.includeDaXacNhan,
                (v) => setState(() {
                  filter = filter.copyWith(includeDaXacNhan: v);
                }),
              ),
              _buildStatusCheckbox('Từ chối', filter.includeTuChoi, (v) {
                setState(() {
                  filter = filter.copyWith(includeTuChoi: v);
                });
              }),
              _buildStatusCheckbox('Chưa xác nhận', filter.includeChuaXacNhan, (
                v,
              ) {
                setState(() {
                  filter = filter.copyWith(includeChuaXacNhan: v);
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCheckbox(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
        Text(title),
      ],
    );
  }

  // ---------------------------
  // Phần học phần
  Widget _buildCourseSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Học phần', style: Theme.of(context).textTheme.bodyLarge),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // TODO: thêm chọn học phần
                },
                icon: const Icon(Icons.add, color: Colors.blue, size: 28),
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: filter.courses.isEmpty
                ? const Center(
                    child: Text(
                      'Không có học phần được chọn',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filter.courses.length,
                    itemBuilder: (context, index) {
                      final course = filter.courses[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.book_outlined),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mã HP: ${course.maHocPhan} - ${course.soTinChi} tín chỉ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                    Text(
                                      course.tenHocPhan,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _showDialogDeleteLecturer(context, () {
                                    setState(() {
                                      filter.courses.removeAt(index);
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------------------
  void _showDialogDeleteLecturer(
    BuildContext context,
    VoidCallback? onPressed,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa mục này khỏi lọc không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
