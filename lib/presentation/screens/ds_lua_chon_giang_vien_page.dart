import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/data/services/lecturer_sevice.dart';
import 'package:tlu_schedule_app/presentation/widgets/card_lecturer.dart';
import 'package:tlu_schedule_app/presentation/widgets/sliver_appBar_backPage.dart';
import '../widgets/text_field_search.dart'; // Đảm bảo đường dẫn này là chính xác

class DsLuaChonGiangVienPage extends StatefulWidget {
  const DsLuaChonGiangVienPage({super.key});

  @override
  State<DsLuaChonGiangVienPage> createState() => _DsLuaChonGiangVienPageState();
}

class _DsLuaChonGiangVienPageState extends State<DsLuaChonGiangVienPage> {
  final FocusNode _searchFocusNode = FocusNode();
  late final List<LecturerModel> _listLecturer;
  Set<LecturerModel> _selectedLecturers = {};

  @override
  void initState() {
    super.initState();
    loadLecturers();
  }

  Future<void> loadLecturers() async {
    final lecturers = await LecturerService().fetchLecturersFromApi();
    setState(() {
      _listLecturer = lecturers;
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
                        child: TextfieldSearch(focusNode: _searchFocusNode),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                      child: Column(
                        children: _listLecturer.map((item) {
                          final isSelected = _selectedLecturers.contains(item);
                          return CardLecturer(
                            lecturerModel: item,
                            selected: isSelected,
                            onPressed: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedLecturers.remove(item);
                                } else {
                                  _selectedLecturers.add(item);
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
                  onPressed: _selectedLecturers.isEmpty
                      ? null
                      : () {
                          Navigator.pop(context, _selectedLecturers.toList());
                        },
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
