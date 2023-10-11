import 'package:flutter/material.dart';
import 'package:social_media_app/components/user_avatar.dart';
import 'package:social_media_app/data/model/chat.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/utils/get_local_time.dart';

class ChatOtherItem extends StatelessWidget {
  final Chat chat;
  final bool showProfile;
  const ChatOtherItem({
    super.key,
    required this.chat,
    this.showProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 30,
        left: 16,
        top: showProfile ? 20 : 4,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minWidth: MediaQuery.of(context).size.width * 0.4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: showProfile
                  ? const UserAvatar(
                      size: 28,
                      borderRadius: 6,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IntrinsicWidth(
                  child: Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 1),
                    color: AppColor.white,
                    surfaceTintColor: AppColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ).copyWith(
                        topRight: const Radius.circular(16),
                        topLeft: showProfile
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                        minWidth: MediaQuery.of(context).size.width * 0.4,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.user.name,
                              style: TextStyle(
                                color: AppColor.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(chat.message),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                getLocalTime(chat.createdAt),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColor.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 4),
                // Text(
                //   // get the time from the chat
                //   getLocalTime(chat.createdAt),
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: AppColor.grey,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
