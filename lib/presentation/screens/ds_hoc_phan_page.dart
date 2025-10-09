import 'package:flutter/material.dart';

class DshocphanPage extends StatefulWidget {
  const DshocphanPage({super.key});

  @override
  State<DshocphanPage> createState() => _DshocphanPageState();
}

class _DshocphanPageState extends State<DshocphanPage> {
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
                      Text(
                        'Danh sách học phần',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(child: Text("Danh sách học phần")),
            ),
          ],
        ),
      ),
    );
  }
}
