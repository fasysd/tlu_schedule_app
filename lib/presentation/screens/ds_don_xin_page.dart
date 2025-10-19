import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/teaching_request_filter_model.dart';
import 'package:tlu_schedule_app/data/models/teaching_request_model.dart';
import 'package:tlu_schedule_app/data/services/teaching_request_service.dart';
import 'package:tlu_schedule_app/presentation/screens/thong_tin_don_page.dart';
import 'package:tlu_schedule_app/presentation/widgets/bottom_sheet_teaching_request_filter.dart';
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
  List<TeachingRequestModel> _listTeachingRequests = []; // khởi tạo rỗng
  late TeachingRequestFilterModel filterModel;
  List<TeachingRequestModel> _filteredRequests = [];

  @override
  void initState() {
    super.initState();
    loadTeachingRequests();
  }

  Future<void> loadTeachingRequests() async {
    final response = await TeachingRequestService().fetchTeachingRequests();

    setState(() {
      _isLoading = false;
      if (response['statusCode'] == 200) {
        _listTeachingRequests = response['data'];
        setFilter(TeachingRequestFilterModel.defaultFilter());
      } else {
        _error = response['message'];
      }
    });
  }

  void setFilter(TeachingRequestFilterModel? filter) {
    setState(() {
      if (filter != null) {
        filterModel = filter;
        _filteredRequests = _listTeachingRequests.where((request) {
          return filterModel.matches(request);
        }).toList();
      }
    });
  }

  void onPressedQuayLai() => Navigator.pop(context);

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _unfocusTextField() => FocusScope.of(context).unfocus();

  void onPressedXemDonXinDuyet(TeachingRequestModel teachingRequest) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ThongTinDonPage(initTeachingRequest: teachingRequest),
      ),
    );
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
                textTittle: 'Danh sách đơn xin duyệt',
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
              SliverToBoxAdapter(
                child: Container(
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

  Future<void> _showBottomSheetFilter() async {
    final result = await showModalBottomSheet<TeachingRequestFilterModel>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return BottomSheetTeachingRequestFilter(initialFilter: filterModel);
      },
    );

    setFilter(result);
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_error.isNotEmpty) {
      return Center(child: Text(_error));
    } else if (_filteredRequests.isEmpty) {
      return const Center(child: Text('Không có dữ liệu.'));
    } else {
      return Column(
        children: _filteredRequests.map((item) {
          return CardRequest(
            teachingRequest: item,
            onPressed: () {
              onPressedXemDonXinDuyet(item);
            },
          );
        }).toList(),
      );
    }
  }
}
