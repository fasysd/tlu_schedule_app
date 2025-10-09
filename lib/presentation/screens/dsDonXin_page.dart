import 'package:flutter/material.dart';

class DsdonxinPage extends StatefulWidget {
  const DsdonxinPage({super.key});

  @override
  State<DsdonxinPage> createState() => _DsdonxinPageState();
}

class _DsdonxinPageState extends State<DsdonxinPage> {
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
                        'Danh sách đơn',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: Center(child: Text('Danh sách đơn'))),
          ],
        ),
      ),
    );
  }
}
