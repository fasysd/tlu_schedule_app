import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/presentation/widgets/sliver_appBar_backPage.dart';
import 'package:tlu_schedule_app/presentation/widgets/text_field_search.dart';

class DshocphanPage extends StatefulWidget {
  const DshocphanPage({super.key});

  @override
  State<DshocphanPage> createState() => _DshocphanPageState();
}

class _DshocphanPageState extends State<DshocphanPage> {
  final FocusNode _searchFocusNode = FocusNode();
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextfieldSearch(focusNode: _searchFocusNode),
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            onPressed: _showBottomSheetFilter,
                            child: Image.asset(
                              'assets/images/icons/filter_icon.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showBottomSheetFilter() async {
    // final result = await showModalBottomSheet<TeachingRequestFilterModel>(
    //   context: context,
    //   isScrollControlled: true,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    //   ),
    //   builder: (context) {
    //     return BottomSheetTeachingRequestFilter(initialFilter: filterModel);
    //   },
    // );
    //
    // setFilter(result);
  }
}
