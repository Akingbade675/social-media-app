import 'package:flutter/material.dart';
import 'package:social_media_app/components/tool_bar.dart';
import 'package:social_media_app/components/user_avatar.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToolBar(title: 'User Page'),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Column(
              children: [
                UserAvatar(),
                SizedBox(width: 14),
                Text('User Name'),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 30,
              (context, index) => const ListTile(
                title: Text('This is test post'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
