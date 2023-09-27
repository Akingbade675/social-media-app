// import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/user_avatar.dart';
import 'package:social_media_app/config/app_strings.dart';
import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class UserPagerItem extends StatelessWidget {
  final User user;

  const UserPagerItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const UserAvatar(
                size: 50,
                borderRadius: 25,
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppText.subtitle1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.email!, // change to location
                    style: AppText.body2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          const Wrap(
            spacing: 6,
            children: [
              Text(
                'Posts: 119',
                style: AppText.body2,
              ),
              Text(
                'Followers: 497',
                style: AppText.body2,
              ),
              Text(
                'Following: 189',
                style: AppText.body2,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryDark,
                  foregroundColor: AppColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Directions'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_outline_rounded),
                label: const Text(
                  AppStrings.save,
                  style: TextStyle(color: AppColor.black),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
