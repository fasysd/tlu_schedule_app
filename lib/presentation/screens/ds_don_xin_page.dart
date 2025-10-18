import 'package:flutter/material.dart';
import 'package:tlu_schedule_app/data/models/lecturer_model.dart';
import 'package:tlu_schedule_app/data/models/teaching_request_model.dart';
import 'package:tlu_schedule_app/data/services/teaching_request_service.dart';
import 'package:tlu_schedule_app/presentation/screens/ds_lua_chon_giang_vien_page.dart';
import 'package:tlu_schedule_app/presentation/screens/thong_tin_don_xin_nghi.dart';
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

  void onPressedXemDonXinDuyet(TeachingRequestModel teachingRequest) {
    if (teachingRequest.loaiDon == "Đơn xin nghỉ dạy") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ThongTinDonXinNghi(requestModel: teachingRequest),
        ),
      );
    } else if (teachingRequest.loaiDon == "Đơn xin dạy bù") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ThongTinDonXinNghi(requestModel: teachingRequest),
        ),
      );
    }
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

  void _showBottomSheetFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.blue, // màu nền giống AppBar
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Text(
                  'Lọc',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Giảng viên',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () async {
                            final selectedLecturers = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DsLuaChonGiangVienPage(),
                              ),
                            );
                            //tạm thời coi như đã lấy và cập nhật ds hiển thị
                            if (selectedLecturers != null &&
                                selectedLecturers.isNotEmpty) {
                              print(
                                'Đã chọn: ${selectedLecturers.map((e) => e.hoVaTen).join(', ')}',
                              );
                            } else {
                              print('Chưa chọn giảng viên nào.');
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 13),
                      ],
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.person_outline),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'gv_g43y84 - Nguyễn Văn A',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _showDialogDeleteLecturer(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loại đơn',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                      children: const [
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(value: false, onChanged: null),
                              Text('Đơn xin nghỉ'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(value: false, onChanged: null),
                              Text('Đơn dạy bù'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trạng thái',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    // Dòng 1: Xác nhận và Từ chối
                    Row(
                      children: const [
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(value: false, onChanged: null),
                              Text('Xác nhận'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(value: false, onChanged: null),
                              Text('Từ chối'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: const [
                        Expanded(
                          child: Row(
                            children: [
                              Checkbox(value: false, onChanged: null),
                              Text('Chưa xác nhận'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Học phần',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 13),
                      ],
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.book_outlined),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mã HP: APP101 - 3 tín chỉ',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                        ),
                                        Text(
                                          'PHÁT TRIỂN ỨNG DỤNG DI ĐỘNG PHÁT TRIỂN ỨNG DỤNG DI ĐỘNG',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _showDialogDeleteLecturer(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Thoát'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Xác nhận'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDialogDeleteLecturer(VoidCallback? onPressed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa giảng viên này khỏi lọc không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed!();
            },
            child: const Text('Xóa'),
          ),
        ],
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
            onPressed: () {
              onPressedXemDonXinDuyet(item);
            },
          );
        }).toList(),
      );
    }
  }
}
