// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:social_media_app/styles/app_colors.dart';

class FrostedGlassCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Widget child;
  final EdgeInsets padding;

  const FrostedGlassCard({
    Key? key,
    this.width = double.infinity,
    this.height = 60,
    required this.borderRadius,
    required this.child,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        // width: width,
        // height: height,
        padding: padding,
        color: Colors.transparent,
        child: Stack(
          children: [
            // blur effect
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: Container(),
            ),
            // gradient effect
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: AppColor.white.withOpacity(0.13)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.white.withOpacity(0.15),
                    AppColor.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            Center(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
