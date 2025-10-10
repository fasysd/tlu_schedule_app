import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PhongdaotaoHomePage extends StatelessWidget {
  const PhongdaotaoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              floating: false,
              pinned:
                  false, // 👈 false để AppBar biến mất hoàn toàn khi kéo xuống
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: Row(
                    children: [
                      const SizedBox(width: 40),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 70,
                        alignment: Alignment.center,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Phòng đào tạo',
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            'Nguyễn Thị A',
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 30,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildNavigationButton(
                          context,
                          'assets/images/icons/user_icon.png',
                        ),
                        buildNavigationButton(
                          context,
                          'assets/images/icons/lesson_icon.png',
                        ),
                        buildNavigationButton(
                          context,
                          'assets/images/icons/form_icon.png',
                        ),
                        buildNavigationButton(
                          context,
                          'assets/images/icons/stats_icon.png',
                        ),
                      ],
                    ),
                    Column(
                      spacing: 10,
                      children: [
                        buildShortStat1(
                          context,
                          'Giảng viên',
                          '123',
                          'assets/images/icons/user_icon.png',
                        ),
                        buildShortStat1(
                          context,
                          'Học phần đang mở',
                          '34',
                          'assets/images/icons/lesson_icon.png',
                        ),
                        buildShortStat1(
                          context,
                          'Đơn xin nghỉ dạy',
                          '2',
                          'assets/images/icons/form_icon.png',
                        ),
                        buildShortStat1(
                          context,
                          'Đơn xin dạy bù',
                          '4',
                          'assets/images/icons/form_icon.png',
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: Colors.grey, // màu viền
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.25,
                            ), // màu bóng (và độ mờ)
                            spreadRadius: 0, // độ lan bóng
                            blurRadius: 4, // độ mờ bóng (càng lớn càng mịn)
                            offset: Offset(0, 4), // hướng đổ bóng (x, y)
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Thống kê',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/images/icons/change_icon.png',
                                  height: 23,
                                ),
                              ),
                            ],
                          ),
                          buildShortStat2(
                            context,
                            'Tỉ lệ hoàn thành',
                            0.5,
                            Colors.blue,
                          ),
                          SizedBox(height: 15),
                          buildShortStat2(
                            context,
                            'Tỉ lệ nghỉ dạy',
                            0.1,
                            Colors.red,
                          ),
                          SizedBox(height: 15),
                          buildShortStat2(
                            context,
                            'Tỉ lệ dạy bù',
                            1,
                            Colors.green,
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: Colors.grey, // màu viền
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.25,
                            ), // màu bóng (và độ mờ)
                            spreadRadius: 0, // độ lan bóng
                            blurRadius: 4, // độ mờ bóng (càng lớn càng mịn)
                            offset: Offset(0, 4), // hướng đổ bóng (x, y)
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(width: 1)),
                            ),
                            child: Text(
                              'Hoạt động gần đây',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                          buildNhatKyHoatDong(
                            context,
                            '22:30 30/09/2025',
                            'Giảng viên Nguyễn Văn A đã gửi yêu cầu nghỉ dạy',
                          ),
                          buildNhatKyHoatDong(
                            context,
                            '22:30 30/09/2025',
                            'Giảng viên Nguyễn Văn A đã gửi yêu cầu nghỉ dạy',
                          ),
                          buildNhatKyHoatDong(
                            context,
                            '22:30 30/09/2025',
                            'Giảng viên Nguyễn Văn A đã gửi yêu cầu nghỉ dạy',
                          ),
                          buildNhatKyHoatDong(
                            context,
                            '22:30 30/09/2025',
                            'Giảng viên Nguyễn Văn A đã gửi yêu cầu nghỉ dạy',
                          ),
                          buildNhatKyHoatDong(
                            context,
                            '22:30 30/09/2025',
                            'Giảng viên Nguyễn Văn A đã gửi yêu cầu nghỉ dạy',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavigationButton(BuildContext context, String pathIcon) {
    return SizedBox(
      width: 75,
      height: 75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)),
        onPressed: () {},
        child: Image.asset(pathIcon),
      ),
    );
  }

  Widget buildShortStat1(
    BuildContext context,
    String label,
    String value,
    String pathIcon,
  ) {
    return Container(
      height: 60,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: Colors.grey, // màu viền
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // màu bóng (và độ mờ)
            spreadRadius: 0, // độ lan bóng
            blurRadius: 4, // độ mờ bóng (càng lớn càng mịn)
            offset: Offset(0, 4), // hướng đổ bóng (x, y)
          ),
        ],
      ),
      child: Center(
        child: Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(width: 5),
            Image.asset(pathIcon, width: 25),
          ],
        ),
      ),
    );
  }

  Widget buildShortStat2(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              Text(
                (value * 100).toInt().toString() + '%',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 15,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                color: Colors.grey, // màu viền
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25), // màu bóng (và độ mờ)
                  spreadRadius: 0, // độ lan bóng
                  blurRadius: 4, // độ mờ bóng (càng lớn càng mịn)
                  offset: Offset(0, 4), // hướng đổ bóng (x, y)
                ),
              ],
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNhatKyHoatDong(
    BuildContext context,
    String time,
    String content,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '22:30 30/09/2025',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text(
            'Giảng viên Nguyễn Văn A đã gửi yêu cầu nghỉ dạy',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
