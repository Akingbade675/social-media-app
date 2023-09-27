import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/data/service/create_post_service.dart';
import 'package:social_media_app/data/service/upload_service.dart';
import 'package:social_media_app/utils/image_picker.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit() : super(CreatingPostState());

  changePostMsg(String message) {
    emit((state as CreatingPostState).copyWith(message: message));
  }

  void pickImage(ImageSource source) async {
    try {
      final imagePath = await Utils.pickImage(source);
      final croppedImage = await Utils.cropImage(imagePath);
      emit((state as CreatingPostState)
          .copyWith(image: croppedImage?.path ?? ''));
    } catch (e) {
      print(e);
    }
  }

  void clearImage() {
    emit((state as CreatingPostState).copyWith(image: ''));
  }

  Future<void> createPost(String token) async {
    try {
      final state = this.state as CreatingPostState;

      var imageUrl = '';
      if (state.image != '') {
        imageUrl = await UploadImageService(state.image).call();
      }
      print('Uploaded Image Url - $imageUrl');
      await CreatePostService(
        message: state.message,
        image: imageUrl,
        token: token,
      ).call();
      emit(PostCreated());
      emit(state.copyWith(message: '', image: ''));
    } on Exception catch (e) {
      print(e);
    }
    //getPost(token);
  }
}
