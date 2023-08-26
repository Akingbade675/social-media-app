import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/cubit/auth/authentication_cubit.dart';
import 'package:social_media_app/pages/edit_profile_page.dart';
import 'package:social_media_app/pages/main_page.dart';
import 'package:social_media_app/pages/my_home_page.dart';
import 'package:social_media_app/pages/my_login_page.dart';
import 'package:social_media_app/pages/my_profile_page.dart';
import 'package:social_media_app/pages/nearby_page.dart';

class AppRoutes {
  static final pages = {
    login: (context) => BlocProvider(
          create: (context) => AuthenticationCubit(),
          child: const MyLoginPage(),
        ),
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
