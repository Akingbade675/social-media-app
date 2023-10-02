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
import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/styles/app_colors.dart';
import 'package:social_media_app/styles/app_text_styles.dart';
import 'package:social_media_app/utils/get_local_time.dart';

class MyChatPage extends StatelessWidget {
  const MyChatPage({super.key});

  willPopScope(BuildContext context, bool showEmoji) {
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
        canPop: context.read<EmojiKeyboardCubit>().willPopScope(),
        child: Builder(
          builder: (context) {
            final chatState = context.watch<ChatBloc>().state;
            return Scaffold(
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
                subTitle: (chatState.typingState != null &&
                        chatState.typingState?.isTyping == true)
                    ? '${chatState.typingState?.user?.name} is typing...'
                    : null,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: chatState.chats.length,
                      itemBuilder: (context, index) {
                        final user = (context.read<AuthenticationCubit>().state
                                as AuthenticationAuthenticated)
                            .user;
                        final chat = chatState.chats[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == chatState.chats.length - 1 ||
                                isAnotherDay(chat, chatState, index))
                              Align(
                                alignment: Alignment.center,
                                child: ChatDateWidget(date: chat.createdAt),
                              ),
                            getChatItemWidget(chat, user, index, chatState),
                          ],
                        );
                      },
                    ),
                  ),
                  const ChatInputBottom(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool isAnotherDay(Chat chat, ChatState appState, int index) {
    return formatUtcDate(chat.createdAt) !=
        formatUtcDate(appState.chats[index + 1].createdAt);
  }

  StatelessWidget getChatItemWidget(
      Chat chat, User user, int index, ChatState appState) {
    if (chat.user.id != user.id) {
      if (index != appState.chats.length - 1 &&
          chat.user.id == appState.chats[index + 1].user.id &&
          !isAnotherDay(chat, appState, index)) {
        return ChatOtherItem(chat: chat);
      } else {
        return ChatOtherItem(chat: chat, showProfile: true);
      }
    }
    if (index != appState.chats.length - 1 &&
        chat.user.id == appState.chats[index + 1].user.id &&
        !isAnotherDay(chat, appState, index)) {
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
      margin: const EdgeInsets.symmetric(vertical: 7),
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
