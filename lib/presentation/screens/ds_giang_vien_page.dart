import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/data/services/lecturer_sevice.dart';
import 'package:tlu_schedule_app/presentation/widgets/card_lecturer.dart';
import '../widgets/text_field_search.dart'; // Đảm bảo đường dẫn này là chính xác

class DsgiangvienPage extends StatefulWidget {
  const DsgiangvienPage({super.key});

  @override
  State<DsgiangvienPage> createState() => _DsgiangvienPageState();
}

class _DsgiangvienPageState extends State<DsgiangvienPage> {
  // FocusNode để bỏ focus khi chạm ra ngoài
  final FocusNode _searchFocusNode = FocusNode();
  final List<LecturerModel> _listLecturer = LecturerService()
      .generateSampleLecturers();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
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
              SliverAppBar(
                automaticallyImplyLeading: false,
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
                              backgroundColor: const Color.fromRGBO(
                                195,
                                217,
                                233,
                                1,
                              ),
                              padding: const EdgeInsets.all(10),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            onPressed: onPressedQuayLai,
                            child: Image.asset(
                              'assets/images/icons/back_icon.png',
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Danh sách giảng viên',
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                        onPressed: () {},
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
