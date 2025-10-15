import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/teaching_request_model.dart';
import 'package:tlu_schedule_app/data/services/teaching_request_service.dart';
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

  @override
  void initState() {
    super.initState();
    loadLecturers();
  }

  Future<void> loadLecturers() async {
    final response = await TeachingRequestService().fetchTeachingRequests();

    setState(() {
      _isLoading = false;
      if (response['statusCode'] == 200) {
        _listTeachingRequests = response['data'];
      } else {
        _error = response['message'];
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

  void onPressedXemDonXinDuyet() {}

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
                    child: TextfieldSearch(focusNode: _searchFocusNode),
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_error.isNotEmpty) {
      return Center(child: Text(_error));
    } else if (_listTeachingRequests.isEmpty) {
      return const Center(child: Text('Không có dữ liệu.'));
    } else {
      return Column(
        children: _listTeachingRequests.map((item) {
          return CardRequest(
            teachingRequest: item,
            onPressed: onPressedXemDonXinDuyet,
          );
        }).toList(),
      );
    }
  }
}
