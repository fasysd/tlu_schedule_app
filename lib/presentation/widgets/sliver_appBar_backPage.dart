import 'package:flutter/material.dart';

class SliverAppbarBackpage extends StatelessWidget {
  final String textTittle;
  final VoidCallback? onPressedBack;
  const SliverAppbarBackpage({
    super.key,
    required this.textTittle,
    required this.onPressedBack,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
                    backgroundColor: const Color.fromRGBO(195, 217, 233, 1),
                    padding: const EdgeInsets.all(10),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  onPressed: onPressedBack,
                  child: Image.asset('assets/images/icons/back_icon.png'),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                textTittle,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
