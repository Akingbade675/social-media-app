import 'package:social_media_app/data/model/user.dart';

class Post {
  final int? id;
  final String? message;
  final String? imageUrl;
  final User author;
  final int? likes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Post({
    this.id,
    this.message,
    this.imageUrl,
    required this.author,
    this.likes,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      message: json['message'],
      imageUrl: json['image_url'],
      author: User.fromJson(json['owner']),
      likes: json['_count']['likes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
