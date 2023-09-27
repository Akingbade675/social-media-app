// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:social_media_app/data/model/post.dart';

class User extends Equatable {
  final String id;
  final String? email;

  final String name;
  final String? avatarUrl;

  final List<Post> posts;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl = '',
    this.posts = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'posts': posts.map((x) => x.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: (map['email'] ?? '') as String,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String?,
      posts: map['posts'] != null
          ? List<Post>.from((map['posts'] as List<dynamic>)
              .map((x) => Post.fromMap(x as Map<String, dynamic>)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [id, name, posts];
}
