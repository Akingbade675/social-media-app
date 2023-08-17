import 'package:flutter/material.dart';
import 'package:social_media_app/styles/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({super.key, required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint,
        labelStyle: TextStyle(
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
        filled: true,
        fillColor: AppColor.fieldColor,
      ),
    );
  }
}
