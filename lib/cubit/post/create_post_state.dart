part of 'create_post_cubit.dart';

@immutable
sealed class CreatePostState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CreatingPostState extends CreatePostState {
  final String message;
  final String image;

  CreatingPostState({
    this.message = '',
    this.image = '',
  });

  CreatingPostState copyWith({
    String message = 'nil',
    String image = 'nil',
  }) {
    return CreatingPostState(
      message: message == 'nil' ? this.message : message,
      image: image == 'nil' ? this.image : image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'image': image,
    };
  }

  @override
  List<Object?> get props => [message, image];
}

final class PostCreated extends CreatePostState {}
