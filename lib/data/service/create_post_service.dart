import 'package:social_media_app/data/service/base_service.dart';

class CreatePostService extends ServiceBase<void> {
  final String message;
  final String? image;
  final String token;

  CreatePostService({required this.message, this.image, required this.token});

  @override
  Future<void> call() async {
    final body = {
      'message': message,
    };
    if (image != null) {
      body['image_url'] = image!;
    }
    final response = await post('posts', body: body, token: token);
    print(response);
  }
}
