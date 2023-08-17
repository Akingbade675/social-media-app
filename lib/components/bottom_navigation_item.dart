import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_app/styles/app_colors.dart';

class MyBottomNavigationItem extends StatelessWidget {
  const MyBottomNavigationItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  final String icon;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        icon,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isSelected ? AppColor.black : AppColor.black.withOpacity(0.3),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
