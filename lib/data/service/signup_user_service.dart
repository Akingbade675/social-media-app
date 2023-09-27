import 'package:social_media_app/data/service/base_service.dart';

class SignupUserService extends ServiceBase<void> {
  final String username;
  final String password;
  final String email;

  SignupUserService(
      {required this.username, required this.password, required this.email});

  @override
  Future<void> call() async {
    await post('users', body: {
      'username': username,
      'password': password,
      'email': email,
    });
  }
}
