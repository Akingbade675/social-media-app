import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/chat_me_item.dart';
import 'package:social_media_app/components/chat_others_item.dart';
import 'package:social_media_app/components/input_bottom.dart';
import 'package:social_media_app/components/tool_bar.dart';
import 'package:social_media_app/config/app_routes.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/cubit/emoji_keyboard_cubit.dart';
import 'package:social_media_app/cubit/message/message_bloc.dart';
import 'package:social_media_app/data/model/chat.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';
import 'package:social_media_app/utils/get_local_time.dart';

class MyChatPage extends StatelessWidget {
  const MyChatPage({super.key});

  willPopScopee(BuildContext context, bool showEmoji) {
    if (showEmoji) {
      context.read<EmojiKeyboardCubit>().hideKeyboard();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        // canPop: context.read<EmojiKeyboardCubit>().willPopScope(),
        canPop: true,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 241, 241, 241),
          appBar: ToolBar(
            title: 'Chat',
            actions: [
              IconButton(
                icon: const Icon(Icons.call, color: AppColor.white),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.videoCall,
                      arguments: {'isCaller': true});
                },
              ),
            ],
            subTitle: (() {
              final typingState = context.select<ChatBloc, TypingState?>(
                (value) => value.state.typingState,
              );
              if (typingState != null && typingState.isTyping == true) {
                return '${typingState.user?.name} is typing...';
              } else {
                return null;
              }
            })(),
          ),
          body: Column(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    final chats = context.select<ChatBloc, List<Chat>>(
                      (value) => value.state.chats,
                    );
                    return ListView.builder(
                      reverse: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final user =
                            context.read<AuthenticationCubit>().getUser();
                        final chat = chats[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == chats.length - 1 ||
                                isAnotherDay(chats, index))
                              Align(
                                alignment: Alignment.center,
                                child: ChatDateWidget(date: chat.createdAt),
                              ),
                            getChatItemWidget(chats, index, user.id),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              const ChatInputBottom(),
            ],
          ),
        ),
      ),
    );
  }

  bool isAnotherDay(List<Chat> chats, int index) {
    return formatUtcDate(chats[index].createdAt) !=
        formatUtcDate(chats[index + 1].createdAt);
  }

  StatelessWidget getChatItemWidget(
    List<Chat> chats,
    int index,
    String userId,
  ) {
    final chat = chats[index];
    if (chat.user.id != userId) {
      if (index != chats.length - 1 &&
          chat.user.id == chats[index + 1].user.id &&
          !isAnotherDay(chats, index)) {
        return ChatOtherItem(chat: chat);
      } else {
        return ChatOtherItem(chat: chat, showProfile: true);
      }
    }
    if (index != chats.length - 1 &&
        chat.user.id == chats[index + 1].user.id &&
        !isAnotherDay(chats, index)) {
      return ChatMeItem(chat: chat, isPreviousChatMe: true);
    }
    return ChatMeItem(chat: chat);
  }
}

class ChatDateWidget extends StatelessWidget {
  const ChatDateWidget({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(formatUtcDate(date), style: AppText.body2),
    );
  }
}

class ChatInputBottom extends StatefulWidget {
  const ChatInputBottom({
    super.key,
  });

  @override
  State<ChatInputBottom> createState() => _ChatInputBottomState();
}

class _ChatInputBottomState extends State<ChatInputBottom> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(
      () {
        final user = (context.read<AuthenticationCubit>().state
                as AuthenticationAuthenticated)
            .user;
        context.read<ChatBloc>().add(
              TypingEvent(
                user: user,
                status: TypingStatus.send,
              ),
            );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputBottom(
      controller: _controller,
      onButtonPressed: () {
        context.read<ChatBloc>().add(ChatSent(message: _controller.text));
        _controller.clear();
      },
    );
  }
}
