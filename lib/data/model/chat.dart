// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:social_media_app/data/model/user.dart';

class Chat extends Equatable {
  final String id;
  final String message;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;

  const Chat({
    required this.id,
    required this.message,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'image': image,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'user': user.toMap(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      message: map['message'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      user: User.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props {
    return [
      id,
      message,
      // image,
      createdAt,
      updatedAt,
      user,
    ];
  }
}
