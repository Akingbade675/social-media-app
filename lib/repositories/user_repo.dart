import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:social_media_app/data/model/user.dart';

class UserRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> hasToken() async {
    var value = await _secureStorage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getToken() async {
    return await _secureStorage.read(key: 'token') ?? '';
  }

  Future<void> persistToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'token');
  }

  Future<void> persistUser(User user) async {
    String userString = user.toJson();
    await _secureStorage.write(key: 'user', value: userString);
  }

  Future<User> getUser() async {
    String? userString = await _secureStorage.read(key: 'user');
    User user = User.fromJson(userString!);
    return user;
  }
}
