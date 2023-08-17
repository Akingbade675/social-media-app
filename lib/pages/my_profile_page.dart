import 'package:flutter/material.dart';
import 'package:social_media_app/components/tool_bar.dart';
import 'package:social_media_app/components/user_avatar.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

enum ProfileMenu {
  edit,
  logout,
}

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToolBar(
        title: AppStrings.profile,
        actions: [
          PopupMenuButton<ProfileMenu>(
            onSelected: (menu) {
              switch (menu) {
                case ProfileMenu.edit:
                  Navigator.of(context).pushNamed(AppRoutes.editProfile);
                  break;
                case ProfileMenu.logout:
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                    value: ProfileMenu.edit, child: Text(AppStrings.edit)),
                const PopupMenuItem(
                    value: ProfileMenu.logout, child: Text(AppStrings.logout)),
              ];
            },
          )
        ],
      ),
      body: const Column(
        children: [
          UserAvatar(),
          SizedBox(height: 12),
          Text(
            'Mahadiru Abdur',
            style: AppText.header2,
          ),
          SizedBox(height: 12),
          Text(
            'Kaduna, Nigeria',
            style: AppText.subtitle3,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ProfileCounts(title: AppStrings.followers, count: 456),
              ProfileCounts(title: AppStrings.posts, count: 119),
              ProfileCounts(title: AppStrings.following, count: 826),
            ],
          ),
          Divider(
            height: 24,
            indent: 24,
            endIndent: 24,
          ),
        ],
      ),
    );
  }
}

class ProfileCounts extends StatelessWidget {
  const ProfileCounts({
    super.key,
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: AppText.header2,
        ),
        Text(title),
      ],
    );
  }
}
