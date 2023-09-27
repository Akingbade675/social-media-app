import 'dart:developer';

import 'package:social_media_app/data/model/post.dart';
import 'package:social_media_app/data/service/base_service.dart';

class GetPostService extends ServiceBase<List<Post>> {
  String token;
  final String userId;

  GetPostService(this.token, {this.userId = ''});

  @override
  Future<List<Post>> call() async {
    try {
      final url = userId.isEmpty ? 'posts' : 'posts/$userId';
      final result = (await get(url, token: token))['data'];
      return List.generate(
        result.length,
        (index) => Post.fromMap(result[index]),
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
