// import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final double borderRadius;

  const UserAvatar(
      {super.key, this.size = 90, this.imageUrl, this.borderRadius = 16});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Image.asset(
          'assets/temp/guy_4.jpg',
          width: size,
          height: size,
        ),
      ),
    );
  }
}
