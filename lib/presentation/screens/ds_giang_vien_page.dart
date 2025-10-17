import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/data/services/lecturer_sevice.dart';
import 'package:tlu_schedule_app/presentation/widgets/card_lecturer.dart';
import 'package:tlu_schedule_app/presentation/widgets/sliver_appBar_backPage.dart';
import 'thong_tin_chi_tiet_giang_vien_page.dart';
import '../widgets/text_field_search.dart'; // Đảm bảo đường dẫn này là chính xác

class DsgiangvienPage extends StatefulWidget {
  const DsgiangvienPage({super.key});

  @override
  State<DsgiangvienPage> createState() => _DsgiangvienPageState();
}

class _DsgiangvienPageState extends State<DsgiangvienPage> {
  // FocusNode để bỏ focus khi chạm ra ngoài
  final FocusNode _searchFocusNode = FocusNode();
  late final List<LecturerModel> _listLecturer;

  @override
  void initState() {
    super.initState();
    loadLecturers(); // gọi hàm async
  }

  Future<void> loadLecturers() async {
    final lecturers = await LecturerService().fetchLecturersFromApi();

    setState(() {
      _listLecturer = lecturers;
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void onPressedXemGiangVien(LecturerModel lecture) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ThongTinChiTietGiangVienPage(lecturerModel: lecture),
      ),
    );
  }

  void onPressedQuayLai() {
    Navigator.pop(context);
  }

  void _unfocusTextField() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusTextField,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppbarBackpage(
                textTittle: 'Danh sách giảng viên',
                onPressedBack: onPressedQuayLai,
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
                    child: TextfieldSearch(focusNode: _searchFocusNode),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
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
