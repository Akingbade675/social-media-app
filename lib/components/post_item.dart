import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:social_media_app/components/comment_bottom_sheet.dart';
import 'package:social_media_app/cubit/post/post_cubit.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:social_media_app/components/user_avatar.dart';
import 'package:social_media_app/config/app_icons.dart';
import 'package:social_media_app/data/model/post.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final bool isUserVisible;
  final double relativePostion;
  final List<String> postImages = const [
    'assets/temp/Discover-Rottnest.png',
    'assets/temp/people.jpeg',
    'assets/temp/place_1.png',
    'assets/temp/place_2.png',
    'assets/temp/place_3.png',
    'assets/temp/Sals-Salis.png',
  ];

  const PostItem(
    this.post, {
    super.key,
    this.isUserVisible = true,
    this.relativePostion = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isUserVisible) ...[
          Row(
            children: [
              const UserAvatar(
                size: 40,
                borderRadius: 10,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(post.owner?.name ?? '', style: AppText.subtitle2),
                  Text(
                    timeago.format(post.createdAt),
                    style: AppText.body2.copyWith(color: AppColor.grey),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (post.imageUrl != null)
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    // randomize post Images
                    postImages[Random().nextInt(postImages.length)],
                    fit: BoxFit.cover,
                    alignment: Alignment(0, relativePostion),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        // if (post.imageUrl != null) Image.network(post.imageUrl!),
        Text(post.message, style: AppText.body2),
        // const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LikeButton(
              size: 20,
              circleColor: const CircleColor(
                start: AppColor.secondaryDark,
                end: AppColor.secondaryDark,
              ),
              bubblesColor: const BubblesColor(
                dotPrimaryColor: AppColor.secondaryDark,
                dotSecondaryColor: AppColor.secondaryDark,
              ),
              isLiked: post.isLiked,
              likeCountPadding: const EdgeInsets.only(left: 8),
              likeBuilder: (bool isLiked) {
                return isLiked
                    ? SvgPicture.asset(
                        AppIcons.icFavoriteFilled,
                        colorFilter: const ColorFilter.mode(
                          AppColor.secondaryDark,
                          BlendMode.srcIn,
                        ),
                        width: 20,
                        height: 20,
                      )
                    : SvgPicture.asset(
                        AppIcons.icFavorite,
                        colorFilter: ColorFilter.mode(
                          AppColor.greyOpaque,
                          BlendMode.srcIn,
                        ),
                        width: 20,
                        height: 20,
                      );
              },
              likeCount: post.likesCount,
              onTap: (isLiked) {
                print('Liking post ${post.id}');
                context.read<PostCubit>().likePost(post.id);
                return Future.value(!isLiked);
              },
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  transitionAnimationController: AnimationController(
                    vsync: Navigator.of(context),
                    duration: const Duration(milliseconds: 300),
                  ),
                  builder: (context) => const CommentBottomSheet(),
                );
              },
              icon: SvgPicture.asset(
                AppIcons.icMessage,
                colorFilter: ColorFilter.mode(
                  AppColor.greyOpaque,
                  BlendMode.srcIn,
                ),
                width: 20,
                height: 20,
              ),
              label: Text(
                post.commentsCount.toString(),
                style: AppText.body2.copyWith(color: AppColor.greyOpaque),
              ),
            ),
          ],
        )
      ],
    );
  }

//   Widget likeWidget(bool isLiked) {
//     if (isLiked) {
//       return Lottie.asset('assets/animations/like_animation.json',
//           width: 20, height: 20);
//       return SvgPicture.asset(
//         AppIcons.icFavoriteFilled,
//         colorFilter: const ColorFilter.mode(
//           AppColor.secondaryDark,
//           BlendMode.srcIn,
//         ),
//         width: 20,
//         height: 20,
//       );
//     } else {
//       return SvgPicture.asset(
//         AppIcons.icFavorite,
//         colorFilter: ColorFilter.mode(
//           AppColor.grey,
//           BlendMode.srcIn,
//         ),
//         width: 20,
//         height: 20,
//       );
//     }
//   }
}
