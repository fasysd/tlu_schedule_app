import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/data/services/lecturer_sevice.dart';
import 'package:tlu_schedule_app/presentation/widgets/card_lecturer.dart';
import 'package:tlu_schedule_app/presentation/widgets/sliver_appBar_backPage.dart';
import '../widgets/text_field_search.dart';

class DsLuaChonGiangVienPage extends StatefulWidget {
  final List<LecturerModel> selectedLecturers;

  const DsLuaChonGiangVienPage({super.key, this.selectedLecturers = const []});

  @override
  State<DsLuaChonGiangVienPage> createState() => _DsLuaChonGiangVienPageState();
}

class _DsLuaChonGiangVienPageState extends State<DsLuaChonGiangVienPage> {
  final FocusNode _searchFocusNode = FocusNode();

  List<LecturerModel> _listLecturer = [];
  Set<String> _selectedLecturerIds = {};
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  List<LecturerModel> _filteredLecturers = [];

  @override
  void initState() {
    super.initState();
    // ✅ Khởi tạo danh sách chọn ban đầu
    _selectedLecturerIds = widget.selectedLecturers
        .map((e) => e.maGiangVien)
        .toSet();
    loadLecturers();
  }

  Future<void> loadLecturers() async {
    final response = await LecturerService().fetchLecturers();

    setState(() {
      _isLoading = false;
      if (response['statusCode'] == 200) {
        _listLecturer = response['data'] as List<LecturerModel>;
        _filteredLecturers = _listLecturer;
      } else {
        _errorMessage = response['message'];
      }
    });
  }

  void _filterLecturers() {
    setState(() {
      _filteredLecturers = _listLecturer.where((lecturer) {
        return lecturer.hoVaTen.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               lecturer.maGiangVien.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               lecturer.email.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  void _unfocusTextField() => FocusScope.of(context).unfocus();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusTextField,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppbarBackpage(
                    textTittle: 'Chọn giảng viên',
                    onPressedBack: () => Navigator.pop(context),
                  ),
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 80,
                    backgroundColor: Colors.transparent,
                    floating: true,
                    snap: true,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: TextfieldSearch(
                          hintText: 'Tìm kiếm giảng viên...',
                          focusNode: _searchFocusNode,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              _filterLecturers();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : _errorMessage != null
                          ? Center(child: Text(_errorMessage!))
                          : Column(
                              children: _filteredLecturers.map((item) {
                                final isSelected = _selectedLecturerIds
                                    .contains(item.maGiangVien);
                                return CardLecturer(
                                  lecturerModel: item,
                                  selected: isSelected,
                                  onPressed: () {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedLecturerIds.remove(
                                          item.maGiangVien,
                                        );
                                      } else {
                                        _selectedLecturerIds.add(
                                          item.maGiangVien,
                                        );
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: _selectedLecturerIds.isEmpty
                      ? null
                      : () => Navigator.pop(
                          context,
                          _listLecturer
                              .where(
                                (l) => _selectedLecturerIds.contains(
                                  l.maGiangVien,
                                ),
                              )
                              .toList(),
                        ),
                  child: const Text('Xác nhận'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
