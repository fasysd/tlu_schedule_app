import 'package:flutter/material.dart';

class BoxAvatar extends StatelessWidget {
  final String pathAvatar;
  const BoxAvatar({super.key, required this.pathAvatar});

  @override
  Widget build(BuildContext context) {
    return Container(
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
