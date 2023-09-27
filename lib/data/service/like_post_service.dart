import 'package:social_media_app/data/service/base_service.dart';

class LikePostService extends ServiceBase<void> {
  final String token;
  final String postId;

  LikePostService({
    required this.token,
    required this.postId,
  });

  @override
  Future<void> call() async {
    final likePostResponse = await post('posts/$postId/likes', token: token);
    print(likePostResponse);
  }
}
