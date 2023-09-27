import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/data/model/post.dart';
import 'package:social_media_app/data/service/get_post_service.dart';
import 'package:social_media_app/data/service/like_post_service.dart';
part 'post_state.dart';

class PostCubit extends HydratedCubit<PostState> {
  final AuthenticationCubit authenticationCubit;
  PostCubit(this.authenticationCubit) : super(PostInitial());

  getPost() async {
    emit(PostGetLoading());
    final posts = await GetPostService(authenticationCubit.getToken()).call();
    emit(PostGetSuccessful(posts: posts));
  }

  likePost(String postId) async {
    await LikePostService(postId: postId, token: authenticationCubit.getToken())
        .call();
    final posts = await GetPostService(authenticationCubit.getToken()).call();
    print('POSTS - $posts');
    emit(PostGetSuccessful(posts: posts));

    // final posts = (state as PostGetSuccessful).posts;
    // final likedPostIndex = posts.indexWhere((post) => post.id == postId);
    // final likedPost = posts[likedPostIndex];
    // posts[likedPostIndex] = likedPost.copyWith(
    //   isLiked: true,
    //   likesCount: likedPost.likesCount + 1,
    // );

    // emit(PostGetSuccessful(posts: posts));
  }

  // unlikePost(String postId) async {
  //   await UnlikePostService(
  //     postId: postId,
  //     token: authenticationCubit.getToken(),
  //   ).call();
  //   final posts = (state as PostGetSuccessful).posts;
  //   final likedPostIndex = posts.indexWhere((post) => post.id == postId);
  //   final likedPost = posts[likedPostIndex];
  //   posts[likedPostIndex] = likedPost.copyWith(
  //     isLiked: false,
  //     likes: likedPost.likes - 1,
  //   );
  //   emit(PostGetSuccessful(posts: posts));
  // }

  scrollPostToTop() {
    emit(ScrollToTop());
  }

  @override
  PostState? fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null && (json['posts'] as List<dynamic>).isNotEmpty) {
      return PostGetSuccessful.fromMap(json);
    }

    return PostGetSuccessful();
  }

  @override
  Map<String, dynamic>? toJson(PostState state) {
    if (state is PostGetSuccessful) {
      return state.toMap();
    }

    return null;
  }
}
