import 'package:social_media_app/data/model/post.dart';
import 'package:social_media_app/data/service/base_service.dart';

class GetPostService extends ServiceBase<List<Post>> {
  String token;

  GetPostService(this.token);

  @override
  Future<List<Post>> call() async {
    final result = (await get('post', token: token))['data'];
    return List.generate(
      result.length,
      (index) => Post.fromJson(result[index]),
    );
  }
}
