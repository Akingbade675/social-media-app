import 'package:social_media_app/data/service/base_service.dart';

class CreateMessageService extends ServiceBase<void> {
  final String message;
  final String token;

  CreateMessageService({required this.message, required this.token});

  @override
  Future<void> call() async {
    final body = {
      'message': message,
    };
    await post('messages', body: body, token: token);
  }
}
