import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubit/emoji_keyboard_cubit.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';

class InputBottom extends StatelessWidget {
  final VoidCallback onButtonPressed;
  final TextEditingController controller;
  const InputBottom({
    super.key,
    required this.onButtonPressed,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          context.read<EmojiKeyboardCubit>().toggleKeyboard();
                        },
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLines: 7,
                          keyboardType: TextInputType.multiline,
                          controller: controller,
                          style: AppText.body2,
                          onTap: () =>
                              context.read<EmojiKeyboardCubit>().hideKeyboard(),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type a message...',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.attach_file,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 48,
                height: 48,
                child: FloatingActionButton(
                  backgroundColor: AppColor.primaryDark,
                  // backgroundColor: Colors.deepPurple,
                  foregroundColor: AppColor.white,
                  onPressed: onButtonPressed,
                  child: const Icon(
                    Icons.send,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Builder(
            builder: (context) {
              final shouldShowEmojiKeyboard =
                  context.watch<EmojiKeyboardCubit>().state;
              if (!shouldShowEmojiKeyboard) return const SizedBox.shrink();
              return Container(
                height: 300,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 6),
                child: EmojiPicker(
                  textEditingController: controller,
                  onBackspacePressed: () =>
                      controller.value = controller.value.copyWith(
                    text:
                        controller.value.text.characters.skipLast(0).toString(),
                  ),
                  config: Config(
                    columns: 8,
                    indicatorColor: Colors.transparent,
                    backspaceColor: AppColor.primaryDark,
                    iconColorSelected: AppColor.primaryDark,
                    bgColor: AppColor.white,
                    emojiSizeMax: 20 * (Platform.isIOS ? 1.30 : 1.0),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
