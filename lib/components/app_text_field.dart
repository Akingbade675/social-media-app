import 'package:flutter/material.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    this.onChanged,
    this.obscureText = false,
  });

  final bool obscureText;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      style: AppText.subtitle3,
      decoration: InputDecoration(
        // hintText: isFocused ? widget.hint : null,
        hintStyle: AppText.body2.copyWith(
          color: AppColor.grey,
        ),
        labelText: widget.hint,
        labelStyle: AppText.body2.copyWith(
          color: AppColor.grey,
        ),
        // contentPadding: const EdgeInsets.symmetric(
        //   horizontal: 16,
        //   vertical: 20,
        // ),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.obscureText
            ? const Icon(Icons.visibility_off_outlined, size: 16)
            : null,
        filled: true,
        fillColor: AppColor.fieldColor,
      ),
    );
  }
}
