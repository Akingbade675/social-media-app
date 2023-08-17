import 'package:social_media_app/pages/edit_profile_page.dart';
import 'package:social_media_app/pages/main_page.dart';
import 'package:social_media_app/pages/my_home_page.dart';
import 'package:social_media_app/pages/my_login_page.dart';
import 'package:social_media_app/pages/my_profile_page.dart';
import 'package:social_media_app/pages/nearby_page.dart';

class AppRoutes {
  static final pages = {
    login: (context) => const MyLoginPage(),
    main: (context) => const MainPage(),
    home: (context) => const MyHomePage(),
    profile: (context) => const MyProfilePage(),
    editProfile: (context) => const EditProfilePage(),
    nearby: (context) => const NearbyPage(),
  };

  static const login = '/login';
  static const home = '/home';
  static const main = '/main';
  static const profile = '/profile';
  static const editProfile = '/edit_profile';
  static const nearby = '/nearby';
}
