import 'package:social_media_app/data/model/chat.dart';
import 'package:social_media_app/data/service/base_service.dart';

class GetChatsService extends ServiceBase<List<Chat>> {
  final String token;
  int page;

  GetChatsService({required this.token, this.page = 0});

  @override
  Future<List<Chat>> call() async {
    final response = await get('messages?page=$page', token: token);
    print(response);
    final chats = response['data'] as List;
    return chats.map((chat) => Chat.fromMap(chat)).toList();
  }
}
