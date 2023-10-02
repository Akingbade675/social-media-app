import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/input_bottom.dart';
import 'package:social_media_app/cubit/emoji_keyboard_cubit.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class CommentBottomSheet extends StatelessWidget {
  const CommentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: context.read<EmojiKeyboardCubit>().willPopScope(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 1,
        minChildSize: 0.4,
        snap: true,
        snapSizes: const [0.4, 0.5, 1],
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: AppColor.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Comments',
                              style: AppText.subtitle1
                                  .copyWith(color: AppColor.black),
                            ),
                            TextSpan(
                              text: ' (10)',
                              style: AppText.subtitle2
                                  .copyWith(color: AppColor.black),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Divider(color: AppColor.grey.withOpacity(0.3)),
                Expanded(
                  child: ListView.separated(
                    // shrinkWrap: true,
                    itemCount: 10,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return ListTile(
                        // titleAlignment: ListTileTitleAlignment.center,
                        minVerticalPadding: 0,
                        dense: false,
                        // visualDensity: VisualDensity.compact,
                        leading: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.grey,
                          backgroundImage: AssetImage(
                              'assets/temp/girl_${Random().nextInt(5) + 1}.jpg'),
                        ),
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Bhobo',
                                style: TextStyle(
                                  color: AppColor.grey,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: ' - ${5 * index} mins ago',
                                style: TextStyle(
                                  color: AppColor.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitleTextStyle: AppText.body2,
                        subtitle: const Text(
                            'This is a comment from Bhobo on this post.'),
                      );
                    },
                  ),
                ),
                InputBottom(
                  onButtonPressed: () {},
                  controller: TextEditingController(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
