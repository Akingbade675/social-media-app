import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/persistent_divider.dart';
import 'package:social_media_app/components/post_item.dart';
import 'package:social_media_app/components/posts_loading_widget.dart';
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

class CustomProfilePage extends StatefulWidget {
  const CustomProfilePage({super.key});

  @override
  State<CustomProfilePage> createState() => _CustomProfilePageState();
}

class _CustomProfilePageState extends State<CustomProfilePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final userId = (context.read<AuthenticationCubit>().state
            as AuthenticationAuthenticated)
        .user
        .id;
    context.read<UsersCubit>().getUserById(userId);
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: 3, vsync: this);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text(AppStrings.profile),
          backgroundColor: AppColor.white,
          surfaceTintColor: AppColor.white,
          pinned: true,
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
                      value: ProfileMenu.logout,
                      child: Text(AppStrings.logout)),
                ];
              },
            )
          ],
        ),
        const PersistentDividerHeader(),
        SliverToBoxAdapter(
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
            ],
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverPersistentHeaderDelegateImpl(
            tabController: tabController,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: TabBarView(
              controller: tabController,
              children: const [
                Center(child: Text('Posts')),
                Center(child: Text('Followers')),
                Center(child: Text('Following')),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          sliver: Builder(
            builder: (context) {
              final userState = context.watch<UsersCubit>().state;
              if (userState is UserLoaded) {
                final user = userState.user;
                return SliverList.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return PostItem(
                      user.posts[index],
                      isUserVisible: false,
                    );
                  },
                  itemCount: user.posts.length,
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      const PostLoadingListItem(isUserVisible: false),
                  childCount: 4,
                ),
              );
            },
          ),
        )
      ],
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

class SliverPersistentHeaderDelegateImpl
    extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  SliverPersistentHeaderDelegateImpl({required this.tabController});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.zero,
      color: AppColor.white,
      child: Column(
        children: [
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     ProfileCounts(title: AppStrings.posts, count: 119),
          //     ProfileCounts(title: AppStrings.followers, count: 456),
          //     ProfileCounts(title: AppStrings.following, count: 826),
          //   ],
          // ),
          Container(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: tabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              indicatorColor: AppColor.primaryDark,
              labelColor: AppColor.primaryDark,
              unselectedLabelColor: AppColor.grey,
              tabs: const [
                ProfileCounts(title: AppStrings.posts, count: 119),
                ProfileCounts(title: AppStrings.followers, count: 456),
                ProfileCounts(title: AppStrings.following, count: 826),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
