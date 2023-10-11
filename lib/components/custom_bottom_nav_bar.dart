import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_media_app/components/bottom_navigation_item.dart';
import 'package:social_media_app/config/app_config.dart';
import 'package:social_media_app/config/app_icons.dart';
import 'package:social_media_app/styles/app_colors.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({
    super.key,
    required this.currentItem,
    required this.onTap,
  });

  final BottomNavigationItem currentItem;
  final ValueChanged<BottomNavigationItem> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 87,
      margin: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Positioned(
            top: 17,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.grey,
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: MyBottomNavigationItem(
                      icon: AppIcons.icHome,
                      isSelected: currentItem == BottomNavigationItem.home,
                      onPressed: () => onTap(BottomNavigationItem.home),
                    ),
                  ),
                  Expanded(
                    child: MyBottomNavigationItem(
                      icon: AppIcons.icFavorite,
                      isSelected: currentItem == BottomNavigationItem.favorites,
                      onPressed: () => onTap(BottomNavigationItem.favorites),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: MyBottomNavigationItem(
                      icon: AppIcons.icMessage,
                      isSelected: currentItem == BottomNavigationItem.messages,
                      onPressed: () => onTap(BottomNavigationItem.messages),
                    ),
                  ),
                  Expanded(
                      child: MyBottomNavigationItem(
                    icon: AppIcons.icProfile,
                    isSelected: currentItem == BottomNavigationItem.profile,
                    onPressed: () => onTap(BottomNavigationItem.profile),
                  )),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                onTap(BottomNavigationItem.add);
              },
              child: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColor.primaryDark,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppIcons.icAdd,
                  colorFilter:
                      const ColorFilter.mode(AppColor.white, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
