import 'package:social_media_app/data/model/user.dart';

class LoginResponse {
  final User user;
  final String token;

  LoginResponse(this.user, this.token);

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(User.fromMap(json['user']), json['access_token']);
  }
}
