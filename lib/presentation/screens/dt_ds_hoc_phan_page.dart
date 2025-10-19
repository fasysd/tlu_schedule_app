import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/course_model.dart';
import 'package:tlu_schedule_app/data/models/semester_model.dart';
import 'package:tlu_schedule_app/presentation/widgets/card_course.dart';
import 'package:tlu_schedule_app/presentation/widgets/sliver_appBar_backPage.dart';
import 'package:tlu_schedule_app/presentation/widgets/text_field_search.dart';

class DshocphanPage extends StatefulWidget {
  const DshocphanPage({super.key});

  @override
  State<DshocphanPage> createState() => _DshocphanPageState();
}

class _DshocphanPageState extends State<DshocphanPage> {
  final FocusNode _searchFocusNode = FocusNode();
  List<SemesterModel> mockSemesters = [
    SemesterModel(
      id: '1_2025_2026',
      startDate: DateTime(2025, 1, 15),
      endDate: DateTime(2025, 5, 15),
    ),
    SemesterModel(
      id: '2_2024_2025',
      startDate: DateTime(2025, 8, 15),
      endDate: DateTime(2025, 12, 15),
    ),
    SemesterModel(
      id: '1_2024_2025',
      startDate: DateTime(2026, 1, 15),
      endDate: DateTime(2026, 5, 15),
    ),
  ];
  late SemesterModel _selectedSemester = mockSemesters[0];

  void onPressedQuayLai() => Navigator.pop(context);

  void _unfocusTextField() => FocusScope.of(context).unfocus();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusTextField,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppbarBackpage(
                textTittle: 'Danh sách học phần',
                onPressedBack: onPressedQuayLai,
              ),

              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 130,
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
                    child: Column(
                      children: [
                        Expanded(
                          child: TextfieldSearch(focusNode: _searchFocusNode),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Kỳ:",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<SemesterModel>(
                                      value: _selectedSemester,
                                      isExpanded: true,
                                      items: mockSemesters.map((
                                        SemesterModel semester,
                                      ) {
                                        return DropdownMenuItem<SemesterModel>(
                                          value: semester,
                                          child: Text(
                                            semester.id.replaceAll('_', ' - '),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (SemesterModel? newValue) {
                                        setState(() {
                                          if (newValue != null)
                                            _selectedSemester = newValue;
                                          // _loadCoursesForSemester();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      CardCourse(courseModel: CourseModel.defaultCourse()),
                      CardCourse(courseModel: CourseModel.defaultCourse()),
                      CardCourse(courseModel: CourseModel.defaultCourse()),
                      CardCourse(courseModel: CourseModel.defaultCourse()),
                      CardCourse(courseModel: CourseModel.defaultCourse()),
                    ],
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
