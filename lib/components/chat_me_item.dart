import 'package:flutter/material.dart';
import 'package:social_media_app/data/model/chat.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/utils/get_local_time.dart';

class ChatMeItem extends StatelessWidget {
  final Chat chat;
  final bool isPreviousChatMe;
  const ChatMeItem(
      {super.key, required this.chat, this.isPreviousChatMe = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 16,
        left: 30,
        top: isPreviousChatMe ? 4 : 4,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 1),
              color: AppColor.primaryLight,
              surfaceTintColor: AppColor.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ).copyWith(
                  topLeft: const Radius.circular(16),
                  topRight: !isPreviousChatMe
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
                  padding: const EdgeInsets.all(8.0).copyWith(bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat.message,
                        style: const TextStyle(
                          color: AppColor.black,
                        ),
                      ),
                      Text(
                        // get the time from the chat
                        getLocalTime(chat.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColor.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
