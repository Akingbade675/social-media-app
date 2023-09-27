import 'package:flutter/material.dart';
import 'package:social_media_app/styles/app_colors.dart';

class PersistentDividerHeader extends StatelessWidget {
  const PersistentDividerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _SliverPersistentHeaderDelegateImpl(),
      pinned: true,
    );
  }
}

class _SliverPersistentHeaderDelegateImpl
    extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColor.grey.withOpacity(0.3),
      height: 1,
    );
  }

  @override
  double get maxExtent => 1;

  @override
  double get minExtent => 1;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
