import 'package:flutter/material.dart';

class BoxAvatar extends StatelessWidget {
  final String pathAvatar;
  final double size;
  const BoxAvatar({super.key, required this.pathAvatar, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(195, 217, 233, 1),
        borderRadius: BorderRadius.circular(21),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Image.asset(pathAvatar, fit: BoxFit.cover),
      ),
    );
  }
}
