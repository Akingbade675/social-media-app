import 'package:flutter/material.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/temp/girl_2.jpg'),
              ),
              SizedBox(width: 16),
              Text('Amylia Sarah', style: AppText.subtitle3),
            ],
          ),
          const SizedBox(height: 12),
          Image.asset('assets/temp/people.jpeg'),
          const SizedBox(height: 12),
          const Text(
              'The text is a daily remainder that we too can share our own light.')
        ],
      ),
    );
  }
}
