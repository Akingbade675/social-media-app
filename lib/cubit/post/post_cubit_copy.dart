import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:social_media_app/cubit/auth/auth_cubit.dart';
import 'package:social_media_app/data/model/post.dart';
import 'package:social_media_app/data/service/get_post_service.dart';
import 'package:social_media_app/data/service/like_post_service.dart';

class PostBloc extends HydratedBloc<PostEvent, PostState> {
  final AuthenticationCubit authenticationCubit;
  PostBloc(this.authenticationCubit) : super(PostState()) {
    on<GetPost>(_getPost);
    on<LikePost>(_likePost);
  }

  _getPost(GetPost event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true));
    final posts = await GetPostService(authenticationCubit.getToken()).call();
    emit(PostState(posts: posts));
  }

  _likePost(LikePost event, Emitter<PostState> emit) async {
    await LikePostService(
      postId: event.postId,
      token: authenticationCubit.getToken(),
    ).call();
    final posts = await GetPostService(authenticationCubit.getToken()).call();

    // final posts = state.posts;
    // final likedPostIndex = posts.indexWhere((post) => post.id == event.postId);
    // final likedPost = posts[likedPostIndex];
    // posts[likedPostIndex] = likedPost.copyWith(
    //   isLiked: true,
    //   likesCount: likedPost.likesCount + 1,
    // );

    emit(PostState(posts: posts));
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

  // scrollPostToTop() {
  //   emit(ScrollToTop());
  // }

  @override
  PostState? fromJson(Map<String, dynamic> json) {
    return PostState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PostState state) {
    return state.toJson();
  }
}

class PostState extends Equatable {
  final bool isLoading;
  final List<Post> posts;

  PostState({this.posts = const [], this.isLoading = false}) {
    print('PostState constructor');
  }

  PostState copyWith({
    bool? isLoading,
    List<Post>? posts,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts': posts.map((x) => x.toMap()).toList(),
    };
  }

  factory PostState.fromJson(Map<String, dynamic> map) {
    return PostState(
      posts: List<Post>.from(map['posts']?.map((x) => Post.fromMap(x))),
    );
  }

  @override
  List<Object?> get props {
    // Include the 'isLoading' property and the individual properties of each 'Post' object.
    // This will trigger a state change if 'isLoading' changes or if any property
    // of any 'Post' object in the 'posts' list changes.
    final postProps = posts.map(
      (post) => [
        post.id,
        post.message,
        post.imageUrl,
        post.owner,
        post.likesCount,
        post.commentsCount,
        post.isLiked,
        post.createdAt,
        post.updatedAt,
      ],
    );

    return [isLoading, ...postProps];
  }
}

sealed class PostEvent {}

final class GetPost extends PostEvent {}

final class LikePost extends PostEvent {
  final String postId;

  LikePost(this.postId);
}

final class UnlikePost extends PostEvent {
  final String postId;

  UnlikePost(this.postId);
}
