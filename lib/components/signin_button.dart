import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    required this.text,
    required this.iconPath,
  });

  final String text;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27.0, vertical: 8.0),
      child: ElevatedButton.icon(
        icon: SvgPicture.asset(
          iconPath,
          height: 24,
          width: 24,
        ),
        label: Text(
          text,
        ),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }
}
