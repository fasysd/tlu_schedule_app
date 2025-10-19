import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/data/models/teaching_request_filter_model.dart';
import 'package:tlu_schedule_app/data/models/teaching_request_model.dart';
import 'package:tlu_schedule_app/data/services/teaching_request_service.dart';
import 'package:tlu_schedule_app/presentation/screens/dt_ds_lua_chon_giang_vien_page.dart';
import 'package:tlu_schedule_app/presentation/screens/thong_tin_don_page.dart';
import 'package:tlu_schedule_app/presentation/widgets/card_request.dart';
import 'package:tlu_schedule_app/presentation/widgets/sliver_appBar_backPage.dart';
import '../widgets/text_field_search.dart';

class DsdonxinPage extends StatefulWidget {
  const DsdonxinPage({super.key});

  @override
  State<DsdonxinPage> createState() => _DsdonxinPageState();
}

class _DsdonxinPageState extends State<DsdonxinPage> {
  final FocusNode _searchFocusNode = FocusNode();
  bool _isLoading = true;
  String _error = '';
  List<TeachingRequestModel> _listTeachingRequests = [];
  late TeachingRequestFilterModel filterModel;
  List<TeachingRequestModel> _filteredRequests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final res = await TeachingRequestService().fetchTeachingRequests();
    setState(() {
      _isLoading = false;
      if (res['statusCode'] == 200) {
        _listTeachingRequests = res['data'];
        _applyFilter(TeachingRequestFilterModel.defaultFilter());
      } else {
        _error = res['message'];
      }
    });
  }

  void _applyFilter(TeachingRequestFilterModel? filter) {
    if (filter == null) return;
    setState(() {
      filterModel = filter;
      _filteredRequests = _listTeachingRequests
          .where(filterModel.matches)
          .toList();
    });
  }

  void _viewRequest(TeachingRequestModel req) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ThongTinDonPage(teachingRequest: req)),
    );
  }

  Future<void> _showFilterSheet() async {
    final result = await showModalBottomSheet<TeachingRequestFilterModel>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) =>
          BottomSheetTeachingRequestFilter(initialFilter: filterModel),
    );
    _applyFilter(result);
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppbarBackpage(
                textTittle: 'Danh sách đơn xin duyệt',
                onPressedBack: () => Navigator.pop(context),
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 80,
                backgroundColor: Colors.transparent,
                floating: true,
                snap: true,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextfieldSearch(focusNode: _searchFocusNode),
                      ),
                      _filterButton(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: _buildBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButton() => SizedBox(
    width: 50,
    height: 50,
    child: ElevatedButton(
      onPressed: _showFilterSheet,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Image.asset('assets/images/icons/filter_icon.png'),
    ),
  );

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error.isNotEmpty) return Center(child: Text(_error));
    if (_filteredRequests.isEmpty)
      return const Center(child: Text('Không có dữ liệu.'));
    return Column(
      children: _filteredRequests
          .map(
            (req) => CardRequest(
              teachingRequest: req,
              onPressed: () => _viewRequest(req),
            ),
          )
          .toList(),
    );
  }
}

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
          _buildHeader(context),
          _buildLecturerSection(context),
          _buildLoaiDonSection(context),
          _buildTrangThaiSection(context),
          _buildCourseSection(context),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
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
  );

  Widget _buildLecturerSection(BuildContext context) => _buildSection(
    context,
    title: 'Giảng viên',
    child: SizedBox(
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
              itemBuilder: (ctx, i) {
                final lecturer = filter.lecturers[i];
                return _buildItemRow(
                  context,
                  leading: const Icon(Icons.person_outline),
                  title: '${lecturer.tenTaiKhoan} - ${lecturer.hoVaTen}',
                  onDelete: () => _removeLecturer(i),
                );
              },
            ),
    ),
    trailing: IconButton(
      onPressed: _selectLecturer,
      icon: const Icon(Icons.add, color: Colors.blue, size: 28),
    ),
  );

  Widget _buildLoaiDonSection(BuildContext context) => _buildSection(
    context,
    title: 'Loại đơn',
    child: Row(
      children: [
        _buildCheckbox(
          'Đơn xin nghỉ',
          filter.includeDonXinNghi,
          (v) => _updateFilter(includeDonXinNghi: v),
        ),
        _buildCheckbox(
          'Đơn dạy bù',
          filter.includeDonDayBu,
          (v) => _updateFilter(includeDonDayBu: v),
        ),
      ],
    ),
  );

  Widget _buildTrangThaiSection(BuildContext context) => _buildSection(
    context,
    title: 'Trạng thái',
    child: Wrap(
      runSpacing: 5,
      children: [
        _buildCheckbox(
          'Xác nhận',
          filter.includeDaXacNhan,
          (v) => _updateFilter(includeDaXacNhan: v),
        ),
        _buildCheckbox(
          'Từ chối',
          filter.includeTuChoi,
          (v) => _updateFilter(includeTuChoi: v),
        ),
        _buildCheckbox(
          'Chưa xác nhận',
          filter.includeChuaXacNhan,
          (v) => _updateFilter(includeChuaXacNhan: v),
        ),
      ],
    ),
  );

  Widget _buildCourseSection(BuildContext context) => _buildSection(
    context,
    title: 'Học phần',
    trailing: IconButton(
      onPressed: () {
        // TODO: chọn học phần
      },
      icon: const Icon(Icons.add, color: Colors.blue, size: 28),
    ),
    child: SizedBox(
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
              itemBuilder: (_, i) {
                final c = filter.courses[i];
                return _buildItemRow(
                  context,
                  leading: const Icon(Icons.book_outlined),
                  title:
                      'Mã HP: ${c.maHocPhan} - ${c.lopHoc} tín chỉ\n${c.tenHocPhan}',
                  onDelete: () => _removeCourse(i),
                );
              },
            ),
    ),
  );

  Widget _buildActionButtons() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
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
  );

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
    Widget? trailing,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            if (trailing != null) trailing,
          ],
        ),
        child,
      ],
    ),
  );

  Widget _buildCheckbox(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
      Text(title),
    ],
  );

  Widget _buildItemRow(
    BuildContext context, {
    required Icon leading,
    required String title,
    required VoidCallback onDelete,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 10),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.labelMedium),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    ),
  );

  void _updateFilter({
    bool? includeDonXinNghi,
    bool? includeDonDayBu,
    bool? includeDaXacNhan,
    bool? includeTuChoi,
    bool? includeChuaXacNhan,
  }) {
    setState(() {
      filter = filter.copyWith(
        includeDonXinNghi: includeDonXinNghi ?? filter.includeDonXinNghi,
        includeDonDayBu: includeDonDayBu ?? filter.includeDonDayBu,
        includeDaXacNhan: includeDaXacNhan ?? filter.includeDaXacNhan,
        includeTuChoi: includeTuChoi ?? filter.includeTuChoi,
        includeChuaXacNhan: includeChuaXacNhan ?? filter.includeChuaXacNhan,
      );
    });
  }

  void _removeLecturer(int i) => setState(() => filter.lecturers.removeAt(i));
  void _removeCourse(int i) => setState(() => filter.courses.removeAt(i));

  Future<void> _selectLecturer() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DsLuaChonGiangVienPage(selectedLecturers: filter.lecturers),
      ),
    );
    if (selected != null && selected.isNotEmpty) {
      setState(() => filter = filter.copyWith(lecturers: List.from(selected)));
    }
  }
}
