import 'package:flutter/material.dart';
import 'package:social_media_app/styles/app_colors.dart';

class PostLoadingWidget extends StatelessWidget {
  final bool isUserVisible;

  const PostLoadingWidget({super.key, this.isUserVisible = true});

  @override
  Widget build(BuildContext context) {
    // showGeneralDialog(
    //   context: context,
    //   pageBuilder: (context, x, y) {
    //     return const AlertDialog();
    //   },
    //   transitionBuilder: (context, animation, secondaryAnimation, child) {
    //     return ScaleTransition(scale: animation);
    //   },
    // );
    return ListView.separated(
      itemCount: 4,
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        return PostLoadingListItem(isUserVisible: isUserVisible);
      },
    );
  }
}

class PostLoadingListItem extends StatelessWidget {
  const PostLoadingListItem({
    super.key,
    this.isUserVisible = true,
  });

  final bool isUserVisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isUserVisible) ...[
          const Row(
            children: [
              ColoredContainer(
                width: 40,
                height: 40,
                radius: 10,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColoredContainer(
                    width: 150,
                    height: 16,
                    radius: 10,
                  ),
                  SizedBox(height: 4),
                  ColoredContainer(
                    width: 80,
                    height: 14,
                    radius: 10,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        const ColoredContainer(
          width: double.infinity,
          height: 200,
          radius: 10,
        ),
        const SizedBox(height: 12),
        const ColoredContainer(
          width: double.infinity,
          height: 16,
          radius: 10,
        ),
        const SizedBox(height: 12),
        const ColoredContainer(
          width: 230,
          height: 16,
          radius: 10,
        ),
        const SizedBox(height: 14),
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ColoredContainer(
              width: 40,
              height: 20,
              radius: 5,
            ),
            SizedBox(
              width: 16,
            ),
            ColoredContainer(
              width: 40,
              height: 20,
              radius: 5,
            ),
          ],
        )
      ],
    );
  }
}

class ColoredContainer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ColoredContainer({
    super.key,
    required this.width,
    required this.height,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.fieldColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
