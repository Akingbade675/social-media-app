import 'package:flutter/material.dart';
import 'package:social_media_app/components/posts_loading_widget.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class OtherUserProfilePage extends StatelessWidget {
  const OtherUserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: width,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.asset(
              'assets/temp/girl_4.jpg',
              height: width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const PostLoadingListItem(isUserVisible: false),
            childCount: 10,
          ),
        )
      ],
    );
  }
}
