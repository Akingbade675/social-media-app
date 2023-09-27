import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:social_media_app/data/service/base_service.dart';

class UploadImageService extends ServiceBase<String> {
  final String imagePath;

  UploadImageService(this.imagePath);

  @override
  Future<String> call() async {
    if (imagePath.isEmpty) return '';
    try {
      final cloudinary =
          CloudinaryPublic('dzvcj9p7c', 'social_image', cache: false);
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imagePath,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl.toString();
    } on CloudinaryException catch (e) {
      print(e.message);
      return '';
    }
  }
}
