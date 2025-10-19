import 'package:flutter/material.dart';

class TextfieldSearch extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

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
      height: 46,
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: style ?? Theme.of(context).textTheme.bodyMedium,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        minLines: minLines,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10, right: 6),
            child: Image.asset(
              'assets/images/icons/search_icon.png',
              width: 20,
              height: 20,
              color: Colors.blueGrey[600],
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
