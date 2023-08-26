part of 'post_cubit.dart';

@immutable
sealed class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class PostInitial extends PostState {}

final class PostGetSuccessful extends PostState {
  final List<Post> posts;

  PostGetSuccessful(this.posts);
}
