part of 'post_cubit.dart';

@immutable
sealed class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

sealed class PostActionState extends PostState {}

final class ScrollToTop extends PostActionState {}

final class PostInitial extends PostState {}

final class PostGetSuccessful extends PostState {
  final List<Post> posts;

  PostGetSuccessful({this.posts = const []});

  PostGetSuccessful copyWith({
    List<Post>? posts,
  }) {
    return PostGetSuccessful(
      posts: posts ?? this.posts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'posts': posts.map((x) => x.toMap()).toList(),
    };
  }

  factory PostGetSuccessful.fromMap(Map<String, dynamic> map) {
    try {
      print('post get successful from map called');
      final postsState = PostGetSuccessful(
        posts: List<Post>.from(map['posts']?.map((x) => Post.fromMap(x))),
      );
      print(postsState.posts.length);
      return postsState;
    } on Exception catch (e) {
      print('Error: $e');
    }

    return PostGetSuccessful(posts: const []);
  }

  @override
  List<Object?> get props => [
        // compare the inner state of posts
        ...posts,
      ];
}

final class PostItemState extends PostState {
  final String? message;
  final String? image;
  final String? createdAt;
  final String? updatedAt;
  final String? id;
  final String? userId;
  final String? userImage;
  final String? userName;
  final bool? liked;

  PostItemState({
    this.message,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.userId,
    this.userImage,
    this.userName,
    this.liked,
  });

  PostItemState copyWith({
    String? message,
    String? image,
    String? createdAt,
    String? updatedAt,
    String? id,
    String? userId,
    String? userImage,
    String? userName,
    bool? liked,
  }) {
    return PostItemState(
      message: message ?? this.message,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userImage: userImage ?? this.userImage,
      userName: userName ?? this.userName,
      liked: liked ?? this.liked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'id': id,
      'userId': userId,
      'userImage': userImage,
      'userName': userName,
      'liked': liked,
    };
  }

  factory PostItemState.fromMap(Map<String, dynamic> map) {
    return PostItemState(
      message: map['message'],
      image: map['image'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      id: map['id'],
      userId: map['userId'],
      userImage: map['userImage'],
      userName: map['userName'],
      liked: map['liked'],
    );
  }

  @override
  List<Object?> get props {
    return [
      message,
      image,
      createdAt,
      updatedAt,
      id,
      userId,
      userImage,
      userName,
      liked,
    ];
  }
}

final class PostCreateSuccessful extends PostState {}

final class PostCreateFailed extends PostState {
  final String message;

  PostCreateFailed(this.message);
}

final class PostGetFailed extends PostState {
  final String message;

  PostGetFailed(this.message);
}

final class PostLoading extends PostState {}

final class PostImageLoading extends PostState {}

final class PostImageError extends PostState {
  final String message;

  PostImageError(this.message);
}

final class PostImageClear extends PostState {}

final class PostClear extends PostState {}

final class PostCreateLoading extends PostState {}

final class PostCreateError extends PostState {
  final String message;

  PostCreateError(this.message);
}

final class PostCreateClear extends PostState {}

final class PostGetLoading extends PostState {}

final class PostGetError extends PostState {
  final String message;

  PostGetError(this.message);
}

final class PostGetClear extends PostState {}

final class PostDeleteLoading extends PostState {}

final class PostDeleteError extends PostState {
  final String message;

  PostDeleteError(this.message);
}

final class PostDeleteClear extends PostState {}

final class PostDeleteSuccessful extends PostState {}

final class PostUpdateLoading extends PostState {}

final class PostUpdateError extends PostState {
  final String message;

  PostUpdateError(this.message);
}

final class PostUpdateClear extends PostState {}

final class PostUpdateSuccessful extends PostState {}

final class PostLikeLoading extends PostState {}

final class PostLikeError extends PostState {
  final String message;

  PostLikeError(this.message);
}

final class PostLikeClear extends PostState {}

final class PostLikeSuccessful extends PostState {}

final class PostUnlikeLoading extends PostState {}

final class PostUnlikeError extends PostState {
  final String message;

  PostUnlikeError(this.message);
}

final class PostUnlikeClear extends PostState {}

final class PostUnlikeSuccessful extends PostState {}
