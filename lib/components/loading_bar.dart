import 'package:flutter/material.dart';
import 'package:social_media_app/styles/app_colors.dart';

class LoadingBar extends StatelessWidget {
  const LoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // showDialog(context: context, builder: (context) => const LoadingBar());
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: Material(
            elevation: 2,
            color: AppColor.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppColor.greyOpaque,
                )),
            child: const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: AppColor.primaryDark,
                  valueColor: AlwaysStoppedAnimation(AppColor.primaryDark),
                  strokeWidth: 2.0,
                  strokeCap: StrokeCap.butt,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
