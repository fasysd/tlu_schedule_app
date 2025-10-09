import 'package:flutter/material.dart';
import '../widgets/textField_search.dart'; // Đảm bảo đường dẫn này là chính xác

class DsgiangvienPage extends StatefulWidget {
  const DsgiangvienPage({super.key});

  @override
  State<DsgiangvienPage> createState() => _DsgiangvienPageState();
}

class _DsgiangvienPageState extends State<DsgiangvienPage> {
  // FocusNode để bỏ focus khi chạm ra ngoài
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void onPressed_quayLai() {
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
                            onPressed: onPressed_quayLai,
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

              // 3. Nội dung danh sách chính
              SliverToBoxAdapter(
                child: Center(
                  // Không nên đặt chiều cao cố định lớn trong SliverToBoxAdapter,
                  // nhưng tôi giữ lại để mô phỏng nội dung dài
                  child: SizedBox(
                    height: 2000,
                    child: const Text("Danh sách giảng viên"),
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
