import 'package:flutter/material.dart';
import 'package:social_media_app/data/model/post.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem(
    this.post, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/temp/girl_2.jpg'),
              ),
              const SizedBox(width: 16),
              Text(post.author.name!, style: AppText.subtitle3),
            ],
          ),
          const SizedBox(height: 12),
          Image.asset('assets/temp/people.jpeg'),
          const SizedBox(height: 12),
          Text(post.message!)
        ],
      ),
    );
  }
}
