import 'package:social_media_app/data/model/user.dart';
import 'package:social_media_app/data/service/base_service.dart';

class GetUserService extends ServiceBase<List<User>> {
  final String token;
  final String userId;

  GetUserService({this.userId = '', required this.token});

  @override
  Future<List<User>> call() async {
    if (userId == '') {
      final users = (await get('users', token: token))['data'];
      return List.generate(users.length, (index) => User.fromMap(users[index]));
    } else {
      final user = (await get('users/$userId', token: token));
      final userMap = User.fromMap(user);
      return [userMap];
    }
  }
}
