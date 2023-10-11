import 'package:flutter/material.dart';
import 'package:social_media_app/components/post_item.dart';
import 'package:social_media_app/data/model/post.dart';

class ScrollAnimationWrapper extends StatefulWidget {
  final Post child;
  final ScrollController controller;

  const ScrollAnimationWrapper(
      {Key? key, required this.child, required this.controller})
      : super(key: key);

  @override
  State<ScrollAnimationWrapper> createState() => _ScrollAnimationWrapperState();
}

class _ScrollAnimationWrapperState extends State<ScrollAnimationWrapper> {
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: ((context, child) {
        final renderObject =
            globalKey.currentContext?.findRenderObject() as RenderBox?;
        final offsetY = renderObject?.localToGlobal(Offset.zero).dy ?? 0;
        if (offsetY <= 0) {
          return child!;
        }
        final deviceHeight = MediaQuery.of(context).size.height;
        final heightVisible = deviceHeight - offsetY;
        // final relativePostion = offsetY / deviceHeight;
        final widgetHeight = renderObject?.size.height ?? 1;
        final howMuchShown = (heightVisible / widgetHeight).clamp(0.0, 1.0);
        final scale = 0.8 + howMuchShown * 0.2;
        final opacity = 0.25 + howMuchShown * 0.75;

        return Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          child: Opacity(opacity: opacity, child: child),
        );
      }),
      child: PostItem(widget.child),
    );
  }
}
