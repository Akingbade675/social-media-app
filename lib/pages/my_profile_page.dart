import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/post_item.dart';
import 'package:social_media_app/components/posts_loading_widget.dart';
import 'package:social_media_app/components/tool_bar.dart';
import 'package:social_media_app/components/user_avatar.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/cubit/users/users_cubit.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

enum ProfileMenu {
  edit,
  logout,
}

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  void initState() {
    super.initState();
    final userId = (context.read<AuthenticationCubit>().state
            as AuthenticationAuthenticated)
        .user
        .id;
    debugPrint('USER ID ----- $userId');
    context.read<UsersCubit>().getUserById(userId);
  }

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
                  context.read<AuthenticationCubit>().loggedOut();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 16),
        child: Column(
          children: [
            const UserAvatar(),
            const SizedBox(height: 12),
            Text(
              (context.read<AuthenticationCubit>().state
                      as AuthenticationAuthenticated)
                  .user
                  .name,
              style: AppText.header2,
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColor.primaryDark,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'Kaduna, Nigeria',
                  style: AppText.subtitle3,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProfileCounts(title: AppStrings.followers, count: 456),
                ProfileCounts(title: AppStrings.posts, count: 119),
                ProfileCounts(title: AppStrings.following, count: 826),
              ],
            ),
            const Divider(
              height: 24,
              indent: 24,
              endIndent: 24,
            ),
            Expanded(
              child: Builder(builder: (context) {
                final userState = context.watch<UsersCubit>().state;
                if (userState is UserLoaded) {
                  final user = userState.user;
                  return ListView.separated(
                    itemCount: user.posts.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                    itemBuilder: (_, index) {
                      return PostItem(
                        user.posts[index],
                        isUserVisible: false,
                      );
                    },
                  );
                }
                return const PostLoadingWidget(isUserVisible: false);
              }),
            )
          ],
        ),
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
