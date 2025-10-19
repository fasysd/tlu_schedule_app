import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/data/services/lecturer_sevice.dart';
import 'package:tlu_schedule_app/presentation/widgets/card_lecturer.dart';
import 'package:tlu_schedule_app/presentation/widgets/sliver_appBar_backPage.dart';
import 'thong_tin_giang_vien_page.dart';
import '../widgets/text_field_search.dart';

class DsgiangvienPage extends StatefulWidget {
  const DsgiangvienPage({super.key});

  @override
  State<DsgiangvienPage> createState() => _DsgiangvienPageState();
}

class _DsgiangvienPageState extends State<DsgiangvienPage> {
  final FocusNode _searchFocusNode = FocusNode();

  List<LecturerModel> _listLecturer = [];
  List<LecturerModel> _filteredLecturers = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadLecturers();
  }

  Future<void> loadLecturers() async {
    final response = await LecturerService().fetchLecturers();

    setState(() {
      _isLoading = false;
      if (response['statusCode'] == 200) {
        _listLecturer = response['data'];
        _filteredLecturers = response['data'];
      } else {
        _errorMessage = response['message'];
      }
    });
  }

  void onPressedXemGiangVien(LecturerModel lecturer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ThongTinGiangVienPage(lecturerModel: lecturer),
      ),
    );
  }

  void onPressedQuayLai() => Navigator.pop(context);

  void _unfocusTextField() => FocusScope.of(context).unfocus();

  void _filterLecturers() {
    setState(() {
      _filteredLecturers = _listLecturer.where((lecturer) {
        return lecturer.hoVaTen.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               lecturer.maGiangVien.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               lecturer.email.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

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
          body: CustomScrollView(
            slivers: [
              // Appbar
              SliverAppbarBackpage(
                textTittle: 'Danh sách giảng viên',
                onPressedBack: onPressedQuayLai,
              ),

              // Thanh tìm kiếm
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 80,
                backgroundColor: Colors.transparent,
                floating: true,
                snap: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
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

              // Nội dung chính
              SliverToBoxAdapter(
                child: _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                        child: Column(
                          children: _listLecturer.map((item) {
                            return CardLecturer(
                              lecturerModel: item,
                              onPressed: () => onPressedXemGiangVien(item),
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
