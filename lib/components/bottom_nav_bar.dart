import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_media_app/components/new_post_modal.dart';
import 'package:social_media_app/config/app_config.dart';
import 'package:social_media_app/config/app_icons.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/cubit/main_page/main_page_cubit.dart';
import 'package:social_media_app/cubit/post/post_cubit.dart';
import 'package:social_media_app/styles/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        Builder(builder: (context) {
          final currentIndex = context.watch<MainPageCubit>().state.index;
          return BottomNavigationBar(
            backgroundColor: AppColor.white,
            elevation: 4,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) => onBottomNavigationItemTapped(
              BottomNavigationItem.values[index],
              context,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: MyIconWidget(
                    index: BottomNavigationItem.home, icon: AppIcons.icHome),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: MyIconWidget(
                    index: BottomNavigationItem.favorites,
                    icon: AppIcons.icFavorite),
                label: 'Favourites',
              ),
              BottomNavigationBarItem(
                icon: MyIconWidget(
                    index: BottomNavigationItem.add,
                    icon: AppIcons.icAddOutline),
                label: 'Add Post',
              ),
              BottomNavigationBarItem(
                icon: MyIconWidget(
                    index: BottomNavigationItem.messages,
                    icon: AppIcons.icMessage),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: MyIconWidget(
                    index: BottomNavigationItem.profile,
                    icon: AppIcons.icProfile),
                label: 'Profile',
              ),
            ],
          );
        })
      ],
    );
  }

  void onBottomNavigationItemTapped(
      BottomNavigationItem selectedItem, BuildContext context) {
    final currentItem = context.read<MainPageCubit>().state;

    switch (selectedItem) {
      case BottomNavigationItem.home:
        if (currentItem == selectedItem) {
          context.read<PostCubit>().scrollPostToTop();
        }
        break;
      case BottomNavigationItem.add:
        _showCreatePostBottomSheet(context);
        return;
      case BottomNavigationItem.messages:
        Navigator.pushNamed(context, AppRoutes.chat);
        return;
      default:
    }

    context.read<MainPageCubit>().tabChange(selectedItem);
  }

  void _showCreatePostBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColor.white,
      enableDrag: false,
      // constraints: BoxConstraints(
      //   maxHeight: MediaQuery.of(context).size.height * 0.9,
      // ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 500),
      ),
      context: context,
      builder: (context) {
        return const CreatePostModalSheet();
      },
    );
  }
}

class MyIconWidget extends StatelessWidget {
  final BottomNavigationItem index;
  final String icon;

  const MyIconWidget({
    super.key,
    required this.index,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      colorFilter: ColorFilter.mode(
        context.watch<MainPageCubit>().state == index
            ? AppColor.primaryDark
            : AppColor.grey,
        BlendMode.srcIn,
      ),
      width: 24,
      height: 24,
    );
  }
}
