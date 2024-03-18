import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class PackageChatPage extends StatelessWidget {
  const PackageChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
          chatController: ChatController(
            initialMessageList: [
              Message(
                id: '1',
                message: 'Hi',
                createdAt: DateTime.now(),
                sendBy: '1',
              ),
              Message(
                id: '2',
                message: 'Hello',
                createdAt: DateTime.now(),
                sendBy: '2',
                messageType: MessageType.voice,
                status: MessageStatus.delivered,
              ),
              Message(
                id: '3',
                message: 'How are you?',
                createdAt: DateTime.now(),
                sendBy: '1',
              ),
              Message(
                message: 'I am fine',
                createdAt: DateTime.now(),
                replyMessage: const ReplyMessage(
                    message: 'How are you?', replyBy: '1', replyTo: '3'),
                sendBy: '2',
              ),
              // audio message
              Message(
                id: '4',
                message:
                    'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3',
                createdAt: DateTime.now(),
                sendBy: '1',
                messageType: MessageType.voice,
                status: MessageStatus.delivered,
              ),
            ],
            scrollController: ScrollController(),
            chatUsers: [
              ChatUser(id: '1', name: 'Bhobo1'),
              ChatUser(id: '2', name: 'Bhobo2'),
            ],
          ),
          currentUser: ChatUser(id: '2', name: 'Bhobo2'),
          chatViewState: ChatViewState.hasMessages),
    );
  }
}
