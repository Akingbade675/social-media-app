import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:social_media_app/data/model/post.dart';
import 'package:social_media_app/data/service/create_post_service.dart';
import 'package:social_media_app/data/service/get_post_service.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  getPost(String token) async {
    final posts = await GetPostService(token).call();
    emit(PostGetSuccessful(posts));
  }

  Future<void> createPost(String message, String token) async {
    await CreatePostService(message, null, token).call();
    getPost(token);
  }
}
