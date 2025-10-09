import 'package:flutter/material.dart';

// Khuyến nghị: Tạo một StatelessWidget mới
class TextfieldSearch extends StatelessWidget {
  // Các tham số tùy chỉnh của TextfieldSearch
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  // ✨ Thêm các tham số phổ biến của TextField vào constructor
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextStyle? style;
  final bool readOnly;
  final GestureTapCallback? onTap;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  const TextfieldSearch({
    super.key,
    this.hintText = 'Tìm kiếm...',
    this.onChanged,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.style,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.onSubmitted,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: style,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        minLines: minLines,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,

        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
          prefixIcon: SizedBox(
            width: 16.0,
            height: 16.0,
            child: Center(
              child: Image.asset(
                'assets/images/icons/search_icon.png',
                width: 16.0,
                height: 16.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
